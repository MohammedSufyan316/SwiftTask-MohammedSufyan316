//
//  TaskListViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCreationDelegate, TaskUpdateDelegate {
    
    @IBOutlet var taskTableView: UITableView!
    
    var managedContext: NSManagedObjectContext!
    var tasks: [Items] = [] // Array to store Task objects
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.dataSource = self
        taskTableView.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        fetchTasksFromCoreData()

    }
    
    func fetchTasksFromCoreData() {
        guard let managedContext = managedContext else {
               print("Managed context is nil")
               return
           }
           
           let fetchRequest: NSFetchRequest<Items> = Items.fetchRequest()
           
           do {
               tasks = try managedContext.fetch(fetchRequest)
               taskTableView.reloadData()
           } catch {
               print("Failed to fetch tasks: \(error)")
           }
    }
    
    func deleteTaskFromCoreData(at indexPath: IndexPath) {
        let taskToDelete = tasks[indexPath.row]
        managedContext.delete(taskToDelete)
        
        do {
            try managedContext.save()
            tasks.remove(at: indexPath.row)
            taskTableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
    
    func didCreateTask(_ task: Items) {
            DispatchQueue.main.async {
                // Directly append the new task to the tasks array
                self.tasks.append(task)
                
                // Reload the table view to display the newly added task
                self.taskTableView.reloadData()
             }
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let taskCreationVC = storyboard?.instantiateViewController(withIdentifier: "TaskCreationViewController") as! TaskCreationViewController
        taskCreationVC.delegate = self
        taskCreationVC.managedContext = managedContext // Pass context
        present(taskCreationVC, animated: true)
    }
    
    
    @IBAction func showCompletedTasks(_ sender: UIBarButtonItem) {
        let completedTasksVC = storyboard?.instantiateViewController(withIdentifier: "CompletedTasksViewController") as! CompletedTasksViewController
           completedTasksVC.completedTasks = tasks.filter { $0.isCompleted }
           completedTasksVC.delegate = self // Set delegate
           navigationController?.pushViewController(completedTasksVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.isCompleted ? "✅ Completed" : "🕒 Pending"
        return cell
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTaskFromCoreData(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let markCompletedAction = UIContextualAction(style: .normal, title: "Complete") { [weak self] (_, _, completionHandler) in
               self?.markTaskAsCompleted(at: indexPath)
               completionHandler(true)
           }
           markCompletedAction.backgroundColor = .systemGreen
           
           return UISwipeActionsConfiguration(actions: [markCompletedAction])
       }
       
       func markTaskAsCompleted(at indexPath: IndexPath) {
           let task = tasks[indexPath.row]
           task.isCompleted = true
           
           do {
               try managedContext.save()
               taskTableView.reloadRows(at: [indexPath], with: .fade)
           } catch {
               print("Failed to update task: \(error)")
           }
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskDetails",
           let destinationVC = segue.destination as? TaskDetailsViewController,
           let selectedIndexPath = taskTableView.indexPathForSelectedRow {
            destinationVC.task = tasks[selectedIndexPath.row]
            destinationVC.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.popToRootViewController(animated: false) // Ensure TaskListViewController is the first view
    }

}
extension TaskListViewController: TaskStatusChangeDelegate {
    func didRestoreTask(_ task: Items) {
        
        if let index = tasks.firstIndex(of: task) {
            tasks[index].isCompleted = false
            saveContext() // Save to Core Data
            taskTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
    
    func didUpdateTask() {
        fetchTasksFromCoreData() // Refresh the list after update
    }
    
    func didDeleteAllCompletedTasks() {
         fetchTasksFromCoreData() // Reload the tasks from Core Data
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

