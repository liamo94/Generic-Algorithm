import java.util.Random

val helloWorld: IntArray = intArrayOf(72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33)
var HIGH: Int = 126
var LOW: Int = 32
var POP_SIZE: Int = 100
var startHighest = 0
var startHighestString = ""
var chromosomes: MutableList<Chromosome> = mutableListOf()
var newChromosomes: MutableList<Chromosome> = mutableListOf()

fun main(args: Array<String>) {
    fillArray()
    var iteration = 0
    while (!checkSolution()) {
        var currentHighest = 0
        var highestString = ""
        for(i in 0 until POP_SIZE) {
            if (i < POP_SIZE/2) {
            createNewPopulation()
            }
            if(i == 0 || chromosomes[i].score < currentHighest) {
                currentHighest = chromosomes[i].score
                highestString = chromosomes[i].string
            }
        }
        if(!checkSolution()) {
            chromosomes = newChromosomes.toMutableList()
            mutate()
            println("$iteration. Best = $highestString, $currentHighest off target")
            newChromosomes = mutableListOf()
            iteration++
        }
    }
    println("\nHello, World! has been made")
    println("Start string was $startHighestString ($startHighest away from target)")
}

class Chromosome(var string: String, var score: Int) {

}

fun createString(): String {
    val sb = StringBuilder()
    val rand = Random()
    for (i in 0 until 13) {
        var n = rand.nextInt((HIGH - LOW) + 1) + LOW
        sb.append(n.toChar())
    }
    return sb.toString()
}

fun calculateFitness(string: String): Int {
    var score = 0
    val stringToCheck = string.toCharArray()
    for (i in 0 until string.length) {
        score += Math.abs((stringToCheck[i].toInt()) - helloWorld[i])
    }
    return score
}

fun fillArray() {
    var word = ""
    var score = 0
    var chromosome: Chromosome
    for (i in 0 until POP_SIZE) {
        word = createString()
        score = calculateFitness(word)
        chromosome = Chromosome(word, score)
        chromosomes.add(chromosome)
        if(i == 0 || score < startHighest) {
            startHighest = score
            startHighestString = word
        }
    }
}

fun checkSolution(): Boolean {
    for(chromosome in chromosomes) {
        if(chromosome.score == 0) {
            return true
        }
    }
    return false
}

fun createNewPopulation() {
    var randomFour1: MutableList<Chromosome> =  mutableListOf()
    var randomFour2: MutableList<Chromosome> = mutableListOf()
    val rand = Random()

    for(i in 1..4) {
        randomFour1.add(chromosomes[rand.nextInt(POP_SIZE)])
        randomFour2.add(chromosomes[rand.nextInt(POP_SIZE)])
    }

    val parent1 = fitnessFunction(randomFour1).string
    val parent2 = fitnessFunction(randomFour2).string
    val n = rand.nextInt(100 - 1 + 1) + 1
    if(n < 70) {
        crossOver(parent1, parent2)
    } else {
        newChromosomes.add(Chromosome(parent1, calculateFitness(parent1)))
        newChromosomes.add(Chromosome(parent2, calculateFitness(parent2)))
    }
}

fun crossOver(parent1: String, parent2: String) {
    val rand = Random()
    val position = rand.nextInt(parent1.length)
    val child1Chars = parent1.toCharArray()
    val child2Chars = parent2.toCharArray()
    var child1 = StringBuilder()
    var child2 = StringBuilder()
    for(i in 0 until parent1.length) {
        child1.append(if (i >= position) child1Chars[i] else child2Chars[i])
        child2.append(if (i >= position) child2Chars[i] else child1Chars[i])
    }
    newChromosomes.add(Chromosome(child1.toString(), calculateFitness(child1.toString())))
    newChromosomes.add(Chromosome(child2.toString(), calculateFitness(child2.toString())))

}

fun fitnessFunction(randomFour: MutableList<Chromosome>): Chromosome {
    var fitnessScore = 0
    var winnerPosition = 0
    for (i in 0 until randomFour.size) {
        var winnerValue = 0
        var word = randomFour[i].string.toCharArray()
        for(j in 0 until word.size) {
            winnerValue +=  Math.abs((word[j].toInt()) - helloWorld[j])
        }
        if(i == 0 || winnerValue < fitnessScore) {
            winnerPosition = i
            fitnessScore = winnerValue
        }
    }
    return randomFour[winnerPosition]
}

fun mutate() {
    val rand = Random()
    for (chromosome in chromosomes) {
        val n = rand.nextInt((100 - 1) + 1) + 1
        if (n < 5) {
            var stringToMutate = chromosome.string
            var answer = rand.nextInt(stringToMutate.length)
            var wordChar = stringToMutate.toCharArray()
            var changedCharacter: Int
            if (wordChar[answer].toInt() == 32) {
                changedCharacter = wordChar[answer].toInt() + 1
            }
            else if (wordChar[answer].toInt() == 126) {
                changedCharacter = wordChar[answer].toInt() - 1
            }
            else {
                changedCharacter = if (rand.nextInt(2) == 0)  wordChar[answer].toInt() + 1 else wordChar[answer].toInt() - 1
            }

            wordChar[answer] = changedCharacter.toChar()
            var mutatedString = ""
            for (i in 0 until wordChar.size) {
                mutatedString += wordChar[i]
            }
            chromosome.string = mutatedString
            chromosome.score = calculateFitness(mutatedString)
        }
    }
}