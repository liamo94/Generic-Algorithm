import UIKit

class Chromosome {
    var score: Int
    var string: String
    
    init(string: String, score: Int) {
        self.score = score
        self.string = string
    }
}

let low = 32
let high = 126

let POP_SIZE = 100
var chromosomes = [Chromosome]()
var newChromosomes = [Chromosome]()

var startHighest = 0
var startHighestString = ""

var iteration = 0
let helloWorld = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]

func createString() -> String {
    var string = ""
    for _ in 1...helloWorld.count {
        let letter = Int.random(in: low ... high)
        let val = UnicodeScalar(letter)
        string += String(val!)
    }
    return string
}

func fillArray() {
    var score = 0
    var string = ""
    for i in 0...POP_SIZE-1 {
        string = createString()
        let chromosome = Chromosome(string: string, score: calculateFitness(string: string))
        chromosomes.append(chromosome)
        score = chromosome.score;
        if (i == 0 || score < startHighest) {
            startHighest = score
            startHighestString = chromosome.string
        }
    }
}

func calculateFitness(string: String) -> Int {
    var score = 0;
    let stringToCheck = Array(string);
    for i in 0...stringToCheck.count - 1 {
        let value = helloWorld[i]
        score = score + abs(Int(stringToCheck[i].asciiValue!) - value)
    }
    return score
}

func checkSolution() -> Bool {
    for i in 0...POP_SIZE-1 {
        if(chromosomes[i].score == 0) {
            return true
        }
    }
    return false
}

func crossOver(parent1: String, parent2: String) {
    let rand = Int.random(in: 0 ... parent1.count)
    var child1 = ""
    var child2 = ""
    for i in 0...parent1.count-1 {
        if i >= rand {
            child1 += String(Array(parent1)[i])
            child2 += String(Array(parent2)[i])
        } else {
            child1 += String(Array(parent2)[i])
            child2 += String(Array(parent1)[i])
        }
    }
    newChromosomes.append(Chromosome(string: child1, score: calculateFitness(string: child1)))
    newChromosomes.append(Chromosome(string: child2, score: calculateFitness(string: child2)))
}

func createNewPopulation() {
    var randomFour1 = [Chromosome]()
    var randomFour2 = [Chromosome]()
    var rand1: Int
    var rand2: Int
    for _ in 0...3 {
        rand1 = Int.random(in: 0 ... POP_SIZE-1)
        rand2 = Int.random(in: 0 ... POP_SIZE-1)
        randomFour1.append(chromosomes[rand1])
        randomFour2.append(chromosomes[rand2])
    }
    let parent1 = fitnessFunction(randomFour: randomFour1).string
    let parent2 = fitnessFunction(randomFour: randomFour2).string
    if Int.random(in: 1 ... 100) < 70 {
        crossOver(parent1: parent1, parent2: parent2)
    }
    else {
        newChromosomes.append(Chromosome(string: parent1, score: calculateFitness(string: parent1)))
        newChromosomes.append(Chromosome(string: parent2, score: calculateFitness(string: parent2)))
    }
}

func fitnessFunction(randomFour: [Chromosome]) -> Chromosome {
    var fitnessScore = 0
    var winnerPosition = 0
    for i in 0...randomFour.count-1 {
        if i == 0 || randomFour[i].score < fitnessScore {
            winnerPosition = i
            fitnessScore = randomFour[i].score
        }
    }
    return randomFour[winnerPosition]
}

func mutate() {
    for i in 0...POP_SIZE-1 {
        if Int.random(in: 0...5) < 5 {
            let stringToMutate = chromosomes[i].string
            let answer = Int.random(in: 0 ... stringToMutate.count-1)
            let index = stringToMutate.index(stringToMutate.startIndex, offsetBy: answer)
            let chromosomeString = stringToMutate[index]
            var character = chromosomeString.asciiValue!
            if character == low {
                character += 1
            } else if character == high {
                character -= 1
            } else {
                if Int.random(in: 0...1) == 0 {
                    character += 1
                } else {
                    character -= 1
                }
            }
            var stringArray = Array(stringToMutate)
            stringArray[answer] = Character(UnicodeScalar(character))
            chromosomes[i].string = String(stringArray)
            chromosomes[i].score = calculateFitness(string: String(stringArray))
        }
    }
}

func main() {
    print("Genetic Algorithm")
    fillArray()
    var iteration = 0
    while(!checkSolution()) {
    var currentHighest = 0
    var highestString = ""
        for i in 0...POP_SIZE-1 {
            createNewPopulation()
            if i == 0 || chromosomes[i].score < currentHighest {
                currentHighest = chromosomes[i].score
                highestString = chromosomes[i].string
            }
        }
        if(!checkSolution()) {
            chromosomes = newChromosomes
            newChromosomes.removeAll()
            mutate()
            print("\(iteration). Best = \(highestString), \(currentHighest) away from target")
            iteration += 1
        }
    }
     print("\nHello, World! has been made")
     print("Start string was \(startHighest) (\(startHighestString) away from target")
}


main()
