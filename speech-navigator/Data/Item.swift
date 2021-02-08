//
//  Item.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-07.
//

import Foundation
import SwiftUI

class Item: Identifiable, Hashable {
    let id: UUID
    var number: Double
    var unit: Unit
    
    init(number: Double, unit: Unit) {
        self.id = UUID()
        self.number = number
        self.unit = unit
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension Item {
    var itemValue: Binding<String> {
        Binding<String>(
            get: { "\(self.number) \(self.unit.symbol)" },
            set: {
                self.number = Double($0.filter { $0.isNumber }) ?? 0
                self.unit = Unit(symbol: $0.filter { $0.isLetter })
            }
        )
    }
}
