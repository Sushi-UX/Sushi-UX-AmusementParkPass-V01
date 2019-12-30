//
//  Errors.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation



class DateCalculator {
    let formatter = DateFormatter()    
    
    // given a formatted string that represents a date, it calculates your age
    func calculateAgeFrom(birthDate dateString: String) throws -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let dateFromString = dateFormatter.date(from: dateString) else {
           throw invalidInformationError.invalidDateOfBirth
        }
        
        return Calendar.current.dateComponents([.year], from: dateFromString, to: Date()).year!
    }
    
    // returns the current date
    func currentDate() -> String {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let stringFromDate = dateFormatter.string(from: currentDate)
        return stringFromDate
    }
    
}
