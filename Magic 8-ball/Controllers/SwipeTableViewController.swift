//
//  SwipeTableViewController.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 19.02.2022.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! SwipeTableViewCell
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            self?.updateModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    // MARK: - Delete Data from Swipe
    
    func updateModel(at indexPath: IndexPath) {
        // Update our data model
    }
}
