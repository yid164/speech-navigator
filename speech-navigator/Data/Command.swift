//
//  Command.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-07.
//

import Foundation

struct Command: Codable, Hashable, Identifiable {
    let id: UUID
    let created: Date
    let text: String
}
