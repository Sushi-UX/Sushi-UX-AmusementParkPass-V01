//
//  Employee.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation

class Employee: Person {
    var firstName: String?
    var lastName: String?
    var streetAddress: String?
    var city: String?
    var state: String?
    var zipCode: Int?
    var type: EmployeeType
    var personType: PersonType? {
        return PersonType(rawValue: type.rawValue)
    }
    var projectNumber: Int?
    
    // Init for the most of the employees
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: String?, type: EmployeeType) throws {
        
        // More guard statements
        guard let firstName = firstName, firstName != "" else {
            throw invalidInformationError.missingCredential(missing: "first name")
        }
        
        guard let lastName = lastName, lastName != "" else {
            throw invalidInformationError.missingCredential(missing: "last name")
        }
        
        guard let streetAddress = streetAddress, streetAddress != "" else {
            throw invalidInformationError.missingCredential(missing: "street address")
        }
        
        guard let city = city, city != "" else {
            throw invalidInformationError.missingCredential(missing: "city")
        }
        
        guard let state = state, state != "" else {
            throw invalidInformationError.missingCredential(missing: "state")
        }
        
        guard let zipCode = zipCode, zipCode != "" else {
            throw invalidInformationError.missingCredential(missing: "zip code")
        }
        
        guard let modifiedZipCode = Int(zipCode) else {
            throw invalidInformationError.invalidZipCode
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = modifiedZipCode
        self.type = type
    }
    
    // init for contract workers
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: String?, type: EmployeeType, projectNumber: String?) throws {
        
        guard let firstName = firstName, firstName.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "first name")
        }
        
        guard let lastName = lastName, lastName.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "last name")
        }
        
        guard let streetAddress = streetAddress, streetAddress.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "street address")
        }
        
        guard let city = city, city.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "city")
        }
        
        guard let state = state, state.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "state")
        }
        
        guard let zipCode = zipCode, zipCode.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "zip code")
        }
        
        guard let modifiedZipCode = Int(zipCode) else {
            throw invalidInformationError.invalidZipCode
        }
        
        guard let projectNumber = projectNumber, projectNumber.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "project number")
        }
        
        guard let modifiedProjectNumber = Int(projectNumber) else {
            throw invalidInformationError.projectNumberIsNotInt
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = modifiedZipCode
        self.type = type
        
        if modifiedProjectNumber == 1001 || modifiedProjectNumber == 1002 || modifiedProjectNumber == 1003 || modifiedProjectNumber == 2001 || modifiedProjectNumber == 2002 {
            self.projectNumber = modifiedProjectNumber
        } else {
            throw invalidInformationError.invalidProjectNumber(projectNumber: modifiedProjectNumber)
        }
    }
    
    func areaSwipe() -> AreaSwipe {
        switch type {
        case .food:
            return AreaSwipe(areas: [.amusementAreas, .kitchenAreas])
        case .ride:
            return AreaSwipe(areas: [.amusementAreas, .rideControlAreas])
        case .maintenance:
            return AreaSwipe(areas: [.amusementAreas, .kitchenAreas, .rideControlAreas, .maintenanceAreas])
        case .contract:
            if projectNumber == 1001 {
                return AreaSwipe(areas: [.amusementAreas, .rideControlAreas])
                
            } else if projectNumber == 1002 {
                return AreaSwipe(areas:[.amusementAreas, .rideControlAreas, .maintenanceAreas])
                
            } else if projectNumber == 1003 {
                return AreaSwipe(areas: [.amusementAreas, .kitchenAreas, .rideControlAreas, .maintenanceAreas, .officeAreas])
                
            } else if projectNumber == 2001 {
                return AreaSwipe(areas: [.officeAreas])
                
            } else if projectNumber == 2002 {
                return AreaSwipe(areas: [.kitchenAreas, .maintenanceAreas])

            } else {
                return AreaSwipe(areas: [])
            }
        }
    }
    
    func rideSwipe() -> RideSwipe {
        return RideSwipe(canSkip: false)
    }
    
    func discountSwipe() -> DiscountSwipe {
        return DiscountSwipe(foodDiscount: 15, merchDiscount: 25)
    }
}

enum EmployeeType: String {
    case food
    case ride
    case maintenance
    case contract
}
