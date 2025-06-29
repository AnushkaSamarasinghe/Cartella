//
//  CartVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import Foundation
import SwiftUI
import Alamofire
import Combine

class CartVM:BaseVM{
    var defaultCardNumber:String = ""
    
    @Published var cardNumber:String = ""
    @Published var expirationDate:String = ""
    @Published var cvv:String = ""

    @Published var showCreditCardSheet:Bool = false
    @Published var isPaymentViewActive:Bool = false
    
    @Published var cartItems : [CartItemWrapper] = []
    @Published var selectedCartItem:CartItemWrapper?

    @Published var cartItemCount = 0
    
    private let persistenceController = PersistenceController.shared
    
    override init() {
        super.init()
        loadCartItems()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func loadCartItems() {
        let coreDataItems = persistenceController.getCartItems()
        self.cartItems = coreDataItems.map { cartItem in
            CartItemWrapper(
                checkoutProduct: cartItem.toCheckoutProduct(),
                quantity: cartItem.itemQuantity
            )
        }
        self.cartItemCount = persistenceController.getCartItemCount()
    }
    
    func checkTextFields() ->Bool{
        if cardNumber.isEmpty{
            self.alertTitle = .Error
            self.alertMessage = "Enter Card Number"
            self.isAlertShown = true
            return true
        } else if expirationDate.isEmpty{
            self.alertTitle = .Error
            self.alertMessage = "Enter Expiration Date"
            self.isAlertShown = true
            return true
        }else if cvv.isEmpty{
            self.alertTitle = .Error
            self.alertMessage = "Enter cvv"
            self.isAlertShown = true
            return true
        }
     return false
    }
}

//MARK: - GET CART ITEMS FUNCTION
extension CartVM {
    func processWithCart(completion: @escaping CompletionHandler) {
        // Load cart items from Core Data
        loadCartItems()
        
        completion(true, "Success Items Getting..")
    }
}

//MARK: - REMOVE ITEM FUNCTION
extension CartVM {
    func processWithRemoveItem(productId: String, completion: @escaping CompletionHandler) {
        print("CartVM: Attempting to remove item with productId: \(productId)")
        
        guard let productIdInt = Int(productId) else {
            print("CartVM: Invalid product ID: \(productId)")
            completion(false, "Invalid product ID")
            return
        }
        
        print("CartVM: Converting to Int: \(productIdInt)")
        
        // Remove from Core Data
        persistenceController.removeFromCart(productId: productIdInt)
        
        // Reload cart items
        loadCartItems()
        
        // Ensure UI updates on main thread
        DispatchQueue.main.async {
            completion(true, "Success Remove Item..")
        }
    }
}

//MARK: - PAY FOR ITEM FUNCTION
extension CartVM {
    func processWithPayForItem(productId: String, completion: @escaping CompletionHandler) {
        guard let productIdInt = Int(productId) else {
            completion(false, "Invalid product ID")
            return
        }
        
        persistenceController.removeFromCart(productId: productIdInt)
        
        // Reload cart items
        loadCartItems()
        
        completion(true, "Success Paid for Item..")
    }
}

//MARK: - ADDITIONAL CART OPERATIONS
extension CartVM {
    func updateItemQuantity(productId: String, quantity: Int, completion: @escaping CompletionHandler) {
        guard let productIdInt = Int(productId) else {
            completion(false, "Invalid product ID")
            return
        }
        
        persistenceController.updateCartItemQuantity(productId: productIdInt, quantity: quantity)
        
        // Reload cart items
        loadCartItems()
        
        // Ensure UI updates on main thread
        DispatchQueue.main.async {
            completion(true, "Quantity updated successfully")
        }
    }
    
    func clearCart(completion: @escaping CompletionHandler) {
        persistenceController.clearCart()
        loadCartItems()
        completion(true, "Cart cleared successfully")
    }
    
    func getCartTotal() -> Double {
        return persistenceController.getCartTotal()
    }
}
