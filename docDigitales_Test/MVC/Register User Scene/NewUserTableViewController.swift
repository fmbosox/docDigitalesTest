//
//  NewUserTableViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/13/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class NewUserTableViewController: AddEditStaticTableViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var rfcTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    private lazy var registrationVCTextFields: [UITextField]! = {
        let registrationTextFields: [UITextField] = [passwordTextField,passwordConfirmationTextField,companyNameTextField,rfcTextField,emailTextField,nameTextField]
        registrationTextFields.forEach({ [unowned self] (textField) in
            textField.delegate = self
        })
        return registrationTextFields
    }()
    
    
    //MARK: - ViewController Lyfecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = registrationVCTextFields
    }

    //MARK: - Methods -
    private func attempToRegisterUser(name: String, rfc: String, email: String, company: String, password: String) throws{
        if !PersonMO.validate(rfc: rfc) {
            throw MOManager.PersonMOError.RFCError
        }
        
        if !PersonMO.validate(name: name) {
            throw MOManager.PersonMOError.userNameError
        }
        
        guard !MOManager.manager.validateIfUserIsAlreadyRegisteredWith(rfc: rfc) else { throw MOManager.PersonMOError.userAlreadyOnDB}
        
            let newUser: UserMO = UserMO(context: MOManager.manager.context)
            newUser.name = name
            newUser.companyName = company
            newUser.rfc = rfc
            newUser.email = email
            newUser.password = password
            try MOManager.manager.saveModelObjects()
    }
    
    override func confirmationButtonAction() {
        super.confirmationButtonAction()
        guard let nameText = nameTextField.text, let rfcText = rfcTextField.text, let password = passwordTextField.text, let confirmationPassword = passwordConfirmationTextField.text, let email = emailTextField.text, let company = companyNameTextField.text, !nameText.isEmpty, !rfcText.isEmpty, !password.isEmpty, !confirmationPassword.isEmpty, !email.isEmpty, !company.isEmpty else { return }
            do {

                if password != confirmationPassword {
                    throw NSError(domain: "Contraseña Invalida", code: 0, userInfo: nil)
                }
                try attempToRegisterUser(name: nameText, rfc: rfcText, email: email, company: company, password: password)
                let alert = UIAlertController(title: "Exito", message: "Usuario registrado con exito!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) {[unowned self] (action) in
                    self.textFields?.forEach({ (textField) in
                        textField.text = nil
                    })
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }catch let error {
                 let MOError = error as? MOManager.PersonMOError
                let alert = UIAlertController(title: "Uppss!", message: MOError?.message ?? error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
            }
    }
    

}

