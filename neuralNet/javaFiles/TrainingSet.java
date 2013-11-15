import java.util.ArrayList;
import java.util.List;


public class TrainingSet
{
  private List<TrainingSample> trainingSetSamples = new ArrayList<TrainingSample>();

  public List<TrainingSample> getTrainingSetSamples()
  {
    return trainingSetSamples;
  }

  public void setTrainingSetSamples( List<TrainingSample> trainingSetSamples )
  {
    this.trainingSetSamples = trainingSetSamples;
  }
  
  
}