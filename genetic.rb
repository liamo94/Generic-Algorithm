$low = 32
$high = 126
$POP_SIZE = 100
$chromosomes = []
$newChromosomes = []
$startHighest = 0
$startHighestString = ''
$iteration = 0
$helloWorld = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
$helloWorldSize = $helloWorld.length

class Chromosome
    # Chromosome object
    def initialize(string, score)
        @string = string
        @score = score
    end

    def setScore=(score)
        @score = score
    end
    def setString=(string)
        @string = string
    end

    def getScore
        @score
    end
    def getString
        @string
    end
end

def fillArray()
    for i in 0..$POP_SIZE - 1
        string = createString()
        $chromosomes.push(Chromosome.new(string, calculateFitness(string)))
    end
end

def createString()
    string = []
    for i in 0..12
        n = Random.rand($low..$high)
        letter = n.chr
        string.push(letter)
    end
    return string
end

def calculateFitness(string)
    score = 0
    for i in 0..string.length - 1
        difference = (string[i].ord - $helloWorld[i]).abs
        score += difference
    end
    return score
end

def checkSolution()
    for i in 0..$POP_SIZE - 1
        if $chromosomes[i].getScore == 0
            return true
        end
    end
    return false
end

def setStartState()
    for i in 0..$POP_SIZE -1
        score = $chromosomes[i].getScore
        if ((i == 0) || score < $startHighest)
            $startHighest = score
            $startHighestString = $chromosomes[i].getString
        end
    end
end

def crossOver(parent1, parent2)
    rand = Random.rand(0..parent1.length)
    child1 = ''
    child2 = ''
    for i in 0..parent1.length-1
        if i >= rand
            child1 = child1 + parent1[i]
            child2 = child2 + parent2[i]
        else
            child1 = child1 + parent2[i]
            child2 = child2 + parent1[i]
        end
    end
    $newChromosomes.push(Chromosome.new(child1.chars, calculateFitness(child1.chars)))
    $newChromosomes.push(Chromosome.new(child2.chars, calculateFitness(child2.chars)))
end

def fitnessFunction(randomFour)
    fitnessScore = 0
    winnerPosition = 0
    for i in 0..randomFour.length - 1
        if ((i == 0) || (randomFour[i].getScore < fitnessScore))
            winnerPosition = i
            fitnessScore = randomFour[i].getScore
        end
    end
    return randomFour[winnerPosition]
end

def createNewPopulation()
    randomFour1 = []
    randomFour2 = []

    # Create first random 4
    for i in 0...3
        rand = Random.rand(0..$POP_SIZE-1)
        randomFour1.push($chromosomes[rand])
        rand2 = Random.rand(0..$POP_SIZE-1)
        randomFour2.push($chromosomes[rand2])
    end
    
    parent1 = fitnessFunction(randomFour1).getString
    parent2 = fitnessFunction(randomFour2).getString

    if (Random.rand(1..100) < 70)
        crossOver(parent1, parent2)
    else
        $newChromosomes.push(Chromosome.new(parent1, calculateFitness(parent1)))
        $newChromosomes.push(Chromosome.new(parent2, calculateFitness(parent2)))
    end
end

def mutate()
    for i in 0..$POP_SIZE-1
        if (Random.rand(1..100) < 5)
            stringToMutate = $chromosomes[i].getString
            answer = Random.rand(0..(stringToMutate.length - 1))
            fiftyFifty = Random.rand(0..1)
            chromosomeChar = $chromosomes[i].getString[answer]
            value = chromosomeChar.ord
            if (value == $low)
                value += 1
            elsif (value == $high)
                value -= 1
            else
                if (fiftyFifty == 0)
                    value += 1
                else
                    value -= 1
                end
            end
            $chromosomes[i].getString[answer] = value.chr
        end
    end
end

def main()
    fillArray()
    setStartState()
    while (!checkSolution())
        for i in 0..$POP_SIZE-1
            createNewPopulation()
        end
        currentHighest = 0
        highestString = ''
        for i in 0..$POP_SIZE-1
            score = $chromosomes[i].getScore
            if((i == 0) || (score < currentHighest))
                currentHighest = score
                highestString = $chromosomes[i].getString.join('')
            end
        end
        if (!checkSolution())
            $chromosomes.clear()
            $chromosomes = [].replace($newChromosomes)
            mutate()
            puts "#{$iteration}. Best = #{highestString}, #{currentHighest} off target"
            $newChromosomes.clear()
            $iteration += 1
        end
    end
    puts "Hello, World has been made"
    puts "Start string was #{$startHighestString.join('')}, (#{$startHighest} away from target)"
end

main()

BEGIN {
    
}

END {

}