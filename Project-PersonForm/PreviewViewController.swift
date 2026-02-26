//
//  PreviewViewController.swift
//  Project-PersonForm
//
//  Created by Amit Bhujbal on 25/02/2026.
//

import UIKit
import CoreData
import MobileCoreServices

class PreviewViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var dataTextView: UITextView!
    
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDisplayData()
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Export Button
    @IBAction func exportButton(_ sender: UIButton) {
        exportDataToCSV()
    }
    
    //MARK: Preview Data (from CoreData) on TextView
    func fetchDisplayData() {
        let fetchRequest:NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let people = try coreDataStack.managedContext.fetch(fetchRequest)
            var dataPreview = ""
            
            for person in people {
                if let lastUpdate = person.lastUpdate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let lastUpdateString = dateFormatter.string(from: lastUpdate)
                    dataPreview += "\n\n--------------\nLast Update Date: \(lastUpdateString)"
                }
                dataPreview += "\n\nName: \(person.name ?? "")"
                dataPreview += "\nBirthday Date: \(person.birthdate ?? "")"
                dataPreview += "\nEducation: \(person.education ?? "")"
                dataPreview += "\nPlace: \(person.place ?? "")"
                dataPreview += "\nJobs: \(person.job ?? "")"
                dataPreview += "\nMobile: \(person.mobile ?? "")"
                dataPreview += "\nEmail ID: \(person.email ?? "")"
            }
            dataTextView.text = dataPreview
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Export Data (from CoreData) to CSV Spreadsheet
    func exportDataToCSV() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let people = try coreDataStack.managedContext.fetch(fetchRequest)
            
            var csvText = "Last Update Date, Name, Birthday, Education, Place, Job, Mobile, Email ID\n"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            for person in people {
                var csvRow = ""
                
                //Last update date
                if let lastUpdate = person.lastUpdate {
                    csvRow += "\(dateFormatter.string(from: lastUpdate)),"
                } else {
                    csvRow += ","
                }
                
                //Name
                if let name = person.name {
                    csvRow += "\(name),"
                } else {
                    csvRow += ","
                }
                
                //Other fields
                csvRow += "\(person.birthdate ?? ""),"
                csvRow += "\(person.education ?? ""),"
                csvRow += "\(person.place ?? ""),"
                csvRow += "\(person.job ?? ""),"
                csvRow += "\(person.mobile ?? ""),"
                csvRow += "\(person.email ?? "")\n"
                
                csvText += csvRow
            }
            
            let fileName = "exported_data.csv"
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                
                do {
                    try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
                    
                    let documentPicker = UIDocumentPickerViewController(url: fileURL, in: .exportToService)
                    documentPicker.delegate = self
                    present(documentPicker, animated: true, completion: nil)
                } catch {
                    print("Error writing CSV file: \(error)")
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Alert Message
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let fileURL = urls.first {
            let message = "CSV file exported and saved to: \(fileURL.path)"
            showAlert(title: "Export Successful", message: message)
        }
    }
}

//MARK: Extension Alert Message
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
