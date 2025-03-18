//
//  TaskChartViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit
import CoreData

class TaskChartViewController: UIViewController {
    
    @IBOutlet weak var progressPieChartView: ProgressPieChartView!
    
    @IBOutlet weak var barGraphView: BarGraphView!
    
    @IBOutlet weak var completedTasksLabel: UILabel!
    
    @IBOutlet weak var pendingTasksLabel: UILabel!
    
    @IBOutlet weak var highPriorityLabel: UILabel!
    
    @IBOutlet weak var mediumPriorityLabel: UILabel!
    
    @IBOutlet weak var lowPriorityLabel: UILabel!
    
    
    var managedContext: NSManagedObjectContext!
       var tasks: [Items] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                managedContext = appDelegate.persistentContainer.viewContext

                fetchTasksFromCoreData()
     
                updateTaskLabels()
                updateProgressChart()
                updateBarGraph()
        
        progressPieChartView.setNeedsDisplay()
        barGraphView.setNeedsDisplay()

    }
    
    func fetchTasksFromCoreData() {
           guard let managedContext = managedContext else {
                  print("Managed context is nil")
                  return
              }
              
           let fetchRequest: NSFetchRequest<Items> = Items.fetchRequest()
           
           do {
               tasks = try managedContext.fetch(fetchRequest)
           } catch {
               print("Failed to fetch tasks: \(error)")
           }
       }
    
    func updateTaskLabels() {
        let completedTasksCount = tasks.filter { $0.isCompleted }.count
        let pendingTasksCount = tasks.filter { !$0.isCompleted }.count
        let totalTasksCount = tasks.count
        
        // Check if there are tasks to avoid division by zero
        if totalTasksCount == 0 {
            completedTasksLabel.text = " 0%"
            pendingTasksLabel.text = " 0%"
        } else {
            let completedPercentage = (CGFloat(completedTasksCount) / CGFloat(totalTasksCount)) * 100
            let pendingPercentage = (CGFloat(pendingTasksCount) / CGFloat(totalTasksCount)) * 100
            
            completedTasksLabel.text = " \(Int(completedPercentage))%"
            pendingTasksLabel.text = " \(Int(pendingPercentage))%"
        }

       }
       
       func updateProgressChart() {
           let completedTasksCount = tasks.filter { $0.isCompleted }.count
               let totalTasksCount = tasks.count
               
               // Check if there are tasks to avoid division by zero
               if totalTasksCount == 0 {
                   progressPieChartView.completedPercentage = 0.0
                   progressPieChartView.pendingPercentage = 1.0
               } else {
                   let completedPercentage = CGFloat(completedTasksCount) / CGFloat(totalTasksCount)
                   progressPieChartView.completedPercentage = completedPercentage
                   progressPieChartView.pendingPercentage = 1.0 - completedPercentage
               }
               progressPieChartView.setNeedsDisplay()
       }
    
    func updateBarGraph() {
        let highPriorityTasks = tasks.filter { $0.priority == 2 }.count
            let mediumPriorityTasks = tasks.filter { $0.priority == 1 }.count
            let lowPriorityTasks = tasks.filter { $0.priority == 0 }.count
            
            // Convert counts to a percentage of total tasks
            let totalTasksCount = tasks.count
            let highPriorityCount = totalTasksCount > 0 ? CGFloat(highPriorityTasks) / CGFloat(totalTasksCount) : 0
            let mediumPriorityCount = totalTasksCount > 0 ? CGFloat(mediumPriorityTasks) / CGFloat(totalTasksCount) : 0
            let lowPriorityCount = totalTasksCount > 0 ? CGFloat(lowPriorityTasks) / CGFloat(totalTasksCount) : 0
            
            // Update the BarGraphView with priority data
            barGraphView.highPriorityCount = highPriorityCount
            barGraphView.mediumPriorityCount = mediumPriorityCount
            barGraphView.lowPriorityCount = lowPriorityCount
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasksFromCoreData() // Refresh tasks when view appears
        updateTaskLabels()        // Update task completion labels
           updateProgressChart()     // Refresh the pie chart
           updateBarGraph()          // Refresh the bar graph
        updatePriorityLabels()
           
           progressPieChartView.setNeedsDisplay()
           barGraphView.setNeedsDisplay()
    }
    
    func updatePriorityLabels() {
        let highPriorityTasks = tasks.filter { $0.priority == 2 }.count
        let mediumPriorityTasks = tasks.filter { $0.priority == 1 }.count
        let lowPriorityTasks = tasks.filter { $0.priority == 0 }.count
        
        highPriorityLabel.text = "\(highPriorityTasks) Task"
        mediumPriorityLabel.text = "\(mediumPriorityTasks) Task"
        lowPriorityLabel.text = "\(lowPriorityTasks) Task"
    }

}
