import org.neuroph.core.NeuralNetwork;
import org.neuroph.core.data.DataSet;

public class adalineTest 
{
    NeuralNetwork network = NeuralNetwork.load("adalineAlarm.nnet");
    DataSet alarmSet = new DataSet(2, 1);
    private static final double MONDAY = 0.1;
    private static final double TUESDAY = 0.2;
    private static final double WEDNESDAY = 0.3;
    private static final double THURSDAY = 0.4;
    private static final double FRIDAY = 0.5;
    private static final double SATURDAY = 0.6;
    private static final double SUNDAY = 0.7;


    public void makeNewAlarm(double day, double inAlarm)
    {
        //change to use cylce calculation

    }
}