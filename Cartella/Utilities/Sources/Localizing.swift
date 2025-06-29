//
//  Localizing.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

extension String {
    static let DeveloperName = NSLocalizedString("Anushka Samarasinghe.", comment: "")
    
    enum Warning {
        static let invalidPhoneNumber = "Invalid Number"
        static let passwordAlradyUsed = "This password has already been used. Please choose a different one."
        static let passwordRequired = "Password must contain at least one letter & one number"
        static let invalidEmail = NSLocalizedString("Invalid email address.", comment: "")
        static let mismatchingPasswords = NSLocalizedString("The password you have entered do not match", comment: "")
        static let noInternet = NSLocalizedString("Internet connection offline.", comment: "")
    }
    static let Alert = NSLocalizedString("Alert", comment: "")
    static let Error = NSLocalizedString("Error", comment: "")
    static let Incomplete = NSLocalizedString("Incomplete", comment: "")
    static let Success = NSLocalizedString("Success", comment: "")
    static let Failed = NSLocalizedString("Failed", comment: "")
    static let ErrorCorrupted = NSLocalizedString("Error is corrupted.", comment: "")
    static let Registered = NSLocalizedString("Email Registered", comment: "")
    
    static let MissingData = NSLocalizedString("Missing data in the request.", comment: "")
    static let InvalidUrl = NSLocalizedString("Invalid url.", comment: "")
    static let NoInternet = NSLocalizedString("Internet connection offline.", comment: "")
    
    static let EmailEmpty = NSLocalizedString("Please enter email address.", comment: "")
    static let PasswordEmpty = NSLocalizedString("Please enter password.", comment: "")
}
