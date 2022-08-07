//
//  MainNavigationController.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 07.08.2022.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    private var userIDViewController: UIViewController {
        let userIDViewController = UserIDViewController.instantiateFromStoryboard()
        return userIDViewController
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setRootViewController()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    private func setRootViewController() {
        self.viewControllers = [userIDViewController]
    }
}
