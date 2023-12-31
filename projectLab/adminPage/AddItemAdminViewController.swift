//
//  AddItemAdminViewController.swift
//  projectLab
//
//  Created by prk on 15/12/23.
//

import UIKit
import CoreData

class AddItemAdminViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePath : String!
    var imageIteration: Int = 1
    
    @IBAction func addImgclick(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        imageView.image = image
        
        saveImageToDocumentDirectory(image: image, fileName: "yourFileName_\(imageIteration).jpg")
        dismiss(animated: true)
    }
    
    var contxt: NSManagedObjectContext!
    var db=Database()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImageView = UIImageView()

        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
        if let savedIteration = UserDefaults.standard.value(forKey: "imageIteration") as? Int {
            imageIteration = savedIteration
        }
    }
    

    @IBAction func onConfirmClicked(_ sender: Any) {
        
        var newItem:Item?
        let name = nameField.text!
        let category = categoryField.text!
        let price = Int(priceField.text!)
        let desc = descField.text!
        
        if(name == "" || category == "" || price == nil || desc == ""){
            showAlert(msg: "You must fill all fields!")
            return
        }
        
        guard let pathImage = imagePath else {
               showAlert(msg: "Please select an image.")
               return
           }
        
        let imageName = "yourFileName_\(imageIteration).jpg"
        
        newItem = Item(name: name, category: category, price: price, desc: desc, img: pathImage)
        print(pathImage)
        
        db.insertProduct(contxt: contxt, product: newItem!)
        
        imageIteration += 1
        UserDefaults.standard.set(imageIteration, forKey: "imageIteration")
        
        
        let alert = UIAlertController(title: "Item Added", message: "Item successfully added into the List Item!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
                            
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "homeAdmin") {
                    let loginView = loginVC as! AdminHomeViewController
                    self.navigationController?.setViewControllers([loginView], animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
            
        present(alert, animated: true, completion: nil)
        
    }
    
    func showAlert(msg:String){
        
        let alert = UIAlertController(title: "Add Product Failed", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func saveImageToDocumentDirectory(image: UIImage, fileName: String) {
        let directoryPath = getDocumentsDirectoryURL().appendingPathComponent("ImageDirectory")
            
            if !FileManager.default.fileExists(atPath: directoryPath.path) {
                do {
                    try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating image directory: \(error)")
                    return
                }
            }
            
            let fileURL = directoryPath.appendingPathComponent(fileName)
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try imageData.write(to: fileURL)
                    print("Image saved successfully at: \(fileURL.absoluteString)")
                    
                    // Set the imagePath to be used later
                    imagePath = fileURL.path
                } catch {
                    print("Error saving image: \(error)")
                }
            }
    }
    
    func getDocumentsDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    

}
