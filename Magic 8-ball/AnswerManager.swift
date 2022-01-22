//
//  AnswerManager.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 22.01.2022.
//

import Foundation

struct AnswerManager {
    let answerURL = "https://8ball.delegator.com/magic/JSON/should"
    
    // Make the API Request
    func performRequest() {
        if let url = URL(string: answerURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(safeData)
                }
            }
            
            task.resume()
        }
    }
    
    // Parse the JSON data
    func parseJSON(_ answerData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(AnswerData.self, from: answerData)
            print(decodedData.magic.answer)
        } catch {
            print(error)
        }
    }
}
