//
//  SettingViewController.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 20.01.2022.
//

import UIKit

class SettingsViewController: SwipeTableViewController {
    private var answers: [String] = []
    var userDefaultAnswersProvider: UserDefaultAnswersProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let storedAnswers = userDefaultAnswersProvider?.loadAnswers(forKey: Constants.localStorage) {
            answers = storedAnswers
        }
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = answers[indexPath.row]
        
        return cell
    }
    
    // MARK: - Add New Hardcoded Answers
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Answer", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
            self?.answers.append(textField.text!)
            self?.userDefaultAnswersProvider?.saveAnswers(self?.answers, forKey: Constants.localStorage)
            
            self?.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new answer"
            
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        answers.remove(at: indexPath.row)
        userDefaultAnswersProvider?.saveAnswers(answers, forKey: Constants.localStorage)
        
        tableView.reloadData()
    }
}
