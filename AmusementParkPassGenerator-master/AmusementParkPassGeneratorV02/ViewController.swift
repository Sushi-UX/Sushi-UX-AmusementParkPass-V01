//
//  ViewController.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import UIKit

// A way to add and remove the buttons to and from the second bar
extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
    func removeAllArrangedSubviews() {
        for view in self.arrangedSubviews {
            self.removeArrangedSubview(view)
        }
    }
}

// Makes it possible to modify fonts with bolding and other things
extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func regularPrimary() -> UIFont {
        return UIFont.systemFont(ofSize: 24)
    }
    
    func regularSecondary() -> UIFont {
        return UIFont.systemFont(ofSize: 20)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}


class ViewController: UIViewController {
    let dateCalculator = DateCalculator()
    
    // Top level buttons
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var employeeButton: UIButton!
    @IBOutlet weak var managerButton: UIButton!
    @IBOutlet weak var vendorButton: UIButton!
    
    // Toward top stackview + buttons
    @IBOutlet weak var bottomStackView: UIStackView!
    
    let button1 = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    let button3 = UIButton(type: .system)
    let button4 = UIButton(type: .system)
    let button5 = UIButton(type: .system)
    
    
    // Fields
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var SSNField: UITextField!
    @IBOutlet weak var projectNumberField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var streetAddressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    // Bottom Buttons
    @IBOutlet weak var generatePassButton: UIButton!
    @IBOutlet weak var populateDataButton: UIButton!
    
    // Vars that keep track of the last pressed button on the top and lower bars
    var currentPrimaryButton = UIButton()
    var currentSecondaryButton = UIButton()
    var fieldsToAutofil = [Fields]()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let person = generatePass()
        
        guard let passController = segue.destination as? PassController else {
            return
        }
        
        passController.person = person
    }
    
    // Required
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Required
    init(fieldsToAutofil: [Fields]) {
        self.fieldsToAutofil = fieldsToAutofil
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds rounded corners to the buttons
        populateDataButton.layer.cornerRadius = 10
        generatePassButton.layer.cornerRadius = 10
        populateDataButton.clipsToBounds = true
        generatePassButton.clipsToBounds = true
        
        // Some other setup things
        bottomStackView.alignment = .center
        setupSecondaryButtonAttributes(for: [button1, button2, button3, button4, button5])
        bottomStackView.addArrangedSubviews([button1, button2, button3, button4, button5])
        disableFields()

        // Do any additional setup after loading the view.
        // Starts it off by pressing the guest button
        guestPressed("me")
    }
    
    // Resets the attributes of the buttons in the first row when they lose focus
    func resetPrimaryButton(_ button: UIButton) {
        button.titleLabel?.font = button.titleLabel?.font.regularPrimary()
        button.setTitleColor(UIColor(red: 0.812, green: 0.761, blue: 0.875, alpha: 1.00), for: .normal)
    }
    
    // Resets the attributes of the buttons in the second row when they lose focus
    func resetSecondaryButton(_ button: UIButton) {
        button.titleLabel?.font = button.titleLabel?.font.regularSecondary()
        button.setTitleColor(UIColor(red: 0.522, green: 0.494, blue: 0.561, alpha: 1.00), for: .normal)
    }
    
    // assigns starting attributes to all the secondary buttons because they are created programatically
    func setupSecondaryButtonAttributes(for buttons: [UIButton]) {
        for button in buttons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.setTitleColor(UIColor(red: 0.522, green: 0.494, blue: 0.561, alpha: 1.00), for: .normal)
            button.addTarget(self, action: #selector(secondaryButtonClicked), for: .touchUpInside)

        }
    }
    
    // Enables fields that it is passed along with wiping all fields that have values written to them
    func enableFields(for fields: [Fields]) {
        disableFields()
        wipeAllFields()
        
        fieldsToAutofil = fields
        for field in fields {
            switch field {
            case .dateOfBirth: dateOfBirthField.isEnabled = true
            case .SSN: SSNField.isEnabled = true
            case .projectNumber: projectNumberField.isEnabled = true
            case .firstName: firstNameField.isEnabled = true
            case .lastName: lastNameField.isEnabled = true
            case .streetAddress: streetAddressField.isEnabled = true
            case .company: companyField.isEnabled = true
            case .city: cityField.isEnabled = true
            case .state: stateField.isEnabled = true
            case .zipCode: zipCodeField.isEnabled = true
            }
        }
    }
    
    // Helper function, disables all the fields
    func disableFields() {
        dateOfBirthField.isEnabled = false
        SSNField.isEnabled = false
        projectNumberField.isEnabled = false
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        streetAddressField.isEnabled = false
        companyField.isEnabled = false
        cityField.isEnabled = false
        stateField.isEnabled = false
        zipCodeField.isEnabled = false
    }
    
    // Helper, removes all text
    func wipeAllFields() {
        dateOfBirthField.text = ""
        SSNField.text = ""
        projectNumberField.text = ""
        firstNameField.text = ""
        lastNameField.text = ""
        streetAddressField.text = ""
        companyField.text = ""
        cityField.text = ""
        stateField.text = ""
        zipCodeField.text = ""
    }
    
    // MARK: Alert function
    func showAlert(title: String, with message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //-----------------------------------------
    // BUTTON CLICKS
    //-----------------------------------------
    
    // When a button in the second row is clicked
    @objc func secondaryButtonClicked(_ sender: UIButton?) {
        guard let sender = sender else {
            //  do nothing
            return
        }
        // modify the font to show that its the focus right now
        sender.titleLabel?.font = sender.titleLabel?.font.bold()
        sender.setTitleColor(.white, for: .normal)
        
        // reset the old one
        resetSecondaryButton(currentSecondaryButton)
        currentSecondaryButton = sender
        
        // Switch on the sender (which represents one of the 5 seconday buttons)
        switch sender {
        case button1:
            if currentPrimaryButton == guestButton {
                //this is for child
                print("child")
                enableFields(for: [.dateOfBirth, .firstName, .lastName])
            }
        case button2:
            if currentPrimaryButton == guestButton {
                //this is for adult
                print("adult")
                enableFields(for: [.firstName, .lastName])
            }
        case button3:
            if currentPrimaryButton == guestButton {
                //this is for senior
                print("senior")
                enableFields(for: [.firstName, .lastName, .dateOfBirth])
            }
        case button4:
            if currentPrimaryButton == guestButton {
                //this is for VIP
                print("VIP")
                enableFields(for: [.firstName, .lastName])
            } else if currentPrimaryButton == employeeButton {
                // this is for contract workers
                print("contract")
                enableFields(for: [.firstName, .lastName, .streetAddress, .city, .state, .zipCode, .projectNumber])
            }
        case button5:
            if currentPrimaryButton == guestButton {
                //this is for season pass
                print("seasonPass")
                enableFields(for: [.firstName, .lastName, .streetAddress, .city, .state, .zipCode])
            } else if currentPrimaryButton == employeeButton {
                // this is an error and should return an error
                print("this should never happen")
            }
        default: print("error")
        }
    }

    //-----------------------------------------
    // TOP BUTTON PRESSES
    //-----------------------------------------
    
    // When the guest button is pressed
    @IBAction func guestPressed(_ sender: Any) {
        resetPrimaryButton(currentPrimaryButton)
        
        // set the attributes
        guestButton.titleLabel?.font = guestButton.titleLabel?.font.bold()
        guestButton.setTitleColor(.white, for: .normal)
        
        // add the 5th button
        if !bottomStackView.arrangedSubviews.contains(button5) {
            bottomStackView.addArrangedSubview(button5)
            button5.isHidden = false

        }
        
        // unhide all the other buttons
        for button in [button1, button2, button3, button4] {
            button.isHidden = false
        }
        
        // set the text for each button
        button1.setTitle("Child", for: .normal)
        button2.setTitle("Adult", for: .normal)
        button3.setTitle("Senior", for: .normal)
        button4.setTitle("VIP", for: .normal)
        button5.setTitle("Season Pass", for: .normal)

        // set the current button to this one
        currentPrimaryButton = guestButton
    }
    
    // When the employee button is pressed (REFER TO GUEST FOR LABELS)
    @IBAction func employeePressed(_ sender: Any) {
        resetPrimaryButton(currentPrimaryButton)
        employeeButton.titleLabel?.font = employeeButton.titleLabel?.font.bold()
        employeeButton.setTitleColor(.white, for: .normal)
        
        if bottomStackView.arrangedSubviews.contains(button5) {
            bottomStackView.removeArrangedSubview(button5)
            button5.isHidden = true
        }
        
        for button in [button1, button2, button3, button4] {
            button.isHidden = false
        }

        button1.setTitle("Food Services", for: .normal)
        button2.setTitle("Ride Services", for: .normal)
        button3.setTitle("Maintenance", for: .normal)
        button4.setTitle("Contract", for: .normal)
        
        // enable the nessicary fields
        enableFields(for: [.firstName, .lastName, .city, .state, .streetAddress, .zipCode])
        
        currentPrimaryButton = employeeButton
    }
    
    @IBAction func managerPressed(_ sender: Any) {
        // assigning attributes
        resetPrimaryButton(currentPrimaryButton)
        managerButton.titleLabel?.font = managerButton.titleLabel?.font.bold()
        managerButton.setTitleColor(.white, for: .normal)
        
        // hide all buttons
        for button in [button1, button2, button3, button4, button5] {
            button.isHidden = true
        }
        
        // enable the fields needed for input
        enableFields(for: [.firstName, .lastName, .city, .state, .streetAddress, .zipCode])
        
        currentPrimaryButton = managerButton
    }
    
    @IBAction func vendorPressed(_ sender: Any) {
        resetPrimaryButton(currentPrimaryButton)
        vendorButton.titleLabel?.font = vendorButton.titleLabel?.font.bold()
        vendorButton.setTitleColor(.white, for: .normal)
        
        for button in [button1, button2, button3, button4, button5] {
            button.isHidden = true
        }
        
        enableFields(for: [.firstName, .lastName, .dateOfBirth, .company])
        
        currentPrimaryButton = vendorButton
    }
    
    //-----------------------------------------
    // BOTTOM BUTTON PRESSES
    //-----------------------------------------
    
    // The HUGE pass generating function...
    func generatePass() -> Person? {
        
        // pass through all the relevent data depending on which top and bottomty button is selected
        
        // if the current primary button is the manager button...
        if currentPrimaryButton == managerButton {
            do {
                // Create the manager
                let person = try Manager(firstName: firstNameField.text, lastName: lastNameField.text, streetAddress: streetAddressField.text, city: cityField.text, state: stateField.text, zipCode: zipCodeField.text)
                
                // return the manager
                return person
                
                // ERROR CATCHING
            } catch invalidInformationError.invalidZipCode {
                showAlert(title: "Invalid Zipcode", with: "Please enter a zip code that only consists of numbers")
            } catch invalidInformationError.missingCredential(let missingCreds) {
                showAlert(title: "Missing Credentials", with: "It looks like you forgot to input any information for your \(missingCreds)" )
            } catch let error {
                showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
            }
            
            // If its a vendor
        } else if currentPrimaryButton == vendorButton {
            
            do {
                // create the vendor
                let person = try Vendor(firstName: firstNameField.text, lastName: lastNameField.text, vendorCompanyString: companyField.text, dateOfBirth: dateOfBirthField.text, dateOfVisit: dateCalculator.currentDate())
                
                // return the vendor
                return person
                
                // ERROR CATCHING
            } catch invalidInformationError.invalidDateOfBirth {
                showAlert(title: "Invalid Date Of Birth", with: "Please enter a valid DOB")
            } catch invalidInformationError.invalidDateOfVisit {
                showAlert(title: "Invalid Date Of Visit", with: "Please enter a valid DOV")
            } catch invalidInformationError.invalidZipCode {
                showAlert(title: "Invalid Zipcode", with: "Please enter a zip code that only consists of numbers")
            } catch invalidInformationError.missingCredential(let missingCreds) {
                showAlert(title: "Missing Credentials", with: "It looks like you forgot to input any information for your \(missingCreds)" )
            } catch invalidInformationError.invalidVendorCompany(let name) {
                if let name = name {
                    showAlert(title: "Invalid Vendor Company", with: "\(name) is an invalid vendor company. Please enter a valid one")
                } else {
                    showAlert(title: "Missing Vendor Company", with: "Please enter a vendor company")
                }
                
            } catch let error {
                showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
            }
            
        } else {
            // for the other kinds of people we switch on the secondar button type...
            switch currentSecondaryButton {
            case button1:
                // if its for the first button and the primary button is the guest one...
                if currentPrimaryButton == guestButton {
                    do {
                        // Create a child
                        let person = try Guest(firstName: firstNameField.text, lastName: lastNameField.text, age: dateCalculator.calculateAgeFrom(birthDate: dateOfBirthField.text ?? ""))
                        
                        // return the child
                        return person
                        
                    } catch invalidInformationError.invalidDateOfBirth {
                        showAlert(title: "Invalid Date Of Birth", with: "Please enter a valid DOB")
                    } catch invalidInformationError.invalidDateOfVisit {
                        showAlert(title: "Invalid Date Of Visit", with: "Please enter a valid DOV")
                    } catch invalidInformationError.invalidAge {
                        showAlert(title: "Invalid Age", with: "You are too old to obtain the free child pass...")
                    } catch invalidInformationError.missingCredential(let missing) {
                        showAlert(title: "Missing First Name", with: "Please either enter a valid \(missing)")
                    } catch let error {
                        showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
                    }
                    
                } else if currentPrimaryButton == employeeButton {
                    // this is for food services
                    
                    do {
                        let person = try Employee(firstName: firstNameField.text, lastName: lastNameField.text, streetAddress: streetAddressField.text, city: cityField.text, state: stateField.text, zipCode: zipCodeField?.text, type: .food)
                        
                        return person
                        
                    } catch invalidInformationError.missingCredential(let missingCreds) {
                        showAlert(title: "Missing Credentials", with: "It looks like you forgot to input any information for your \(missingCreds)" )
                        
                    } catch invalidInformationError.invalidZipCode {
                        showAlert(title: "Invalid Zipcode", with: "Please enter a zip code that only consists of numbers")
                        
                    } catch let error {
                        showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
                    }
                }
                
                // The same process goes for every single one of the 5 buttons
            case button2:
                if currentPrimaryButton == guestButton {
                    //this is for adult
                    let person = Guest(firstName: firstNameField.text, lastName: lastNameField.text, isVIP: false)
                    
                    return person
                    
                    
                } else if currentPrimaryButton == employeeButton {
                    // this is for ride services
                    
                    do {
                        let person = try Employee(firstName: firstNameField.text, lastName: lastNameField.text, streetAddress: streetAddressField.text, city: cityField.text, state: stateField.text, zipCode: zipCodeField?.text, type: .ride)
                        
                        return person
                        
                    } catch invalidInformationError.missingCredential(let missingCreds) {
                        showAlert(title: "Missing Credentials", with: "It looks like you forgot to input any information for your \(missingCreds)" )
                        
                    } catch invalidInformationError.invalidZipCode {
                        showAlert(title: "Invalid Zipcode", with: "Please enter a zip code that only consists of numbers")
                        
                    } catch let error {
                        showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
                    }
                }
                
            case button3:
                if currentPrimaryButton == guestButton {
                    //this is for senior
                    do {
                        let person = try Guest(firstName: firstNameField.text, lastName: lastNameField.text, age: dateCalculator.calculateAgeFrom(birthDate: dateOfBirthField.text ?? ""))
                        
                        return person
                        
                    } catch invalidInformationError.invalidDateOfBirth {
                        showAlert(title: "Invalid Date Of Birth", with: "Please enter a valid DOB")
                    } catch invalidInformationError.invalidDateOfVisit {
                        showAlert(title: "Invalid Date Of Visit", with: "Please enter a valid DOV")
                    } catch invalidInformationError.invalidAge {
                        showAlert(title: "Invalid Age", with: "You are too young to obtain the senior pass...")
                    } catch let error {
                        showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
                    }
                    
                } else if currentPrimaryButton == employeeButton {
                    // this is for maintenance
                    
                    do {
                        let person = try Employee(firstName: firstNameField.text, lastName: lastNameField.text, streetAddress: streetAddressField.text, city: cityField.text, state: stateField.text, zipCode: zipCodeField?.text, type: .maintenance)
                        
                        return person
                        
                    } catch invalidInformationError.missingCredential(let missingCreds) {
                        showAlert(title: "Missing Credentials", with: "It looks like you forgot to input any information for your \(missingCreds)" )
                        
                    } catch invalidInformationError.invalidZipCode {
                        showAlert(title: "Invalid Zipcode", with: "Please enter a zip code that only consists of numbers")
                        
                    } catch let error {
                        showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
                    }
                }
                
            case button4:
                if currentPrimaryButton == guestButton {
                    //this is for VIP
                    
                    let person = Guest(firstName: firstNameField.text, lastName: lastNameField.text, isVIP: true)
                    
                    return person
                    
                    
                } else if currentPrimaryButton == employeeButton {
                    // this is for contract workers
                    
                    do {
                        let person = try Employee(firstName: firstNameField.text, lastName: lastNameField.text, streetAddress: streetAddressField.text, city: cityField.text, state: stateField.text, zipCode: zipCodeField.text, type: .contract, projectNumber: projectNumberField.text)
                        
                        return person
                    } catch invalidInformationError.projectNumberIsNotInt {
                        showAlert(title: "Invalid Project Number", with: "The project number provided is not a number...")
                    } catch invalidInformationError.invalidProjectNumber(let projectNumber) {
                        showAlert(title: "invalid Project Number", with: "\(projectNumber) is not a valid project number...")
                    } catch invalidInformationError.invalidZipCode {
                        showAlert(title: "Invalid Zipcode", with: "Please enter a zip code that only consists of numbers")
                    } catch invalidInformationError.missingCredential(let missingCreds) {
                        showAlert(title: "Missing Credentials", with: "It looks like you forgot to input any information for your \(missingCreds)" )
                    } catch let error {
                        showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
                    }
                }
                
            case button5:
                if currentPrimaryButton == guestButton {
                    //this is for season pass
                    
                    do {
                        let person = try Guest(firstName: firstNameField.text, lastName: lastNameField.text, streetAddress: streetAddressField.text, city: cityField.text, state: stateField.text, zipCode: zipCodeField.text)
                        
                        return person
                        
                    } catch invalidInformationError.invalidZipCode {
                        showAlert(title: "Invalid Zipcode", with: "Please enter a zip code that only consists of numbers")
                    } catch invalidInformationError.missingCredential(let missingCreds) {
                        showAlert(title: "Missing Credentials", with: "It looks like you forgot to input any information for your \(missingCreds)" )
                    } catch let error {
                        showAlert(title: "Oops...", with: "We have encountered an unexpected error... \(error)")
                    }
                    
                }
            default:
                // If nothing is selected then an alert tells you to select a seconday button
                showAlert(title: "Select a Type", with: "Please select a type on the top bar to continue")
            }
        }
        return nil
    }
    
    // Fills the needed data in to satisfy the creation requirements
    @IBAction func populateDataPressed(_ sender: Any) {
        for field in fieldsToAutofil {
            switch field {
            case .firstName:
                firstNameField.text = "Julio"
            case .lastName:
                lastNameField.text = "Smith"
            case .dateOfBirth:
                if currentPrimaryButton == guestButton && currentSecondaryButton == button1 {
                    dateOfBirthField.text = "08/19/2018"

                } else if currentPrimaryButton == guestButton && currentSecondaryButton == button3 {
                    dateOfBirthField.text = "08/19/1940"
                } else {
                    dateOfBirthField.text = "08/19/2000"
                }
                
            case .SSN:
                print("SSN")
            case .city:
                cityField.text = "Lakeview"
            case .state:
                stateField.text = "California"
            case .zipCode:
                zipCodeField.text = "99999"
            case .company:
                companyField.text = "Acme"
            case .projectNumber:
                projectNumberField.text = "1001"
            case .streetAddress:
                streetAddressField.text = "123 Ridgecrest Dr."
            }
        }
    }
}

