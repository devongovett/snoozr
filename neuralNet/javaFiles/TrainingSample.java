
import java.util.ArrayList;
import java.util.List;


public class TrainingSample
{
  
  private List<Double> inputVector = new ArrayList<Double>();
  private List<Double> outputVector = new ArrayList<Double>();
  
  public List<Double> getInputVector()
  {
    return inputVector;
  }
  public void setInputVector( List<Double> inputVector )
  {
    this.inputVector = inputVector;
  }
  public List<Double> getOutputVector()
  {
    return outputVector;
  }
  public void setOutputVector( List<Double> outputVector )
  {
    this.outputVector = outputVector;
  }
  
}