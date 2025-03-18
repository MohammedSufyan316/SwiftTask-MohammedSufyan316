//
//  CompletedTasksViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit
import CoreData

protocol TaskStatusChangeDelegate: AnyObject {
    func didRestoreTask(_ task: Items)
    func didDeleteAllCompletedTasks() 
}

class CompletedTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var completedTasksTableView: UITableView!
    
    var completedTasks: [Items] = []
    weak var delegate: TaskStatusChangeDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        completedTasksTableView.dataSource = self
        completedTasksTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTaskCell", for: indexPath)
        let task = completedTasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.isCompleted ? "✅ Completed" : "🕒 Pending"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let restoreAction = UIContextualAction(style: .normal, title: "Restore") { _, _, completionHandler in
            self.restoreTask(at: indexPath)
            completionHandler(true)
        }
        restoreAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [restoreAction])
    }
    
    private func restoreTask(at indexPath: IndexPath) {
        let task = completedTasks[indexPath.row]
        task.isCompleted = false // Mark task as pending
        
        // Save changes to Core Data
        saveContext()
        delegate?.didRestoreTask(task)
        
        // Remove task from the completed list
        completedTasks.remove(at: indexPath.row)
        completedTasksTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    @IBAction func deleteAllCompletedTasks(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete All?", message: "Are you sure you want to delete all completed tasks permanently?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteAllCompletedTasksFromCoreData()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteAllCompletedTasksFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Items> = Items.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == true")
        
        do {
            let tasksToDelete = try context.fetch(fetchRequest)
            for task in tasksToDelete {
                context.delete(task)
            }
            try context.save()
            
            // Clear the local array and update the table view
            completedTasks.removeAll()
            completedTasksTableView.reloadData()
            
            delegate?.didDeleteAllCompletedTasks()
        } catch {
            print("Error deleting tasks: \(error)")
        }
    }
    
    private func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving task status change: \(error)")
        }
    }
}
