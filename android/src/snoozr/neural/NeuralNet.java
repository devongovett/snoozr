package snoozr.neural;

import java.util.Random;

public class NeuralNet {
	public static final int DEFAULT_MAX_ITERATIONS = 20000;
	public static final double DEFAULT_MIN_ERROR = 0.005;
	public static final double DEFAULT_LEARNING_RATE = 0.3;
	public static final double DEFAULT_MOMENTUM = 0.1;
	
	private int[] sizes;
	private int outputLayer;
	private Layer[] layers;
	
	private int maxIteration;
	private double minError;
	private double learningRate;
	private double momentum;
	
	public NeuralNet(int numInputs, int numOutputs) {
		this(numInputs, null, numOutputs);
	}
	
	public NeuralNet(int numInputs, Layer[] hiddenLayers, int numOutputs) {
		maxIteration = DEFAULT_MAX_ITERATIONS;
		minError = DEFAULT_MIN_ERROR;
		learningRate = DEFAULT_LEARNING_RATE;
		momentum = DEFAULT_MOMENTUM;
		
		outputLayer = 1 + (hiddenLayers != null ? hiddenLayers.length : 1);
		sizes = new int[outputLayer + 1];
		layers = new Layer[outputLayer + 1];
		
		sizes[0] = numInputs;
		if (hiddenLayers != null) {
			for (int i = 0; i < hiddenLayers.length; i++)
				sizes[i + 1] = hiddenLayers[i].size();
		}
		else {
			// one hidden layer by default
			sizes[1] = Math.max(3, numInputs / 2);
		}
		
		sizes[outputLayer] = numOutputs;
		
		// allocate layers
		for (int layer = 0; layer <= outputLayer; layer++) {
			int size = sizes[layer];
			
			if (layer == 0) {
				layers[layer] = new Layer(zeros(size), zeros(size), zeros(size));
			}
			else {
				int size2 = size * sizes[layer - 1];
				layers[layer] = new Layer(zeros(size), zeros(size), zeros(size), randos(size), randos(size2), zeros(size2));
			}
		}
	}
	
	private Double[] randos(int size) {
		Random rand = new Random();
		
		Double[] rands = new Double[size];
		
		for (int i = 0; i < size; i++)
			rands[i] = rand.nextDouble();
		
		return rands;
	}
	
	private Double[] zeros(int size) {
		Double[] zeros = new Double[size];
		
		for (int i = 0; i < size; i++)
			zeros[i] = Double.valueOf(0.0);
		
		return zeros;
	}
}