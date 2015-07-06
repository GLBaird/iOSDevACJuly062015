//: Playground - noun: a place where people can play

import UIKit


// variable
var username = "Leon"

// constant
let CONSTANT_VALUE = "BOB"

username = "Mike"


// Datatypes

var username2:String = "Leon"


var myInteger = 30
var myDouble = 23.475
var myCGFloat:CGFloat = 23.475

var anything:AnyObject = "Leon"
anything = 34
anything = "Mike"

let castedString = anything as! String

myDouble = Double(myCGFloat)

// String Ineteger Double Float AnyObject (as)
// NSString NSInteger, CGFloat

println("Hi there from SWIFT")

println("Username: "+username+" integer: "+myInteger.description)

println("Username: \(username) integer: \(myInteger)")

// collections

// Mutable Immutable

let numbers = [10, 20, 30, 40, 50]

numbers[0]

numbers.count
numbers.last

let numbers2:Array<Int> = [10, 20, 30, 40, 50]

let number3:[Int] = [10, 20, 30, 40 ,50]

var emptyNumbers = Array<Int>()

emptyNumbers.append(30)
emptyNumbers.append(60)
emptyNumbers.insert(10, atIndex: 0)

// Dictionary

var myDictionary = [
    "forename": "Leon",
    "surname": "Baird"
]

myDictionary["surname"]

myDictionary["surname"] = "Peters"
myDictionary["title"] = "Mr"

var mySet:Set<Int> = [10, 20, 30, 40]

/*
player.move(100, 200, 50, true)

[player moveToX:100
              y:200
          speed:50
  withAnimation:YES]
*/

func addValues(valA:Int, valB:Int) {
    println("Answer: \(valA+valB)")
}

addValues(10, 20)

func addValueA(valA:Int, toValB valB:Int) {
    println("Answer: \(valA+valB)")
}

addValueA(10, toValB: 20)

func addValues(valA a:Int, valB b:Int) -> Int {
    return a + b
}

addValues(valA: 10, valB: 20)

if username == "Leon" {
    println("Hi there")
} else {
    println("Go AWAY!")
}

username = "Evil"

switch username {
    case "Leon":
        println("Hi there")
    
    case "Mary", "Peter", "Paul":
        println("Hi from the groovy gang")
    
    case "Evil":
        println("Go AWAY")
        fallthrough
    
    case "Salesman":
        println("Go away forever!")
    
    default:
        println("Who the hell are you?")
}

let names = ["Bob", "Steve", "Mary", "Richard"]

for name in names {
   println("Hi there \(name)")
}

for i in 0...1000 {
    sin(Double(i)/50)
}


// tupples

func getMutliples(value:Int) -> (quad:Int, dub:Int, tripple:Int) {
    return (value*5, value*2, value*3)
}

getMutliples(5).quad

// optionals

var playerName:String?

playerName = "Bob"

if let value = playerName {
    println("Hi there \(value)")
}

if playerName != nil && !playerName!.isEmpty {
    println("Hi there \(playerName!)")
}

let anyList:[AnyObject] = [5, 30.6, "Steve"]

if let value = anyList[0] as? Int {
    println("Value is INT")
} else if let value = anyList[0] as? NSDate {
    println("Double")
} else if let value = anyList[0] as? String {
    println("Got a string")
}

var alwaysExists:Int!

// closures

var closure = {
    println("Hi there \(username)")
}

closure()

var calc = { (valA:Int, valB:Int) -> Int in
    return valA + valB
}

calc(10, 20)


// class

class Person {
    var surname = "Blank"
    var forename = "Blank"
    var age = 0
    
    var fullname:String {
        return forename+" "+surname
    }
    
    init() {
        //code
    }
    
    init(forename:String, surname:String, age:Int) {
        self.surname = surname
        self.forename = forename
        self.age = age
    }
    
    func getFullName() -> String {
        return forename+" "+surname
    }
}

var person1 = Person(forename: "Leon", surname: "Baird", age: 39)
person1.surname
person1.getFullName()
person1.forename = "Bob"
person1.getFullName()
person1.fullname


var person2 = Person()
person2.forename
person2.fullname

class BusinessPerson: Person {
    
    override init(forename:String, surname:String, age:Int) {
        super.init(forename: forename, surname: surname, age: age)
    }

    
    init(forename:String, surname:String, age:Int, position:String) {
        super.init(forename: forename, surname: surname, age: age)
        self.position = position
    }
    
    var position = "Tea Lady"
}

var person3 = BusinessPerson(forename: "Jane", surname: "Fonda", age: 200, position: "Exercise Lady")
person3.position




