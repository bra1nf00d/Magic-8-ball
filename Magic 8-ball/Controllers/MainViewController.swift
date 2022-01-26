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
    
    // MARK: - UIResponder Motion Method
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        answerManager.performRequest()
    }
}

// MARK: - AnswerManagerDelegate

extension MainViewController: AnswerManagerDelegate {
    
    func didUpdateAnswer(_ answer: String) {
        self.answerText.text = answer
    }
    
    func didFailWithError(_ errorMessage: String) {
        let alert = UIAlertController(title: "No answer found", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
