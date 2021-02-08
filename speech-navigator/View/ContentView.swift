//
//  ContentView.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var commands: [Command] = []
    @State private var recording = false
    @ObservedObject private var mic = MicMonitor(numberOfSamples: 10)
    
    private var speechManager = SpeechManager()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
//                    ForEach(commands) { item in
//                        Text(item.text)
//                    }
//                    .onDelete(perform: deleteItems)
                    OperationsView()
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Speech Commands List")
                
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
            }
        }.onAppear() {
            speechManager.checkPermissions()
        }.navigationViewStyle(StackNavigationViewStyle())
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
            mic.stopMonitoring()
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
                        let newItem = Command(id: UUID(), created: Date(), text: text)
                        commands.append(newItem)
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
            commands.remove(atOffsets: offsets)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
