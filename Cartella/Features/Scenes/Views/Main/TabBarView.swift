//
//  TabBarView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import SwiftUI

struct UserTabsView: View {
    // MARK: - PROPERITY
    @StateObject var vm: UserTabsVM
    @State private var isKeyboardVisible = false
    
    var body: some View {
        // MARK: - BODY
        ZStack(alignment: .center) {
            VStack {
                switch vm.selectedTab {
                case .home: HomeView()
                case .cart: CartView()
                case .user: ViewProfileView()
                }
            } //: VStack
            .overlay(
                // Custom Tab Bar..
                UserTabBar()
                    .opacity(isKeyboardVisible ? 0 : 1)
                , alignment: .bottom
            )
            .onAppear {
                observeKeyboardNotifications()
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
            }
        } //: ZStack
        .environmentObject(vm)
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
            isKeyboardVisible = true
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            isKeyboardVisible = false
        }
    }
}

class UserTabsVM: ObservableObject {
    @Published var selectedTab: UserTabType = .home
    @Published var selectedTabString: String = ""
    
    init(selectedTab: UserTabType?) {
        self.selectedTab = selectedTab ?? .home
        selectedTabString = "Home"
    }
}

enum UserTabType {
    case home, cart, user
}

private struct UserTabBar: View {
    // MARK: - PROPERITY
    @EnvironmentObject private var vm: UserTabsVM
    
    var body: some View {
        // MARK: - BODY
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .opacity(1)
                .blur(radius: 10)
                .ignoresSafeArea()
                .frame(height: 120)
            Capsule()
                .fill(Color.mainTitle)
                .frame(height: 80)
            
            // Tab Buttons...
            HStack {
                Spacer()
                UserTabItem(
                    item: .home,
                    image: "house.fill",
                    title: "Home"
                )
                .onTapGesture {
                    vm.selectedTab = .home
                    vm.selectedTabString = "Home"
                }
                
                Spacer()
                
                UserTabItem(
                    item: .cart,
                    image: "cart.fill",
                    title: "My Cart"
                )
                .onTapGesture {
                    vm.selectedTab = .cart
                    vm.selectedTabString = "My Cart"
                }
                Spacer()
                
                UserTabItem(
                    item: .user,
                    image: "person.crop.circle",
                    title: "User"
                )
                .onTapGesture {
                    vm.selectedTab = .user
                    vm.selectedTabString = "User"
                }
                Spacer()
            } //:HStack
            .padding(.vertical, 15)
            .offset(CGSize(width: 0.0, height: 0))
        } //:ZStack
        .padding(.horizontal, 16)
        .offset(y: 30)
    }
}

private struct UserTabItem: View {
    // MARK: - PROPERTIES
    @EnvironmentObject private var vm: UserTabsVM
    @State var item: UserTabType
    var image: String
    var title: String
    
    var body: some View {
        // MARK: - BODY
        VStack {
            Image(systemName: image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(maxWidth: .infinity)
            
            Text(title)
                .font(.system(size: 10, weight: .medium, design: .default))
        } //:VStack
        .foregroundColor(vm.selectedTab == item ? .white : .white.opacity(0.5))
    }
}

#Preview {
    UserTabsView(vm: UserTabsVM(selectedTab: .home))
}
