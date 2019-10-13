//high, low - the range of decimal ASCII codes for characters
let low =32;
let high = 126;
let POP_SIZE = 100;
let chromosomes= [];
let newChromosomes = [];
let startHighest = 0;
let startHighestString;

let iteration = 0;
// Hello, World!
let helloWorld = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33];

/**
 * Chromosome object
 */
function Chromosome() {
    this.score = 0;
    this.string = [];

    this.setScore = function(score) {
        this.score = score;
    }
    this.setName = function(string) {
        this.string = string;
    }
}

/**
 * Main method
 * 
 * @return void
 */
function main() {
    fillArray();
    setStartState();
    while(!checkSolution()) {
        for (let i = 0; i < POP_SIZE; i++) {
            createNewPopulation();
        }
        let currentHighest = 0;
        let highestString = '';
        for (let i = 0; i < POP_SIZE; i++) {
            let score = chromosomes[i].score;
            if ((i == 0) || (score < currentHighest)) {
                currentHighest = score;
                highestString = chromosomes[i].string.join('');
            }
        }
        if (!checkSolution()) {
            chromosomes = newChromosomes.slice();
            mutate();
            console.log(iteration + ". " + "Best = " + highestString + ", " + currentHighest + " off target");
    
            newChromosomes = [];
            iteration++;
        }
    }
    console.log('Hello, World! has been made');
    console.log(`Start string was ${startHighestString.join('')} (${startHighest} away from target)`);
}

/**
 * Run the application
 */
main();

/**
 * Creates a random String 13 characters long
 * 
 * @returns {Array} chromosomes string (char array)
 */
function createString() {
    let string = [];
    for (let i = 0; i < 13; i++) {
        let letter = random(low, high++);
        string.push(String.fromCharCode(letter));
   }
   return string;
}

/**
 * 
 * Fills the chromosome array with chromsomes
 * 
 * @returns void
 */
function fillArray() {
    for (let i = 0; i < POP_SIZE; i++) {
        let chr = new Chromosome();
        chr.setName(createString());
        chr.setScore(calculateFitness(chr));
        chromosomes.push(chr);
    }
}

/**
 * Takes in a character array and calculates how far away it is from the 
 * target String
 * 
 * @param {Array} characters
 * 
 * @returns {Int} the chrosmones score 
 */
function calculateFitness(chr) {
    let score = 0;
    for (let i = 0; i < chr.string.length; i++) {
        let difference =  Math.abs(chr.string[i].charCodeAt(0) - helloWorld[i]);
        score += difference;
    }
    return score;
}

/**
 * Constructs a String out of a character array
 * 
 * @param {Array} arr 
 * 
 * @return {String}
 */
function constructString(arr) {
    let string = '';
    arr.forEach(char => {
        string = string + char;
    });
    return string;
}

/**
 * Checks each Chromosome to see if it matches the correct solution
 * 
 * @return boolean
 */
function checkSolution() {
    for (let i =0; i < POP_SIZE; i++) {
        if (chromosomes[i].score == 0) {
            return true;
        }
    }
    return false;
}

/**
 * Find the closest string to the goal from the initial
 * population of chromosomes
 * 
 * @returns void
 */
function setStartState() {
    for (let i = 0; i < POP_SIZE; i++) {
        let score = chromosomes[i].score;
        if ((i == 0) ||(score < startHighest)) {
            startHighest = score;
            startHighestString = chromosomes[i].string;
        }
    }
}

/**
 * Takes in two parent strings and and crosses them over, 
 * adding them to the new chromosomes array.
 * 
 * @param {Array} parent1 - char array
 * @param {Array} parent2 - char array
 */
function crossOver(parent1, parent2) {
    let rand = random(parent1.length);
    let child1 = '';
    let child2 = '';
    // Create child 1
    for (let i = 0; i < parent1.length; i++) {
        if (i >= rand){
            child1 = child1 + parent1[i];
            child2 = child2 + parent2[i];
        }
        else {
            child1 = child1 + parent2[i];
            child2 = child2 + parent1[i];
        }
    }
    let ch1 = new Chromosome();
    let ch2 = new Chromosome();
    ch1.setName(child1.split(''));
    ch1.setScore(calculateFitness(ch1));
    newChromosomes.push(ch1);
    ch2.setName(child2.split(''));
    ch2.setScore(calculateFitness(ch2));
    newChromosomes.push(ch2);
}

/**
 * Function to create a new population based on the previous.
 * It will take 4 random chromosomes from the popualtion and pick
 * the best 2. 70% of them will be added straight into the new population,
 * with the further 30% crossed over.
 * 
 * @returns void
 */
function createNewPopulation() {
    let randomFour1 = [];
    let randomFour2 = [];

    // create random 4 population
    for (let i = 0; i < 4; i++) {
        randomFour1.push(random(chromosomes));
        randomFour2.push(random(chromosomes));
    }

    let parent1 = fitnessFunction(randomFour1).string;
    let parent2 = fitnessFunction(randomFour2).string;
    let n = random(1, 100);
    if (n < 70) {
        crossOver(parent1, parent2);
    } else {
        let ch1 = new Chromosome();
        let ch2 = new Chromosome();
        ch1.setName(parent1);
        ch1.setScore(calculateFitness(ch1));
        newChromosomes.push(ch1);
        ch2.setName(parent2);
        ch2.setScore(calculateFitness(ch2));
        newChromosomes.push(ch2);
    }
}

/**
 * Takes in 4 random strings and returns the string
 * with the highest fitness score.
 * 
 * @param {Array} randomFour [Strings]
 * 
 * @returns {String} highest scored string
 */
function fitnessFunction(randomFour) {
    let fitnessScore = 0;
    let winnerPosition = 0;
    for (let i = 0; i < randomFour.length; i++) {
        if ((i == 0) || (randomFour[i].score < fitnessScore)) {
            winnerPosition = i;
            fitnessScore = randomFour[i].score;
        }
    }
    return randomFour[winnerPosition];
}

/**
 * This function will loop through the array of chromosomes, and give them
 * a 5% chance of mutating (that is one letter will change by 1)
 * 
 * @returns void
 */
function mutate() {
    for (let i = 0; i < chromosomes.length; i++) {
        let n = random(1, 100);
        if (n < 5) {
            let StringToMutate = chromosomes[i].string;
            let answer = random(StringToMutate.length);
            let fiftyFifty = random(2);
            let chromosomeString = chromosomes[i].string[answer];
            let changedCharacter = 0;
            let value = chromosomeString.charCodeAt(0);
            if (value == low) {
                value += 1;
            } else if(value == high) {
                value -= 1;
            } else {
                fiftyFifty == 0 ? value += 1 : value-= 1;
            }
            chromosomes[i].string[answer] = String.fromCharCode(value);
        }
    }
}

/**
 * @method random
 * 
 * @param {Number} [x] || {Array} [x]
 * @param {Number} [y] - optional (If blank, return number between 0 and x)
 * 
 * @return {Number} random number (or {Object} of Array x)
 */
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

