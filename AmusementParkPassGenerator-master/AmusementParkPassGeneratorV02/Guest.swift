//
//  Guest.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation

class Guest: Person {    
    var firstName: String?
    var lastName: String?
    var age: Int?
    var streetAddress: String?
    var city: String?
    var state: String?
    var zipCode: Int?
    var type: GuestType
    var personType: PersonType? {
        return PersonType(rawValue: type.rawValue)
    }
    
    
    // Init for Classic and VIPs
    init(firstName: String?, lastName: String?, isVIP: Bool) {
        
        self.firstName = firstName
        self.lastName = lastName
        
        if isVIP {
            self.type = .vip
        } else {
            self.type = .classic
        }
    }
    
    // Child and senior init method
    init(firstName: String?, lastName: String?, age: Int?) throws {
        
        if firstName == "" && lastName != "" {
            throw invalidInformationError.missingCredential(missing: "first name")
        }
        
        self.firstName = firstName
        self.lastName = lastName
        
        guard let age = age else {
            throw invalidInformationError.missingCredential(missing: "birthday")
        }
        
        if age <= 5 {
            self.type = .freeChild
            self.age = age
        } else if age >= 60 {
            self.type = .senior
            self.age = age
        } else {
            throw invalidInformationError.invalidAge
        }
    }
    
    // Season Pass Guest
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: String?) throws {
        
        // these guard statements just make sure that the user  didn't leave anything blank
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
        self.type = .seasonPass
    }
    
    // returns the food discount that the user is entitled to
    var foodDiscount: Int? {
        switch type {
        case .vip: return 10
        default: return nil
        }
    }
    
    // returns the merch discount that the user is entitled to
    var merchDiscount: Int? {
        switch type {
        case .vip: return 20
        default: return nil
        }
    }
    
    // returns the areas the user can visit
    func areaSwipe() -> AreaSwipe {
        return AreaSwipe(areas: [.amusementAreas])
    }
    
    // returns their ride skipping ability
    func rideSwipe() -> RideSwipe {
        switch type {
        case .classic, .freeChild:
            return RideSwipe(canSkip: false)
        case .vip, .seasonPass, .senior:
            return RideSwipe(canSkip: true)
        }
    }
    
    // returns the discounts their have access to
    func discountSwipe() -> DiscountSwipe {
        switch type {
        case .classic, .freeChild:
            return DiscountSwipe(foodDiscount: 0, merchDiscount: 0)
        case .vip, .seasonPass:
            return DiscountSwipe(foodDiscount: 10, merchDiscount: 20)
        case .senior:
            return DiscountSwipe(foodDiscount: 10, merchDiscount: 10)
        }
    }
}

// the different guest types
enum GuestType: String {
    case classic
    case vip
    case freeChild
    case seasonPass
    case senior
}
