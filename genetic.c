#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define POP_SIZE 100
#define LOW 32
#define HIGH 126

const int helloWorld[] = {72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33};
const int helloWorldSize = sizeof(helloWorld)/sizeof(*helloWorld);
char *chromosomeStrings [POP_SIZE];
char *newChromosomeStrings [POP_SIZE];

/**
 * Function to create a random number
 * */
int getRandom(int min, int max) {
    int r = rand() % (max - min) + min;
    return r;
}

char *createString() {
    char randomString [helloWorldSize + 1] ;
    for(int i = 0; i < helloWorldSize; i++) {
        char charToAdd = getRandom(LOW, HIGH);
        randomString[i] = charToAdd;
    }
    // Add null terminating string
    randomString[helloWorldSize] = '\0';
    return strdup(randomString);
}

void createInitialString() {
    for (int i = 0; i < POP_SIZE; i++) {
        chromosomeStrings[i] = createString();
    }
}


int main() {
    int x = 20;
    char test [] = {'a', 'b', 'c'};
    chromosomeStrings[0] = strdup(test);
    srand(time(NULL));
    printf("Genetic algorithm\n");
    printf("%s \n", chromosomeStrings[0]);
    createInitialString();
    for(int i = 0; i < POP_SIZE; i++){
        printf("%s \n", chromosomeStrings[i]);
    }
    return 0;
}