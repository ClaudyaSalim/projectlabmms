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
    
    //
    var imagePath : String!
    
    @IBAction func addImgclick(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        imageView.image = image
        
        //
        saveImageToDocumentDirectory(image: image, fileName: "yourFileName.jpg")
        
        
        
        dismiss(animated: true)
    }
    
    var contxt: NSManagedObjectContext!
    var db=Database()

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
    }
    

    @IBAction func onConfirmClicked(_ sender: Any) {
        
        var newItem:Item?
        let name = nameField.text!
        let category = categoryField.text!
        let price = Int(priceField.text!)
        let desc = descField.text!
        let pathImage = imagePath!
        
        
        if(name=="" || category=="" || price==nil || desc==""){
            showAlert(msg: "You must fill all fields!")
            return
        }
//        print(pathImage)
        
        newItem = Item(name: name, category: category, price: price, desc: desc, img: pathImage)
        print(pathImage)
        
        db.insertProduct(contxt: contxt, product: newItem!)
        
    }
    
    func showAlert(msg:String){
        
        // define alert
        let alert = UIAlertController(title: "Add Product Failed", message: msg, preferredStyle: .alert)
        
        // define action
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        // add action to alert
        alert.addAction(okAction)
        
        // show alert
        present(alert, animated: true)
    }
    
    func saveImageToDocumentDirectory(image: UIImage, fileName: String) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try imageData.write(to: fileURL)
                    print("Image saved successfully at: \(fileURL.absoluteString)")
                    
                    //
                    imagePath = fileURL.path
                } catch {
                    print("Error saving image: \(error)")
                }
            }
        }
    }

}
