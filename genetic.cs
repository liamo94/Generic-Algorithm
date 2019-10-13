using System;
using System.Collections.Generic;

namespace GeneticAlgorithm {

    class MainClass {

        static int[] helloWorld = { 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33};
        static List<Chromosome> population = new List<Chromosome>();
        static List<Chromosome> newPopulation = new List<Chromosome>();
        static int POP_SIZE = 100;
        private static Random random = new Random();
        static int startHighest = 0;
        static int low = 32;
        static int high = 126;
        static string startHighestString = "";

        public static void Main(string[] args) {
            fillArray();
            setStartState();
			int iteration = 0;
            while (!checkSolution()){
                for (int i = 0; i < POP_SIZE / 2; i++) {
                	createNewPopulation();
                }
                int currentHighest = 0;
                string highestString = "";
                for (int i = 0; i < POP_SIZE; i++) {
                	int score = population[i].getScore();
                	if (i == 0 || score < currentHighest) {
                		currentHighest = score;
                		highestString = population[i].getString();
                	}
                }
                    if (!checkSolution()) {
                        population = new List<Chromosome>(newPopulation);
                        mutate();
                        Console.WriteLine(iteration + ". Best = " + highestString + ", " + currentHighest + " off target");
                        newPopulation.Clear();
                        iteration++;
                    }
            }
			Console.WriteLine("\nHello, World! has been made");
            Console.WriteLine("Start string was " + startHighestString + " (" + startHighest + " away from target)");
        }

        /*
         * Creates an array of Chromosomes
         * 
         * @return void
         */
        private static void fillArray() {
            for (int i = 0; i < POP_SIZE; i++) {
                Chromosome chromosome = new Chromosome();
                chromosome.setString(makeString());
                chromosome.setScore(calculateFitness(chromosome));
                Console.WriteLine(chromosome.getScore());
                population.Add(chromosome);
            }
        }
        private static string makeString() {
            string chString = "";
            for (int i = 0; i < 13; i++) {
                int n = random.Next(32, 126);
                char s = (char)n;
                chString = chString + s;
            }
            return chString;
        }

        private static int calculateFitness(Chromosome chromosome) {
            int score = 0;
            string check = chromosome.getString();
            char[] stringToCheck = check.ToCharArray();
            for (int i = 0; i < check.Length; i++){
                score += Math.Abs((int)stringToCheck[i] - helloWorld[i]);
            }
            return score;
        }

        private static Boolean checkSolution() {
            for (int i = 0; i < POP_SIZE; i++) {
                if (population[i].getScore() == 0) {
					return true;
                }
            }
            return false;
        }

        private static void setStartState() {
            for (int i = 0; i < POP_SIZE; i++) {
                int score = population[i].getScore();
                if (i == 0 || score < startHighest) {
                    startHighest = score;
                    startHighestString = population[i].getString();
                }
            }
        }

        private static void crossOver(string parent1, string parent2) {
            int position = random.Next(parent1.Length);
            char[] child1Chars = parent1.ToCharArray();
            char[] child2Chars = parent2.ToCharArray();
            string child1 = "";
            string child2 = "";

            for (int i = 0; i < parent1.Length; i++) {
                if (i >= position) {
                    child1 += child1Chars[i];
                    child2 += child2Chars[i];
                } else {
                    child1 += child2Chars[i];
                    child2 += child1Chars[i];
                }
            }
            Chromosome ch1 = new Chromosome();
            Chromosome ch2 = new Chromosome();
            ch1.setString(child1);
            ch1.setScore(calculateFitness(ch1));
            newPopulation.Add(ch1);
            ch2.setString(child2);
            ch2.setScore(calculateFitness(ch2));
            newPopulation.Add(ch2);
        }

        private static Chromosome fitnessFunction(List<Chromosome> randomFour) {
            int fitnessScore = 0;
            int winnerPosition = 0;

            for (int i = 0; i < randomFour.Count; i++) {
                if (i == 0 || calculateFitness(randomFour[i]) < fitnessScore) {
                    winnerPosition = i;
                    fitnessScore = calculateFitness(randomFour[i]);
                }
            }
            return randomFour[winnerPosition];
        }

        private static void createNewPopulation() {
            List<Chromosome> randomFour1 = new List<Chromosome>();
            List<Chromosome> randomFour2 = new List<Chromosome>();
            for (int i = 0; i < 4; i++) {
                randomFour1.Add(population[random.Next(POP_SIZE)]);
                randomFour2.Add(population[random.Next(POP_SIZE)]);
            }
            string parent1 = fitnessFunction(randomFour1).getString();
            string parent2 = fitnessFunction(randomFour2).getString();

            int n = random.Next(1, 100);
            if (n < 70) {
                crossOver(parent1, parent2);
            } else {
                Chromosome ch1 = new Chromosome();
                Chromosome ch2 = new Chromosome();
                ch1.setString(parent1);
                ch1.setScore(calculateFitness(ch1));
                newPopulation.Add(ch1);
                ch2.setString(parent2);
                ch2.setScore(calculateFitness(ch2));
                newPopulation.Add(ch2);
            }
        }

        private static void mutate() {
            for (int i = 0; i < POP_SIZE; i++) {
                int n = random.Next(1, 100);
                if (n < 5) {
                    string stringToMutate = population[i].getString();
                    int answer = random.Next(stringToMutate.Length);
                    int fiftyFifty = random.Next(2);
                    char[] wordChar = stringToMutate.ToCharArray();
                    int changedCharacter = 0;
                    if((int)wordChar[answer] == low) {
                        changedCharacter = (int)wordChar[answer] + 1;
                    } else if ((int)wordChar[answer] == high) {
                        changedCharacter = (int)wordChar[answer] - 1;
                    } else {
                        if (fiftyFifty == 0) {
                            changedCharacter = (int)wordChar[answer] + 1;
                        } else {
                            changedCharacter = (int)wordChar[answer] - 1;
                        }
                    }
                    wordChar[answer] = (char)changedCharacter;
                    string mutatedString = "";
                    for (int j = 0; j < wordChar.Length; j++) {
                        mutatedString = mutatedString + wordChar[j];
                    }
                    population[i].setString(mutatedString);
                    population[i].setScore(calculateFitness(population[i]));
                }
            }
        }
        //END OF MAIN
    }

    class Chromosome {
        private string chString = "";
        private int score = 0;
        public Chromosome() {}


        public string getString() {
            return chString;
        }

        public void setString(string chString) {
            this.chString = chString;
        }

        public int getScore() {
            return score;
        }

        public void setScore(int score) {
            this.score = score;
        }

    }
}
