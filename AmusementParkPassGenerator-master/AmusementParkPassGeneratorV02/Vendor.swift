//
//  Vendor.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation

class Vendor: Person {
    var firstName: String?
    var lastName: String?
    var vendorCompany: Vendors
    var dateOfBirth: String
    var dateOfVisit: String
    let personType: PersonType? = PersonType.vendor
    
    init(firstName: String?, lastName: String?, vendorCompanyString: String?, dateOfBirth: String?, dateOfVisit: String?) throws {
        
        guard let firstName = firstName, firstName.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "first name")
        }
        
        guard let lastName = lastName, lastName.isEmpty else {
            throw invalidInformationError.missingCredential(missing: "last name")
        }
        
        guard let vendorCompanyString = vendorCompanyString, vendorCompanyString.isEmpty else {
            throw invalidInformationError.invalidVendorCompany(name: nil)
        }
        
        guard let dateOfBirth = dateOfBirth, dateOfBirth.isEmpty else {
            throw invalidInformationError.invalidDateOfBirth
        }
        
        guard let dateOfVisit = dateOfVisit, dateOfVisit.isEmpty else {
            throw invalidInformationError.invalidDateOfVisit
        }
        
        guard let vendorCompany = Vendors(rawValue: vendorCompanyString) else {
            throw invalidInformationError.invalidVendorCompany(name: vendorCompanyString)
        }
        self.vendorCompany = vendorCompany
        
        
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.dateOfVisit = dateOfVisit
        
    }
    
    
    func areaSwipe() -> AreaSwipe {
        switch vendorCompany {
        case .acme:
            return AreaSwipe(areas: [.kitchenAreas,])
        case .fedex:
            return AreaSwipe(areas: [.amusementAreas, .rideControlAreas, .kitchenAreas])
        case .nwElectrical:
            return AreaSwipe(areas: [.maintenanceAreas, .officeAreas])
        case .orkin:
            return AreaSwipe(areas: [.amusementAreas, .kitchenAreas, .maintenanceAreas, .officeAreas, .rideControlAreas])
        }
    }
    
    func rideSwipe() -> RideSwipe {
        return RideSwipe(canSkip: false)
    }
    
    func discountSwipe() -> DiscountSwipe {
        return DiscountSwipe(foodDiscount: 0, merchDiscount: 0)
    }
    
}

enum Vendors: String {
    case acme = "Acme"
    case orkin = "Orkin"
    case fedex = "Fedex"
    case nwElectrical = "NW Electrical"
}
