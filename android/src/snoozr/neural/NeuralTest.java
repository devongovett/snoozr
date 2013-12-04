package snoozr.neural;

import org.junit.Test;

public class NeuralTest {
	@Test
	public void test() throws Exception {
		TrainingRecord records[] = {
				new TrainingRecord(new Points(.14), new Points(510.0/1440)),
				new TrainingRecord(new Points(.28), new Points(570.0/1440)),
				new TrainingRecord(new Points(.42), new Points(630.0/1440)),
				new TrainingRecord(new Points(.56), new Points(700.0/1440)),
				new TrainingRecord(new Points(.70), new Points(390.0/1440)),
				new TrainingRecord(new Points(.14), new Points(515.0/1440)),
				new TrainingRecord(new Points(.28), new Points(560.0/1440)),
				new TrainingRecord(new Points(.42), new Points(615.0/1440)),
				new TrainingRecord(new Points(.56), new Points(680.0/1440)),
				new TrainingRecord(new Points(.70), new Points(405.0/1440)),
				new TrainingRecord(new Points(.14), new Points(515.0/1440)),
				new TrainingRecord(new Points(.28), new Points(560.0/1440)),
				new TrainingRecord(new Points(.42), new Points(615.0/1440)),
				new TrainingRecord(new Points(.56), new Points(680.0/1440)),
				new TrainingRecord(new Points(.70), new Points(405.0/1440)),
				new TrainingRecord(new Points(.14), new Points(515.0/1440)),
				new TrainingRecord(new Points(.42), new Points(615.0/1440)),
				new TrainingRecord(new Points(.70), new Points(405.0/1440))
		};

		NeuralNet net = new NeuralNet(1, 1);
		net.minError = 0.0001;
		net.learningRate = 0.8;
		net.maxIterations = 75000;
		net.train(records);

		for (int i = 0; i < 5; i++) {
			double[] output = net.runInput(records[i].input).points;

			double sum = 0;
			int c = 0;
			for (int j = 0; j < records.length; j++) {
				if (records[i].getInputs()[0] == records[j].getInputs()[0]) {
					sum += records[j].getOutputs()[0];
					c++;
				}
			}
			double avg = 1440 * sum / c;

			int roundTime = 5;

			double newVal = (output[0] * 1400 + avg) / 2;
			int val = (int)newVal;

			if (avg > newVal)
				val += roundTime;

			if (avg != newVal)
				val -= (val % roundTime);

			System.out.printf("OUTPUT %d: %f %f %f %d\n", i, output[0] * 1440, avg, newVal, val);
		}
	}
}