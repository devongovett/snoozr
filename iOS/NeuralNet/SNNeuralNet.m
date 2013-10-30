#import "SNNeuralNet.h"
#include <math.h>

typedef struct {
    double *deltas;
    double *errors;
    double *outputs;
    double *biases;
    double **weights;
    double **changes;
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
    for (int layer = 0; layer <= outputLayer; layer++) {
        int size = sizes[layer];
        
        layers[layer].deltas = zeros(size);
        layers[layer].errors = zeros(size);
        layers[layer].outputs = zeros(size);
        
        if (layer > 0) {
            layers[layer].biases = randos(size);
            layers[layer].weights = malloc(size * sizeof(double *));
            layers[layer].changes = malloc(size * sizeof(double *));
            
            for (int node = 0; node < size; node++) {
                int prevSize = sizes[layer - 1];
                layers[layer].weights[node] = randos(prevSize);
                layers[layer].changes[node] = zeros(prevSize);
            }
        }
    }
}

- (void)dealloc
{
    for (int layer = 0; layer <= outputLayer; layer++) {
        free(layers[layer].deltas);
        free(layers[layer].errors);
        free(layers[layer].outputs);
        
        if (layer > 0) {
            free(layers[layer].biases);
            
            for (int node = 0; node < sizes[layer]; node++) {
                free(layers[layer].weights[node]);
                free(layers[layer].changes[node]);
            }
            
            free(layers[layer].weights);
            free(layers[layer].changes);
        }
    }
    
    free(layers);
    free(sizes);
}

- (double *)runInput:(double *)input
{
    memcpy(layers[0].outputs, input, sizes[0] * sizeof(double));
    
    for (int layer = 1; layer <= outputLayer; layer++) {
        for (int node = 0; node < sizes[layer]; node++) {
            double *weights = layers[layer].weights[node];
            double sum = layers[layer].biases[node];
            
            for (int k = 0; k < sizes[layer - 1]; k++) {
                sum += weights[k] * input[k];
            }
            
            layers[layer].outputs[node] = 1 / (1 + exp(-sum));
        }
        
        input = layers[layer].outputs;
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
    double *errors = layers[outputLayer].errors;
    double sum = 0;
    for (int i = 0; i < sizes[outputLayer]; i++) {
        sum += errors[i] * errors[i];
    }
    
    return sum / sizes[outputLayer];
}

- (void)calculateDeltas:(double *)target
{
    for (int layer = outputLayer; layer >= 0; layer--) {
        for (int node = 0; node < sizes[layer]; node++) {
            double output = layers[layer].outputs[node];
            
            double error = 0;
            if (layer == outputLayer) {
                error = target[node] - output;
            } else {
                double *deltas = layers[layer + 1].deltas;
                for (int k = 0; k < sizes[layer + 1]; k++) {
                    error += deltas[k] * layers[layer + 1].weights[k][node];
                }
            }
            
            layers[layer].errors[node] = error;
            layers[layer].deltas[node] = error * output * (1 - output);
        }
    }
}

- (void)adjustWeights
{
    for (int layer = 1; layer <= outputLayer; layer++) {
        double *incoming = layers[layer - 1].outputs;
        
        for (int node = 0; node < sizes[layer]; node++) {
            double delta = layers[layer].deltas[node];
            
            for (int k = 0; k < sizes[layer - 1]; k++) {
                double change = layers[layer].changes[node][k];
                
                change = (LEARNING_RATE * delta * incoming[k]) + (MOMENTUM * change);
                
                layers[layer].changes[node][k] = change;
                layers[layer].weights[node][k] += change;
            }
            
            layers[layer].biases[node] += LEARNING_RATE * delta;
        }
    }
}

@end
