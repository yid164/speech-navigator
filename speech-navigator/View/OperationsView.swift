//
//  OperationsView.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-07.
//

import SwiftUI

struct OperationsView: View {
    @State var item1: String = ""
    @State var item2: String = ""
    
    var body: some View {
        Form {
            Section {
                Text("Start Your Operations")
            }
            
            Section(header: Text("Item 1")) {
                TextField("The first item", text: $item1)
            }
            
            Section(header: Text("Item 2")) {
                TextField("The second item", text: $item2)
            }
        }
    }
}

struct OperationsView_Previews: PreviewProvider {
    static var previews: some View {
        OperationsView()
    }
}
