var Chromo = /** @class */ (function () {
    function Chromo(score, string) {
        this.score = score;
        this.string = string;
    }
    return Chromo;
}());
var Main = /** @class */ (function () {
    function Main() {
        this.low = 32;
        this.high = 126;
        this.POP_SIZE = 100;
        this.chromosomes = [];
        this.newChromosomes = [];
        this.startHighest = 0;
        this.iteration = 0;
        this.helloWorld = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33];
    }
    Main.prototype.run = function () {
        console.log('Running');
        console.log(this.createString());
    };
    /**
     * Creates a random String 13 characters long
     *
     * @returns {Array} chromosomes string (char array)
     */
    Main.prototype.createString = function () {
        var string = [];
        for (var i = 0; i < 13; i++) {
            var letter = this.random(this.low, this.high++);
            string.push(String.fromCharCode(letter));
        }
        return string;
    };
    /**
     * @method random
     *
     * @param {Number} [x] || {Array} [x]
     * @param {Number} [y] - optional (If blank, return number between 0 and x)
     *
     * @return {Number} random number (or {Object} of Array x)
     */
    Main.prototype.random = function (x, y) {
        if (typeof y === 'undefined') {
            if (x instanceof Array) {
                var index = Math.floor(Math.random() * x.length);
                return x[index];
            }
            else {
                return Math.floor(Math.random() * x);
            }
        }
        else {
            return Math.floor(Math.random() * (y - x) + x);
        }
    };
    return Main;
}());
var main = new Main();
main.run();
