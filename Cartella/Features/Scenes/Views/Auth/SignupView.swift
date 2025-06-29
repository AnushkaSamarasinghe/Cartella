//
//  SignupView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI
import SwiftData

struct SignupView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.navigationCoordinator) var coordinator: NavigationCoordinator
    @StateObject var vm = SignupVM()
    
    var body: some View {
        VStack {
            // MARK: - BODY
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Image(.logo)
                        .frame(width: 150, height: 150)
                        .cornerRadius(24)
                        .padding(.top, 24)
                    
                    // Email Input
                    EmailField(email: $vm.email)
                    
                    // Password Input
                    PasswordField(password: $vm.password)
                    
                    // Create Account Button
                    CommonButton(title: "Create Account", isFilled: true, isFullWidth: false) {
                        Task {
                            await processWithSignup()
                        }
                    }
                    .padding(.top, 16)
                    
                    // Already have an account
                    HStack(spacing:0) {
                        Text("Already have an account?")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundStyle(Color.secondary)
                            .padding(.trailing,5)
                        
                        // Login Button
                        Button {
                            coordinator.push(page: .login)
                        } label: {
                            Text("Login")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .foregroundStyle(.primary)
                        }
                    } //:HStack
                    .padding(.top, 300)
                } //:VStack
            } //:ScrollView
            .padding(.horizontal, 16)
            .onAppear() {
                vm.accAvailable = false
            }
            
            //MARK: - ALERTS
            .alert(
                vm.alertTitle,
                isPresented: $vm.isAlertShown,
                actions: {
                    if vm.accAvailable == true {
                        Button("Login", role: .destructive) {
                            // Add action to navigate to login
                            coordinator.push(page: .login)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                },
                message: {
                    Text(vm.alertMessage)
                }
            )
        } //:VStack
        .withBaseViewMod()
        .customNavigationBar(title: "SignUp", showsBackButton: true, popAction: { coordinator.pop() }) // MARK: NAVIGATION BAR
    }
}

#Preview {
    SignupView()
}

// process with SignUp function
extension SignupView {
    func processWithSignup() async {
        vm.startLoading()
        
        do {
            try await vm.processWithSignUp()
            
            // Navigate to create profile
            coordinator.push(page: .createProfile)
            
        } catch {
            // Handle specific error cases
            if vm.alertMessage.contains("Email already exists. Please login instead.") {
                vm.accAvailable = true
                // Show alert and navigate to login
                vm.showAlert(
                    title: "Account Already Exists",
                    message: "This email is already registered. Please login instead."
                )
            } else {
                vm.accAvailable = false
                vm.showAlert(
                    title: .Alert,
                    message: vm.alertMessage
                )
            }
            vm.isActive = true
        }
        vm.stopLoading()
    }
}
