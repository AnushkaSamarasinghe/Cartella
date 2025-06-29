//
//  HomeVM.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation
import Combine

class HomeVM: BaseVM {
    @Published var searchText: String = ""
    
    @Published var ProductCategories: [String] = []
    @Published var selectedProductCategory: String? = nil
    
    @Published var ProductCards: [ProductModel] = []
    @Published var selectedItemCard: ProductModel? = nil
    
    // MARK: - Combine Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Loading States
    @Published var isLoadingProducts: Bool = false
    
    deinit {
        cancellables.removeAll()
    }
}

// MARK: - Combine Network Operations
extension HomeVM {
    
    /// Fetch products using Combine
    func fetchProductsWithCombine(categoryId: String, query: String, completion: @escaping CompletionHandler) {
        isLoadingProducts = true
        startLoading()
        self.ProductCards.removeAll()
        NetworkService.shared.fetchProductsPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completionResult in
                    self?.isLoadingProducts = false
                    self?.stopLoading()
                    
                    if case .failure(let error) = completionResult {
                        print("[DEBUG] HomeVM: Failed to fetch products: \(error)")
                        self?.showErrorLogger(message: "Failed to fetch products: \(error.localizedDescription)")
                        self?.handleErrorAndShowAlert(error: error)
                        completion(false, "Failed to fetch products: \(error.localizedDescription)")
                    } else {
                        print("[DEBUG] HomeVM: fetchProductsWithCombine completed successfully")
                    }
                },
                receiveValue: { [weak self] products in
                    print("[DEBUG] HomeVM: Received products: \(products)")
                    var filteredProducts = products
                    // Filter by categoryId if not empty
                    if !categoryId.isEmpty {
                        filteredProducts = filteredProducts.filter { $0.category == categoryId }
                    }
                    // Filter by query if not empty
                    if !query.isEmpty {
                        filteredProducts = filteredProducts.filter { $0.title?.localizedCaseInsensitiveContains(query) == true }
                    }
                    self?.ProductCards = filteredProducts
                    self?.extractCategoriesFromProducts(products)
                    self?.showSuccessLogger(message: "Products fetched successfully!")
                    completion(true, "Products fetched successfully!")
                }
            )
            .store(in: &cancellables)
    }
    
    /// Extract unique categories from products
    private func extractCategoriesFromProducts(_ products: [ProductModel]) {
        let categories = products.compactMap { $0.category }
        let unique = Array(Set(categories)).sorted()
        self.ProductCategories = unique
    }
}
