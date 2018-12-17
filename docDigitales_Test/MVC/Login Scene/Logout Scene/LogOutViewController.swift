//
//  LogOutViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/16/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import CoreData

class LogOutViewController: UIViewController {

    
    //MARK: - ViewController Lfecycle -
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        attempLogOut()
    }
    //MARK: - Methods -
    private func attempLogOut(){
        let alert = UIAlertController(title: "Log Out", message: "¿Quieres cerrar tu sesión?", preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Cerrar", style: .destructive) { [unowned self](action) in
            self.performSegue(withIdentifier: "Log Out", sender: nil)
        }
        let naAction = UIAlertAction(title: "No", style: .default){ [unowned self](action) in
            self.performSegue(withIdentifier: "Home Segue", sender: nil)
        }
        alert.addAction(naAction)
        alert.addAction(logOutAction)
        present(alert, animated: true, completion: nil)
    }
}

