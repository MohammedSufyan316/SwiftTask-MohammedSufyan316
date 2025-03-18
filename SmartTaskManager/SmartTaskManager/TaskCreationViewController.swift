//
//  TaskCreationViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit
import CoreData

protocol TaskCreationDelegate: AnyObject {
    func didCreateTask(_ task: Items)
}

class TaskCreationViewController: UIViewController {
    
    weak var delegate: TaskCreationDelegate?
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var taskTitleField: UITextField!
    
    @IBOutlet weak var taskDescriptionView: UITextView!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var categories = ["Work", "Personal", "Shopping", "Fitness", "Other"] // Example categories
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        } else {
            print("Managed context is nil")
        }
 
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        guard let title = taskTitleField.text, !title.isEmpty else { return }
               
        guard let context = managedContext else {
                    print("Managed context is nil")
                    return
                }
        
           let newTask = Items(context: context)
               newTask.title = title
               newTask.taskDescription = taskDescriptionView.text
               newTask.dueDate = dueDatePicker.date
               newTask.priority = Int16(prioritySegment.selectedSegmentIndex)
               newTask.category = selectedCategory ?? "Other"
               newTask.isCompleted = false
               
               do {
                   try context.save()
                   delegate?.didCreateTask(newTask)
                   
                   dismiss(animated: true, completion: nil)
                   } catch {
                       print("Failed to save task: \(error)")
                   }
           }
    
    @IBAction func cancelTask(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension TaskCreationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { categories.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { categories[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { selectedCategory = categories[row] }
}
