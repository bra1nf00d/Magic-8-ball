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

    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        answerManager.performRequest()
    }
}
