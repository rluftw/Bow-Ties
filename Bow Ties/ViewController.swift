//
//  ViewController.swift
//  Bow Ties
//
//  Created by Pietro Rea on 7/12/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: - Stored properties
    
    var managedContext: NSManagedObjectContext!
    var currentBowtie: Bowtie!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
            1. insertSampleData() itself performs a fetch to make sure it isn’t inserting the 
            sample data into Core Data multiple times.
        */
        
        insertSampleData()
        
        /*
            2. create a fetch request for the purpose of fetching the newly inserted Bowtie entities. 
            The segmented control has tabs to filter by color, so the predicate adds the condition to 
            find the bow ties that match the selected color.
        */
        
        let request = NSFetchRequest(entityName: "Bowtie")
        let firstTitle = segmentedControl.titleForSegmentAtIndex(0)
        
        request.predicate = NSPredicate(format: "searchKey == %@", firstTitle!)
        
        /*
            3. The managed context does the heavy lifting for you. It executes the fetch request you 
            crafted moments earlier and returns an array of Bowtie objects.
        */
        
        do {
            let results = try managedContext.executeFetchRequest(request) as! [Bowtie]
            
            /*
                Populate the user interface with the first bow tie in the results array.
                If there was an error, print the error to the console.
            */
            
            currentBowtie = results.first!
            populate(currentBowtie)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - IBActions
    
    @IBAction func segmentedControl(control: UISegmentedControl) {
        let selectedValue = control.titleForSegmentAtIndex(control.selectedSegmentIndex)
        let request = NSFetchRequest(entityName: "Bowtie")
        
        request.predicate = NSPredicate(format: "searchKey == %@", selectedValue!)
        
        do {
            let results = try managedContext.executeFetchRequest(request) as! [Bowtie]
            currentBowtie = results.first!
            populate(currentBowtie)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    @IBAction func wear(sender: AnyObject) {
        let times = currentBowtie.timesWorn!.integerValue
        currentBowtie.timesWorn = NSNumber(integer: (times+1))
        currentBowtie.lastWorn = NSDate()
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        populate(currentBowtie)
    }

    @IBAction func rate(sender: AnyObject) {
        let alert = UIAlertController(title: "New Rating",
            message: "Rate this bow tie",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default,
            handler: nil)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) {
            (action: UIAlertAction) -> Void in
                let textField = alert.textFields![0] as UITextField
                self.updateRating(textField.text!)
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.keyboardType = .DecimalPad
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - helper methods
    
    func insertSampleData() {
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        fetchRequest.predicate = NSPredicate(format: "searchKey != nil")
        
        /* Check if the sample data has been inserted before */
        
        let count = managedContext.countForFetchRequest(fetchRequest, error: nil)
        if count > 0 { return }
        
        /* Retrieve data from the plist */
        
        let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: path!)!
        
        /* Make bowtie(entity) objects from the data array and then place into the managedContext */
        
        for dict: AnyObject in dataArray {
            let entity = NSEntityDescription.entityForName("Bowtie", inManagedObjectContext: managedContext)
            
            /* Initializes the receiver and inserts it into the specified managed object context */
            
            let bowtie = Bowtie(entity: entity!, insertIntoManagedObjectContext: managedContext)
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"] as? String
            bowtie.searchKey = btDict["searchKey"] as? String
            bowtie.rating = btDict["rating"] as? NSNumber
            
            let tintColorDict = btDict["tintColor"] as? NSDictionary
            bowtie.tintColor = colorFromDict(tintColorDict!)
            
            let imageName = btDict["imageName"] as? String
            let image = UIImage(named: imageName!)
            let photoData = UIImagePNGRepresentation(image!)
            bowtie.photoData = photoData
            
            bowtie.lastWorn = btDict["lastWorn"] as? NSDate
            bowtie.timesWorn = btDict["timesWorn"] as? NSNumber
            bowtie.isFavorite = btDict["isFavorite"] as? NSNumber
        }
    }
    
    func colorFromDict(dict: NSDictionary) -> UIColor {
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        
        let color = UIColor(
            red: CGFloat(red)/255.0,
            green: CGFloat(green)/255.0,
            blue: CGFloat(blue)/255.0,
            alpha: 1)
        return color
    }
    
    func populate(bowtie: Bowtie) {
        imageView.image = UIImage(data: bowtie.photoData!)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating!.doubleValue)/5"
        
        timesWornLabel.text = "# times worn: \(bowtie.timesWorn!.integerValue)"
     
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        lastWornLabel.text = "Last worn: " + dateFormatter.stringFromDate(bowtie.lastWorn!)
        favoriteLabel.hidden = !bowtie.isFavorite!.boolValue
        
        /*
            The tintColor transformable attribute that stores your bow tie’s color 
            changes the color of not one, but all the elements on the screen.
        */

        view.tintColor = bowtie.tintColor as! UIColor
    }
    
    func updateRating(numericString: String) {
        currentBowtie.rating = (numericString as NSString).doubleValue
        
        do {
            try managedContext.save()
            populate(currentBowtie)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            
            if error.domain == NSCocoaErrorDomain &&
                (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError) {
                    rate(currentBowtie)
            }
        }
    }
}

