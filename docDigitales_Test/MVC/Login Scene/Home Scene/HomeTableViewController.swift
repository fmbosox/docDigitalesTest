//
//  HomeTableViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/13/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {
    
    //MARK: - ViewController Lyfecycle -
    
    private var fetchedResultsController: NSFetchedResultsController<BranchMO>?
    
    //MARK: - ViewController Lyfecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = MOManager.manager.branchesFetchController()
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch() //***Handle possible erros***!!
    }

    // MARK: - Table view -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?.first?.numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Branch Cell", for: indexPath)
        if let branch = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = branch.branchName!
            cell.detailTextLabel?.text = String(branch.employees?.count ?? 0)
        }
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "Edit Branch", sender: fetchedResultsController?.object(at: indexPath))
    }

    //MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit Branch" {
            let destinationVC = segue.destination as! AddEditBranchTableViewController
            destinationVC.currentBranch = sender as? BranchMO
        }else if segue.identifier == "Detail Segue", let  indexPath = tableView.indexPathForSelectedRow, let branch = fetchedResultsController?.object(at: indexPath){
            let destinationVC = segue.destination as! BranchDetailTableViewController
            destinationVC.currentBranch = branch
        }
    
    }
    
    @IBAction func unwindToHomeTVC (segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    

}

    //MARK: - NSFetchedResultsController -
extension HomeTableViewController: NSFetchedResultsControllerDelegate {
   
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
}
