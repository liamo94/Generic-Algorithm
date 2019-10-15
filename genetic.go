package main

import (
	"fmt"
	"math/rand"
	"strings"
	"time"
)

var helloWorld = [13]int{72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33}

const low = 32
const high = 126
const popSize = 100
const stringLength = len(helloWorld)

var startHighest = 0
var starHighestString = ""
var iteration = 0

var chromosomes = make([]Chromosome, popSize)
var newChromosomes = make([]Chromosome, 0)

// Chromosome object
type Chromosome struct {
	chromeString string
	score        int
}

func main() {
	fmt.Println("Genetic algorithm")
	fillArray()
	for true {
		for i := 0; i < popSize/2; i++ {
			createNewPopulation()
		}
		currentHighest := 0
		highestString := ""
		for i := 0; i < popSize; i++ {
			if i == 0 || chromosomes[i].score < currentHighest {
				currentHighest = chromosomes[i].score
				highestString = chromosomes[i].chromeString
			}
		}
		if !checkSolution() {
			copy(chromosomes, newChromosomes)
			newChromosomes = newChromosomes[:0]
			iteration++
			fmt.Printf("%v. Best = %v, %v off target\n", iteration, highestString, currentHighest)
			mutate()
		} else {
			break
		}
	}
	fmt.Println("\nHello, World! has been made\n")
	fmt.Printf("Start string was %v (%v away from target)\n", starHighestString, startHighest)
}

func fillArray() {
	score := 0
	newString := ""
	for i := 0; i < popSize; i++ {
		newString = createString()
		score = calculateFitness(newString)
		chromosomes[i] = Chromosome{chromeString: newString, score: score}
		if i == 0 || score < startHighest {
			startHighest = score
			starHighestString = chromosomes[i].chromeString
		}
	}
}

func createString() string {
	rand.Seed(time.Now().UTC().UnixNano())
	bytes := make([]byte, stringLength)
	for i := 0; i < stringLength; i++ {
		bytes[i] = byte(random(low, high))
	}
	return string(bytes)
}

func random(min int, max int) int {
	return min + rand.Intn(max-min)
}

func calculateFitness(chromeString string) int {
	score := 0
	stringArray := strings.Split(chromeString, "")
	for i := 0; i < len(stringArray); i++ {
		score = score + Abs(int([]byte(stringArray[i])[0])-helloWorld[i])
	}
	return score
}

func checkSolution() bool {
	for i := 0; i < popSize; i++ {
		if chromosomes[i].score == 0 {
			return true
		}
	}
	return false
}

func crossOver(parent1 string, parent2 string) {
	rand := random(0, stringLength)
	child1 := ""
	child2 := ""

	for i := 0; i < stringLength; i++ {
		if i >= rand {
			child1 += string(parent1[i])
			child2 += string(parent2[i])
		} else {
			child1 += string(parent2[i])
			child2 += string(parent1[i])
		}
	}
	newChromosomes = append(newChromosomes, Chromosome{chromeString: child1, score: calculateFitness(child1)})
	newChromosomes = append(newChromosomes, Chromosome{chromeString: child2, score: calculateFitness(child2)})
}

func createNewPopulation() {
	var randomFour1 [4]Chromosome
	var randomFour2 [4]Chromosome
	rand1 := 0
	rand2 := 0

	for i := 0; i < 4; i++ {
		rand1 = random(0, popSize)
		rand2 = random(0, popSize)
		randomFour1[i] = chromosomes[rand1]
		randomFour2[i] = chromosomes[rand2]
	}
	parent1 := fitnessFunction(randomFour1).chromeString
	parent2 := fitnessFunction(randomFour2).chromeString
	if random(1, 100) < 70 {
		crossOver(parent1, parent2)
	} else {
		newChromosomes = append(newChromosomes, Chromosome{chromeString: parent1, score: calculateFitness(parent1)})
		newChromosomes = append(newChromosomes, Chromosome{chromeString: parent2, score: calculateFitness(parent2)})
	}
}

func mutate() {
	for i := 0; i < popSize; i++ {
		if random(1, 100) < 5 {
			stringToMutate := chromosomes[i].chromeString
			answer := random(0, stringLength)
			chromosomeString := string(stringToMutate[answer])
			character := int([]byte(chromosomeString)[0])
			if character == low {
				character++
			} else if character == high {
				character--
			} else {
				if random(0, 2) == 0 {
					character++
				} else {
					character--
				}
			}
			stringArray := strings.Split(stringToMutate, "")
			stringArray[answer] = string(character)
			chromosomes[i].chromeString = strings.Join(stringArray, "")
		}
	}
}

func fitnessFunction(randomFour [4]Chromosome) Chromosome {
	fitnessScore := 0
	winnerPosition := 0
	for i := 0; i < len(randomFour); i++ {
		if i == 0 || randomFour[i].score < fitnessScore {
			winnerPosition = i
			fitnessScore = randomFour[i].score
		}
	}
	return randomFour[winnerPosition]
}

// Abs returns absolute value of two ints
func Abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
