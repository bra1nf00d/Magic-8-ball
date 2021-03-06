//
//  AnswerManager.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 22.01.2022.
//

import Foundation

protocol AnswerManagerDelegate {
    func didUpdateAnswer(_ answer: String)
    func didFailWithError(message errorMessage: String)
}

struct AnswerManager {
    private let answerURL = "https://8ball.delegator.com/magic/JSON/should"
    private let defaults = UserDefaults.standard
    
    var delegate: AnswerManagerDelegate?
    
    // Make the API Request
    func performRequest() {
        if let url = URL(string: answerURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    if let answers = defaults.array(forKey: Constants.localStorage) as? [String] {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateAnswer(answers.randomElement()!)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.delegate?.didFailWithError(message: "Сheck your internet connection or add the answer yourself in settings")
                    }
                    return
                }
                
                if let safeData = data {
                    if let answer = self.parseJSON(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateAnswer(answer)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    // Parse the JSON data
    private func parseJSON(_ answerData: Data) -> String? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(AnswerData.self, from: answerData)
            return decodedData.magic.answer
        } catch {
            return nil
        }
    }
}
