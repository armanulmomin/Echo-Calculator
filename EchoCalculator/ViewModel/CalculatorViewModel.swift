//
//  CalculatorViewModel.swift
//  EchoCalculator
//
//  Created by Arman on 8/5/25.
//

import Foundation
import AVFoundation

class CalculatorViewModel: ObservableObject {
    @Published var model = CalculatorModel()

    private let synthesizer = AVSpeechSynthesizer()

    // Calculator layout buttons
    let buttons: [[String]] = [
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"],
        ["C"]
    ]

    // Handles button tap logic
    func handleTap(_ button: String) {
        speak(button) // Speak the input

        switch button {
        case "C":
            model.input = ""
            model.result = ""
        case "=":
            calculateResult()
        default:
            model.input.append(button)
        }
    }

    // Calculate result using NSExpression
    private func calculateResult() {
        let expression = model.input
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")

        let exp = NSExpression(format: expression)
        if let value = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            let resultText = "\(value)"
            model.result = "= \(resultText)"
            model.history.append("\(model.input) = \(resultText)") // Save to history
            speak(resultText) // Speak the result
        } else {
            model.result = "Error"
            speak("Error")
        }
    }

    // Text-to-speech using AVSpeechSynthesizer
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}

