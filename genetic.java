import java.util.ArrayList;
import java.util.Random;

public class genetic {

	static int POP_SIZE = 100;
	static int[] helloWorld = {72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33};
	static ArrayList<Chromosome> population = new ArrayList<>();
	static ArrayList<Chromosome> newPopulation = new ArrayList<>();
	static int startHighest = 0;
	static String startHighestString = "";

	public static void main(String args[]){
		System.out.println("---------------------------------");
		System.out.println("|   GENETIC ALGORITHM PROGRAM   |");
		System.out.println("---------------------------------");
		System.out.println("Trying to make \"Hello World!\" ...\n");
		fillArray();
		setStartState();
		int iteration = 0;
		
		while(!checkSolution()){
			for(int i = 0; i < POP_SIZE; i++){
				createNewPopulation();
				//WithoutCrossover.createNewPopulation();
				//RandomSelection.createNewPopulation();
			}
			int currentHighest = 0;
			String highestString = "";
			for(int i = 0; i < POP_SIZE; i++){
				int score = population.get(i).getScore();
				if(i == 0){
					currentHighest = score;
					highestString = population.get(i).getString();
				}else if(score < currentHighest){
					currentHighest = score;
					highestString = population.get(i).getString();
				}
			}
			if(!checkSolution()){
				population = (ArrayList<Chromosome>) newPopulation.clone();
				mutate();
				System.out.println(iteration + ". " + "Best = " + highestString + ", " + currentHighest + " off target");
				newPopulation.clear();
				iteration++;
			}

		}
		System.out.println("\nHello World! has been made\n");
		System.out.println("Start string was " + startHighestString + " (" + startHighest + " away from target)");
	}

	/**
	 * Creates an array of chromosomes
	 * 
	 * @return void
	 */
	private static void fillArray(){
		for(int i = 0; i < POP_SIZE; i++){
			Chromosome ch = new Chromosome();
			ch.makeString();
			ch.setScore(calculateFitness(ch.getString()));
			population.add(ch);
		}
	}

	/**
	 * Takes in a String and returns its fitness score
	 * 
	 * @param String
	 * @return Integer
	 */
	private static int calculateFitness(String check){
		int score = 0;
		char[] stringToCheck = check.toCharArray();
		for(int i = 0; i < check.length(); i++){
			score = score + Math.abs(((int)stringToCheck[i]) - helloWorld[i]);
		}
		return score;
	}

	/**
	 * Checks to see if the target string has been made
	 * 
	 * @return boolean
	 */
	private static boolean checkSolution(){
		for(int i = 0; i < population.size(); i++){
			if(population.get(i).getScore() == 0){
				return true;
			}
		}
		return false;
	}

	
	/**
	 * It will pick 2 sets of 4 random strings. It will pick the best string in
	 * the subset of 4. 70% of the time the 2 strings will be crossed over, with the
	 * other 30% being added straight to the array
	 * 
	 * @return void
	 */
	private static void createNewPopulation(){
		Random rand = new Random();
		ArrayList<Chromosome> randomFour1 = new ArrayList<>();
		ArrayList<Chromosome> randomFour2 = new ArrayList<>();

		//create first random 4
		for(int i = 0; i < 4; i++){
			int n = rand.nextInt(POP_SIZE);
			randomFour1.add(population.get(n));
		}

		//create second random 4
		for(int i = 0; i < 4; i++){
			int n = rand.nextInt(POP_SIZE);
			randomFour2.add(population.get(n));
		}
		String parent1 = fitnessFunction(randomFour1).getString();
		String parent2 = fitnessFunction(randomFour2).getString();

		int n = rand.nextInt((100 - 1) + 1) + 1;
		if(n < 70){
			crossOver(parent1, parent2);
		}else{
			Chromosome ch1 = new Chromosome();
			ch1.setString(parent1);
			ch1.setScore(calculateFitness(parent1));
			newPopulation.add(ch1);
			Chromosome ch2 = new Chromosome();
			ch2.setString(parent2);
			ch2.setScore(calculateFitness(parent2));
			newPopulation.add(ch2);
		}
	}

	/**
	 * Takes in 2 Strings and will crosses them over, adding the new Strings
	 * to the population array.
	 */
	private static void crossOver(String parent1, String parent2){
		Random rand = new Random();
		int position = rand.nextInt(parent1.length());
		char[] child1Chars = parent1.toCharArray();
		char[] child2Chars = parent2.toCharArray();
		String child1 = "";
		String child2 = "";

		//Create child 1
		for(int i = 0; i < parent1.length(); i++){
			if(i >= position){
				child1 = child1 + child1Chars[i];
			}
			else{
				child1 = child1 + child2Chars[i];
			}
		}
		//Create child 2
		for(int i = 0; i < parent2.length(); i++){
			if(i >= position){
				child2 = child2 + child2Chars[i];
			}
			else{
				child2 = child2 + child1Chars[i];
			}
		}
		Chromosome ch1 = new Chromosome();
		ch1.setString(child1);
		ch1.setScore(calculateFitness(child1));
		newPopulation.add(ch1);
		Chromosome ch2 = new Chromosome();
		ch2.setString(child2);
		ch2.setScore(calculateFitness(child2));
		newPopulation.add(ch2);
	}


	/**
	 * Takes in 4 strings and calculates the string with the best score,
	 * and returns it. 
	 * 
	 * @param ArrayList<Chromosome>
	 * @return Chromosome 
	 */
	private static Chromosome fitnessFunction(ArrayList<Chromosome> randomFour){
		int fitnessScore = 0;
		int winnerPosition = 0;
		for(int i = 0; i < randomFour.size(); i++){
			int winnerValue = 0;
			String word = randomFour.get(i).getString();
			char[] wordChar = word.toCharArray();
			for(int j =0; j < word.length(); j++){
				winnerValue = winnerValue + Math.abs(((int)wordChar[j]) - helloWorld[j]);
			}
			if(i == 0){
				fitnessScore = winnerValue;
			}
			else if(winnerValue < fitnessScore){
				winnerPosition = i;
				fitnessScore = winnerValue;
			}
		}
		return randomFour.get(winnerPosition);
	}
	
	/**
	 * Works out the closest string to target from initial list
	 * 
	 * @return void
	 */
	private static void setStartState(){
		for(int i = 0; i < POP_SIZE; i++){
			int score = (population.get(i).getScore());
			if(i == 0){
				startHighest = score;
				startHighestString = population.get(i).getString();
			}else if(score < startHighest){
				startHighest = score;
				startHighestString = population.get(i).getString();
			}
		}
	}

	/**
	 * This method will randomly mutate the array, with 5% of strings being
	 * mutated by one character.
	 * 
	 * @return void
	 */
	private static void mutate(){
		Random rand = new Random();
		for(int i = 0; i < population.size(); i++){
			int n = rand.nextInt((100 - 1) + 1) + 1;
			if(n < 5){
				String stringToMutate = population.get(i).getString();
				int answer = rand.nextInt(stringToMutate.length());
				int fiftyFifty = rand.nextInt(2);
				char[] wordChar = stringToMutate.toCharArray();
				int changedCharacter = 0;
				if((int)wordChar[answer] == 32){
					changedCharacter = (int)wordChar[answer] + 1;
				}
				else if((int)wordChar[answer] == 122){
					changedCharacter = (int)wordChar[answer] - 1;
				}
				else{
					if(fiftyFifty == 0){
						changedCharacter = (int)wordChar[answer] + 1;
					}else{
						changedCharacter = (int)wordChar[answer] - 1;
					}
				}

				wordChar[answer] = (char)changedCharacter;
				String mutatedString = "";
				for(int j = 0; j < wordChar.length; j++){
					mutatedString = mutatedString + wordChar[j];
				}
				population.get(i).setString(mutatedString);
			}
		}
	}
}

public class Chromosome {

	private String word = "";
	private int score = 0;
	public Chromosome(){
		
	}

	public void makeString() {
		for(int j = 0; j < 12; j++){
			Random rand = new Random();
			int n = rand.nextInt((122 - 32) + 1) + 32;
			String s = (Character.toString((char)n));
			word = word + s;
		}
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
