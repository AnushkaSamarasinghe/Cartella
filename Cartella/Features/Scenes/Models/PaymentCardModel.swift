//
//  PaymentCardModel.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import Foundation

// MARK: - Payment Card Model
public struct PaymentCardModel: Codable {
    public let id: String?
    public let cardNumber: String?
    public let cardType: CardType?
    public let expiryDate: String?
    public let cvv: String?
    public let isDefault: Bool?
    
    public init(id: String?, cardNumber: String?, cardType: CardType?, expiryDate: String?, cvv: String?, isDefault: Bool?) {
        self.id = id
        self.cardNumber = cardNumber
        self.cardType = cardType
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.isDefault = isDefault
    }
}

// MARK: - Card Type Enum
public enum CardType: String, CaseIterable, Codable {
    case visa = "Visa"
    case mastercard = "MasterCard"
    case americanExpress = "AmericanExpress"
    case unknown = "Unknown"
    
    public var imageName: String {
        switch self {
        case .visa:
            return "Visa"
        case .mastercard:
            return "MasterCard"
        case .americanExpress:
            return "AmericanExpress"
        case .unknown:
            return "Visa"
        }
    }
}
