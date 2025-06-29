//
//  ViewProductVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import Foundation
import SwiftUI
import Alamofire

class ViewProductVM:BaseVM{
    @Published var product:ProductModel?
    @Published var addFavoriteGifts : ProductModel?
    
    private let persistenceController = PersistenceController.shared
    
    init(homeVM: HomeVM) {
        super.init()
        self.product = homeVM.selectedItemCard
    }
}

//MARK: - ADD TO CART FUNCTION
extension ViewProductVM {
    func processWithAddToCartItems(itemId: String, completion: @escaping CompletionHandler) {
        guard let product = self.product else {
            completion(false, "Product not available")
            return
        }
        
        persistenceController.addToCart(product: product)
        
        self.isAlertShown = true
        self.alertTitle = "Success"
        self.alertMessage = "Item added to cart successfully"
        
        completion(true, "Success Product Add to Cart")
    }
    
    func isProductInCart() -> Bool {
        guard let product = self.product else { return false }
        return persistenceController.isProductInCart(productId: product.id ?? 0)
    }
}
