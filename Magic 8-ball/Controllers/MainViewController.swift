//
//  MainViewController.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 20.01.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var answerText: UILabel!
    
    var answerManager = AnswerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        answerManager.delegate = self
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        answerManager.performRequest()
    }
}

// MARK: - AnswerManagerDelegate

extension MainViewController: AnswerManagerDelegate {
    
    func didUpdateAnswer(_ answer: String) {
        print(answer)
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
