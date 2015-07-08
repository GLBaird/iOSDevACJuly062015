//: Playground - noun: a place where people can play

import UIKit

let bbcURL = NSURL(string: "http://www.bbc.co.uk")
let bbcHTML = String(
    contentsOfURL: bbcURL!,
    encoding: NSUTF8StringEncoding,
    error: nil
)
