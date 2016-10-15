//
//  Stanza.swift
//  HealthHackJazzHands
//
//  Created by Joe Scharf on 15/10/16.
//  Copyright © 2016 Julian Scharf. All rights reserved.
//

import Foundation

class Stanza {
  var index: Int
  var lines: [String]
  var on_at: Double
  var off_at: Double
  
  public init(index: Int, lines: [String], on_at:Double, off_at: Double) {
    self.index = index
    self.lines = lines
    self.on_at = on_at
    self.off_at = off_at
  }
}
