//
//  DatabaseFunctions.swift
//  projectLab
//
//  Created by prk on 06/12/23.
//

import Foundation
import CoreData

class Database {
    
    func insertUser(contxt:NSManagedObjectContext, person:Person) {
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: contxt)
        
        let newPerson = NSManagedObject(entity: entity!, insertInto: contxt)
        newPerson.setValue(person.name, forKey: "name")
        newPerson.setValue(person.email, forKey: "email")
        newPerson.setValue(person.pass, forKey: "password")
        
        do {
            try contxt.save()
            getUsers(contxt:contxt)
        } catch {
            print("Entity creation failed")
        }
        
    }
    
    
    
    func getUsers(contxt:NSManagedObjectContext) {
        var userArr = [Person]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                userArr.append(
                    Person(name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String, pass: data.value(forKey: "password") as! String))
            }
            
            for i in userArr {
                print(i)
            }
            
        } catch {
            print("Data loading failure")
        }
    }
    
    func getUser(contxt:NSManagedObjectContext, email:String) -> Person{
        var person:Person?
        
        // check all user
        getUsers(contxt: contxt)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.predicate = NSPredicate(format: "email=%@", email)
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                person = Person(name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String, pass: data.value(forKey: "password") as! String)
            }
            
        } catch {
            print("Data loading failure")
        }
        
        return person ?? Person(name: nil, email: nil, pass: nil)
    }
    
    
    func insertProduct(contxt:NSManagedObjectContext, product:Item) {
        
        var itemArr = [Item]()
        
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: contxt)
        
        let newProduct = NSManagedObject(entity: entity!, insertInto: contxt)
        newProduct.setValue(product.name, forKey: "name")
        newProduct.setValue(product.category, forKey: "category")
        newProduct.setValue(product.price, forKey: "price")
        newProduct.setValue(product.desc, forKey: "desc")
        newProduct.setValue(product.img, forKey: "image")
        print(product.img! + "Database")
        do {
            try contxt.save()
            itemArr = getProducts(contxt:contxt)
        } catch {
            print("Entity creation failed")
        }
    }
    
    
    func getProducts(contxt:NSManagedObjectContext) -> [Item] {
        var itemArr = [Item]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                itemArr.append(
                    Item(name: data.value(forKey: "name") as! String, category: data.value(forKey: "category") as! String, price: data.value(forKey: "price") as! Int, desc: data.value(forKey: "desc") as! String, img: data.value(forKey: "image") as! String))
            }
            
            for i in itemArr {
                print(i)
            }
            
        } catch {
            print("Data loading failure")
        }
        
        return itemArr
    }
    
    
    func getProduct(contxt:NSManagedObjectContext, name:String) -> Item{
        var product:Item?
        
        // check all products
        getProducts(contxt: contxt)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        request.predicate = NSPredicate(format: "name=%@", name)
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                product = Item(name: data.value(forKey: "name") as! String, category: data.value(forKey: "category") as! String, price: data.value(forKey: "price") as! Int, desc: data.value(forKey: "desc") as! String, img: data.value(forKey: "image") as! String)
            }
            
        } catch {
            print("Data loading failure")
        }
        
        return product ?? Item(name: nil, category: nil, price: nil, desc: nil)
    }
    
    
    func deleteProduct(contxt:NSManagedObjectContext, name:String){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        request.predicate = NSPredicate(format: "name=%@", name)
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                contxt.delete(data)
            }
            
            try contxt.save()
        } catch {
            print("Data deletion failure.")
        }
    }
    
    
    func updateProduct(contxt:NSManagedObjectContext, newProduct:Item, oldProduct:Item){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        request.predicate = NSPredicate(format: "name=%@", oldProduct.name!)
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                data.setValue(newProduct.name, forKey: "name")
                data.setValue(newProduct.category, forKey: "category")
                data.setValue(newProduct.price, forKey: "price")
                data.setValue(newProduct.desc, forKey: "desc")
                data.setValue(newProduct.img, forKey: "image")
                updateCartItemsAfterProduct(contxt: contxt, newProduct: newProduct, oldProductName: oldProduct.name!)
            }
            
            try contxt.save()
        } catch {
            print("Data update failure.")
        }
    }
    
    
    func insertToCart(contxt:NSManagedObjectContext, cartItem:CartItem) {
        
        var itemArr = [CartItem]()
        
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: contxt)
        
        let newItem = NSManagedObject(entity: entity!, insertInto: contxt)
        newItem.setValue(cartItem.userEmail, forKey: "useremail")
        newItem.setValue(cartItem.productName, forKey: "productname")
        newItem.setValue(cartItem.qty, forKey: "qty")
        newItem.setValue(cartItem.price, forKey: "price")
        do {
            try contxt.save()
            itemArr = getItemsByUser(contxt:contxt, userEmail: cartItem.userEmail!)
        } catch {
            print("Entity creation failed")
        }
    }
    
    
    func getItemsByUser(contxt:NSManagedObjectContext, userEmail:String) -> [CartItem] {
        var itemArr = [CartItem]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        request.predicate = NSPredicate(format: "useremail=%@", userEmail)
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                itemArr.append(CartItem(userEmail: data.value(forKey: "useremail") as! String, productName: data.value(forKey: "productname") as! String, qty: data.value(forKey: "qty") as! Int, price: data.value(forKey: "price") as! Int))
            }
            
            for i in itemArr {
                print(i)
            }
            
        } catch {
            print("Data loading failure")
        }
        
        return itemArr
    }
    
    
    
    func getItemByUserAndProduct(contxt:NSManagedObjectContext, name:String, userEmail:String) -> CartItem{
        var item:CartItem?
        
        // check all items
        getItemsByUser(contxt: contxt, userEmail: userEmail)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "useremail=%@", userEmail), NSPredicate(format: "productname=%@", name)])
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                item = CartItem(userEmail: data.value(forKey: "useremail") as! String, productName: data.value(forKey: "productname") as! String, qty: data.value(forKey: "qty") as! Int, price: data.value(forKey: "price") as! Int)
            }
            
        } catch {
            print("Data loading failure")
        }
        
        return item ?? CartItem(userEmail: nil, productName: nil, qty: nil, price: nil)
    }
    
    
    func updateQty(contxt:NSManagedObjectContext, userEmail:String, name:String, newQty:Int, newPrice:Int){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "useremail=%@", userEmail), NSPredicate(format: "productname=%@", name)])
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                data.setValue(newQty, forKey: "qty")
                data.setValue(newPrice, forKey: "price")
            }
            
            try contxt.save()
        } catch {
            print("Data update failure")
        }
        
        
    }
    
    
    
    func updateItemsByProduct(contxt:NSManagedObjectContext, newItem:Item, oldProductName:String){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        request.predicate = NSPredicate(format: "productname=%@", oldProductName)
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                let qty = data.value(forKey: "qty") as! Int
                let price = newItem.price! as Int
                let newPrice = qty * price
                data.setValue(newItem.name, forKey: "productname")
                data.setValue(newPrice, forKey: "price")
            }
            
        } catch {
            print("Data loading failure")
        }
        
    }
    
    
    func deleteCart(contxt:NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                contxt.delete(data)
            }
            
            try contxt.save()
        } catch {
            print("Data deletion failure.")
        }
    }
    
    func updateCartItemsAfterProduct(contxt:NSManagedObjectContext, newProduct:Item, oldProductName:String){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        request.predicate = NSPredicate(format: "productname=%@", oldProductName)
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                let qty = data.value(forKey: "qty")
                data.setValue(newProduct.name, forKey: "productname")
                data.setValue(qty as! Int * newProduct.price!, forKey: "price")
            }
            
            try contxt.save()
        } catch {
            print("Data update failure.")
        }
    }
}
