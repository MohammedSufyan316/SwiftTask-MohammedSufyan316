//
//  CompletedTasksViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit

class CompletedTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var completedTasksTableView: UITableView!
    
    var completedTasks: [Items] = []
    
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
           return cell
       }
}
