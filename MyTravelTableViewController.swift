//
//  MyTravelTableViewController.swift
//  MyTravel
//
//  Created by hyeong jin kim on 2017. 8. 22..
//  Copyright © 2017년 MJP. All rights reserved.
//

import UIKit
import CoreData

class MyTravelTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //var myGifts = [["name":"Best Friend","image":"1","item":"Camera"],["name":"Mom","image":"2","item":"Flowers"],["name":"Dad","image":"3","item":"Some kind of tech"],["name":"Sister","image":"4","item":"Sweets"]]
    
    var travels = [Travel]()
    
    var managedObjectContext:NSManagedObjectContext!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconImageView = UIImageView(image: UIImage(named: "Shape"))
        self.navigationItem.titleView = iconImageView
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData(){
        let travelRequest:NSFetchRequest<Travel> = Travel.fetchRequest()
        
        do{
            travels = try managedObjectContext.fetch(travelRequest)
            self.tableView.reloadData()
        }catch{
            print("Could not load data from database \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return travels.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTravelTableViewCell
        
        let TravelItem = travels[indexPath.row]
        
        if let travelImage = UIImage(data: TravelItem.image as! Data){
                cell.backgroundImageView.image = travelImage
        }
        
        
        cell.destinaionLabel.text = TravelItem.destination
        cell.dateLabel.text = TravelItem.date
        
        
        return cell
    }
    
    
    @IBAction func addTravel(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                
                self.createTravelItem(with: image)
            })
            
        }
        
    }
    
    func createTravelItem(with image: UIImage){
        
        let travelItem = Travel(context: managedObjectContext)
        travelItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        
        let inputAlert = UIAlertController(title: "New Travel", message: "Enter a destination and a date.", preferredStyle: .alert)
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Destination"
        }
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Date"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let destinationTextField = inputAlert.textFields?.first
            let dateTextField = inputAlert.textFields?.last
            
            if destinationTextField?.text != "" && dateTextField?.text != "" {
                travelItem.destination = destinationTextField?.text
                travelItem.date = dateTextField?.text
                
                do {
                    try self.managedObjectContext.save()
                    self.loadData()
                }catch {
                    print("Could not save data \(error.localizedDescription)")
                }
                
            }
            
            
        }))
        
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)

        
    }
}
