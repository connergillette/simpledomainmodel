//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
      switch (to) {
      case "GBP":
        return Money(amount: Int(convertToGBP(currency)), currency: to)
      case "EUR":
        return Money(amount: Int(convertToEUR(currency)), currency: to)
      case "USD":
        return Money(amount: Int(convertToUSD(currency)), currency: to)
      case "CAN":
        return Money(amount: Int(convertToCAN(currency)), currency: to)
      default:
        return self
      }
  }
  
  private func convertToGBP(_ from : String) -> Double {
    switch(from) {
    case "USD":
      return Double(amount) * 0.5
    case "EUR":
      return Double(amount) * 1.5
    default:
      return Double(amount)
    }
  }
  
  private func convertToEUR(_ from : String) -> Double {
    switch(from) {
    case "USD":
      return Double(amount) * 1.5
    case "CAN":
      return Double(amount) * 0.6
    case "GBP":
      return Double(amount) * 0.3
    default:
      return Double(amount)
    }
  }
  
  private func convertToCAN(_ from : String) -> Double {
    switch(from) {
    case "USD":
      return Double(amount) * 1.25
    case "EUR":
      return Double(amount) * 1.875
    case "GBP":
      return Double(amount) * 0.67
    default:
      return Double(amount)
    }
  }
  
  private func convertToUSD(_ from : String) -> Double {
    switch(from) {
    case "CAN":
      return Double(amount) * 0.8
    case "EUR":
      return Double(amount) * (2 / 3)
    case "GBP":
      return Double(amount) * 2
    default:
      return Double(amount)
    }
  }
  
  public func add(_ to: Money) -> Money {
    if (to.currency == currency) {
      return Money(amount: self.amount + to.amount, currency: currency)
    } else {
      let _to = to.convert(currency)
      return Money(amount: self.amount + _to.amount, currency: currency).convert(to.currency)
    }
  }
  public func subtract(_ from: Money) -> Money {
    if (from.currency == currency) {
      return Money(amount: self.amount - from.amount, currency: currency)
    } else {
      let _from = from.convert(currency)
      return Money(amount: self.amount - _from.amount, currency: currency)
    }
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType
  
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch(type) {
    case (.Hourly(let hourly)):
      return Int(hourly * Double(hours))
    case (.Salary(let salary)):
      return Int(salary)
    }
  }
  
  open func raise(_ amt : Double) {
    switch(type) {
    case (.Hourly(let hourly)):
      type = JobType.Hourly(hourly + amt)
    case (.Salary(let salary)):
      type = JobType.Salary(Int(Double(salary) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0
  
  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
      return _job
    }
    set(value) {
      if(age > 15) {
        _job = value
      }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
      if(age > 15) {
        _spouse = value
      }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    var response = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age)"
    if let job = self.job?.title {
      response.append(" job:\(job)")
    } else {
      response.append(" job:nil")
    }
    if let spouse = self.spouse?.firstName {
      response.append(" spouse:\(spouse)")
    } else {
      response.append(" spouse:nil")
    }
    response.append("]")
    return response;
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    weak var _spouse1 = spouse1
    weak var _spouse2 = spouse2
    if(spouse1.spouse == nil) {
      spouse1.spouse = _spouse2
    }
    if(spouse1.spouse == nil) {
      spouse2.spouse = _spouse1
    }
    members.append(spouse1)
    members.append(spouse2)
    print("(Family) Members: \(members)")
  }
  
  open func haveChild(_ child: Person) -> Bool {
    for person in self.members {
      if person.age >= 21 {
        members.append(child)
        return true
      }
    }
    return false
  }
  
  open func householdIncome() -> Int {
    print("Checking household income...")
    var total = 0
    for person in members {
      if let income = person.job?.calculateIncome(2000) {
        total += income
      }
    }
    print("(householdIncome) Returning \(total)")
    return total
  }
}





