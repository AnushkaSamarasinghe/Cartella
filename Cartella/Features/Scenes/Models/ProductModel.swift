//
//  ProductModel.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

// MARK: - Products API Response Wrapper
struct ProductsResponse: Codable {
    let products: [ProductModel]
}

// MARK: - Product Model
public struct ProductModel: Codable {
    public let id: Int?
    public let title: String?
    public let price: Double?
    public let description: String?
    public let category: String?
    public let image: String?
    public let rating: Rating?
    public let isFavourite: Bool?
}

// MARK: - Rating
public struct Rating: Codable {
    public let rate: Double?
    public let count: Int?
}
