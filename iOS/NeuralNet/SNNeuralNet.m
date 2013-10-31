#import "SNNeuralNet.h"
#import <math.h>
#import <Accelerate/Accelerate.h>

typedef struct {
    double *deltas;
    double *errors;
    double *outputs;
    double *biases;
    double *weights;
    double *changes;
} SNLayer;

#define zeros(size) calloc(size, sizeof(double))
double *randos(int size) { 
    double *ptr = malloc(size * sizeof(double));
    for (int i = 0; i < size; i++)
        ptr[i] = (double)arc4random() / 0x100000000;
    
    return ptr;
}

@implementation SNNeuralNet
{
    int *sizes;
    int outputLayer;
    SNLayer *layers;
    double *buf;
}

- (instancetype)initWithTrainingData:(NSData *)data numInputs:(int)numInputs numOutputs:(int)numOutputs
{
    self = [super init];
    
    if (self) {
        int numElements = data.length / sizeof(SNTrainingRecord);
        SNTrainingRecord *trainingData = (SNTrainingRecord *)data.bytes;
    
        [self allocateInputs:numInputs outputs:numOutputs];
    
        double error = 1.0;
        int i;
        for (i = 0; i < MAX_ITERATIONS && error > MIN_ERROR; i++) {
            double sum = 0;
            for (int j = 0; j < numElements; j++) {
                sum += [self trainPattern:&trainingData[j]];
            }
            error = sum / numElements;
        }
        
        printf("iterations = %d, error = %f\n", i, error);
    }
    
    return self;
}

- (void)allocateInputs:(int)numInputs outputs:(int)numOutputs
{
    // no hidden layers for now
    outputLayer = 2;
    sizes = malloc(3 * sizeof(int));
    sizes[0] = numInputs;
    sizes[1] = fmax(3, floor(numInputs / 2));
    sizes[2] = numOutputs;
    
    layers = malloc((outputLayer + 1) * sizeof(SNLayer));
    int maxSize = 0;
    
    for (int layer = 0; layer <= outputLayer; layer++) {
        int size = sizes[layer];
                
        layers[layer].deltas = zeros(size);
        layers[layer].errors = zeros(size);
        layers[layer].outputs = zeros(size);
        
        if (layer > 0) {
            layers[layer].biases = randos(size);
            layers[layer].weights = randos(size * sizes[layer - 1]);
            layers[layer].changes = zeros(size * sizes[layer - 1]);
            
            int bufSize = sizes[layer] * sizes[layer - 1];
            if (bufSize > maxSize)
                maxSize = bufSize;
        }
    }
    
    // intermediary buffer used in adjustWeights
    buf = malloc(maxSize * sizeof(double));
}

- (void)dealloc
{
    for (int layer = 0; layer <= outputLayer; layer++) {
        free(layers[layer].deltas);
        free(layers[layer].errors);
        free(layers[layer].outputs);
        
        if (layer > 0) {
            free(layers[layer].biases);
            free(layers[layer].weights);
            free(layers[layer].changes);
        }
    }
    
    free(layers);
    free(sizes);
    free(buf);
}

- (double *)runInput:(double *)input
{
    memcpy(layers[0].outputs, input, sizes[0] * sizeof(double));
    
    for (int layer = 1; layer <= outputLayer; layer++) {
        vDSP_mmulD(layers[layer].weights, 1, layers[layer - 1].outputs, 1, layers[layer].outputs, 1, sizes[layer], 1, sizes[layer - 1]);
        
        // Activation function (http://en.wikipedia.org/wiki/Activation_function)
        for (int i = 0; i < sizes[layer]; i++) {
            double sum = layers[layer].outputs[i] + layers[layer].biases[i];
            layers[layer].outputs[i] = 1 / (1 + exp(-sum));
        }
        
        // Option 1. 1 / (1 + exp(-sum))
        // layers[layer].outputs = 1 / (1 + exp(-sum));
        // vDSP_vaddD(layers[layer].outputs, 1, layers[layer].biases, 1, layers[layer].outputs, 1, sizes[layer]);
        // vDSP_vnegD(layers[layer].outputs, 1, layers[layer].outputs, 1, sizes[layer]);
        // vvexp(layers[layer].outputs, layers[layer].outputs, &sizes[layer]);
        // 
        // double one = 1;
        // vDSP_vsaddD(layers[layer].outputs, 1, &one, layers[layer].outputs, 1, sizes[layer]);
        // 
        // vvrec(layers[layer].outputs, layers[layer].outputs, &sizes[layer]);
        
        // Option 2. tanh(sum)
        // vvtanh(layers[layer].outputs, layers[layer].outputs, &sizes[layer]);
    }
    
    return layers[outputLayer].outputs;
}

- (double)trainPattern:(SNTrainingRecord *)record
{
    // forward propogate
    [self runInput:record->input];
    
    // back propogate
    [self calculateDeltas:record->output];
    [self adjustWeights];
    
    // mean squared error
    double error;
    vDSP_measqvD(layers[outputLayer].errors, 1, &error, sizes[outputLayer]);
    return error;
}

- (void)calculateDeltas:(double *)target
{
    for (int layer = outputLayer; layer >= 0; layer--) {
        if (layer == outputLayer) {
            // layers[layer].errors = target - layers[layer].outputs
            vDSP_vsubD(layers[layer].outputs, 1, target, 1, layers[layer].errors, 1, sizes[layer]);
        } else {
            // layers[layer].errors = layers[layer + 1].deltas * layers[layer + 1].weights
            vDSP_mmulD(layers[layer + 1].deltas, 1, layers[layer + 1].weights, 1, layers[layer].errors, 1, 1, sizes[layer], sizes[layer + 1]);
        }
        
        // layers[layer].deltas = layers[layer].errors * layers[layer].outputs * (1 - layers[layer].outputs)
        // simplifying since x * (1 - x) == x - x^2
        vDSP_vsqD(layers[layer].outputs, 1, layers[layer].deltas, 1, sizes[layer]);                           // deltas = x^2
        vDSP_vsubD(layers[layer].deltas, 1, layers[layer].outputs, 1, layers[layer].deltas, 1, sizes[layer]); // deltas = x - x^2
        vDSP_vmulD(layers[layer].errors, 1, layers[layer].deltas, 1, layers[layer].deltas, 1, sizes[layer]);  // deltas = errors * x - x^2
    }
}

- (void)adjustWeights
{
    double learningRate = LEARNING_RATE;
    double momentum = MOMENTUM;
    
    for (int layer = 1; layer <= outputLayer; layer++) {
        // 1. Update changes
        // layers[layer].changes = (LEARNING_RATE * layers[layer].deltas * layers[layer - 1].outputs) + (MOMENTUM * layers[layer].changes)
        
        // buf = layers[layer].deltas * layers[layer - 1].outputs
        vDSP_mmulD(layers[layer].deltas, 1, layers[layer - 1].outputs, 1, buf, 1, sizes[layer], sizes[layer - 1], 1);
        
        // buf = buf * LEARNING_RATE
        vDSP_vsmulD(buf, 1, &learningRate, buf, 1, sizes[layer] * sizes[layer - 1]);
        
        // layers[layer].changes = layers[layer].changes * MOMENTUM + buf
        vDSP_vsmaD(layers[layer].changes, 1, &momentum, buf, 1, layers[layer].changes, 1, sizes[layer] * sizes[layer - 1]);
        
        // 2. Update weights
        // layers[layer].weights += layers[layer].changes
        vDSP_vaddD(layers[layer].weights, 1, layers[layer].changes, 1, layers[layer].weights, 1, sizes[layer] * sizes[layer - 1]);
        
        // 3. Update biases
        // layers[layer].biases += layers[layer].deltas * LEARNING_RATE
        vDSP_vsmaD(layers[layer].deltas, 1, &learningRate, layers[layer].biases, 1, layers[layer].biases, 1, sizes[layer]);
    }
}

@end
