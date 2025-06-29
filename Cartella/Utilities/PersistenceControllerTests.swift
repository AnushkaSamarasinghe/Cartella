//
//  PersistenceControllerTests.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import Foundation
import XCTest
@testable import Cartella

class PersistenceControllerTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController.shared
    }
    
    override func tearDown() {
        // Clear cart after each test
        persistenceController.clearCart()
        super.tearDown()
    }
    
    func testAddToCart() {
        // Given
        let product = ProductModel(
            id: 1,
            title: "Test Product",
            price: 99.99,
            description: "Test Description",
            category: Category(id: "1", category: "Test Category"),
            image: "test-image.jpg",
            rating: Rating(rate: 4.5, count: 100),
            isFavourite: false
        )
        
        // When
        persistenceController.addToCart(product: product)
        
        // Then
        let cartItems = persistenceController.getCartItems()
        XCTAssertEqual(cartItems.count, 1)
        XCTAssertEqual(persistenceController.getCartItemCount(), 1)
        XCTAssertEqual(persistenceController.getCartTotal(), 99.99)
        XCTAssertTrue(persistenceController.isProductInCart(productId: 1))
    }
    
    func testAddDuplicateProduct() {
        // Given
        let product = ProductModel(
            id: 1,
            title: "Test Product",
            price: 99.99,
            description: "Test Description",
            category: Category(id: "1", category: "Test Category"),
            image: "test-image.jpg",
            rating: Rating(rate: 4.5, count: 100),
            isFavourite: false
        )
        
        // When
        persistenceController.addToCart(product: product)
        persistenceController.addToCart(product: product)
        
        // Then
        let cartItems = persistenceController.getCartItems()
        XCTAssertEqual(cartItems.count, 1) // Should still be 1 item
        XCTAssertEqual(persistenceController.getCartItemCount(), 2) // But quantity should be 2
        XCTAssertEqual(persistenceController.getCartTotal(), 199.98) // Price * 2
    }
    
    func testRemoveFromCart() {
        // Given
        let product = ProductModel(
            id: 1,
            title: "Test Product",
            price: 99.99,
            description: "Test Description",
            category: Category(id: "1", category: "Test Category"),
            image: "test-image.jpg",
            rating: Rating(rate: 4.5, count: 100),
            isFavourite: false
        )
        persistenceController.addToCart(product: product)
        
        // When
        persistenceController.removeFromCart(productId: 1)
        
        // Then
        let cartItems = persistenceController.getCartItems()
        XCTAssertEqual(cartItems.count, 0)
        XCTAssertEqual(persistenceController.getCartItemCount(), 0)
        XCTAssertEqual(persistenceController.getCartTotal(), 0.0)
        XCTAssertFalse(persistenceController.isProductInCart(productId: 1))
    }
    
    func testUpdateQuantity() {
        // Given
        let product = ProductModel(
            id: 1,
            title: "Test Product",
            price: 99.99,
            description: "Test Description",
            category: Category(id: "1", category: "Test Category"),
            image: "test-image.jpg",
            rating: Rating(rate: 4.5, count: 100),
            isFavourite: false
        )
        persistenceController.addToCart(product: product)
        
        // When
        persistenceController.updateCartItemQuantity(productId: 1, quantity: 3)
        
        // Then
        XCTAssertEqual(persistenceController.getCartItemCount(), 3)
        XCTAssertEqual(persistenceController.getCartTotal(), 299.97)
    }
    
    func testClearCart() {
        // Given
        let product1 = ProductModel(
            id: 1,
            title: "Test Product 1",
            price: 99.99,
            description: "Test Description 1",
            category: Category(id: "1", category: "Test Category"),
            image: "test-image-1.jpg",
            rating: Rating(rate: 4.5, count: 100),
            isFavourite: false
        )
        
        let product2 = ProductModel(
            id: 2,
            title: "Test Product 2",
            price: 149.99,
            description: "Test Description 2",
            category: Category(id: "2", category: "Test Category 2"),
            image: "test-image-2.jpg",
            rating: Rating(rate: 4.0, count: 50),
            isFavourite: false
        )
        
        persistenceController.addToCart(product: product1)
        persistenceController.addToCart(product: product2)
        
        // When
        persistenceController.clearCart()
        
        // Then
        let cartItems = persistenceController.getCartItems()
        XCTAssertEqual(cartItems.count, 0)
        XCTAssertEqual(persistenceController.getCartItemCount(), 0)
        XCTAssertEqual(persistenceController.getCartTotal(), 0.0)
    }
    
    func testUserManagement() {
        // Given
        let user = UserModel(
            email: "test@example.com",
            password: "password123",
            name: "Test User",
            isProfileCompleted: true,
            isActive: true
        )
        
        // When
        let savedUser = persistenceController.saveUserData(with: user)
        
        // Then
        XCTAssertNotNil(savedUser)
        XCTAssertEqual(savedUser?.email, "test@example.com")
        XCTAssertEqual(savedUser?.name, "Test User")
        XCTAssertTrue(savedUser?.isProfileCompleted ?? false)
        XCTAssertTrue(savedUser?.isActive ?? false)
        
        // Test loading user
        let loadedUser = persistenceController.loadUserData()
        XCTAssertNotNil(loadedUser)
        XCTAssertEqual(loadedUser?.email, "test@example.com")
        
        // Test user exists
        XCTAssertTrue(persistenceController.userExists())
        
        // Clean up
        persistenceController.deleteUserData()
    }
    
    func testProductManagement() {
        // Given
        let product = ProductModel(
            id: 1,
            title: "Test Product",
            price: 99.99,
            description: "Test Description",
            category: Category(id: "1", category: "Test Category"),
            image: "test-image.jpg",
            rating: Rating(rate: 4.5, count: 100),
            isFavourite: false
        )
        
        // When
        let savedProduct = persistenceController.saveProduct(product)
        
        // Then
        XCTAssertNotNil(savedProduct)
        XCTAssertEqual(savedProduct?.id, 1)
        XCTAssertEqual(savedProduct?.title, "Test Product")
        XCTAssertEqual(savedProduct?.price, 99.99)
        
        // Test loading product
        let loadedProduct = persistenceController.loadProduct(by: 1)
        XCTAssertNotNil(loadedProduct)
        XCTAssertEqual(loadedProduct?.title, "Test Product")
        
        // Test update favorite status
        persistenceController.updateProductFavouriteStatus(productId: 1, isFavourite: true)
        let updatedProduct = persistenceController.loadProduct(by: 1)
        XCTAssertTrue(updatedProduct?.isFavourite ?? false)
        
        // Clean up
        persistenceController.deleteProduct(productId: 1)
    }
    
    func testPaymentCardManagement() {
        // Given
        let cardNumber = "4111111111111111"
        let cardType = "Visa"
        let expiryDate = "12/25"
        let cvv = "123"
        let cardholderName = "Test User"
        
        // When
        let savedCard = persistenceController.savePaymentCard(
            cardNumber: cardNumber,
            cardType: cardType,
            expiryDate: expiryDate,
            cvv: cvv,
            cardholderName: cardholderName
        )
        
        // Then
        XCTAssertNotNil(savedCard)
        XCTAssertEqual(savedCard?.cardNumber, cardNumber)
        XCTAssertEqual(savedCard?.cardType, cardType)
        XCTAssertEqual(savedCard?.cardholderName, cardholderName)
        
        // Test loading all cards
        let allCards = persistenceController.loadAllPaymentCards()
        XCTAssertEqual(allCards.count, 1)
        
        // Test setting default card
        if let cardId = savedCard?.id {
            persistenceController.setDefaultPaymentCard(cardId: cardId)
            let defaultCard = persistenceController.loadDefaultPaymentCard()
            XCTAssertNotNil(defaultCard)
            XCTAssertTrue(defaultCard?.isDefault ?? false)
        }
        
        // Clean up
        if let cardId = savedCard?.id {
            persistenceController.deletePaymentCard(cardId: cardId)
        }
    }
} 