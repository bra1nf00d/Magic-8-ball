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
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                }
            }
            
            task.resume()
        }
    }
}
