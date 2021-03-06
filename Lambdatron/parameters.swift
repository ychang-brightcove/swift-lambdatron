//
//  parameters.swift
//  Lambdatron
//
//  Created by Austin Zheng on 2/9/15.
//  Copyright (c) 2015 Austin Zheng. All rights reserved.
//

import Foundation

/// A struct holding an arbitrary number of parameters without using heap storage if there are eight or fewer params.
struct Params : Printable, CollectionType, GeneratorType {
  private var a0, a1, a2, a3, a4, a5, a6, a7 : ConsValue?

  /// An array containing all parameters from 8 and onwards.
  private var others : [ConsValue]?

  /// How many parameters are stored within the struct.
  private(set) var count = 0

  /// When Params is being used as a generator, indicates the current parameter number.
  private var index = 0

  var description : String { return describe(nil) }

  var startIndex : Int { return 0 }
  var endIndex : Int { return count }

  init() { }

  init(_ a0: ConsValue) {
    self.a0 = a0
    count = 1
  }

  init(_ a0: ConsValue, _ a1: ConsValue) {
    self.a0 = a0; self.a1 = a1
    count = 2
  }

  init(_ a0: ConsValue, _ a1: ConsValue, _ a2: ConsValue) {
    self.a0 = a0; self.a1 = a1; self.a2 = a2
    count = 3
  }

  /// Return a Params consisting of all arguments in the current Params except for the first.
  func rest() -> Params {
    if self.count == 0 {
      return self
    }
    var newParams = Params()
    for (idx, item) in enumerate(self) {
      if idx > 0 {
        newParams.append(item)
      }
    }
    return newParams
  }

  /// Return a Params consisting of a prefix argument followed by all arguments in the current Params.
  func prefixedBy(prefix: ConsValue) -> Params {
    var newParams = Params(prefix)
    for item in self {
      newParams.append(item)
    }
    return newParams
  }

  /// Return the first item in the Params, or nil if none exists.
  var first : ConsValue? {
    return a0
  }

  /// Return the last item in the Params. Precondition: the Params is not empty.
  var last : ConsValue? {
    return count == 0 ? nil : self[count - 1]
  }

  /// An array containing all values within the Params. Note that this should be used sparingly, since it is relatively
  /// expensive (requiring the creation of a mutable array).
  var asArray : [ConsValue] {
    var buffer : [ConsValue] = []
    for item in self {
      buffer.append(item)
    }
    return buffer
  }

  /// Push another value onto the Params struct. This is ONLY meant for the use case where the Params struct is
  /// initially being populated.
  mutating func append(newValue: ConsValue) {
    switch count {
    case 0: a0 = newValue
    case 1: a1 = newValue
    case 2: a2 = newValue
    case 3: a3 = newValue
    case 4: a4 = newValue
    case 5: a5 = newValue
    case 6: a6 = newValue
    case 7: a7 = newValue
    default:
      others?.append(newValue)
      if others == nil {
        others = [newValue]
      }
    }
    count++
  }

   subscript(idx: Int) -> ConsValue {
    switch idx {
    case 0: return a0!
    case 1: return a1!
    case 2: return a2!
    case 3: return a3!
    case 4: return a4!
    case 5: return a5!
    case 6: return a6!
    case 7: return a7!
    default: return others![idx - 8]
    }
  }

  func generate() -> Params {
    return self
  }

  mutating func next() -> ConsValue? {
    if !(index < count) {
      return nil
    }
    let value = self[index]
    index++
    return value
  }
}
