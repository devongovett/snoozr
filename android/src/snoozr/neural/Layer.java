package snoozr.neural;

public class Layer {	
	public double[] deltas;
	public double[] errors;
	public double[] outputs;
	public double[] biases;
	public double[] weights;
	public double[] changes;
	
	public Layer(double[] deltas, double[] errors, double[] outputs) {
		this.deltas = deltas;
		this.errors = errors;
		this.outputs = outputs;
	}
	
	public Layer(double[] deltas, double[] errors, double[] outputs, double[] biases, double[] weights, double[] changes) {
		this(deltas, errors, outputs);

		this.biases = biases;
		this.weights = weights;
		this.changes = changes;
	}
	
	public int size() {
		return deltas.length;
	}
}