//
//  ViewProfileVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

final class ViewProfileVM: BaseVM {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var showDeleteAlert: Bool = false
    @Published var showAddCardSheet: Bool = false
    @Published var cardNumber: String = ""
    @Published var cardType: String = ""
    @Published var expiryDate: String = ""
    @Published var cvv: String = ""
    @Published var cardholderName: String = ""
    @Published var addCardError: String? = nil
    private let persistenceController = PersistenceController.shared
    
    func loadCurrentUser() {
        if let user = persistenceController.getCurrentUser() {
            email = user.email ?? ""
            name = user.name ?? ""
        }
    }
    
    func deleteAccount() async throws {
        startLoading()
        do {
            startLoading()
            persistenceController.deleteUserData()
            stopLoading()
            
        } catch {
            throw error
        }
        stopLoading()
    }
}
