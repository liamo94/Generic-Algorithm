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

=begin
    Chromosome object
=end
class Chromosome
    # Chromosome object
    def initialize()
        @score = 0
        @string = ""
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

<<-DOC
    Creates the initial array of chromosomes

    @return void
DOC
def fillArray()
    for i in 0..$POP_SIZE - 1
        chrome = Chromosome.new()
        chrome.setString = createString()
        chrome.setScore = calculateFitness(chrome)
        $chromosomes.push(chrome)
    end
end

<<-DOC
    Creates a random string 13 characters long

    @return {Array <String>} characters (chromosome string)
DOC
def createString()
    string = []
    for i in 0..12
        n = Random.rand($low..$high)
        letter = n.chr
        string.push(letter)
    end
    return string
end

<<-DOC
    Takes in a character array and calculates how far away it is from
    the target string

    @param {Chromosome} chrome

    @return {int} score
DOC
def calculateFitness(chrome)
    score = 0
    for i in 0..chrome.getString.length - 1
        difference = (chrome.getString[i].ord - $helloWorld[i]).abs
        score += difference
    end
    return score
end

<<-DOC
    Checks each Chromosome to see if it matches the correct solution

    @return boolean
DOC
def checkSolution()
    for i in 0..$POP_SIZE - 1
        if $chromosomes[i].getScore == 0
            return true
        end
    end
    return false
end

<<-DOC
    Find the closest string to the goal from the initial population
    of chromosomes

    @return void
DOC
def setStartState()
    for i in 0..$POP_SIZE -1
        score = $chromosomes[i].getScore
        if ((i == 0) || score < $startHighest)
            $startHighest = score
            $startHighestString = $chromosomes[i].getString
        end
    end
end

<<-DOC
    Crosses over 2 strings

    @param {String} parent1
    @param {String} parent1

    @return void
DOC
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
    ch1 = Chromosome.new()
    ch2 = Chromosome.new()
    ch1.setString = child1.chars
    ch1.setScore = calculateFitness(ch1)
    $newChromosomes.push(ch1)
    ch2.setString = child2.chars
    ch2.setScore = calculateFitness(ch2)
    $newChromosomes.push(ch2)
end

<<-DOC
    Takes in an array of 4 chromosomes and return the chromosome
    with the highest fitness score

    @param {Array <Chromosomes>} randomFour

    @return {Chromosome}
DOC
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

<<-DOC
    This function creates a new population based on the previous.
    It will take 4 random chromosomes from the population and pick the
    best 2. 70% of them will be added straight into the new population,
    with the further 30% crossed over.

    @return void
DOC
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

    n = Random.rand(1..100)
    if (n < 70)
        crossOver(parent1, parent2)
    else
        ch1 = Chromosome.new()
        ch2 = Chromosome.new()
        ch1.setString = parent1
        ch1.setScore = calculateFitness(ch1)
        $newChromosomes.push(ch1)
        ch2.setString = parent2
        ch2.setScore = calculateFitness(ch2)
        $newChromosomes.push(ch2)
    end
end

<<-DOC
    This function will loop through the array of chromosomes, and give
    them a 5% chance of mutating (that is one letter will change by 1)

    @return void
DOC
def mutate()
    for i in 0..$POP_SIZE-1
        n = Random.rand(1..100)
        if (n < 5)
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

<<-DOC
    Main method to run the program

    @return void
DOC
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