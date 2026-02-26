//
//  ViewController.swift
//  Project-PersonForm
//
//  Created by Amit Bhujbal on 25/02/2026.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    let coreDataStack = CoreDataStack()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Submit to Data (from CoreData)
    @IBAction func saveButton(_ sender: UIButton) {
        let person = Person(context: coreDataStack.managedContext)
        person.name = nameTextField.text
        person.birthdate = birthdateTextField.text
        person.education = educationTextField.text
        person.place = placeTextField.text
        person.job = jobTextField.text
        person.mobile = mobileTextField.text
        person.email = emailTextField.text
        
        let currentDate = Date()
        person.lastUpdate = currentDate //Set the last update and time
        
        coreDataStack.saveContext()
        
        let alertController = UIAlertController(title: "Success", message: "Data submitted successfully.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        clearTextFields()
    }

    //MARK: Clear TextFields
    @IBAction func ClearButton(_ sender: UIButton) {
        clearTextFields()
    }
    
    func clearTextFields() {
        nameTextField.text = ""
        birthdateTextField.text = ""
        educationTextField.text = ""
        placeTextField.text = ""
        jobTextField.text = ""
        mobileTextField.text = ""
        emailTextField.text = ""
    }
}

