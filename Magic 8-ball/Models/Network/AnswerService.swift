//
//  AnswerService.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 25.02.2022.
//

import Foundation

protocol AnswerServiceDelegate {
    func didUpdateAnswer(_ answer: String)
    func didFailWithError(message errorMassage: String)
}

protocol AnswerServiceProvider {
    func loadAnswer()
    var delegate: AnswerServiceDelegate? { get set }
}

struct AnswerService: AnswerServiceProvider {
    private var client: AnswerClientProvider?
    private var storage: UserDefaultAnswersProvider?
    var delegate: AnswerServiceDelegate?
    
    init(client: AnswerClientProvider, storage: UserDefaultAnswersProvider) {
        self.client = client
        self.storage = storage
    }
    
    func loadAnswer() {
        client?.performRequestWithModel(url: "https://8ball.delegator.com/magic/JSON/should", model: AnswerData.self) { (data, error) in
            if error != nil {
                if let storedAnswer = storage?.loadAnswers(forKey: Constants.localStorage) {
                    DispatchQueue.main.async {
                        delegate?.didUpdateAnswer(storedAnswer.randomElement()!)
                    }
                } else {
                    DispatchQueue.main.async {
                        delegate?.didFailWithError(message: "The saved answers appear to be not found")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    delegate?.didFailWithError(message: error!.localizedDescription)
                }
            }
            
            if let safeData = data {
                let answer = safeData.magic.answer
                
                DispatchQueue.main.async {
                    delegate?.didUpdateAnswer(answer)
                }
            }
        }
    }
}
