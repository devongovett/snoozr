package snoozr.neural;

public class TrainingRecord {	
	public Points input;
	public Points output;
	
	TrainingRecord(Points input, Points output) {
		this.input = input;
		this.output = output;
	}
	
	public double[] getInputs() {
		return input.points;
	}
	
	public double[] getOutputs() {
		return output.points;
	}
}