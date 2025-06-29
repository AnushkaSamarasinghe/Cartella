//
//  Persistence.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import CoreData
import Foundation
import SwiftUI

// MARK: - Persistence Controller
class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cartella")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    var container: NSPersistentContainer {
        return persistentContainer
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // MARK: - Context Management
    func saveContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func saveBackgroundContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving background context: \(error)")
            }
        }
    }
}

// MARK: - User Management
extension PersistenceController {
    
    // MARK: - User CRUD Operations
    
    /// Save user data to Core Data
    @discardableResult
    func saveUserData(with user: UserModel) -> LocalUserData? {
        let context = mainContext
        
        // Check if user already exists
        if let existingUser = loadUserData() {
            // Update existing user
            existingUser.email = user.email
            existingUser.name = user.name
            existingUser.password = user.password
            existingUser.isProfileCompleted = user.isProfileCompleted ?? false
            existingUser.isActive = user.isActive ?? false
            existingUser.updatedAt = Date()
        } else {
            // Create new user
        let entity = LocalUserData.entity()
        let userData = LocalUserData(entity: entity, insertInto: context)
            userData.id = UUID().uuidString
        userData.email = user.email
            userData.name = user.name
            userData.password = user.password
            userData.isProfileCompleted = user.isProfileCompleted ?? false
            userData.isActive = user.isActive ?? false
            userData.createdAt = Date()
            userData.updatedAt = Date()
        }
        
        saveContext()
        return loadUserData()
    }
    
    /// Load user data from Core Data
    func loadUserData() -> LocalUserData? {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalUserData> = LocalUserData.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest).first
            return result
        } catch {
            print("Error loading user data: \(error)")
            return nil
        }
    }
    
    /// Load user by email
    func loadUserByEmail(email: String) -> LocalUserData? {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalUserData> = LocalUserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest).first
            return result
        } catch {
            print("Error loading user by email: \(error)")
            return nil
        }
    }
    
    /// Check if user exists by email
    func userExistsByEmail(email: String) -> Bool {
        return loadUserByEmail(email: email) != nil
    }
    
    /// Authenticate user with email and password
    func authenticateUser(email: String, password: String) -> LocalUserData? {
        guard let user = loadUserByEmail(email: email) else {
            return nil
        }
        
        // Check if password matches
        if user.password == password {
            // Update user as active
            user.isActive = true
            user.updatedAt = Date()
            saveContext()
            return user
        }
        
        return nil
    }
    
    /// Create new user account
    @discardableResult
    func createUserAccount(email: String, password: String) -> LocalUserData? {
        // Check if user already exists
        if userExistsByEmail(email: email) {
            return nil
        }
        
        let user = UserModel(
            email: email,
            password: password,
            name: nil,
            isProfileCompleted: false,
            isActive: false,
            paymentCards: nil,
            checkoutProducts: nil
        )
        
        return saveUserData(with: user)
    }
    
    /// Complete user profile
    @discardableResult
    func completeUserProfile(email: String, name: String) -> LocalUserData? {
        guard let user = loadUserByEmail(email: email) else {
            return nil
        }
        
        user.name = name
        user.isProfileCompleted = true
        user.isActive = true
        user.updatedAt = Date()
        
        saveContext()
        return user
    }
    
    /// Update user data
    func updateUserData(with user: UserModel) {
        guard let userData = loadUserData() else { return }
        
        userData.email = user.email
        userData.name = user.name
        userData.password = user.password
        userData.isProfileCompleted = user.isProfileCompleted ?? false
        userData.isActive = user.isActive ?? false
        userData.updatedAt = Date()
        
        saveContext()
    }
    
    /// Update user profile completion status
    func updateProfileCompleteStatus(_ status: Bool) {
        guard let userData = loadUserData() else { return }
        
        userData.isProfileCompleted = status
        userData.updatedAt = Date()
        
        saveContext()
    }
    
    /// Update user active status
    func updateUserActiveStatus(_ status: Bool) {
        guard let userData = loadUserData() else { return }
        
        userData.isActive = status
        userData.updatedAt = Date()
        
        saveContext()
    }
    
    /// Logout user
    func logoutUser() {
        guard let userData = loadUserData() else { return }
        
        userData.isActive = false
        userData.isProfileCompleted = false
        userData.updatedAt = Date()
        
        saveContext()
    }
    
    /// Delete user data
    func deleteUserData() {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalUserData> = LocalUserData.fetchRequest()
        
        do {
            let userData = try context.fetch(fetchRequest)
            userData.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting user data: \(error)")
        }
    }
    
    /// Check if user exists
    func userExists() -> Bool {
        return loadUserData() != nil
    }
    
    /// Get current active user
    func getCurrentUser() -> LocalUserData? {
        guard let user = loadUserData() else { return nil }
        return user.isActive ? user : nil
    }
}

// MARK: - Product Management
extension PersistenceController {
    
    // MARK: - Product CRUD Operations
    
    /// Save product to Core Data
    @discardableResult
    func saveProduct(_ product: ProductModel) -> LocalProductData? {
        let context = mainContext
        
        // Check if product already exists
        if let existingProduct = loadProduct(by: product.id ?? 0) {
            // Update existing product
            existingProduct.title = product.title
            existingProduct.price = product.price ?? 0.0
            existingProduct.productDescription = product.description
            existingProduct.category = product.category
            existingProduct.image = product.image
            existingProduct.rating = product.rating?.rate ?? 0.0
            existingProduct.ratingCount = Int32(product.rating?.count ?? 0)
            existingProduct.isFavourite = product.isFavourite ?? false
            existingProduct.updatedAt = Date()
        } else {
            // Create new product
            let entity = LocalProductData.entity()
            let productData = LocalProductData(entity: entity, insertInto: context)
            productData.id = Int32(product.id ?? 0)
            productData.title = product.title
            productData.price = product.price ?? 0.0
            productData.productDescription = product.description
            productData.category = product.category
            productData.image = product.image
            productData.rating = product.rating?.rate ?? 0.0
            productData.ratingCount = Int32(product.rating?.count ?? 0)
            productData.isFavourite = product.isFavourite ?? false
            productData.createdAt = Date()
            productData.updatedAt = Date()
        }
        
        saveContext()
        return loadProduct(by: product.id ?? 0)
    }
    
    /// Load product by ID
    func loadProduct(by id: Int) -> LocalProductData? {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalProductData> = LocalProductData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest).first
            return result
        } catch {
            print("Error loading product: \(error)")
            return nil
        }
    }
    
    /// Load all products
    func loadAllProducts() -> [LocalProductData] {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalProductData> = LocalProductData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error loading all products: \(error)")
            return []
        }
    }
    
    /// Load favourite products
    func loadFavouriteProducts() -> [LocalProductData] {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalProductData> = LocalProductData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavourite == true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error loading favourite products: \(error)")
            return []
        }
    }
    
    /// Update product favourite status
    func updateProductFavouriteStatus(productId: Int, isFavourite: Bool) {
        guard let product = loadProduct(by: productId) else { return }
        
        product.isFavourite = isFavourite
        product.updatedAt = Date()
        
        saveContext()
    }
    
    /// Delete product
    func deleteProduct(productId: Int) {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalProductData> = LocalProductData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting product: \(error)")
        }
    }
    
    /// Clear all products
    func clearAllProducts() {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalProductData> = LocalProductData.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error clearing all products: \(error)")
        }
    }
}

// MARK: - Cart Management
extension PersistenceController {
    
    // MARK: - Cart CRUD Operations
    
    /// Load or create the main cart
    func loadCart() -> Cart? {
        let context = mainContext
        
        // Try to fetch existing cart
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingCart = results.first {
                return existingCart
            } else {
                // Create new cart if none exists
                return createNewCart()
            }
        } catch {
            print("Error loading cart: \(error)")
            return nil
        }
    }
    
    /// Create a new cart
    private func createNewCart() -> Cart? {
        let context = mainContext
        let newCart = Cart(context: context)
        newCart.id = UUID().uuidString
        newCart.createdAt = Date()
        newCart.updatedAt = Date()
            
            do {
                try context.save()
            return newCart
        } catch {
            print("Error creating cart: \(error)")
            return nil
        }
    }
    
    /// Get cart items
    func getCartItems() -> [CartItem] {
        let context = mainContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addedAt", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error getting cart items: \(error)")
            return []
        }
    }
    
    /// Add product to cart
    func addToCart(product: ProductModel) {
        let context = mainContext
        let cart = loadCart()
        
        // Check if product already exists in cart
        if let existingItem = findCartItem(for: product) {
            // Update quantity
            existingItem.quantity += 1
            existingItem.addedAt = Date()
        } else {
            // Create new cart item
            let newItem = CartItem(context: context)
            newItem.id = UUID().uuidString
            newItem.productId = Int32(product.id ?? 0)
            newItem.title = product.title
            newItem.price = product.price ?? 0.0
            newItem.productDescription = product.description
            newItem.category = product.category
            newItem.image = product.image
            newItem.rating = product.rating?.rate ?? 0.0
            newItem.ratingCount = Int32(product.rating?.count ?? 0)
            newItem.quantity = 1
            newItem.addedAt = Date()
            newItem.cart = cart
        }
        
        // Update cart timestamp
        cart?.updatedAt = Date()
        
        saveContext()
    }
    
    /// Remove product from cart
    func removeFromCart(productId: Int) {
        let context = mainContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
            
            // Update cart timestamp
            if let cart = loadCart() {
                cart.updatedAt = Date()
            }
            
            saveContext()
        } catch {
            print("Error removing item from cart: \(error)")
        }
    }
    
    /// Update cart item quantity
    func updateCartItemQuantity(productId: Int, quantity: Int) {
        let context = mainContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let item = results.first {
                if quantity <= 0 {
                    context.delete(item)
                } else {
                    item.quantity = Int32(quantity)
                }
                
                // Update cart timestamp
                if let cart = loadCart() {
                    cart.updatedAt = Date()
                }
                
                saveContext()
            }
        } catch {
            print("Error updating quantity: \(error)")
        }
    }
    
    /// Clear all items from cart
    func clearCart() {
        let context = mainContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
            
            // Update cart timestamp
            if let cart = loadCart() {
                cart.updatedAt = Date()
            }
            
            saveContext()
        } catch {
            print("Error clearing cart: \(error)")
        }
    }
    
    /// Get cart item count
    func getCartItemCount() -> Int {
        let cartItems = getCartItems()
        return cartItems.reduce(0) { $0 + Int($1.quantity) }
    }
    
    /// Get cart total price
    func getCartTotal() -> Double {
        let cartItems = getCartItems()
        return cartItems.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    /// Check if product is in cart
    func isProductInCart(productId: Int) -> Bool {
        return findCartItem(for: ProductModel(id: productId, title: nil, price: nil, description: nil, category: nil, image: nil, rating: nil, isFavourite: nil)) != nil
    }
    
    /// Find existing cart item for a product
    private func findCartItem(for product: ProductModel) -> CartItem? {
        guard let productId = product.id else { return nil }
        
        let context = mainContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error finding cart item: \(error)")
            return nil
        }
    }
}

// MARK: - Payment Card Management
extension PersistenceController {
    
    // MARK: - Payment Card CRUD Operations
    
    /// Save payment card
    @discardableResult
    func savePaymentCard(cardNumber: String, cardType: String, expiryDate: String, cvv: String, cardholderName: String) -> LocalPaymentCardData? {
        let context = mainContext
        
        let entity = LocalPaymentCardData.entity()
        let cardData = LocalPaymentCardData(entity: entity, insertInto: context)
        cardData.id = UUID().uuidString
        cardData.cardNumber = cardNumber
        cardData.cardType = cardType
        cardData.expiryDate = expiryDate
        cardData.cvv = cvv
        cardData.cardholderName = cardholderName
        cardData.isDefault = false
        cardData.createdAt = Date()
        cardData.updatedAt = Date()
        
        saveContext()
        return cardData
    }
    
    /// Load all payment cards
    func loadAllPaymentCards() -> [LocalPaymentCardData] {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalPaymentCardData> = LocalPaymentCardData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error loading payment cards: \(error)")
            return []
        }
    }
    
    /// Load default payment card
    func loadDefaultPaymentCard() -> LocalPaymentCardData? {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalPaymentCardData> = LocalPaymentCardData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDefault == true")
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest).first
            return result
        } catch {
            print("Error loading default payment card: \(error)")
            return nil
        }
    }
    
    /// Update payment card
    func updatePaymentCard(cardId: String, cardNumber: String, cardType: String, expiryDate: String, cvv: String, cardholderName: String) {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalPaymentCardData> = LocalPaymentCardData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", cardId)
        
        do {
            if let card = try context.fetch(fetchRequest).first {
                card.cardNumber = cardNumber
                card.cardType = cardType
                card.expiryDate = expiryDate
                card.cvv = cvv
                card.cardholderName = cardholderName
                card.updatedAt = Date()
                saveContext()
            }
        } catch {
            print("Error updating payment card: \(error)")
        }
    }
    
    /// Set default payment card
    func setDefaultPaymentCard(cardId: String) {
        let context = mainContext
        
        // First, unset all default cards
        let fetchRequest: NSFetchRequest<LocalPaymentCardData> = LocalPaymentCardData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDefault == true")
        
        do {
            let defaultCards = try context.fetch(fetchRequest)
            for card in defaultCards {
                card.isDefault = false
            }
            
            // Set the new default card
            let specificFetchRequest: NSFetchRequest<LocalPaymentCardData> = LocalPaymentCardData.fetchRequest()
            specificFetchRequest.predicate = NSPredicate(format: "id == %@", cardId)
            
            if let card = try context.fetch(specificFetchRequest).first {
                card.isDefault = true
                card.updatedAt = Date()
            }
            
            saveContext()
        } catch {
            print("Error setting default payment card: \(error)")
        }
    }
    
    /// Delete payment card
    func deletePaymentCard(cardId: String) {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalPaymentCardData> = LocalPaymentCardData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", cardId)
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting payment card: \(error)")
        }
    }
    
    /// Clear all payment cards
    func clearAllPaymentCards() {
        let context = mainContext
        let fetchRequest: NSFetchRequest<LocalPaymentCardData> = LocalPaymentCardData.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error clearing all payment cards: \(error)")
        }
    }
}

// MARK: - Extensions for Core Data Models

extension CartItem {
    /// Convert CartItem to ProductModel for compatibility
    func toProductModel() -> ProductModel {
        let rating = Rating(rate: self.rating, count: Int(self.ratingCount))
        return ProductModel(
            id: Int(self.productId),
            title: self.title,
            price: self.price,
            description: self.productDescription,
            category: self.category,
            image: self.image,
            rating: rating,
            isFavourite: false
        )
    }
    
    /// Convert CartItem to CheckoutProductModel for compatibility
    func toCheckoutProduct() -> CheckoutProductModel {
        return CheckoutProductModel(
            id: self.id,
            productDetails: self.toProductModel(),
            status: 1 // Active status
        )
    }
    
    /// Get quantity for this cart item
    var itemQuantity: Int {
        return Int(self.quantity)
    }
}

extension LocalProductData {
    /// Convert LocalProductData to ProductModel for compatibility
    func toProductModel() -> ProductModel {
        let rating = Rating(rate: self.rating, count: Int(self.ratingCount))
        return ProductModel(
            id: Int(self.id),
            title: self.title,
            price: self.price,
            description: self.productDescription,
            category: self.category,
            image: self.image,
            rating: rating,
            isFavourite: self.isFavourite
        )
    }
}

extension LocalPaymentCardData {
    /// Convert LocalPaymentCardData to PaymentCardModel for compatibility
    func toPaymentCardModel() -> PaymentCardModel {
        let cardType = CardType(rawValue: self.cardType ?? "") ?? .unknown
        
        return PaymentCardModel(
            id: self.id,
            cardNumber: self.cardNumber,
            cardType: cardType,
            expiryDate: self.expiryDate,
            cvv: self.cvv,
            isDefault: self.isDefault
        )
    }
}

extension Date {
    func ISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
