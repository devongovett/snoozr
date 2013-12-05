package snoozr.neural;

/****
 * Convenience wrapper for a double array
 * 
 * @author Donovan McKelvey
 *
 */
public class Points {
	public double[] points;
	
	/****
	 * Convenience constructor so we can use arrays or comma separated parameters
	 * 
	 * @param points The points for this object to hold
	 */
	public Points(double... points) {
		this.points = points;
	}
}