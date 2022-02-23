//
//  AnswerManager.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 22.01.2022.
//

import Foundation

protocol NetworkAnswerClientDelegate {
    func didUpdateAnswer(_ answer: String)
    func didFailWithError(message errorMessage: String)
}

protocol NetworkAnswerProvider {
    var delegate: NetworkAnswerClientDelegate? { get set }
    var storage: UserDefaultAnswersProvider? { get set }
    func performRequest()
}

struct NetworkAnswerClient: NetworkAnswerProvider {
    private let answerURL = Constants.answerURL
    var delegate: NetworkAnswerClientDelegate?
    var storage: UserDefaultAnswersProvider?
    
    // Make the API Request
    func performRequest() {
        if let url = URL(string: answerURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    if let storedAnswers = storage?.loadAnswers(forKey: Constants.localStorage) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateAnswer(storedAnswers.randomElement()!)
                        }
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