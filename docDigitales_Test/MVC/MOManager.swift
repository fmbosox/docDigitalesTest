//
//  MOManager.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/12/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MOManager {
    
    
    //MARK: - Properties -
    private var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static let manager = MOManager()
    
    final func saveModelObjects() throws {
        try context.save()
    }
    
    private var _loggedUser: UserMO?
    
    var loggedUser: UserMO? {
        return _loggedUser
    }
    
    final func validateIfUserIsAlreadyRegisteredWith(rfc: String) -> Bool {
        let request: NSFetchRequest <UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "rfc = %@", rfc)
        let userArray = try? context.fetch(request)
        guard let unwrappedUserArray = userArray else { return false }
        return !unwrappedUserArray.isEmpty
    }
    
    
    final func attempLogin(email: String, password: String) throws {
        let request: NSFetchRequest <UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "email = %@ AND password = %@", email, password)
        let userArray = try? context.fetch(request)
        guard let user = userArray?.first else { throw MOManager.LoginError.wrongCredentials }
        _loggedUser = user
    }
    
    
    final func logOut()  {
        context.reset()
        _loggedUser = nil
    }
    
    final func branchesFetchController() -> NSFetchedResultsController<BranchMO> {
        let request: NSFetchRequest <BranchMO> = BranchMO.fetchRequest()
        request.predicate = NSPredicate(format: "admin.rfc = %@", _loggedUser!.rfc!)
        request.sortDescriptors = [NSSortDescriptor(key: "branchName", ascending: true)]
       let controller = NSFetchedResultsController (fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
  
}

    //MARK: Error types

extension MOManager {
    enum LoginError: Error {
        case wrongCredentials
        var message: String {
            switch self {
            case .wrongCredentials: return "Asegurate de que el correo y la contraseña sean las correctas"
            }
        }
    }
    
    enum PersonMOError: Error {
        case userAlreadyOnDB
        case userNameError
        case RFCError
        
        var message: String {
            switch self {
            case .userAlreadyOnDB: return "Usuario ya registrado con ese RFC"
            case .userNameError: return "Nombre de Usuario no valido"
            case .RFCError: return "RFC Invalido: Solo letreas y numero y de 12 a 13 caracteres"
            }
        }
    }
    
    enum BranchMOError: Error {
        case postalCodeError
        case extNumberError
        
        var message: String {
            switch self {
            case .postalCodeError: return "Código Postal solo permite números."
            case .extNumberError: return "Solo se permiten números en el número exterior del domicilio."
            }
        }
    }
    
    
}

//MARK: Test Values
extension MOManager {
    
    var isTestsDataAlreadyOnDB: Bool {
        let value = UserDefaults.standard.bool(forKey: "TestValuesOn")
        return value
    }
    
    
    func uploadTestDataOnDB(){
        let key = "TestValuesOn"
        do {
            try setTestData()
            UserDefaults.standard.setValue(true, forKey: key)
            context.reset()
        } catch {
            UserDefaults.standard.setValue(false, forKey: key)
        }
        
    }
    
    private func setTestData()throws {
        let userOne: UserMO = UserMO(context: MOManager.manager.context)
        userOne.name = "Samuel"
        userOne.companyName = "Company one"
        userOne.rfc = "MORF5653T23"
        userOne.email = "test01@email.com"
        userOne.password = "123456"
        userOne.branches = nil
    
        let branchOne: BranchMO = BranchMO(context: MOManager.manager.context)
        branchOne.branchName = "Matriz"
        branchOne.streetName = "Fernando Montes de Oca #1311"
        branchOne.suburbName = "Roma"
        branchOne.postalCode = "21250"
        branchOne.extNumber = "1311"
        branchOne.city = "Mexicali"
        branchOne.country = "Mexico"
        branchOne.admin = userOne
    
        let empOne: EmployeeMO = EmployeeMO(context: MOManager.manager.context)
        empOne.name = "Emp"
        empOne.rfc = "XAXX343231"
        empOne.position = "Cajero"
        empOne.branch = branchOne
    
        let empTwo: EmployeeMO = EmployeeMO(context: MOManager.manager.context)
        empTwo.name = "Emp two"
        empTwo.rfc = "XAXX343231"
        empTwo.position = "Mesero"
        empTwo.branch = branchOne
    
        let branchTwo: BranchMO = BranchMO(context: MOManager.manager.context)
        branchTwo.branchName = "Periferico"
        branchTwo.streetName = "Calzada Manuel Gómez Morín"
        branchTwo.suburbName = "Fraccionamiento San Fernando"
        branchTwo.extNumber = "1100"
        branchTwo.postalCode = "21297"
        branchTwo.city = "Mexicali"
        branchTwo.country = "Mexico"
        branchTwo.admin = userOne
    
        let empFour: EmployeeMO = EmployeeMO(context: MOManager.manager.context)
        empFour.name = "Employee"
        empFour.rfc = "XAXX343231"
        empFour.position = "Cocinero"
        empFour.branch = branchTwo
    
        let empFive: EmployeeMO = EmployeeMO(context: MOManager.manager.context)
        empFive.name = "Employee dos"
        empFive.rfc = "XAXX343231"
        empFive.position = "Auxiliar"
        empFive.branch = branchTwo
        
        try self.saveModelObjects()
    }
}
