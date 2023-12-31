//
//  UpdateItemAdminViewController.swift
//  projectLab
//
//  Created by prk on 12/10/23.
//

import UIKit
import CoreData

class UpdateItemAdminViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
    
    @IBOutlet weak var nameGameField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var contxt: NSManagedObjectContext!
    var db=Database()
    var item:Item?
    
    var imagePath : String!
    var imageIteration: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
        if let savedIteration = UserDefaults.standard.value(forKey: "imageIteration") as? Int {
            imageIteration = savedIteration
        }
        
        nameGameField.text = item!.name!
        categoryField.text = item!.category!
        priceField.text =  "\(item!.price!)"
        descriptionField.text = item!.desc!
        
        if let imagePath = item!.img {
            let image = UIImage(contentsOfFile: imagePath)
            imageView.image = image
        }else{
            imageView.image = UIImage(named: "defaultImage")
        }
    }
    
    @IBAction func btnImagePicker(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    

    @IBAction func onConfirmClick(_ sender: Any) {
        var newItem:Item?
        let name = nameGameField.text!
        let category = categoryField.text!
        let price = Int(priceField.text!)
        let desc = descriptionField.text!
        
        if(name == "" || category == "" || price == nil || desc == ""){
            showAlert(msg: "You must fill all fields!")
            return
        }
        
        
        let pathImage = imagePath
        
        let imageName = "yourFileName_\(imageIteration).jpg"
        
        if pathImage == nil{
            newItem = Item(name: name, category: category, price: price, desc: desc, img: item!.img)
        }else{
            newItem = Item(name: name, category: category, price: price, desc: desc, img: pathImage)
        }
            
            
        print(pathImage)
        

        db.updateProduct(contxt: contxt, newProduct: newItem!, oldProduct: item!)
        
        // bikin update massal ke semua cart user yg produknya sama
        db.updateItemsByProduct(contxt: contxt, newItem: newItem!, oldProductName: item!.name!)
        
        imageIteration += 1
        UserDefaults.standard.set(imageIteration, forKey: "imageIteration")
        
        
        let alert = UIAlertController(title: "Item Updated", message: "Item successfully updated into the List Item!", preferredStyle: .alert)
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
        
        let alert = UIAlertController(title: "Update Product Failed", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        imageView.image = image
        saveImageToDocumentDirectory(image: image, fileName: "yourFileName_\(imageIteration).jpg")
        dismiss(animated: true)
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
