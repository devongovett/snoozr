#import "SNNeuralNet.h"

int main() {
    NSData *data = SNTrainingData(
        {SNInput(0,0), SNOutput(0)},
        {SNInput(0,1), SNOutput(1)},
        {SNInput(1,0), SNOutput(1)},
        {SNInput(1,1), SNOutput(0)}
    );
        
    SNNeuralNet *net = [[SNNeuralNet alloc] initWithTrainingData:data numInputs:2 numOutputs:1];
    
    double *output = [net runInput:SNInput(1,0)];
    printf("%.20f\n", *output);
}