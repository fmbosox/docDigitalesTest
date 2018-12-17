//
//  AddEditStaticTableViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/15/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class AddEditStaticTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Properties -
    
    var textFields: [UITextField]?
    
    @objc func confirmationButtonAction()
    {
        textFields?.forEach({ [weak self] (textField) in
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
            if let emptyTextField = textField.text?.isEmpty, emptyTextField {
                self?.setRedBorder(emptyTextField,for: textField)
            }
        })
    }
    
    
    var confirmationButton: UIButton  = {
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle("Registrar", for: .normal)
        loginButton.addTarget(self, action: #selector(confirmationButtonAction), for: .touchUpInside)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.frame = CGRect.zero
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    // - TextField  -
    
    private func setRedBorder(_ bool: Bool,for textField: UITextField){
        if bool {
            textField.layer.borderWidth = 0.55
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 0.0
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func removeTabsOnText(_ givenText: String) -> String {
         var text = givenText
        repeat {
            if text.first == Character(" ") {
                text.removeFirst()
            } else if text.last == Character(" "){
                text.removeLast()
            }
        } while text.first == Character(" ") || text.last == Character(" ")
        return text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
            let preparedText = removeTabsOnText(text)
            setRedBorder(preparedText.isEmpty, for: textField)
            textField.text = preparedText
    }
    
    // - TableView delegate -
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.numberOfSections - 1 == section {
            return 100.0
        }else {
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard tableView.numberOfSections - 1 == section else { return nil }
        let footerView = UIView(frame:CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.15)))
        footerView.addSubview(confirmationButton)
        
        NSLayoutConstraint.activate([confirmationButton.widthAnchor.constraint(equalToConstant: 130),
                                     confirmationButton.heightAnchor.constraint(equalToConstant: 30),
                                     confirmationButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                                     confirmationButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)])
        
        return footerView
    }
    
}
