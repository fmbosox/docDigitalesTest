//
//  LoginTableViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/13/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class LoginTableViewController: AddEditStaticTableViewController {
    
    //MARK: - Outlets & Properties -
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    private lazy var loginVCTextFields: [UITextField]! = {
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        return [loginEmailTextField, loginPasswordTextField]
    }()
    
    //MARK: - ViewController lyfecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Test Objects
        
        if !MOManager.manager.isTestsDataAlreadyOnDB {
            MOManager.manager.uploadTestDataOnDB()
        }
        
        //
        
        textFields = loginVCTextFields
        confirmationButton.setTitle("Iniciar", for: .normal)
    }
    
    //MARK: - Methods (Override) -
    override func confirmationButtonAction() {
        super.confirmationButtonAction()
        guard let email = loginEmailTextField.text, let password = loginPasswordTextField.text, !email.isEmpty, !password.isEmpty else { return }
        do{
            try MOManager.manager.attempLogin(email: email, password: password)
            performSegue(withIdentifier: "Home Segue", sender: nil)
        }catch let error {
            let MOError = error as? MOManager.LoginError
            let alert = UIAlertController(title: "Upssss!", message: MOError?.message ?? error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }

    }
    
    //MARK: - Navigation -
    
    @IBAction func logOutUnwind(segue: UIStoryboardSegue){
        MOManager.manager.logOut()
        loginPasswordTextField.text = nil
    }
    
}
