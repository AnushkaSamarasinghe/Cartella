//
//  Validators.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation
import Regex

class Validator {
    func nonEmptyValidator(value: String, value2: String? = nil) -> ValidationStatus {
        if value.count > 0 {
            return .success
        }
        return .failure(message: "cannot be emply")
    }
    
    func isValidEmailValidator(value : String, value2 : String? = nil) -> ValidationStatus {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex : Regex  = pattern.r!
        
        guard regex.matches(value) else {
            return .failure(message: " Invalid email address")
        }
        return .success
    }
    
    func isValidPasswordValidator(value : String, value2 : String? = nil)-> ValidationStatus {
        if value.count > 7 {
            return .success
        }
        return .failure(message: "must be 8 digit or more")
    }
    
    func passwordMatchValidator(value: String, value2: String?, value3: String?) -> ValidationStatus {
        if (value.count < 8) {
            return .failure(message: .Warning.passwordRequired)
        }
        if (value != value2) {
            return .failure(message: .Warning.mismatchingPasswords)
        }
        if (value3 == value) {
            return .failure(message: .Warning.passwordAlradyUsed)
        }
        return .success
    }
    
}
