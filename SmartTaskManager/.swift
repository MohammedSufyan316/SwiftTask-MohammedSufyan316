//
//  Items+CoreDataProperties.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var category: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var priority: Int16
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?

}

extension Items : Identifiable {

}
