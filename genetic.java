
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Genetic {

	private final static int POP_SIZE = 100;
	private final static int HIGH = 126;
	private final static int LOW = 32;
	private final static int[] helloWorld = {72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33};
	private static List<Chromosome> population = new ArrayList<>();
	private static List<Chromosome> newPopulation = new ArrayList<>();
	private static int startHighest = 0;
	private static String startHighestString = "";

	public static void main(String args[]) {
		System.out.println("Trying to make \"Hello World!\" ...\n");
		fillArray();
		int iteration = 0;
		
		while (!checkSolution()) {
			int currentHighest = 0;
			String highestString = "";
			for (int i = 0; i < POP_SIZE; i++) {
				createNewPopulation();
				int score = population.get(i).getScore();
				if (i == 0 || score < currentHighest) {
					currentHighest = score;
					highestString = population.get(i).getString();
				}
			}
			if (!checkSolution()) {
				population = clone(newPopulation);
				mutate();
				System.out.printf("%d. Best = %s, %d off target\n", iteration, highestString, currentHighest);
				newPopulation.clear();
				iteration++;
			}
		}
		
		System.out.println("\nHello World! has been made\n");
		System.out.printf("Start string was %s (%d away from target)\n", startHighestString, startHighest);
	}

	private static void fillArray() {
		String word = "";
		int score = 0;
		Chromosome chromosome;
		for (int i = 0; i < POP_SIZE; i++) {
			word = makeString();
			chromosome = new Chromosome(word, calculateFitness(word));
			population.add(chromosome);
			score = (population.get(i).getScore());
			if (i == 0 || score < startHighest) {
				startHighest = score;
				startHighestString = population.get(i).getString();
			}
		}
	}
	
	private static List<Chromosome> clone(List<Chromosome> original) {
	    List<Chromosome> copy = new ArrayList<>();
	    copy.addAll(original);
	    return copy;
	}

	private static int calculateFitness(String check) {
		int score = 0;
		char[] stringToCheck = check.toCharArray();
		for (int i = 0; i < check.length(); i++) {
			score += Math.abs(((int) stringToCheck[i]) - helloWorld[i]);
		}
		return score;
	}

	private static boolean checkSolution() {
		for (Chromosome chromsome: population) {
			if (chromsome.getScore() == 0) {
				return true;
			}
		}
		return false;
	}
	
	private static String makeString() {
		StringBuilder word = new StringBuilder();
		for (int j = 0; j < 12; j++) {
			Random rand = new Random();
			int n = rand.nextInt((HIGH - LOW) + 1) + LOW;
			char s = (char) n;
			word.append(s);
		}
		return word.toString();
	}

	private static void createNewPopulation() {
		Random rand = new Random();
		ArrayList<Chromosome> randomFour1 = new ArrayList<>();
		ArrayList<Chromosome> randomFour2 = new ArrayList<>();

		for (int i = 0; i < 4; i++) {
			randomFour1.add(population.get(rand.nextInt(POP_SIZE)));
			randomFour2.add(population.get(rand.nextInt(POP_SIZE)));
		}
		
		String parent1 = fitnessFunction(randomFour1).getString();
		String parent2 = fitnessFunction(randomFour2).getString();

		int n = rand.nextInt((100 - 1) + 1) + 1;
		if (n < 70) {
			crossOver(parent1, parent2);
		} else {
			newPopulation.add(new Chromosome(parent1, calculateFitness(parent1)));
			newPopulation.add(new Chromosome(parent2, calculateFitness(parent2)));
		}
	}

	private static void crossOver(String parent1, String parent2) {
		Random rand = new Random();
		int position = rand.nextInt(parent1.length());
		char[] child1Chars = parent1.toCharArray();
		char[] child2Chars = parent2.toCharArray();
		StringBuilder child1 = new StringBuilder();
		StringBuilder child2 = new StringBuilder();

		for (int i = 0; i < parent1.length(); i++) {
			child1.append(i >= position ? child1Chars[i] : child2Chars[i]);
			child2.append(i >= position ? child2Chars[i] : child1Chars[i]);
		}
		
		newPopulation.add(new Chromosome(child1.toString(), calculateFitness(child1.toString())));
		newPopulation.add(new Chromosome(child2.toString(), calculateFitness(child2.toString())));
	}

	private static Chromosome fitnessFunction(ArrayList<Chromosome> randomFour) {
		int fitnessScore = 0;
		int winnerPosition = 0;
		for (int i = 0; i < randomFour.size(); i++) {
			int winnerValue = 0;
			String word = randomFour.get(i).getString();
			char[] wordChar = word.toCharArray();
			for (int j =0; j < word.length(); j++) {
				winnerValue += Math.abs(((int)wordChar[j]) - helloWorld[j]);
			}
			if (i == 0) {
				fitnessScore = winnerValue;
			}
			else if (winnerValue < fitnessScore) {
				winnerPosition = i;
				fitnessScore = winnerValue;
			}
		}
		return randomFour.get(winnerPosition);
	}
	
	static void mutate(){
		Random rand = new Random();
		for (Chromosome chromosome: population) {
			int n = rand.nextInt((100 - 1) + 1) + 1;
			if (n < 5) {
				String stringToMutate = chromosome.getString();
				int answer = rand.nextInt(stringToMutate.length());
				char[] wordChar = stringToMutate.toCharArray();
				int changedCharacter = 0;
				if ((int) wordChar[answer] == LOW) {
					changedCharacter = (int) wordChar[answer] + 1;
				}
				else if ((int)wordChar[answer] == HIGH) {
					changedCharacter = (int) wordChar[answer] - 1;
				}
				else {
					changedCharacter = rand.nextInt(2) == 0 ? (int) wordChar[answer] + 1 : (int) wordChar[answer] - 1;
				}

				wordChar[answer] = (char) changedCharacter;
				String mutatedString = "";
				for (int j = 0; j < wordChar.length; j++) {
					mutatedString = mutatedString + wordChar[j];
				}
				chromosome.setString(mutatedString);
				chromosome.setScore(calculateFitness(mutatedString));
			}
		}
	}
}

class Chromosome {

	private String word;
	private int score;
	
	public Chromosome(String word, int score){
		this.word = word;
		this.score = score;
	}

	public String getString(){
		return word;
	}
	
	public void setString(String word){
		this.word = word;
	}
	
	public void setScore(int score){
		this.score = score;
	}
	
	public int getScore(){
		return score;
	}
}