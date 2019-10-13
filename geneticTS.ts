class Chromo {
    private score: number;
    private string: string[];

    constructor(score: number, string: string[]) {
        this.score = score;
        this.string = string;
    }
}

class Main {
    private low: number = 32;
    private high: number = 126;
    private POP_SIZE: number = 100;
    private chromosomes: Chromo[] = [];
    private newChromosomes: Chromo[] = [];
    private startHighest: number = 0;
    private startHighestString: string;

    private iteration: number = 0;
    private helloWorld: number[] = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33];
    public run() {
        console.log('Running');
        console.log(this.createString());
    }

    /**
     * Creates a random String 13 characters long
     * 
     * @returns {Array} chromosomes string (char array)
     */
    private createString(): string[] {
        let string: string[] = [];
        for (let i = 0; i < 13; i++) {
            let letter: number = this.random(this.low, this.high++);
            string.push(String.fromCharCode(letter));
        }
        return string;
    }

    /**
     * @method random
     * 
     * @param {Number} [x] || {Array} [x]
     * @param {Number} [y] - optional (If blank, return number between 0 and x)
     * 
     * @return {Number} random number (or {Object} of Array x)
     */
    private random(x: any, y: number): any {
        if (typeof y === 'undefined') {
            if (x instanceof Array) {
                let index: number = Math.floor(Math.random() * x.length);    
                return x[index];
            } else {
                return Math.floor(Math.random() * x);            
            }
        } else {
            return Math.floor(Math.random() * (y - x) + x);
        }
    }
}
let main = new Main();

main.run();