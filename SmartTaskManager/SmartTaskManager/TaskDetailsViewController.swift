//
//  TaskDetailsViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit
import CoreData

protocol TaskUpdateDelegate: AnyObject {
    func didUpdateTask()
}

class TaskDetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var taskTitleField: UITextField!
    
    @IBOutlet weak var taskDescriptionView: UITextView!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    var categories = ["Work", "Personal", "Shopping", "Fitness", "Other"] // Example categories
    var selectedCategory: String?
    
    weak var delegate: TaskUpdateDelegate?
    var managedContext: NSManagedObjectContext!
     var task: Items!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
                
        guard let task = task else {
               print("Task is nil")
               return
           }
 
        let disableEditing = UserDefaults.standard.bool(forKey: "disableEditingEnabled")
        
        // Disable all UI elements except cancel button if editing is disabled
        if disableEditing {
            taskTitleField.isEnabled = false
            taskDescriptionView.isEditable = false
            dueDatePicker.isEnabled = false
            prioritySegment.isEnabled = false
            categoryPicker.isUserInteractionEnabled = false
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
        let disableEditing = UserDefaults.standard.bool(forKey: "disableEditingEnabled")
         
         if disableEditing {
             let alert = UIAlertController(title: "Editing Disabled",
                                           message: "Enable editing in Settings to make changes.",
                                           preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             present(alert, animated: true)
             return
         }
                task.title = taskTitleField.text
                task.taskDescription = taskDescriptionView.text
                task.dueDate = dueDatePicker.date
                task.priority = Int16(prioritySegment.selectedSegmentIndex)
                task.category = selectedCategory
                
                do {
                    try managedContext.save()
                    delegate?.didUpdateTask()
                    navigationController?.popViewController(animated: true)
                } catch {
                    print("Failed to update task: \(error)")
                }
            }
    
}

