package Chromosome;

sub new {
   my $class = shift;
   my $self = {
      _string => shift,
      _score  => shift,
   };

   bless $self, $class;
   return $self;
}
sub setString {
   my ( $self, $string ) = @_;
   $self->{_string} = $string if defined($string);
   return $self->{_string};
}

sub getString {
   my( $self ) = @_;
   return $self->{_string};
}

sub setScore {
    my ( $self, $score ) = @_;
    $self->{_score} = $score if defined($score);
    return $self->{_score};
}

sub getScore {
   my( $self ) = @_;
   return $self->{_score};
}

package main;

my $low = 32;
my $high = 126;
my $POP_SIZE = 100;
my @chromosomes = ();
my @newChromosomes = ();
my @helloWorld = (72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33);
my $startHighestScore = 0;
my $startHighestString = "";

sub random {
    # Get number of arguments passed
    $n = scalar(@_);
    if($n == 1){
        return int(rand($_[0]));
    }else{
        return int($_[0] + rand($_[1] - $_[0]));
    }
}

sub fillArray {   
    for( my $i = 0; $i < $POP_SIZE; $i = $i + 1 ) {
        my $string = createString();
        $chromosome = new Chromosome($string, calculateFitness($string));
        push @chromosomes, $chromosome;
    }
}

sub createString {
    @string = ();
    for($i = 0; $i < 13; $i++){
        $char = chr(random($low, $high + 1));
        push @string, $char;
    }
    $str = join("", @string);
    return $str;
}

sub calculateFitness {
    my $chromeString = $_[0];
    my $score = 0;
    my @characters = split //, $chromeString;
    for($i = 0; $i < 13; $i = $i + 1){
       my $difference = abs(ord($characters[$i]) - $helloWorld[$i]);
       $score = $score + $difference;
    }
    return $score;
}

sub checkSolution {
    for($i = 0; $i < $POP_SIZE; $i++) {
        $chromosome = $chromosomes[$i];
        $chromeScore = $chromosome->getScore();
        if($chromeScore == 0){
            return 1;
        }
    }
    return 0;
}

sub setStartState {
    for($i = 0; $i < $POP_SIZE; $i++) {
        my $chromosome = $chromosomes[$i];
        my $score = $chromosome->getScore();
        my $chromeString = $chromosome->getString();
        if ($i == 0 || $score < $startHighestScore) {
            $startHighestScore = $score;
            $startHighestString = $chromeString;

        }
    }
}

sub crossOver {
    my $child1 = "";
    my $child2 = "";
    @parent1 = split //, $_[0];
    @parent2 = split //, $_[1];
    my $n = scalar(@parent1);
    my $rand = random($n);
    for ($i = 0; $i < $n; $i++) {
        if($i >= $rand) {
            $child1 .= $parent1[$i];
            $child2 .= $parent2[$i];
        } else {
            $child1 .= $parent2[$i];
            $child2 .= $parent1[$i];
        }
    }
    $ch1 = new Chromosome($child1, calculateFitness($child1));
    $ch2 = new Chromosome($child2, calculateFitness($child2));
    push @newChromosomes, $ch1;
    push @newChromosomes, $ch2;
}

sub fitnessFunction {
    $fitnessScore = 0;
    $winnerPosition = 0;
    @chromes = @_;
    for ($i = 0; $i < scalar(@chromes); $i++) {
        my $chromosome = $chromes[$i];
        my $chromeScore = $chromosome->getScore();
        if (($i == 0) || $chromeScore < $fitnessScore) {
            $winnerPosition = $i;
            $fitnessScore = $chromeScore;
        }
    }
    return $_[$winnerPosition];
}

sub createNewPopulation {
    @randomFour1 = ();
    @randomFour2 = ();

    for (my $i = 0; $i < 4; $i++) {
        my $rand1 = random($POP_SIZE);
        push @randomFour1, $chromosomes[$rand1];
        my $rand2 = random($POP_SIZE);
        push @randomFour2, $chromosomes[$rand2]; 
    }
    my $parent1Chrome = fitnessFunction(@randomFour1);
    my $parent2Chrome = fitnessFunction(@randomFour2);
    my $parent1 = $parent1Chrome->getString();
    my $parent2 = $parent2Chrome->getString();
    if (random(1, 100) < 70){
        crossOver($parent1, $parent2);
    } else {
        $ch1 = new Chromosome($parent1, calculateFitness($parent1));
        $ch1 = new Chromosome($parent2, calculateFitness($parent2));
        push @newChromosomes, $ch1;
        push @newChromosomes, $ch2;
    }
}

sub mutate {
    for (my $i = 0; $i < $POP_SIZE; $i++) {
        if (random(1, 100)< 5) {
            my $chromosome = $chromosomes[$j];
            my $stringToMutate = $chromosome->getString();
            my $fiftyFifty = random(2);
            my @characters = split //, $stringToMutate;
            my $answer = random(scalar @characters);
            my $value = ord($characters[$answer]);
            if ($value == $low) {
                $value = $value + 1;
            } elsif ($value == $high) {
                $value = $value - 1;
            } else {
                if ($fiftyFifty == 0) {
                    $value = $value + 1;
                } else {
                    $value = $value - 1;
                }
            }
            $characters[$answer] = chr($value);
            my $str = join("", @characters);
            $chromosome->setString($str);
            $chromosome->setScore(calculateFitness($str));
        }
    }
}

sub main {
    my $iteration = 0;
    fillArray();
    setStartState();
   
    while (checkSolution() == 0){
        for(my $i = 0; $i < $POP_SIZE/2; $i++){
            createNewPopulation();
            #print "$i \n";
        }
        $currentHighest = 0;
        $highestString = "";
        for (my $j = 0; $j < $POP_SIZE/2; $j++) {
            my $chromosome = $chromosomes[$j];
            my $score = $chromosome->getScore();
            my $chromeString = $chromosome->getString();
            if ($j == 0 || $score < $currentHighest) {
                $currentHighest = $score;
                $highestString = $chromeString;
            }
        }
        if (checkSolution() == 0) {
            @chromosomes = ();
            @chromosomes = @newChromosomes;
            mutate();
            print "$iteration. Best = $highestString, $currentHighest off target \n";
            @newChromosomes = ();
            $iteration++;
        }
    }
    print "Hello, World! has been made \n";
    print "Start highest string was $startHighestString ($startHighestScore away from target) \n"
}

main();
