//
//  ViewController.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 07.08.2022.
//

import UIKit

final class UserIDViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var userIDTextField: UITextField!
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: - Private properties
    private let userIdLimit = 8
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }

    // MARK: - IBActions
    @IBAction private func textChanged(_ sender: UITextField) {

    }
    
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        pushToCamera()
    }
    
    // MARK: - Private methods
    private func pushToCamera() {
        let cameraViewController = CameraViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(cameraViewController, animated: true)
    }
}

// MARK: - IBActions
extension UserIDViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        let isAllowedCount = newString.count < userIdLimit
        actionButton.isEnabled = !isAllowedCount
        
        return newString.count <= userIdLimit
    }
}
