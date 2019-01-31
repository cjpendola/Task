//
//  TaskController.swift
//  Task
//
//  Created by Carlos Pendola on 1/31/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    static let shared = TaskController()
    
    // MARK: Properties
    /*var tasks: [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            return try CoreDataStack.context.fetch(request)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }*/
    
    let fetchedResultController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let isComplete = NSSortDescriptor(key: "isComplete", ascending: false)
        let due = NSSortDescriptor(key: "due", ascending: false)
        fetchRequest.sortDescriptors = [isComplete, due]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
    }()
    
    init() {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Error loading FetchResultsController \(error) : \(error.localizedDescription)")
        }
        //fetchedResultController.delegate = self
    }
    
    
    
    // MARK: Public
    func add(taskWithName name: String, notes: String?, due: Date?) {
        let _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStore()
        //tasks = fetchTasks()
    }
    
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStore()
        //tasks = fetchTasks()
    }
    
    func remove(task: Task) {
        task.managedObjectContext?.delete(task)
        saveToPersistentStore()
        //tasks = fetchTasks()
    }
    
    func toggleIsCompleteFor(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStore()
    }
    
    // MARK: Persistence
    func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges {
            do {
                try CoreDataStack.context.save()
            } catch {
                print("Error saving Managed Object Context. Items not saved.")
            }
        }
    }
    
    /*func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }*/
    
    
    
}


