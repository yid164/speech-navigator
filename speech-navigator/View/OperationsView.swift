//
//  OperationsView.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-07.
//

import SwiftUI

struct OperationsView: View {
    @State var selectedItem: Item? = nil

    @State var items: [Item] = [
        Item(number: 13, unit: Unit(symbol: "g")),
        Item(number: 14, unit: Unit(symbol: "g")),
        Item(number: 15, unit: Unit(symbol: "g")),
        Item(number: 16, unit: Unit(symbol: "g")),
        Item(number: 17, unit: Unit(symbol: "g"))
        
    ]
    
    var body: some View {
        Form {
            Section {
                Text("Start Your Operations")
            }
            
            ForEach(0 ..< items.count) { index in
                Section(header: Text("Item \(index)")) {
                    TextField("Record your item \(index)", text: items[index].itemValue )
                }
                .listRowBackground(Color( selectedItem == items[index] ? .blue : .systemBackground))
                .onTapGesture {
                    self.selectedItem = items[index]
                }
            }
        }
    }
}

struct OperationsView_Previews: PreviewProvider {
    static var previews: some View {
        OperationsView()
    }
}
