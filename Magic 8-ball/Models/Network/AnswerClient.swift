//
//  AnswerManager.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 22.01.2022.
//

import Foundation

protocol AnswerClientProvider {
    func performRequestWithModel<Model: Decodable> (url apiUrl: String, model: Model.Type, completion: @escaping (Model?) -> Void)
}

struct AnswerClient: AnswerClientProvider {
    func performRequestWithModel<Model: Decodable> (url apiUrl: String, model: Model.Type, completion: @escaping (Model?) -> Void) {
        if let url = URL(string: apiUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(nil)
                }
                
                if let responseData = data {
                    if let parsedData = parseJSON(responseData, in: model) {
                        completion(parsedData)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    private func parseJSON<Model: Decodable>(_ data: Data, in modelType: Model.Type) -> Model? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(modelType, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}
