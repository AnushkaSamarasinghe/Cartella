//
//  NavigationCoordinator.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

enum NavigationCoordinatorDestination: Hashable, View {
    case initial
    case login
    case signup
    case createProfile
    
    case tabBar
    case home
    case viewProduct(HomeVM)
    case cart
    case viewProfile
    
    var body: some View {
        switch self {
        case .initial:
            InitialView()
        case .login:
            LoginView()
        case .signup:
            SignupView()
        case .createProfile:
            CreateProfileView()
            
        case .tabBar:
            UserTabsView(vm: UserTabsVM(selectedTab: .home))
        case .home:
            HomeView()
        case .viewProduct(let home):
            ViewProductView(vm: ViewProductVM(homeVM: home))
        case .cart:
            CartView()
        case .viewProfile:
            ViewProfileView()
        }
    }
    
    // MARK: - Initial Destination Logic
    static func initialDestination() -> NavigationCoordinatorDestination {
        if AppManager.IsAuthenticated() {
            if AppManager.IsProfileCompleteCompleted() {
                return .tabBar
            }
            return .createProfile
        }
        return .initial
    }
}

// MARK: - App Manager
struct AppManager {
    static func IsAuthenticated() -> Bool {
        return PersistenceController.shared.loadUserData() != nil
    }
    
    static func IsProfileCompleteCompleted() -> Bool {
        return PersistenceController.shared.loadUserData()?.isActive != nil
    }
}

enum NavigationCoordinatorSheet: String, Identifiable, View {
    var id: String { self.rawValue }
    
    case sheet1
    
    var body: some View {
        switch self {
        case .sheet1:
            EmptyView()
        }
    }
}

enum NavigationCoordinatorCover: String, Identifiable, View {
    var id: String { self.rawValue }
    
    case cover1
    
    var body: some View {
        switch self {
        case .cover1:
            EmptyView()
        }
    }
}

@Observable
class NavigationCoordinator {
    var pathInNavigation: NavigationPath = NavigationPath()
    var sheet: NavigationCoordinatorSheet?
    var cover: NavigationCoordinatorCover?
    private var data: Any?
    
    static let shared = NavigationCoordinator()
    init() {}
    
    func push(page: NavigationCoordinatorDestination, _ data: Any? = nil) {
        pathInNavigation.append(page)
        self.data = data
    }
    
    func pop(_ last: Int = 1, _ data: Any? = nil) {
        pathInNavigation.removeLast(last)
        self.data = data
    }
    
    func popToRoot() {
        pathInNavigation.removeLast(pathInNavigation.count)
    }
    
    func present(sheet: NavigationCoordinatorSheet, _ data: Any? = nil) {
        self.sheet = sheet
        self.data = data
    }
    
    func present(cover: NavigationCoordinatorCover, _ data: Any? = nil) {
        self.cover = cover
        self.data = data
    }
    
    func popSheet() {
        self.sheet = nil
    }
    
    func popCover() {
        self.cover = nil
    }
}

extension EnvironmentValues {
    @Entry var navigationCoordinator = NavigationCoordinator()
}

struct NavigationCoordinatorView: View {
    @State private var coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.pathInNavigation) {
            NavigationCoordinatorDestination.initialDestination()
                .navigationDestination(for: NavigationCoordinatorDestination.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.cover) { $0 }
                .navigationBarBackButtonHidden(true)
        }
        .environment(\.navigationCoordinator, coordinator)
    }
}
