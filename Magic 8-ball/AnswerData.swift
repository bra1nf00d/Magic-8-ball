//
//  AnswerData.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 22.01.2022.
//

import Foundation

struct AnswerData: Decodable {
    let magic: Magic
}

struct Magic: Decodable {
    let answer: String
}
