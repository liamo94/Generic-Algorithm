# Generic-Algorithm
Generic Algorithm (evolution) written in numerous coding languages:

  __LANGUAGES__
  * C++
  * C#
  * Go
  * Java
  * JavaScipt
  * Kotlin
  * Ruby
  * Perl
  * PHP
  * Python
  * Swift
  * Typescript
   
 __Pseudocode:__
  ```
  Create inital population of POP_SIZE
  Calculate fitness
  WHILE string not made
    Selection
    Crossover
    Mutate
    Re-compute fitness
  RETURN NUMBER OF STEPS
```
  
This project was a challenge I set myself to write the same piece of code over as many languages as possible to see the differences. The code uses arrays, ints, strings, while loops, for loops, conditional logic and objects so I believe it was a great comparison of a small subsets of some of the features the languages have to offer. This was not to showcase best practices or the optimal solution for all languages (at least for the ones I am less familar with), but rather enforce the idea that all modern languages follow similar flows.

Compairson of performance**

| Language | Lines of code| Avg Permutations | Avg Time (ms) | Ratio permuations:time |
| ------------- |:-------------:|:-------------:|:-------------:|:-------------:|
| C++ ~     | 245 | 522 | 5,389 | 0.10 |
| C# ~      | 197| 256 | 120 | 2.13 |
| Go ~ | 187 | 316 | 58 | 5.45 |
| Java + |  215 | 214 | 218 | 0.98 |
| JavaScript ~ | 189 | 195 | 118 | 1.65 |
| Kotlin +| 169 | 214 | 113 | 1.65 |
| Ruby ~ | 197 | 277 | 324 | 0.85 |
| Perl ~ | 231 | 1,033 | 3,089 | 0.33 |
| PHP ± | 229 | 331 | 5,750 | 0.06 |
| Python ~ | 152 | 223 | 438 | 0.51 |
| Swift ~ | 177 | 77 | 178 | 0.43 |
| TypeScript ^ | 196 | 134 | 115 | 1.17 |

**The code was ran 10 times using a pool of 100 strings and the average time taken. Times are not meant to be a comparison of which language is better, rather a reference (e.g PHP was ran in a browser which would have been slower and I am not as strong with procedural languages like C++)

+Compiled and ran as jar

^Ran as transpiled JavaScript (then run with node)

~Ran in the terminal

±Ran in browser
