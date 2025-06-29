//
//  CheckoutProduct.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import Foundation

// MARK: - CheckoutProduct
public struct CheckoutProductModel: Codable {
    public let id: String?
    public let productDetails: ProductModel?
    public let status: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productDetails, status
    }

    public init(id: String?, productDetails: ProductModel?, status: Int?) {
        self.id = id
        self.productDetails = productDetails
        self.status = status
    }
}

struct CartItemWrapper {
    let checkoutProduct: CheckoutProductModel
    let quantity: Int
    
    init(checkoutProduct: CheckoutProductModel, quantity: Int) {
        self.checkoutProduct = checkoutProduct
        self.quantity = quantity
    }
    
    var totalPrice: Double {
        return (checkoutProduct.productDetails?.price ?? 0) * Double(quantity)
    }
} 
