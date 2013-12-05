package snoozr.neural;

/****
 * Represents a layer in a neural net
 * 
 * @author Donovan McKelvey
 *
 */
public class Layer {	
	public double[] deltas;
	public double[] errors;
	public double[] outputs;
	public double[] biases;
	public double[] weights;
	public double[] changes;
	
	/****
	 * Creates a layer with limited number of fields
	 * 
	 * @param deltas
	 * @param errors
	 * @param outputs
	 */
	public Layer(double[] deltas, double[] errors, double[] outputs) {
		this.deltas = deltas;
		this.errors = errors;
		this.outputs = outputs;
	}
	
	/****
	 * Creates a layer with all of the fields
	 * 
	 * @param deltas
	 * @param errors
	 * @param outputs
	 * @param biases
	 * @param weights
	 * @param changes
	 */
	public Layer(double[] deltas, double[] errors, double[] outputs, double[] biases, double[] weights, double[] changes) {
		this(deltas, errors, outputs);

		this.biases = biases;
		this.weights = weights;
		this.changes = changes;
	}
	
	/****
	 * 
	 * @return the size of the layer
	 */
	public int size() {
		return deltas.length;
	}
}