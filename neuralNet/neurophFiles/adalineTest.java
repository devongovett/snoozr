import org.neuroph.core.NeuralNetwork;
import org.neuroph.core.data.DataSet;
import java.util.Vector;

public class adalineTest extends NeuralNetwork<Adaline>
{
    static NeuralNetwork network = NeuralNetwork.createFromFile("adalineAlarm.nnet");
    DataSet alarmSet = new DataSet(2, 1);
    private static final double MONDAY = 0.1;
    private static final double TUESDAY = 0.2;
    private static final double WEDNESDAY = 0.3;
    private static final double THURSDAY = 0.4;
    private static final double FRIDAY = 0.5;
    private static final double SATURDAY = 0.6;
    private static final double SUNDAY = 0.7;


    public void makeNewAlarm(double day, double inAlarm) {
        double[] input = new double[] {day, inAlarm};
        double[] output = new double[]{inAlarm}; //change to use cylce calculation for outuput

        alarmSet.addRow(input, output);
    }

    public void resetNet_Data(boolean resetNet, boolean resetData) {
        if (resetNet) 
            network.reset();
        if (resetData)
            alarmSet.clear();   
    }

    public void learnAlarms() {
        network.learn(alarmSet);
    }

    public static void main(String[] args) {
        adalineTest myTest = new adalineTest();
        myTest.makeNewAlarm(MONDAY, 0.93);
        myTest.makeNewAlarm(TUESDAY, 0.80);
        myTest.makeNewAlarm(WEDNESDAY, 0.70);
        myTest.makeNewAlarm(THURSDAY, 0.85);
        myTest.makeNewAlarm(FRIDAY, 0.10);
        myTest.makeNewAlarm(SATURDAY, 0.645);
        myTest.makeNewAlarm(SUNDAY, 0.6);
        network.calculate();
        double[] output = network.getOutput();
        double answer = output[0];
        System.out.println(answer);
        myTest.resetNet_Data(true, true);
    }
}