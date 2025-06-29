//
//  SignupVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

final class SignupVM: BaseVM {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var accAvailable = false
    @Published var isActive = false
    
    private let persistenceController = PersistenceController.shared
}

extension SignupVM {
    @MainActor
    func processWithSignUp() async throws {
        startLoading()
        do {
            try validateEmail(email)
            try validatePassword(password)
            
            // Check if user already exists
            if persistenceController.userExistsByEmail(email: email) {
                self.alertMessage = "Email already exists. Please login instead."
                throw AppError.message("Email already exists. Please login instead.")
            }
            
            // Create new user account
            guard persistenceController.createUserAccount(email: email, password: password) != nil else {
                self.alertMessage = "Failed to create account. Please try again."
                throw AppError.message("Failed to create account. Please try again.")
            }
            
            // Navigate to create profile
            self.isActive = false
            
        } catch {
            self.isActive = false
            throw error
        }
        stopLoading()
    }
    
    /// Check if user should navigate to login
    func shouldNavigateToLogin() -> Bool {
        return persistenceController.userExistsByEmail(email: email)
    }
}
