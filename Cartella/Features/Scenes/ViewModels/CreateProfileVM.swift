//
//  CreateProfileVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

final class CreateProfileVM: BaseVM {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var isProfileCompleted: Bool = false
    
    private let persistenceController = PersistenceController.shared
    
    init(email: String? = nil) {
        self.email = email ?? ""
    }
}

extension CreateProfileVM {
    @MainActor
    func processWithCreateProfile() async throws {
        startLoading()
        do {
            try nonEmptyValidation(email, fieldName: "Email", title: .EmailEmpty)
            try nonEmptyValidation(name, fieldName: "Name", title: .Incomplete)
            
            // Complete user profile
            guard persistenceController.completeUserProfile(email: email, name: name) != nil else {
                throw AppError.message("Failed to complete profile. Please try again.")
            }
            
            // Profile completed successfully
            isProfileCompleted = true
            
        } catch {
            isProfileCompleted = false
            throw error
        }
        stopLoading()
    }
    
    func loadEmailFromCoreData() {
        if email.isEmpty {
            // Get email from the current user in Core Data
            if let currentUser = persistenceController.getCurrentUser() {
                email = currentUser.email ?? ""
            } else if let userData = persistenceController.loadUserData() {
                email = userData.email ?? ""
            }
        }
    }
}

