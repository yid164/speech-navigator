//
//  SpeechManager.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-06.
//

import Foundation
import Speech

class SpeechManager {
    public var isRecording = false
    
    private var audioEngine: AVAudioEngine!
    private var inputNote: AVAudioInputNode!
    private var audioSession: AVAudioSession!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { auth in
            DispatchQueue.main.async {
                switch auth {
                    case .authorized: break
                    default:
                        print("Speech recognition is not available")
                }
            }
        }
    }
    
    func start(completion: @escaping (String?) -> ()) {
        if isRecording {
            stopRecording()
        } else {
            startRecording(completion: completion)
        }
    }
    
    func stopRecording() {
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        audioEngine.stop()
        inputNote.removeTap(onBus: 0)
        
        try? audioSession.setActive(false)
        audioSession = nil
    }
    
    func startRecording(completion: @escaping (String?) -> ()) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            print("recognizer is not avavilbe")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        
        recognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
            guard error == nil else { return }
            
            guard let result = result else { return }
            
            if result.isFinal {
                completion(result.bestTranscription.formattedString)
            }
        }
        
        audioEngine = AVAudioEngine()
        inputNote = audioEngine.inputNode
        
        let recordingFormat = inputNote.outputFormat(forBus: 0)
        inputNote.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
        }
    }
}
