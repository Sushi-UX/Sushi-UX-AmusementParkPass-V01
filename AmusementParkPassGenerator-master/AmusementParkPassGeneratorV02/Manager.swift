//
//  Manager.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation

class Manager: Person {
    var firstName: String?
    var lastName: String?
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: Int
    let personType: PersonType? = .manager
    
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: String? ) throws {
        
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
        
        self.firstName = firstName
        self.lastName = lastName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = modifiedZipCode
    }
    
    // approperate types need to access their designated areas
    var areas: [Areas] {
        return [.amusementAreas, .kitchenAreas, .maintenanceAreas, .officeAreas, .rideControlAreas]
    }
    
    // every employee needs to get the same discount so a static function will do
    static var foodDiscount: Int = 25
    static var merchDiscount: Int = 25
    
    
    
    func areaSwipe() -> AreaSwipe {
        return AreaSwipe(areas: [.amusementAreas, .kitchenAreas, .maintenanceAreas, .officeAreas, .rideControlAreas])
    }
    
    func rideSwipe() -> RideSwipe {
        return RideSwipe(canSkip: false)
    }
    
    func discountSwipe() -> DiscountSwipe {
        return DiscountSwipe(foodDiscount: 25, merchDiscount: 25)
    }
    
}
