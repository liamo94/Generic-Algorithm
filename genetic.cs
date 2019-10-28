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
            int iteration = 0;
            while (!checkSolution()) {
                int currentHighest = 0;
                string highestString = "";
                for (int i = 0; i < POP_SIZE; i++) {
                    if (i < POP_SIZE)/2 {
                        createNewPopulation();
                    }
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

        private static void fillArray() {
            int score = 0;
            string chString;
            for (int i = 0; i < POP_SIZE; i++) {
                chString = makeString();
                Chromosome chromosome = new Chromosome(chString, calculateFitness(chString));
                population.Add(chromosome);
                score = (population[i].getScore());
                if (i == 0 || score < startHighest) {
                    startHighest = score;
                    startHighestString = population[i].getString();
                }
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

        private static int calculateFitness(string chString) {
            int score = 0;
            char[] stringToCheck = chString.ToCharArray();
            for (int i = 0; i < chString.Length; i++){
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

        private static void crossOver(string parent1, string parent2) {
            int position = random.Next(parent1.Length);
            char[] child1Chars = parent1.ToCharArray();
            char[] child2Chars = parent2.ToCharArray();
            string child1 = "";
            string child2 = "";

            for (int i = 0; i < parent1.Length; i++) {
                child1 += i >= position ? child1Chars[i] : child2Chars[i];
                child2 += i >= position ? child2Chars[i] : child1Chars[i];
            }

            Chromosome ch1 = new Chromosome(child1, calculateFitness(child1));
            Chromosome ch2 = new Chromosome(child2, calculateFitness(child2));
            newPopulation.Add(ch1);
            newPopulation.Add(ch2);
        }

        private static Chromosome fitnessFunction(List<Chromosome> randomFour) {
            int fitnessScore = 0;
            int winnerPosition = 0;

            for (int i = 0; i < randomFour.Count; i++) {
                if (i == 0 || randomFour[i].getScore() < fitnessScore) {
                    winnerPosition = i;
                    fitnessScore = randomFour[i].getScore();
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

            if (random.Next(1, 100) < 70) {
                crossOver(parent1, parent2);
            } else {
                Chromosome ch1 = new Chromosome(parent1, calculateFitness(parent1));
                Chromosome ch2 = new Chromosome(parent2, calculateFitness(parent2));
                newPopulation.Add(ch1);
                newPopulation.Add(ch2);
            }
        }

        private static void mutate() {
            for (int i = 0; i < POP_SIZE; i++) {
                if (random.Next(1, 100) < 5) {
                    string stringToMutate = population[i].getString();
                    int answer = random.Next(stringToMutate.Length);
                    char[] wordChar = stringToMutate.ToCharArray();
                    int changedCharacter = 0;
                    if((int)wordChar[answer] == low) {
                        changedCharacter = (int)wordChar[answer] + 1;
                    } else if ((int)wordChar[answer] == high) {
                        changedCharacter = (int)wordChar[answer] - 1;
                    } else {
                        changedCharacter = random.Next(2) == 0 ? (int)wordChar[answer] + 1 : (int)wordChar[answer] - 1;
                    }
                    wordChar[answer] = (char)changedCharacter;
                    string mutatedString = "";
                    for (int j = 0; j < wordChar.Length; j++) {
                        mutatedString = mutatedString + wordChar[j];
                    }
                    population[i].setString(mutatedString);
                    population[i].setScore(calculateFitness(population[i].getString()));
                }
            }
        }
        //END OF MAIN
    }

    class Chromosome {
        private string chString = "";
        private int score = 0;
        public Chromosome(string chString, int score) {
            this.chString = chString;
            this.score = score;
        }


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
