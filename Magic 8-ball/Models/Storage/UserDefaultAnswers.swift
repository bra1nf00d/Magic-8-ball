//
//  UserDefaultAnswers.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 23.02.2022.
//

import Foundation

protocol UserDefaultAnswersProvider {
    func saveAnswers(_ answers: [String]?, forKey key: String)
    func loadAnswers(forKey key: String) -> [String]?
}

struct UserDefaultAnswers: UserDefaultAnswersProvider {
    private let defaults = UserDefaults.standard
    
    func saveAnswers(_ answers: [String]?, forKey key: String) {
        if let safeAnswers = answers {
            defaults.set(safeAnswers, forKey: key)
        }
    }
    
    func loadAnswers(forKey key: String) -> [String]? {
        if let answers = defaults.array(forKey: key) as? [String] {
            if !answers.isEmpty {
                return answers
            }
        }
        
        return nil
    }
}
