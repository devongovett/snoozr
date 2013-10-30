#import <Foundation/Foundation.h>

#define MAX_ITERATIONS 20000
#define MIN_ERROR 0.005
#define LEARNING_RATE 0.3
#define MOMENTUM 0.1

typedef struct {
    double *input;
    double *output;
} SNTrainingRecord;

#define SNInput(...) (double[]){__VA_ARGS__}
#define SNOutput SNInput
#define SNTrainingData(...) ({                                  \
    SNTrainingRecord __data__[] = {__VA_ARGS__};                \
    [NSData dataWithBytes:__data__ length:sizeof(__data__)];    \
})

@interface SNNeuralNet : NSObject

- (instancetype)initWithTrainingData:(NSData *)data numInputs:(int)inputs numOutputs:(int)outputs;
- (double *)runInput:(double *)input;

@end
