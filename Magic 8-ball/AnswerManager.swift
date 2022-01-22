//
//  AnswerManager.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 22.01.2022.
//

import Foundation

protocol AnswerManagerDelegate {
    func didUpdateAnswer(_ answer: String)
    func didFailWithError(_ error: Error)
}

struct AnswerManager {
    let answerURL = "https://8ball.delegator.com/magic/JSON/should"
    
    var delegate: AnswerManagerDelegate?
    
    // Make the API Request
    func performRequest() {
        if let url = URL(string: answerURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let answer = self.parseJSON(safeData) {
                        self.delegate?.didUpdateAnswer(answer)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    // Parse the JSON data
    func parseJSON(_ answerData: Data) -> String? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(AnswerData.self, from: answerData)
            return decodedData.magic.answer
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
