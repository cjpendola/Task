//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Carlos Pendola on 1/31/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {
    
    /*let fetchedResultController: NSFetchedResultsController<Task> = {
        let fetchRequest : NSFetchRequest = Task.fetchRequest()
        let isCompleteSort = NSSortDescriptor(key : "isComplete" ,ascending: false)
        let dueSort    = NSSortDescriptor(key : "due" ,ascending: false)
        fetchRequest.sortDescriptors = [isCompleteSort,dueSort]
        
        //return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        
    }()*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaskController.shared.fetchedResultController.delegate = self
        /*do{
            try fetchedResultController.performFetch()
        }catch{
            print("Error loading fetchedResultsController \(error) : \(error.localizedDescription) ")
        }
        fetchedResultController.delegate = self*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.shared.fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TaskController.shared.fetchedResultController.sectionIndexTitles[section] == "1" ? "Completed" : "Not Completed"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else {return UITableViewCell()}
        
        let task = TaskController.shared.fetchedResultController.object(at: indexPath)
        cell.update(withTask: task)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = TaskController.shared.fetchedResultController.object(at: indexPath)
            TaskController.shared.remove(task: task)
        }
    }
    
    // MARK: ButtonTableViewCellDelegate
    
    /*func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        print("buttonCellButtonTapped")
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let task = TaskController.shared.fetchedResultController.object(at: indexPath)
        TaskController.shared.toggleIsCompleteFor(task: task)
        sender.update(withTask: task)
    }*/
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewTask" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let task = TaskController.shared.fetchedResultController.object(at: indexPath)
            
            let detailVC = segue.destination as? TaskDetailTableViewController
            detailVC?.task = task
            detailVC?.dueDateValue = task.due
        }
    }
}

extension TaskListTableViewController : ButtonTableViewCellDelegate{
    func buttonCellButtonTapped(_ sender:ButtonTableViewCell)
    {
        guard let indexPath = tableView.indexPath(for:sender) else {return}
        let task = TaskController.shared.fetchedResultController.object(at: indexPath)
        TaskController.shared.toggleIsCompleteFor(task: task)
        sender.update(withTask: task)
        
    }
}


extension TaskListTableViewController : NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type{
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer:sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}

