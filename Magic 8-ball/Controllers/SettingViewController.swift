//
//  SettingViewController.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 20.01.2022.
//

import UIKit

class SettingViewController: UITableViewController {
    private var answers: [String] = []
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let safeAnswers = defaults.array(forKey: "Answers") as? [String] {
            answers = safeAnswers
        }
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        cell.textLabel?.text = answers[indexPath.row]
        
        return cell
    }
    
    // MARK: - Add New Hardcoded Answers
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Answer", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.answers.append(textField.text!)
            self.defaults.set(self.answers, forKey: "Answers")
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new answer"
            
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
}
