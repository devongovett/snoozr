package snoozr.neural;

public class Points {
	public double[] points;
	
	public Points(double... points) {
		this.points = points;
	}
	
	public Points(Double... points) {
		Double[] tmp = points;
		System.arraycopy(tmp, 0, points, 0, tmp.length);
	}
	
	public Double[] asObject() {
		Double[] tmp = new Double[points.length];
		System.arraycopy(points, 0, tmp, 0, points.length);
		return tmp;
	}
}