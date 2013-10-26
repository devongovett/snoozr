Example on how to load net into java file.


public class blah
{
    NeuralNetwork network = NeuralNetwork.load("neural_traffic.nnet");
 
    public static void main(String[] args)
    {
        new TestTrafficNeural().go();
    }
 
    private void go()
    {
        calculate(1,0,0);
        calculate(0,1,0);
        calculate(0,0,1);
    }
 
    private void calculate(double... input)
    {
        network.setInput(input);
        network.calculate();
        Vector output = network.getOutput();
        Double answer = output.get(0);
        System.out.println(answer);
    }
}

we can train and test with code on the fly, but don't make enormous test files, keep realistic.