import java.util.List;

import org.apache.commons.math3.linear.RealMatrix;

public interface Network {
    public abstract double getBias();
    
    public abstract void setBias(double bias);

    public abstract double getLearningRate();

    public abstract void setLearningRate(double learningRate);

    public abstract double getMinError();

    public abstract void setMinError(double minError);

    public abstract long getMaxIterations();

    public abstract void setMaxIterations(long maxIterations);

    public abstract int getNumInputElements();

    public abstract void setNumInputElements(int numInputElements);

    public abstract int getNumOutputElements();

    public abstract void setNumOutputElements(int numOutputElements);

    public abstract RealMatrix getWeightMatrix();

    public abstract void setWeightMatrix(RealMatrix weightMatrix);

    public abstract List<Double> getOutputElements();

    public abstract void setOutputElements(List<Double> outputElements);

    public abstract List<Double> process(List<Double> inputElements);

    public abstract void train(TrainingSet trainingSet);
}