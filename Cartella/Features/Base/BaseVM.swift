//
//  BaseVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation
import SwiftUI

class BaseVM: NSObject, ObservableObject, LoadingIndicatorDelegate {
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isAlertShown: Bool = false
    @Published var isAlertShownRegisterd: Bool = false
    
}

enum AppError: Error {
    case message(_ text: String)
    case invalidEmail(message: String = .Warning.invalidEmail)
    case invalidPassword(message: String = .Warning.passwordRequired)
    case mismatchingPasswords(message: String = .Warning.mismatchingPasswords)
    case noInternet(message: String = .Warning.noInternet)
}

extension BaseVM {
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isAlertShown = true
    }
    
    func showErrorAlert(message: String) {
        alertTitle = "Error"
        alertMessage = message
        isAlertShown = true
    }
    
    func showNoInternetAlert() {
        showAlert(title: .Error, message: .NoInternet)
    }
    func handleErrorAndShowAlert(error: Error?) {
        let message = error?.localizedDescription.lowercased() ?? "Unknown error"
        let code = (error as NSError?)?.code ?? 0

        if code != 300 {
            if message == "The email has already been taken." {
                alertTitle = "Email Registered"
            } else {
                alertTitle = .Alert
            }
        } else {
            alertTitle = self.alertTitle != "" ? self.alertTitle : .Alert
        }
        alertMessage = message
        isAlertShown = true
        
        self.stopLoading()
    }
}

extension BaseVM {
    func validateEmail(_ email: String, title: String? = nil, message: String? = nil) throws {
        let validator = Validator()
        guard validator.isValidEmailValidator(value: email).isSuccess else {
            DispatchQueue.main.async {
                self.alertTitle = title ?? "Valid Email Required"
            }
            throw AppError.message(message ?? .Warning.invalidEmail)
        }
    }

    func validatePassword(_ password: String, message: String? = nil) throws {
        let validator = Validator()
        guard validator.isValidPasswordValidator(value: password).isSuccess else {
            DispatchQueue.main.async {
                self.alertTitle = "Valid Password Required"
                self.alertMessage = message ?? "Password must contain at least 8 digit or more"
            }
            if validator.isValidPasswordValidator(value: password) == ValidationStatus.failure(message: .Warning.passwordRequired) {
                throw AppError.message(message ?? .Warning.passwordRequired)
            }
            throw AppError.message("Password must contain at least  8 digit or more")
        }
    }

    func nonEmptyValidation(_ input: String, fieldName: String, title: String? = nil, message: String? = nil) throws {
        let validator = Validator()
        guard validator.nonEmptyValidator(value: input).isSuccess else {
            alertTitle = title ?? .Alert
            throw AppError.message(message ?? "\(fieldName) field is required and cannot be empty")
        }
    }

    func checkInternetConnection() throws {
        guard (NetworkMonitor().isNetworkConnected ?? false) else {
            throw AppError.noInternet()
        }
    }
    
}

extension BaseVM {
    func showErrorLogger(message: String) {
        Logger.log(logType: .error, message: message)
    }

    func showSuccessLogger(message: String) {
        Logger.log(logType: .success, message: message)
    }

    func showInfoLogger(message: String) {
        Logger.log(logType: .warning, message: message)
    }
}
