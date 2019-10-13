# Imports
import random

# Variables
low = 32
high = 126
chromosomes = []
newChromosomes = []
POP_SIZE = 100
helloWorld = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
startHighest = 0
startHighestString = ""
iteration = 0

'''
    The Chromosome object
'''
class Chromosome:
    'Chromosome class'

    def __init__(self):
        self.score = 0
        self.string = ""

    def setScore(self, score):
        self.score = score

    def setName(self, string):
        self.string = string

'''
    Creates a random string

    @return: {Array <String>} characters (chromosome string)
'''
def createString():
    string = []
    for i in range(0, 13):
        letter = random.randint(low, high)
        string.append(chr(letter))
    return string

'''
    Creates the initial array of chromosomes

    @return void
'''
def fillArray():
    for i in range(0, POP_SIZE):
        chrome = Chromosome()
        chrome.setName(createString())
        chrome.setScore(calculateFitness(chrome))
        chromosomes.append(chrome)
    return

'''
    Takes in a character array and calculates how far away it is from
    the target string

    @param {Chromosome} chrome

    @return {int} score
'''
def calculateFitness(chrome):
    score = 0
    for i in range(0, len(chrome.string)):
        difference = abs(ord(chrome.string[i]) - helloWorld[i])
        score += difference
    return score

'''
    Checks each Chromosome to see if it matches the correct solution

    @return boolean
'''
def checkSolution():
    for i in range(0, POP_SIZE):
        if chromosomes[i].score == 0:
            return True
    return False

'''
    Find the closest string to the goal from the initial population
    of chromosomes

    @return void
'''
def setStartState():
    for i in range(0, POP_SIZE):
        score = chromosomes[i].score
        global startHighest
        global startHighestString
        if ((i == 0) or (score < startHighest)):
            startHighest = score
            startHighestString = chromosomes[i].string
    return

def constructString(strArr):
    return ''.join(strArr)


'''
    Crosses over 2 strings

    @param {String} parent1
    @param {String} parent2

    @return: void
'''
def crossOver(parent1, parent2):
    rand = random.randint(0, len(parent1))
    child1 = ''
    child2 = ''
    for i in range(0, len(parent1)):
        if i >= rand:
            child1 = child1 + parent1[i]
            child2 = child2 + parent2[i]
        else:
            child1 = child1 + parent2[i]
            child2 = child2 + parent1[i]

    ch1 = Chromosome()
    ch2 = Chromosome()
    ch1.setName(list(child1))
    ch1.setScore(calculateFitness(ch1))
    newChromosomes.append(ch1)
    ch2.setName(list(child2))
    ch2.setScore(calculateFitness(ch2))
    newChromosomes.append(ch2)
    return

'''
    Takes in an array of 4 chromosomes and returns the chromosome
    with the highest fitness score

    @param {Array <Chromosomes>} randomFour

    @return {Chromosome}
'''
def fitnessFunction(randomFour):
    fitnessScore = 0
    winnerPosition = 0
    for i in range(0, len(randomFour)):
        if((i == 0) or (randomFour[i].score < fitnessScore)):
            winnerPosition = i
            fitnessScore = randomFour[i].score
    return randomFour[winnerPosition]

'''
    This function creates a new population based on the previous.
    It will take 4 random chromosomes from the population and pick the
    best 2. 70% of them will be added straight into the new population,
    with the further 30% crossed over.

    @return void
'''
def createNewPopulation():
    randomFour1 = []
    randomFour2 = []

    for i in range(0, 4):
        rand = random.randint(0, POP_SIZE - 1)
        rand2 = random.randint(0, POP_SIZE - 1)
        randomFour1.append(chromosomes[rand])
        randomFour2.append(chromosomes[rand2])
    
    parent1 = fitnessFunction(randomFour1).string
    parent2 = fitnessFunction(randomFour2).string
    n = random.randint(1,100)
    if (n < 70):
        crossOver(parent1, parent2)
    else:
        ch1 = Chromosome()
        ch2 = Chromosome()
        ch1.setName(parent1)
        ch1.setScore(calculateFitness(ch1))
        newChromosomes.append(ch1)
        ch2.setName(parent2)
        ch2.setScore(calculateFitness(ch2))
        newChromosomes.append(ch2)
    
    return

'''
    This function will loop through the array of chromosomes, and give
    them a 5% chance of mutating (that is one letter will change by 1)

    @return void
'''
def mutate():
    for i in range(0, len(chromosomes)):
        n = random.randint(1, 100)
        if (n < 5):
            stringToMutate = chromosomes[i].string
            answer = random.randint(0, len(stringToMutate) - 1)
            fiftyFifty = random.randint(0, 1)
            #print(answer, ' ', len(chromosomes[i].string))
            chromosomeChar = chromosomes[i].string[answer]
            value = ord(chromosomeChar)
            if (value == low):
                value += 1
            elif (value == high):
                value -= 1
            else:
                if (fiftyFifty == 0):
                    value += 1
                else:
                    value -= 1
            
            chromosomes[i].string[answer] = chr(value)
    return

'''
    Main method to run the program

    @return void
'''
def main():
    global chromosomes
    global newChromosomes
    global iteration
    fillArray()
    setStartState()
    while(not checkSolution()):
        for i in range (0, POP_SIZE):
            createNewPopulation()
        currentHighest = 0
        highestString = ''
        for i in range(0, POP_SIZE):
            score = chromosomes[i].score
            if((i == 0) or (score < currentHighest)):
                currentHighest = score
                highestString = constructString(chromosomes[i].string)
        if(not checkSolution()):
            chromosomes = newChromosomes[:]
            mutate()
            print(iteration, ". Best =" , highestString , "," , currentHighest , "off target")
            newChromosomes = []
            iteration += 1
    print('Hello, World has been made')
    print('Start string was ', constructString(startHighestString), ' (', startHighest, ' away from target)')

main()