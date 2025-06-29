//
//  NetworkService.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import Foundation
import Combine

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError(String)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingFailed:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        case .noData:
            return "No data received"
        }
    }
}

// MARK: - API Response Models
struct APIErrorResponse: Codable {
    let status: String?
    let code: String?
    let message: String?
}

// MARK: - Network Service
class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "https://fakestoreapi.com"
    private let endpoint = "/products"
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Generic Request Method
    private func request<T: Codable>(_ endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add parameters for POST/PUT requests
        if let parameters = parameters, method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        // Add query parameters for GET requests
        if let parameters = parameters, method == .get {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            if let finalURL = components?.url {
                request.url = finalURL
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // Check for HTTP errors
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to decode error response
                if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    throw NetworkError.serverError(errorResponse.message ?? "Server error")
                }
                throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
            }
            
            // Debug: Print raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[DEBUG] NetworkService: Raw JSON response for \(endpoint): \n\(jsonString)")
            }
            
            // Decode response
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


extension NetworkService {
    private func _fetchProducts() async throws -> [ProductModel] {
        let products: [ProductModel] = try await request(endpoint)
        return products
    }
    
    func fetchProducts() async throws -> [ProductModel] {
        return try await _fetchProducts()
    }

    // MARK: - Combine Publishers
    func fetchProductsPublisher() -> AnyPublisher<[ProductModel], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            Task {
                do {
                    let products = try await self._fetchProducts()
                    promise(.success(products))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
