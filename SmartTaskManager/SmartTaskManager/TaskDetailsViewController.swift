//
//  TaskDetailsViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit
import CoreData

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskTitleField: UILabel!
    
    @IBOutlet weak var taskDescriptionView: UITextView!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    var categories = ["Work", "Personal", "Shopping", "Fitness", "Other"] // Example categories
    var selectedCategory: String?
    
    var managedContext: NSManagedObjectContext!
     var task: Items!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        guard let task = task else {
               print("Task is nil")
               return
           }
        
        // Pre-fill fields with task data
        taskTitleField.text = task.title
        taskDescriptionView.text = task.taskDescription
        dueDatePicker.date = task.dueDate ?? Date()
        prioritySegment.selectedSegmentIndex = Int(task.priority)
        if let category = task.category, let index = categories.firstIndex(of: category) {
            categoryPicker.selectRow(index, inComponent: 0, animated: false)
            selectedCategory = category
        } else {
            selectedCategory = "Other"
        }
    }
    
    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
    
    @IBAction func editChanges(_ sender: UIButton) {
        task.title = taskTitleField.text
                task.taskDescription = taskDescriptionView.text
                task.dueDate = dueDatePicker.date
                task.priority = Int16(prioritySegment.selectedSegmentIndex)
                task.category = selectedCategory
                
                do {
                    try managedContext.save()
                    navigationController?.popViewController(animated: true)
                } catch {
                    print("Failed to update task: \(error)")
                }
            }
    
}
