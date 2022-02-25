//
//  AnswerService.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 25.02.2022.
//

import Foundation

//protocol NetworkAnswerServiceDelegate {
//    func didUpdateAnswer(_ answer: String)
//    func didFailWithError(message errorMessage: String)
//}


//struct NetworkAnswerService {
//    private let apiURL = "https://8ball.delegator.com/magic/JSON/should"
//
//    private let delegate: NetworkAnswerServiceDelegate?
//    private let storage: UserDefaultAnswersProvider?
//    // init
//    //
//
//
////    DispatchQueue.main.async {
////        self.delegate?.didFailWithError(message: "Сheck your internet connection or add the answer yourself in settings")
////    }
//
//
////    if let storedAnswers = storage?.loadAnswers(forKey: Constants.localStorage) {
//    //                        DispatchQueue.main.async {
//    //                            self.delegate?.didUpdateAnswer(storedAnswers.randomElement()!)
//    //                        }
//    //                    }
//}

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
        client?.performRequestWithModel(url: "https://8ball.delegator.com/magic/JSON/should", model: AnswerData.self) { (data) in
            if let safeData = data {
                let answer = safeData.magic.answer
                
                DispatchQueue.main.async {
                    delegate?.didUpdateAnswer(answer)
                }
            } else {
                if let storedAnswer = storage?.loadAnswers(forKey: Constants.localStorage) {
                    DispatchQueue.main.async {
                        delegate?.didUpdateAnswer(storedAnswer.randomElement()!)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                   delegate?.didFailWithError(message: "Сheck your internet connection or add the answer yourself in settings")
                }
                return
            }
        }
    }
}
