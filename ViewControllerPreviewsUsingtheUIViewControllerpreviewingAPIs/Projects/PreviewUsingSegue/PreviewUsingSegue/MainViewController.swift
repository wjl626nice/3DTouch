/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The master view controller.
*/

import UIKit

class MasterViewController: UITableViewController {
    
    // MARK: Properties
    
    let sampleData = [
        "Item 1",
        "Item 2",
        "Item 3"
    ]
    
    /// An alert controller used to notify the user if 3D touch is not available.
    var alertController: UIAlertController?

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for force touch feature, and add force touch/previewing capability.
        if traitCollection.forceTouchCapability != .Available {
            // Create an alert to display to the user.
            alertController = UIAlertController(title: "3D Touch Not Available", message: "Unsupported device.", preferredStyle: .Alert)
        }
    }

    override func viewWillAppear(animated: Bool) {
        // Clear the selection if the split view is only showing one view controller.
        clearsSelectionOnViewWillAppear = splitViewController!.collapsed
        
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Present the alert if necessary.
        if let alertController = alertController {
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
            // Clear the `alertController` to ensure it's not presented multiple times.
            self.alertController = nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        /*
            Check if this is a segue from a cell and that it's presenting a
            `DetailViewController` embedded in a `UINavigationController`.
        */
        if let cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell),
            navigationController = segue.destinationViewController as? UINavigationController,
            detailViewController = navigationController.viewControllers.first as? DetailViewController
        {
            // Pass the `title` to the `detailViewController`.
            detailViewController.sampleTitle = sampleData[indexPath.row]

            // Hide the navigation bar if this is the peek segue.
            navigationController.navigationBarHidden = segue.identifier == "previewDetail"
        }
    }
    
    // MARK: Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        return sampleData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = sampleData[indexPath.row]
        
        return cell
    }
}