//
//  Item.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-07.
//

import Foundation

struct Item: Identifiable, Hashable {
    let id: UUID
    let number: Double
    let unit: Unit
}
