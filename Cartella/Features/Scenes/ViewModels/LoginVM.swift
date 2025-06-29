//
//  LoginVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

final class LoginVM: BaseVM {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var accNotAvailable = false
    @Published var isActive = false
    
    private let persistenceController = PersistenceController.shared
}

extension LoginVM {
    @MainActor
    func processWithSignIn() async throws {
        startLoading()
        do {
            try validateEmail(email)
            try validatePassword(password)
            
            // Check if user exists
            if !persistenceController.userExistsByEmail(email: email) {
                self.alertMessage = "Email not found. Please sign up first."
                throw AppError.message("Email not found. Please sign up first.")
            }
            
            // Authenticate user
            guard let authenticatedUser = persistenceController.authenticateUser(email: email, password: password) else {
                self.alertMessage = "Invalid email or password."
                throw AppError.message("Invalid email or password.")
            }
            
            // Check if profile is completed
            if authenticatedUser.isProfileCompleted {
                // Navigate to home
                isActive = true
            } else {
                // Navigate to create profile
                isActive = false
            }
        } catch {
            throw error
        }
        stopLoading()
    }
    
    /// Check if user should navigate to signup
    func shouldNavigateToSignup() -> Bool {
        return !persistenceController.userExistsByEmail(email: email)
    }
}
