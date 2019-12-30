//
//  Person.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation

protocol Person {
    var firstName: String? { get set }
    var lastName: String? { get set }
    var personType: PersonType? { get }
    
    func areaSwipe() -> AreaSwipe
    func discountSwipe() -> DiscountSwipe
    func rideSwipe() -> RideSwipe
}

enum PersonType: String {
    // Guest Types
    case classic
    case vip
    case freeChild
    case seasonPass
    case senior
    
    // Employee Types
    case food
    case ride
    case maintenance
    case contract
    
    case manager
    case vendor
}
