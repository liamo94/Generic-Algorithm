#include <iostream>
#include <string>
#include <random>
#include <cstdlib>
#include <ctime>
#include <string>
//using namespace std;

#define POP_SIZE 100
#define LOW 32
#define HIGH 126

const int helloWorld[] = {72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33};
const int helloWorldSize = sizeof(helloWorld)/sizeof(*helloWorld);
int someValues[helloWorldSize];
std::clock_t    start;

int startHighest = 0;
char startHighestString[helloWorldSize];

/**
 * 
 * Chromosome class
 * 
 * */
class Chromosome {
    public:
        int score;
        char *string;

    void setScore(int score);
    void setString(char *string);
};

Chromosome chromosomes[POP_SIZE];
Chromosome newChromosomes[POP_SIZE];

int chromosomeSize = 0;
void Chromosome::setScore( int score ) {
   this->score = score;
}
void Chromosome::setString( char *chString ) {
        string = chString;
}

/*
    Uses Mersenne Twister PRNG ( pseudorandom number generator) to generate a random number.
    Generating a random number in C is a bitch.
*/
int getRandom(int low, int high) {
    std::random_device _rand;
    std::mt19937 randomValue(_rand());
    std::uniform_int_distribution<> createRandom(low, high);    
    return createRandom(randomValue);
}

char *createString() {
    char theString [helloWorldSize + 1];
    for(int i = 0; i < helloWorldSize; i++) {
        char charToAdd = getRandom(LOW, HIGH);
        theString[i] = charToAdd;
    }
    return strdup(theString);
}

/*
    Pass chromosome by reference to modify score
*/
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
    start = std::clock();
    for(int i = 0; i < POP_SIZE; i++){
        int score = chromosomes[i].score;
        if((i == 0) || (score < startHighest)) {
            startHighest = score;
            for(int j = 0; j < helloWorldSize; j++){
                startHighestString[j] = chromosomes[i].string[j];
            }
        }
    }
    std::cout << "start state Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;
}

/*
    Create an array of random chromosomes to begin with.
*/
void fillArray() {
    for(int i = 0; i < POP_SIZE; i++) {
        //char test[] = "a a a a a";
        Chromosome chr;
        chr.setString(createString());
        chr.setScore(calculateFitness(chr));
        chromosomes[i] = chr;
    }
}

/*
    Check if a chromosome is the solution
*/
bool checkSolution() {
    for(int i = 0; i < POP_SIZE; i++) {
        if(chromosomes[i].score == 0) {
            return true;
        }
    }
    return false;
}

Chromosome fitnessFunction(Chromosome randomFour [], int size) {
    start = std::clock();
    int fitnessScore = 0;
    int winnerPosition = 0;
    for (int i = 0; i < size; i++) { 
        if ((i == 0) || (randomFour[i].score < fitnessScore)) {
            winnerPosition = i;
            fitnessScore = randomFour[i].score;
        }
    }
   // std::cout << "fitness start Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;
    return randomFour[winnerPosition];
}

void crossOver ( char *parent1, char *parent2) {
    start = std::clock();
    int rand = getRandom(0, helloWorldSize-1);
    char *child1 = parent1;
    char *child2 = parent2;

    for (int i = 0; i < helloWorldSize; i++) {
        if (i >= rand) {
            child1[i] += parent1[i];
            child2[i] += parent2[i];
        } else {
            child1[i] += parent2[i];
            child2[i] += parent1[i];
        }
    }

    char *child1Add = child1;
    char *child2Add = child2;

    Chromosome ch1;
    Chromosome ch2;
    ch1.setString(strdup(child1));
    ch1.setScore(calculateFitness(ch1));
    newChromosomes[chromosomeSize] = ch1;
    chromosomeSize++;
    ch2.setString(child2);
    ch2.setScore(calculateFitness(ch2));
    newChromosomes[chromosomeSize] = ch2;
    chromosomeSize++;
   // std::cout << "crossover state Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;
}

void createNewPopulation() {
    start = std::clock();    
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
    char *parent1String;
    char *parent2String;

    parent1String = parent1Chrome.string;
    parent2String = parent2Chrome.string;

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
        //std::cout << "new pop start Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;

        // delete [] randomFour1;
        // delete [] randomFour2;
    }
}

void mutate(int i) {
    start = std::clock();    
    char stringToMuatate[helloWorldSize];
    for (int j = 0; j < helloWorldSize; j++){
        stringToMuatate[j] = chromosomes[i].string[j];
    }
    int answer = getRandom(0, helloWorldSize-1);
    int fiftyFifty = getRandom(0, 1);
    char chromosomeString = stringToMuatate[answer];
    int changedCharacter = 0;
    int value = chromosomeString;
    if (value == LOW) {
        value += 1;
    } else if (value == HIGH) {
        value -= 1;
    }
    else {
        if (fiftyFifty == 0) {
            value += 1;
        } else {
            value -= 1;
        }
    }
    char newValue = value;
    chromosomes[i].string[answer] = newValue;
            
    //std::cout << "mutate start Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;    
}

void engine() {
    int iteration = 0;
    fillArray();
    std::cout << "filled array" <<std::endl;
    setStartState();
    std::cout << "set start state" <<std::endl;
    // for(int i = 0; i < POP_SIZE; i++) {
    //     std::cout << chromosomes[i].string <<std::endl;
    // }
    while (!checkSolution()) {
        for(int i = 0; i < POP_SIZE/2; i++){
            createNewPopulation();
        }
        int currentHighest = 0;
        char *highestString;
        for(int i = 0; i < POP_SIZE; i++){
            int score = chromosomes[i].score;
            if ((i == 0) || (score < currentHighest)) {
                currentHighest = score;
                highestString = chromosomes[i].string;
            } 

        }
        if (!checkSolution()) { 
            for(int i = 0; i < POP_SIZE; i++){
                chromosomes[i] = newChromosomes[i];
                int n = getRandom(1, 100);
                if (n < 5){
                    mutate(i);
                }
            }
            chromosomeSize = 0;
            iteration ++;
            //std::cout << "restart start Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;    
            std::cout << iteration << ". Best = " << highestString << " (" << currentHighest << " away from target)" << std::endl;
        }
        
    }
    std::cout << "Hello, World! has been made" << "\n\n";
    std::cout << "Start string was " << startHighestString << " (" << startHighest <<" away from target)" << "\n\n";
}

int main() {
    //engine();
    fillArray();
    Chromosome randomFour1 [4];
    Chromosome randomFour2 [4];
    int randomValue = 0;

    for(int i = 0; i < 4; i++) {
        randomValue = getRandom(0, POP_SIZE-1);
        randomFour1[i] = chromosomes[randomValue];
        std::cout << randomFour1[i].string;
    }
    for(int i = 0; i < 4; i++) {
        randomValue = getRandom(0, POP_SIZE-1);
        randomFour2[i] = chromosomes[randomValue];
    }

    Chromosome parent1Chrome = fitnessFunction(randomFour1, 4);
    Chromosome parent2Chrome = fitnessFunction(randomFour2, 4);
    char *parent1String;
    char *parent2String;

    parent1String = parent1Chrome.string;
    parent2String = parent2Chrome.string;

    crossOver(parent1String, parent2String);

}