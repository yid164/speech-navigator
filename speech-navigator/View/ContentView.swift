//
//  ContentView.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Todo.created, ascending: true)], animation: .default) private var todos: FetchedResults<Todo>
    
    @State private var recording = false
    
    @ObservedObject private var mic = MicMonitor(numberOfSamples: 10)
    
    private var speechManager = SpeechManager()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(todos) { item in
                        Text(item.text ?? " - ")
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Speech Todo List")
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.primary.opacity(0.5))
                .padding()
                .overlay(
                    VStack {
                        visulizerView()
                    }
                )
                .opacity(recording ? 1 : 0)
            
            VStack {
                recordButton()
            }
        }.onAppear() {
            speechManager.checkPermissions()
        }
    }
    
    private func recordButton() -> some View {
        Button(action: addItem) {
            Image(systemName: recording ? "stop.fill" : "mic.fill")
                .font(.system(size: 40))
                .padding()
                .cornerRadius(10)
        }
        .foregroundColor(.red)
    }
    
    private func addItem() {
        if speechManager.isRecording {
            self.recording = false
            speechManager.stopRecording()
        } else {
            self.recording = true
            mic.startMonitoring()
            speechManager.start { speechText in
                guard let text = speechText, !text.isEmpty else {
                    self.recording = false
                    return
                }
                
                DispatchQueue.main.async {
                    withAnimation {
                        let newItem = Todo(context: viewContext)
                        newItem.id = UUID()
                        newItem.text = text
                        newItem.created = Date()
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        speechManager.isRecording.toggle()
    }
    
    private func normalizedSouldLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50)/2
        return CGFloat(level * (100/25))
    }
    
    private func visulizerView() -> some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(mic.soundSamples, id: \.self) { level in
                    VisualBarView(value: self.normalizedSouldLevel(level: level))
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todos[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
