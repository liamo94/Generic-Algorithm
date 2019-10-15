#include <iostream>
#include <string>
#include <random>
#include <cstdlib>
#include <ctime>
//using namespace std;

#define POP_SIZE 100
#define LOW 32
#define HIGH 126

const int helloWorld[] = {72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33};
const int helloWorldSize = sizeof(helloWorld)/sizeof(*helloWorld);
char randomString[helloWorldSize];
int someValues[helloWorldSize];

int startHighest = 0;
char startHighestString[helloWorldSize];

class Chromosome {
    public:
        int score;
        char string [13];

    void setScore(int score);
    void setString(char string[]);
};

Chromosome chromosomes[POP_SIZE];
Chromosome newChromosomes[POP_SIZE];

int chromosomeSize = 0;
void Chromosome::setScore( int score ) {
   this->score = score;
}
void Chromosome::setString( char chString [] ) {
    for(unsigned int i = 0; i < sizeof(*chromosomes); i++){
        string[i] = chString[i];
    }
}

int getRandom(int low, int high) {
    std::random_device _rand;
    std::mt19937 randomValue(_rand());
    std::uniform_int_distribution<> createRandom(low, high);
    return createRandom(randomValue);
}

void createString() {
    std::fill(randomString, randomString+helloWorldSize, 0);
    for(int i = 0; i < helloWorldSize; i++) {
        char charToAdd = getRandom(LOW, HIGH);
        randomString[i] = charToAdd;
    }
}

int calculateFitness(Chromosome chrome) {
    int score = 0;
    for(int i = 0; i < helloWorldSize; i++) {
        int stringValue = chrome.string[i];
        int difference = std::abs(stringValue - helloWorld[i]);
        score += difference;
    }
    return score;
}

void setStartState() {
    for(int i = 0; i < POP_SIZE; i++){
        int score = chromosomes[i].score;
        if((i == 0) || (score < startHighest)) {
            startHighest = score;
            for(int j = 0; j < helloWorldSize; j++){
                startHighestString[j] = chromosomes[i].string[j];
            }
        }
    }
}

void fillArray() {
    for(int i = 0; i < POP_SIZE; i++) {
        createString();
        Chromosome chr;
        chr.setString(randomString);
        chr.setScore(calculateFitness(chr));
        chromosomes[i] = chr;
    }
}

bool checkSolution() {
    for(int i = 0; i < POP_SIZE; i++) {
        if(chromosomes[i].score == 0) {
            return true;
        }
    }
    return false;
}

Chromosome fitnessFunction(Chromosome randomFour [], int size) {
    int fitnessScore = 0;
    int winnerPosition = 0;
    for (int i = 0; i < size; i++) { 
        if ((i == 0) || (randomFour[i].score < fitnessScore)) {
            winnerPosition = i;
            fitnessScore = randomFour[i].score;
        }
    }
    return randomFour[winnerPosition];
}

void crossOver ( char parent1 [helloWorldSize], char parent2 [helloWorldSize]) {
    int rand = getRandom(0, helloWorldSize);
    char child1 [helloWorldSize];
    char child2 [helloWorldSize];

    for (int i = 0; i < helloWorldSize; i++) {
        if (i >= rand) {
            child1[i] = parent1[i];
            child2[i] = parent2[i];
        } else {
            child1[i] = parent2[i];
            child2[i] = parent1[i];
        }
    }

    Chromosome ch1;
    Chromosome ch2;
    ch1.setString(child1);
    ch1.setScore(calculateFitness(ch1));
    newChromosomes[chromosomeSize] = ch1;
    chromosomeSize++;
    ch2.setString(child2);
    ch2.setScore(calculateFitness(ch2));
    newChromosomes[chromosomeSize] = ch2;
    chromosomeSize++;

}

void createNewPopulation() {
    Chromosome randomFour1 [4];
    Chromosome randomFour2 [4];
    int randomValue = 0;

    for(int i = 0; i < 4; i++) {
        randomValue = getRandom(0, POP_SIZE-1);
        randomFour1[i] = chromosomes[randomValue];
    }
    for(int i = 0; i < 4; i++) {
        randomValue = getRandom(0, POP_SIZE-1);
        randomFour2[i] = chromosomes[randomValue];
    }

    Chromosome parent1Chrome = fitnessFunction(randomFour1, 4);
    Chromosome parent2Chrome = fitnessFunction(randomFour2, 4);
    char parent1String [helloWorldSize];
    char parent2String [helloWorldSize];
    for (int i = 0; i < helloWorldSize; i++) {
        parent1String[i] = parent1Chrome.string[i];
        parent2String[i] = parent2Chrome.string[i];
    }
    int n = getRandom(1, 100);
    if(n < 70) {
        crossOver(parent1String, parent2String);
    } else {
        Chromosome ch1;
        Chromosome ch2;
        ch1.setString(parent1String);
        ch1.setScore(calculateFitness(ch1));
        newChromosomes[chromosomeSize] = ch1;
        chromosomeSize++;
        ch2.setString(parent2String);
        ch2.setScore(calculateFitness(ch2));
        newChromosomes[chromosomeSize] = ch2;
        chromosomeSize++;

    }
}

void mutate() {
    for (int i = 0; i < POP_SIZE; i++) {
        int n = getRandom(1, 100);
        if (n < 5){
            char stringToMuatate[helloWorldSize];
            for (int j = 0; j < helloWorldSize; j++){
                stringToMuatate[j] = chromosomes[i].string[j];
            }
            int answer = getRandom(0, helloWorldSize-1);
            int fiftyFifty = getRandom(0, 1);
            char chromosomeString = stringToMuatate[answer];
            int changedCharacter = 0;
            int value = chromosomeString;
            if (value == HIGH) {
                value++;
            } else if (value == LOW) {
                value--;
            }
            else {
                if (fiftyFifty == 0) {
                    value++;
                } else {
                    value--;
                }
            }
            char newValue = value;
            chromosomes[i].string[answer] = newValue;
            chromosomes[i].score = calculateFitness(chromosomes[i]);
        }
    }
}

int main() {
    int iteration = 0;
    fillArray();
    setStartState();
    while (!checkSolution()) {
        for(int i = 0; i < POP_SIZE/2; i++){
            createNewPopulation();
        }
        int currentHighest = 0;
        char highestString[helloWorldSize + 1];
        for(int i = 0; i < POP_SIZE; i++){
            int score = chromosomes[i].score;
            if ((i == 0) || (score < currentHighest)) {
                currentHighest = score;
                for (int j = 0; j < helloWorldSize; j++) {
                    highestString[j] = chromosomes[i].string[j];
                }
            } 
            highestString[helloWorldSize] = '\0';  

        }
        if (!checkSolution()) {
            for(int i = 0; i < POP_SIZE; i++){
                chromosomes[i] = newChromosomes[i];
            }
            mutate();
            chromosomeSize = 0;
            iteration ++;
            std::cout << iteration << ". Best = " << highestString << " (" << currentHighest << " away from target)" << std::endl;
        }
        
    }
    std::cout << "Hello, World! has been made" << "\n\n";
    std::cout << "Start string was " << startHighestString << " (" << startHighest <<" away from target)" << "\n\n";
    return 0;
}
