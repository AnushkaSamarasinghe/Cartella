//
//  UserModel.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

public struct UserModel: Codable {
    public let email: String?
    public let password: String?
    public let name: String?
    public let isProfileCompleted: Bool?
    public let isActive: Bool?
    public let paymentCards: [PaymentCardModel]?
    public let checkoutProducts: [CheckoutProductModel]?
    
    public init(email: String?, password: String?, name: String?, isProfileCompleted: Bool?, isActive: Bool?, paymentCards: [PaymentCardModel]?, checkoutProducts: [CheckoutProductModel]?) {
        self.email = email
        self.password = password
        self.name = name
        self.isProfileCompleted = isProfileCompleted
        self.isActive = isActive
        self.paymentCards = paymentCards
        self.checkoutProducts = checkoutProducts
    }
}
