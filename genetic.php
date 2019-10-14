<html>
<head>
<style>
    p{
        margin-left: 20px;
    }
</style>
</head>
<body>

<h1>Genetic Algorithm</h1>
<p><small>(Note some special characters will be filtered out so to not break up the HTML tags)</small></p>
<!-- Run the code -->
<form method="post">
    <input type="submit" name="test" id="test" value="RUN" /><br/>
</form>


<?php
    $low = 32;
    $high = 126;
    $POP_SIZE = 100;
    $helloWorld = array(72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33);
    $startHighest = 0;
    $startHighestString = '';
    $helloWorldSize = sizeof($helloWorld);

    $chromosomes = [];
    $newChromosomes = [];

    class Chromosome {
       public $score;
       public $string = [];
    }

    function createString() {
        global $low;
        global $high;
        $string = [];
        for($i = 0; $i < 13; $i++){
            $letter = rand($low, $high);
            $string[] = chr($letter);
        }
        return $string;
    }

    function fillArray() {
        global $chromosomes, $POP_SIZE, $startHighest, $startHighestString;
        for($i = 0; $i < $POP_SIZE; $i++) {
            $chrome = new Chromosome();
            $chrome->string = createString();
            $chrome->score = calculateFitness($chrome);
            $chromosomes[] = $chrome;
            $score = $chromosomes[$i]->score;
            if (($i == 0) || ($score < $startHighest)) {
                $startHighest = $score;
                $startHighestString = $chromosomes[$i]->string;
            }
        }
    }

    function calculateFitness($chrome) {
        $score = 0;
        global $helloWorld;
        for($i = 0; $i < sizeof($chrome->string); $i++) {
            $difference = abs(ord($chrome->string[$i]) - $helloWorld[$i]);
            $score += $difference;
        }
        return $score;
    }

    function checkSolution() {
        global $chromosomes, $POP_SIZE;
        for($i = 0; $i < $POP_SIZE; $i++){
            if($chromosomes[$i]->score == 0){
                return true;
            }
        }
        return false;
    }

    function crossOver($parent1, $parent2) {
        global $newChromosomes;
        $rand = rand(0, sizeof($parent1)-1);
        $child1 = [];
        $child2 = [];

        // Create child 1
        for ($i = 0; $i < sizeof($parent1); $i++) {
            if ($i >= $rand) {
                $child1[] = $parent1[$i];
                $child2[] = $parent2[$i];
            } else {
                $child1[] = $parent2[$i];
                $child2[] = $parent1[$i];
            }
        }

        $ch1 = new Chromosome();
        $ch2 = new Chromosome();
        $ch1->string = $child1;
        $ch1->score = calculateFitness($ch1);
        $newChromosomes[] = $ch1;
        $ch2->string = $child2;
        $ch2->score = calculateFitness($ch2);
        $newChromosomes[] = $ch2;
    }

    function fitnessFunction($randomFour) {
        $fitnessScore = 0;
        $winnerPosition = 0;
        for ($i = 0; $i < sizeof($randomFour); $i++) {
            if (($i == 0) || ($randomFour[$i]->score < $fitnessScore)) {
                $winnerPosition = $i;
                $fitnessScore = $randomFour[$i]->score;
            }
        }
        return $randomFour[$winnerPosition];
    }

    function createNewPopulation() {
        global $POP_SIZE, $chromosomes, $newChromosomes;
        $randomFour1 = [];
        $randomFour2 = [];

        for ($i = 0; $i < 4; $i++) {
            $rand1 = rand(0, $POP_SIZE -1);
            $rand2 = rand(0, $POP_SIZE -1);
            $randomFour1[] = $chromosomes[$rand1];
            $randomFour2[] = $chromosomes[$rand2];
        }

        $parent1 = fitnessFunction($randomFour1)->string;
        $parent2 = fitnessFunction($randomFour2)->string;

        if (rand(1, 100) < 70) {
            crossOver($parent1, $parent2);
        } else {
            $ch1 = new Chromosome();
            $ch2 = new Chromosome();
            $ch1->string = $parent1;
            $ch1->score = calculateFitness($ch1);
            $newChromosomes[] = $ch1;
            $ch2->string = $parent2;
            $ch2->score = calculateFitness($ch2);
            $newChromosomes[] = $ch2;
        }
    }

    function mutate() {
        global $chromosomes, $low, $high, $POP_SIZE;
        for ($i = 0; $i < $POP_SIZE; $i++) {
            if (rand(1, 100) < 5) {
                $stringToMutate = $chromosomes[$i]->string;
                $answer = rand(0, sizeof($stringToMutate)-1);
                $fiftyFifty = rand(0, 1);
                $chromosomeString = $chromosomes[$i]->string[$answer];
                $changedCharacter = 0;
                $value = ord($chromosomeString);
                if ($value == $low) {
                    $value += 1;
                } else if ($value == $high) {
                    $value -=1;
                } else {
                    if ($fiftyFifty == 0) {
                        $value += 1;
                    } else{
                        $value -= 1;
                    }
                }
                $chromosomes[$i]->string[$answer] = chr($value);
            }
        }
    }

    function main() {
        global $chromosomes, $newChromosomes, $startHighest, $startHighestString, $POP_SIZE;
        echo '<div id="gaOutput">';
        $iteration = 0;
        fillArray();
            while (!checkSolution()) {
            for ($i = 0; $i < $POP_SIZE/2; $i++) {
                createNewPopulation();
            }
            $currentHighest = 0;
            $highestString = "";
            for ($i = 0; $i < $POP_SIZE; $i++) {
                $score = $chromosomes[$i]->score;
                if (($i == 0) || $score < $currentHighest) {
                    $currentHighest = $score;
                    $highestString = implode($chromosomes[$i]->string);
                }
            }
            $filteredString = filter_var($highestString, FILTER_SANITIZE_STRING);
            if (!checkSolution()) {
                $chromosomes = $newChromosomes;
                mutate();
                $newChromosomes = [];
                $iteration ++;
                echo "<p><b>" . $iteration . "</b>.Best = " . $filteredString . ', <span style="color: red">' . $currentHighest . "</span> off target</p>";
            }
        }
        echo "<p>Hello, World! has been made</p>";
        echo "<p>Start string was " . implode($startHighestString) . ' (<span style="color: red">' . $startHighest . '</span> away from target)'. "</p>";
        echo "</div>";
    }

    if(array_key_exists('test',$_POST)){
        main();
     }
?>
<!-- Button to clear the output of the chromosomes -->
<button onclick="clearDiv()">Clear</button>

<script>
/**
    Clear the output.
 */
function clearDiv() {
    var output = document.getElementById("gaOutput");
    if(output !== null){
        output.parentNode.removeChild(output);
    }
}
</script>
</body>


</html>
