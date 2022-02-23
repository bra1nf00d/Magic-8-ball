//
//  MainViewController.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 20.01.2022.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var answerText: UILabel!
    var networkAnswerProvider: NetworkAnswerProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkAnswerProvider?.delegate = self
        networkAnswerProvider?.storage = UserDefaultAnswers()
    }
    
    // MARK: - Navigate to Settings Screen
    @IBAction func goToSettings(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.settingsSequeIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.settingsSequeIdentifier {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.userDefaultAnswersProvider = UserDefaultAnswers()
        }
    }
    
    // MARK: - UIResponder Motion Method
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        networkAnswerProvider?.performRequest()
    }
}

// MARK: - NetworkAnswerClientDelegate

extension MainViewController: NetworkAnswerClientDelegate {
    
    func didUpdateAnswer(_ answer: String) {
        self.answerText.text = answer
    }
    
    func didFailWithError(message errorMessage: String) {
        let alert = UIAlertController(title: "No answer found", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
