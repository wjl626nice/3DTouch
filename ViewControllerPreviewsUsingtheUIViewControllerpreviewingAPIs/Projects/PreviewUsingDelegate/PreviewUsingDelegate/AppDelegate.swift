/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The application delegate. Creates and holds onto the main window, and implements the split view controller delegate.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    // MARK: Properties

    var window: UIWindow?
    
    // MARK: App Delegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        guard let splitViewController = self.window!.rootViewController as? UISplitViewController else { fatalError("Unexpected view controller setup") }
        
        splitViewController.delegate = self

        return true
    }
    
    // MARK: Split View Delegate

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        
        // Return true if the `sampleTitle` has not been set, collapsing the secondary controller.
        return topAsDetailController.sampleTitle == nil
    }

}