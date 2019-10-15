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

class Chromosome:
    'Chromosome class'

    def __init__(self, string, score):
        self.string = string
        self.score = score

    def setScore(self, score):
        self.score = score

    def setName(self, string):
        self.string = string

def createString():
    string = []
    for i in range(0, 13):
        letter = random.randint(low, high)
        string.append(chr(letter))
    return string

def fillArray():
    for i in range(0, POP_SIZE):
        string = createString()
        chromosomes.append(Chromosome(string, calculateFitness(string)))
        score = calculateFitness(string)
        global startHighest
        global startHighestString
        if (i == 0 or score < startHighest):
            startHighest = score
            startHighestString = chromosomes[i].string
    return

def calculateFitness(string):
    score = 0
    for i in range(0, len(string)):
        difference = abs(ord(string[i]) - helloWorld[i])
        score += difference
    return score

def checkSolution():
    for i in range(0, POP_SIZE):
        if chromosomes[i].score == 0:
            return True
    return False

def constructString(strArr):
    return ''.join(strArr)


def crossOver(parent1, parent2):
    rand = random.randint(0, len(parent1))
    child1 = ''
    child2 = ''
    for i in range(0, len(parent1)):
        child1 += parent1[i] if i >= rand else parent2[i]
        child2 += parent2[i] if i >= rand else parent1[i]

    newChromosomes.append(Chromosome(list(child1), calculateFitness(list(child1))))
    newChromosomes.append(Chromosome(list(child2), calculateFitness(list(child2))))
    return

def fitnessFunction(randomFour):
    fitnessScore = 0
    winnerPosition = 0
    for i in range(0, len(randomFour)):
        if((i == 0) or (randomFour[i].score < fitnessScore)):
            winnerPosition = i
            fitnessScore = randomFour[i].score
    return randomFour[winnerPosition]

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
    if (random.randint(1,100) < 70):
        crossOver(parent1, parent2)
    else:
        newChromosomes.append(Chromosome(parent1, calculateFitness(parent1)))
        newChromosomes.append(Chromosome(parent2, calculateFitness(parent2)))
    
    return

def mutate():
    for i in range(0, len(chromosomes)):
        if (random.randint(1, 100) < 5):
            stringToMutate = chromosomes[i].string
            answer = random.randint(0, len(stringToMutate) - 1)
            fiftyFifty = random.randint(0, 1)
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
            chromosomes[i].score = calculateFitness(chromosomes[i].string)
    return

def main():
    global chromosomes
    global newChromosomes
    global iteration
    fillArray()
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
            print iteration , ". " , "Best = " , highestString,", (" , currentHighest , " off target)"
            newChromosomes = []
            iteration += 1
    print('Hello, World has been made')
    print'Start string was ' + constructString(startHighestString) + ' (', startHighest, ' away from target)'
    return

main()

