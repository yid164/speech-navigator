//
//  ContentView.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //@State private var commands: [Command] = []
    @State private var recording = false
    @ObservedObject private var mic = MicMonitor(numberOfSamples: 10)
    
    private var speechManager = SpeechManager()
    
    @State private var currentCommand: Command = .none
    @State private var currentIndex: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    OperationsView(currentIndex: $currentIndex)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Speech Commands List")
                .navigationBarTitleDisplayMode(.inline)
                
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
        Button(action: startRecording) {
            Image(systemName: recording ? "stop.fill" : "mic.fill")
                .font(.system(size: 40))
                .padding()
                .cornerRadius(10)
        }
        .foregroundColor(.red)
    }
    
    private func startRecording() {
        if speechManager.isRecording {
            self.recording = false
            speechManager.stopRecording()
            mic.stopMonitoring()
        } else {
            self.recording = true
            mic.startMonitoring()
            speechManager.start { speechText in
                if let text = speechText, !text.isEmpty {
                    if !fetchCommands(text: text) {
                        print(currentCommand)
                        speechManager.isRecording = false
                        startRecording()
                    } else {
                        speechManager.isRecording = false
                        startRecording()
                    }
                } else {
                    self.recording = false
                    return
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
    
    private func fetchCommands(text: String) -> Bool {
        switch text.lowercased() {
            case "next":
                currentCommand = .next
                if currentIndex != nil {
                    if currentIndex! <= 4 {
                        currentIndex! += 1
                    }
                } else {
                    currentIndex = 0
                }
                return false
            case "previous":
                currentCommand = .previous
                if currentIndex != nil {
                    if currentIndex! > 0 {
                        currentIndex! -= 1
                    }
                } else {
                    currentIndex = 0
                }
                return false
            default:
                currentCommand = .none
                return true
        }
    }
}


enum Command: CaseIterable {
    case previous, next, none
    
//    var commandValue: String {
//
//    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
