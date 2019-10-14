//high, low - the range of decimal ASCII codes for characters
let low =32;
let high = 126;
let POP_SIZE = 100000;
let chromosomes= [];
let newChromosomes = [];
let startHighest = 0;
let startHighestString;

let iteration = 0;
// Hello, World!
let helloWorld = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33];

function Chromosome(string, score) {
    this.string = string;
    this.score = score;

    this.getString = function() {
        return this.string;
    }

    this.getScore = function() {
        return this.score;
    }

    this.setCharacter = function(index, character) {
        this.string[index] = character;
    }
}

function main() {
    fillArray();
    while (!checkSolution()) {
        for (let i = 0; i < POP_SIZE; i++) {
            createNewPopulation();
        }
        let currentHighest = 0;
        let highestString = '';
        for (let i = 0; i < POP_SIZE; i++) {
            let score = chromosomes[i].getScore();
            if (i == 0 || score < currentHighest) {
                currentHighest = score;
                highestString = chromosomes[i].getString().join('');
            }
        }
        if (!checkSolution()) {
            chromosomes = newChromosomes.slice();
            mutate();
            console.log(`${iteration}. Best = ${highestString}, ${currentHighest} off target`)
    
            newChromosomes = [];
            iteration++;
        }
    }
    console.log('\nHello, World! has been made');
    console.log(`Start string was ${startHighestString.join('')} (${startHighest} away from target)\n`);
}

main();

function createString() {
    let string = [];
    for (let i = 0; i < 13; i++) {
        string.push(String.fromCharCode(random(low, high)));
   }
   return string;
}

function fillArray() {
    let string, score;
    for (let i = 0; i < POP_SIZE; i++) {
        string = createString();
        chromosomes.push(new Chromosome(string, calculateFitness(string)));
        score = calculateFitness(string);
        if (i == 0 || score < startHighest) {
            startHighest = score;
            startHighestString = chromosomes[i].getString();
        }
    }
}

function calculateFitness(string) {
    let score = 0;
    for (let i = 0; i < string.length; i++) {
        score += Math.abs(string[i].charCodeAt(0) - helloWorld[i]);
    }
    return score;
}

function constructString(arr) {
    let string = '';
    arr.forEach(char => {
        string = string + char;
    });
    return string;
}

function checkSolution() {
    for (let i =0; i < POP_SIZE; i++) {
        if (chromosomes[i].getScore() == 0) {
            return true;
        }
    }
    return false;
}

function crossOver(parent1, parent2) {
    let rand = random(parent1.length);
    let child1 = '';
    let child2 = '';

    for (let i = 0; i < parent1.length; i++) {
        child1 += i >= rand ? parent1[i] : parent2[i];
        child2 += i >= rand ? parent2[i] : parent1[i];
    }

    newChromosomes.push(new Chromosome(child1.split(''), calculateFitness(child1.split(''))));
    newChromosomes.push(new Chromosome(child2.split(''), calculateFitness(child2.split(''))));
}

function createNewPopulation() {
    let randomFour1 = [];
    let randomFour2 = [];

    for (let i = 0; i < 4; i++) {
        randomFour1.push(random(chromosomes));
        randomFour2.push(random(chromosomes));
    }

    let parent1 = fitnessFunction(randomFour1).getString();
    let parent2 = fitnessFunction(randomFour2).getString();
    let n = random(1, 100);
    if (n < 70) {
        crossOver(parent1, parent2);
    } else {
        newChromosomes.push(new Chromosome(parent1, calculateFitness(parent1)));
        newChromosomes.push(new Chromosome(parent2, calculateFitness(parent2)));
    }
}

function fitnessFunction(randomFour) {
    let fitnessScore = 0;
    let winnerPosition = 0;
    for (let i = 0; i < randomFour.length; i++) {
        if (i == 0 || randomFour[i].score < fitnessScore) {
            winnerPosition = i;
            fitnessScore = randomFour[i].getScore();
        }
    }
    return randomFour[winnerPosition];
}

function mutate() {
    for (let i = 0; i < chromosomes.length; i++) {
        if (random(1, 100) < 5) {
            let StringToMutate = chromosomes[i].getString();
            let answer = random(StringToMutate.length);
            let chromosomeString = chromosomes[i].getString()[answer];
            let character = chromosomeString.charCodeAt(0);
            if (character == low) {
                character += 1;
            } else if (character == high) {
                character -= 1;
            } else {
                random(2) == 0 ? character += 1 : character -= 1;
            }
            chromosomes[i].setCharacter(answer, String.fromCharCode(character));
        }
    }
}

function random(x, y) {
    if (typeof y === "undefined") {
        if (x instanceof Array) {
            let index = Math.floor(Math.random() * x.length);    
            return x[index];
        } else {
            return Math.floor(Math.random() * x);            
        }
    } else {
        return Math.floor(Math.random() * (y - x) + x);
    }
}
