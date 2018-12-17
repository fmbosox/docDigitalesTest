//
//  AddEditBranchTableViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/13/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class AddEditBranchTableViewController: AddEditStaticTableViewController {

    //MARK: - Outlets & Properties -
    
    @IBOutlet weak var branchNameTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var extNumberTextField: UITextField!
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet var branchTextFields: [UITextField]! {
        didSet {
            textFields = branchTextFields
            branchTextFields.forEach { [unowned self] (texField) in
                texField.delegate = self
            }
        }
    }
    
    var currentBranch: BranchMO?
    
    
    //MARK: - ViewController LyfeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentBranch != nil {
            updateUI()
        }
    }
    
    //MARK: - Methods -
    
    private func updateUI(){
        navigationItem.title = "Editar Sucursal"
        branchNameTextField.text = currentBranch?.branchName!
        streetTextField.text = currentBranch?.streetName!
        extNumberTextField.text = currentBranch?.extNumber!
        suburbTextField.text = currentBranch?.suburbName!
        zipCodeTextField.text = currentBranch?.postalCode!
        cityTextField.text = currentBranch?.city!
        countryTextField.text = currentBranch?.country!
    }
    
    private func attempToRegisterBranch(branch: String, street: String, ext: String, suburb: String, postalCode: String, city: String, country: String) throws{
        if !BranchMO.validate(number: ext) {
            throw MOManager.BranchMOError.extNumberError
        }
        
        if !BranchMO.validate(number: postalCode) {
            throw MOManager.BranchMOError.postalCodeError
        }
        
        var branchToSave: BranchMO!
        if currentBranch != nil {
            branchToSave = currentBranch!
        } else {
            branchToSave = BranchMO(context: MOManager.manager.context)
            branchToSave.admin = MOManager.manager.loggedUser!
        }
        branchToSave.branchName = branch
        branchToSave.streetName = street
        branchToSave.extNumber = ext
        branchToSave.suburbName = suburb
        branchToSave.postalCode = postalCode
        branchToSave.city = city
        branchToSave.country = country
       
        try MOManager.manager.saveModelObjects()
    }
    
    override func confirmationButtonAction() {
        super.confirmationButtonAction()
        
        guard let branch = branchNameTextField.text, let street = streetTextField.text, let ext = extNumberTextField.text, let suburb = suburbTextField.text, let zipCode = zipCodeTextField.text, let city = cityTextField.text, let country = countryTextField.text, !branch.isEmpty, !street.isEmpty, !ext.isEmpty, !suburb.isEmpty, !zipCode.isEmpty, !city.isEmpty, !country.isEmpty else { return }
        
    
            do {
                try attempToRegisterBranch(branch: branch, street: street, ext: ext, suburb: suburb, postalCode: zipCode, city: city, country: country)
                let alert = UIAlertController(title: "Exito", message: "Sucursal \(currentBranch != nil ? "actualizada" : "registrada") con exito!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) {[unowned self] (action) in
                    if self.currentBranch != nil {
                        self.performSegue(withIdentifier: "Unwind Home", sender: nil)
                    }else {
                        self.textFields?.forEach({ (textField) in
                            textField.text = nil
                        })
                    }
                
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }catch let error {
                let MOError = error as? MOManager.BranchMOError
                let alert = UIAlertController(title: "Yikes!!", message: MOError?.message ?? error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
    }
    
    
}
