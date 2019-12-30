//
//  PassController.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import UIKit

class PassController: UIViewController {
    
    var person: Person?
    
    // Labels
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var attributeLabel1: UILabel!
    @IBOutlet weak var attributeLabel2: UILabel!
    @IBOutlet weak var attributeLabel3: UILabel!
    @IBOutlet weak var testResultsLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var areaAccessButton: UIButton!
    @IBOutlet weak var rideAccessButton: UIButton!
    @IBOutlet weak var discountAccessButton: UIButton!
    @IBOutlet weak var createNewPassButton: UIButton!
    
    // etc
    @IBOutlet weak var personCardBackground: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounds all the corners to the buttons and boxes
        areaAccessButton.layer.cornerRadius = 10
        areaAccessButton.clipsToBounds = true
        rideAccessButton.layer.cornerRadius = 10
        rideAccessButton.clipsToBounds = true
        discountAccessButton.layer.cornerRadius = 10
        discountAccessButton.clipsToBounds = true
        testResultsLabel.layer.cornerRadius = 20
        testResultsLabel.clipsToBounds = true
        createNewPassButton.layer.cornerRadius = 10
        createNewPassButton.clipsToBounds = true
        personCardBackground.layer.cornerRadius = 20
        personCardBackground.clipsToBounds = true
        
        // makes sure that the person var and others are created and not nil
        guard let person = person, let firstName = person.firstName, let lastName = person.lastName else {
            return
        }
        
        // if the first name is empty that means they didn't want to add their name so its just registered as a Park  Attendee
        if firstName.isEmpty {
            personNameLabel.text = "Park Attendee"
        } else {
            // if not then it puts their name
            personNameLabel.text = "\(firstName)  \(lastName)"
        }
        
        // checks to see if the person has a type
        guard let personType = person.personType else {
            showAlert(title: "Missing Person Type", with: "There is no person type included in the pass")
            return
        }
        
        // add the type to a label
        passTypeLabel.text = "\(personType) Pass".uppercased()
        
        // add their line skipping ability to the card
        let canSkip = person.rideSwipe().canSkip
        if canSkip {
            attributeLabel1.text = "Can skip rides"
        } else {
            attributeLabel1.text = "Can't skip rides"
        }
        
        // and add their merch discounts
        let foodDiscount = person.discountSwipe().foodDiscount
        let merchDiscount = person.discountSwipe().merchDiscount
        
        attributeLabel2.text = "\(foodDiscount)% off food items."
        attributeLabel3.text = "\(merchDiscount)% off merch items"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    // Helper, resets the label at the bottom
    func resetTestResultsLabel() {
        testResultsLabel.text = ""
        testResultsLabel.backgroundColor = UIColor(red: 0.792, green: 0.776, blue: 0.808, alpha: 1.00)

    }
    
    func showAlert(title: String, with message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Tests their area access and then changes the label to reflect it
    @IBAction func areaAccessButton(_ sender: Any) {
        resetTestResultsLabel()
        
        let areaSwipe = person?.areaSwipe()
        guard let areas = areaSwipe?.areas else {
            // this will never happen
            showAlert(title: "Oops...", with: "We have encountered an unexpected error...")
            return
        }
        
        for area in areas {
            testResultsLabel.text?.append(contentsOf: area.rawValue.uppercased())
            testResultsLabel.text?.append("\n")
        }
    }
    
    // Tests their ride access and then changes the label to reflect it
    @IBAction func rideAccessButton(_ sender: Any) {
        resetTestResultsLabel()
        
        guard let person = person else {
            return
        }
        
        let canSkip = person.rideSwipe().canSkip
        if canSkip {
            testResultsLabel.backgroundColor  = .green
            testResultsLabel.text = "CAN SKIP"
        } else {
            testResultsLabel.backgroundColor  = .red
            testResultsLabel.text = "CAN NOT SKIP"
        }
        
    }
    
    // Tests their discount access and then changes the label to reflect it
    @IBAction func discountAccess(_ sender: Any) {
        resetTestResultsLabel()
        
        let discountSwipe = person?.discountSwipe()
        if let foodDiscount: Int = discountSwipe?.foodDiscount {
            testResultsLabel.text?.append("Food Discount: \(foodDiscount)% \n")

        }
        if let merchDiscount: Int = discountSwipe?.merchDiscount {
            testResultsLabel.text?.append("Merch Discount: \(merchDiscount)% \n")

        }
    }
    
    // dismisses the view and goes back the main menu
    @IBAction func createNewPassPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
