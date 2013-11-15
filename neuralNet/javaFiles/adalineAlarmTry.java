import java.util.ArrayList;
import java.util.List;

import org.apache.commons.math3.linear.Array2DRowRealMatrix;
import org.apache.commons.math3.linear.RealMatrix;

public class adalineAlarmTry implements Network {
   private int numInputElements;
   private int numOutputElements;

   private double learningRate;
   private double minError;
   private double bias;
   private long maxIterations;

   private RealMatrix weightMatrix;

   private List<Double> outputElements = new ArrayList<Double>();

   public adalineAlarmTry() {
      initWeights();
   }

   public double getBias() {
      return bias;
   }

   public void setBias(double bias) {
      this.bias = bias;
   }

   protected void initWeights() {

      double [][] d = new double[numInputElements][numOutputElements];

      for(int i = 0; i < numInputElements; i++) {
         for(int j = 0; j < numOutputElements; j++) {
            d[i][j] = Math.random();
      }
   }

   weightMatrix = new Array2DRowRealMatrix(d);

   }

   public double getLearningRate() {
      return learningRate;
   }

   public void setLearningRate(double learningRate) {
      this.learningRate = learningRate;
   }

   public double getMinError() {
      return minError;
   }

   public void setMinError(double minError) {
      this.minError = minError;
   }

   public long getMaxIterations() {
      return maxIterations;
   }

   public void setMaxIterations(long maxIterations) {
      this.maxIterations = maxIterations;
   }

   public int getNumInputElements() {
      return numInputElements;
   }

   public void setNumInputElements(int numInputElements) {
      this.numInputElements = numInputElements;
   }

   public int getNumOutputElements() {
      return numOutputElements;
   }

   public void setNumOutputElements(int numOutputElements) {
      this.numOutputElements = numOutputElements;
   }

   public RealMatrix getWeightMatrix() {
      return weightMatrix;
   }

   public void setWeightMatrix(RealMatrix weightMatrix) {
      this.weightMatrix = weightMatrix;
   }

   public List<Double> getOutputElements() {
      return outputElements;
   }

   public void setOutputElements(List<Double> outputElements) {
      this.outputElements = outputElements;
   }


   public List<Double> process(List<Double> inputElements) {
      List<Double> outputList = new ArrayList<Double>();

      for(int j = 0; j < numOutputElements; j++) {
         Double output = 0.0;

         for(int i = 0; i < inputElements.size(); i++) {
            output += inputElements.get(i) * weightMatrix.getEntry(i, j);
         }

         output += bias;
         output = sigmoid(output);
         outputList.add(output);
      }

      return outputList;
   }

   private Double sigmoid(Double value) {
      return 1.0 / (1 + Math.exp(-1000 * value));
   }

   public void train(TrainingSet trainingSet) {

      initWeights();

      for(int j = 0; j < numOutputElements; j++) {
         Double desiredOutput = 0.0;
         Double actualOutput = 0.0;
         long iter = 0;

         for(TrainingSample trainingSample : trainingSet.getTrainingSetSamples()) {
            desiredOutput = trainingSample.getOutputVector().get(j);
            actualOutput = process(trainingSample.getInputVector()).get(j);

            iter = 0;

            while(Math.pow(desiredOutput - actualOutput, 2) > minError && iter < maxIterations) {
               double [] weights = weightMatrix.getColumn(j);

               for(int i = 0; i < weights.length; i++) {
                  weightMatrix.setEntry(i, j, weights[i] + learningRate * (desiredOutput - actualOutput) * trainingSample.getInputVector().get(i));
               }

               desiredOutput = trainingSample.getOutputVector().get(j);
               actualOutput = process(trainingSample.getInputVector()).get(j);
               iter++;
            }
         }
      }
   }
}