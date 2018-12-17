//
//  AddEmployeeTableViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/14/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class AddEmployeeTableViewController: AddEditStaticTableViewController {

    //MARK: - Outlets & Properties -
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var rfcTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var branchPicker: UIPickerView! {
        didSet{
            branchPicker.dataSource = self
            branchPicker.delegate = self
        }
    }
    private lazy var employeeVCTextFields: [UITextField]! = {
        nameTextField.delegate = self
        rfcTextField.delegate = self
        positionTextField.delegate = self
        return [nameTextField, rfcTextField, positionTextField]
    }()
    
    private var branches: [BranchMO] = []
    
    //MARK: - ViewController Lyfecycle  -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = employeeVCTextFields
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let unwrappeBranches = MOManager.manager.loggedUser?.branches?.sortedArray(using: []) as? [BranchMO] else { return }
        branches = unwrappeBranches
        branchPicker.reloadAllComponents()
    }

    // MARK: - Register Employee Methods -
    
    private func attempToRegisterEmployee(name: String, rfc: String, position: String,branch: BranchMO ) throws{
        if !PersonMO.validate(rfc: rfc) {
            throw MOManager.PersonMOError.RFCError
        }
        
        if !PersonMO.validate(name: name) {
            throw MOManager.PersonMOError.userNameError
        }
        let newEmployee: EmployeeMO = EmployeeMO(context: MOManager.manager.context)
        newEmployee.name = name
        newEmployee.rfc = rfc
        newEmployee.position = position
        newEmployee.branch = branch
        try MOManager.manager.saveModelObjects()
    }
    
    override func confirmationButtonAction() {
        super.confirmationButtonAction()
        guard let nameText = nameTextField.text, let rfcText = rfcTextField.text, let position = positionTextField.text, !nameText.isEmpty, !rfcText.isEmpty, !position.isEmpty else { return }
        
        do {
            let branchPickerselectedRow = branchPicker.selectedRow(inComponent: 0)
            if branchPickerselectedRow < 0 {
                throw NSError(domain: "Error de Picker View", code: 0, userInfo: nil)
            }
            try attempToRegisterEmployee(name: nameText, rfc: rfcText, position: position, branch: branches[branchPickerselectedRow])
            let alert = UIAlertController(title: "Exito", message: "Empleado registrado con exito!", preferredStyle: .alert)
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
    
    // MARK: - Tableview delegate -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 1{ // section of the picker view
            return 113.0
        }
        return 53.0
    }

}

    // MARK: - PickerView delegate -
extension AddEmployeeTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return branches.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return branches[row].branchName!
    }
    

    
}
