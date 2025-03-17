//
//  TaskListViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCreationDelegate {
    
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
        tasks.append(task)
        taskTableView.reloadData()
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


}
