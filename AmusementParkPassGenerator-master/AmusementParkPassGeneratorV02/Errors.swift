//
//  Errors.swift
//  AmusementParkPassGenerator
//
//  Created by Raymond Choy on 12/30/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation

enum invalidInformationError: Error {
    case missingCredential(missing: String)
    case invalidAge
    case invalidProjectNumber(projectNumber: Int)
    case projectNumberIsNotInt
    case invalidZipCode
    case invalidVendorCompany(name: String?)
    case invalidDateOfBirth
    case invalidDateOfVisit
}
