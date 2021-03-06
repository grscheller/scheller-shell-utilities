package scalaImplicits
// Package showing syntax how to use implicit conversions in Scala 3.
//
//   See grok/Scala2/learnScala/implicits for the Scala 2
//   version I translated this from.  That version using the
//   the overly overloaded explicit key word.  For backward
//   compatibility, that version would still compile in Scala 3,
//   but would be deprecated.
//
// Todo: The sayHello method still needs to be updated to Scala 3

import scala.language.implicitConversions

case class IntWrapper(ii: Int) {
  def doubleMe = ii*2
  def tripleMe = ii*3
}

object IntWrapper {
  given doubleToInt: Conversion[Double, Int] with
    def apply(d:Double): Int = d.toInt
  given intToIntWrapper: Conversion[Int, IntWrapper] = IntWrapper(_)
  given doubleToIntWrapper: Conversion[Double, IntWrapper] = (x: Double) => IntWrapper(x.toInt)

  extension (first: Int)
    def x(second: Int) = IntWrapper(first * second)
}

object Main {

  import IntWrapper.doubleToInt
  import IntWrapper.intToIntWrapper
  import IntWrapper.doubleToIntWrapper
  import IntWrapper.x

  class PreferedName(name: String) {
    def getName = name
  }

  def sayHello(implicit preferedName: PreferedName) =
    println(s"Hello, ${preferedName.getName}")

  def main(args: Array[String]) = {
    val foo: Double = 42.314159
    val bar: Int = foo   // implicit conversion prevents this
                         // from being a type mismatch error
    print("foo = "); println(foo)
    print("bar = "); println(bar)
    print("4.tripleMe = "); println(4.tripleMe)      // add a method to Int
    print("foo.doubleMe = "); println(foo.doubleMe)  // add a method to Double
    print("bar x 10 = "); println(bar x 10)

    given geoffrey: PreferedName = new PreferedName("Geoffrey")
    val beowulf: PreferedName = new PreferedName("Beowulf")
    sayHello
    sayHello(using beowulf)
  }
}
