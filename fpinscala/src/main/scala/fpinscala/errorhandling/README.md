# Functional Programming in Scala Book Exercises

## Handling errors without exceptions.

Chapter 4.

Implementing Option and Either error handling data structures while<br>
working through the exercises in  "Functional Programming in Scala"<br>
by Paul Chiusana and Runar Bjarnason.

### Trait [fpinscala.errorhandling.Option](Option.scala)
* A datatype containing a successful value or 
  indicating a failure occured.

### Program [OptionTest](OptionTest.scala)
* A program that parses to exercise fpinscala.errorhandling.Option.

### Trait [fpinscala.errorhandling.Either](Either.scala)
* A datatype containing either one or another
  of two possible types of values.

### Program [EitherTest](EitherTest.scala)
* A program that parses to exercise fpinscala.errorhandling.Either.

### Program [scalaErrorhandling](scalaErrorhandling.scala)
* Parsing and error handling using the scala libraries.
* Does not use fpinscala.errorhandling.

Book exercises give practice with combinators.  Combinators are<br>
higher order functions used to manipulate ADT's.  They allow you<br>
to avoid having to pattern match on the internal structure of the<br>
ADT's.  Also, the important concept of referential transparency is<br>
further explored.  Java exceptions are shown to not be referential<br>
transparent.

Methods are now being defined in the traits
as opposed to in the companion objects.