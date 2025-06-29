//
//  LoginView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.navigationCoordinator) var coordinator: NavigationCoordinator
    @StateObject var vm = LoginVM()
    
    var body: some View {
        VStack {
            // MARK: - BODY
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Image(.logo)
                        .frame(width: 130, height: 130)
                        .cornerRadius(24)
                        .padding(.top, 24)
                    
                    Text("Add your details to login")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .padding(.top, 32)
                    
                    // Email Input
                    EmailField(email: $vm.email)
                    
                    // Password Input
                    PasswordField(password: $vm.password)
                    
                    // Verify Account Button
                    CommonButton(title: "Sign In", isFilled: true, isFullWidth: false) {
                        Task {
                            await processWithSignIn()
                        }
                    }
                    .padding(.top, 8)
                    
                    // Already have an account
                    HStack(spacing:0) {
                        Text("Don’t have an account?")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundStyle(Color.secondary)
                            .padding(.trailing,5)
                        
                        // SignUp Button
                        Button {
                            coordinator.push(page: .signup)
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .foregroundStyle(.primary)
                        }
                    } //:HStack
                    .padding(.top, 260)
                } //:VStack
            } //:ScrollView
            .padding(.horizontal, 16)
            .onAppear {
                vm.accNotAvailable = false
            }
            
            //MARK: - ALERTS
            .alert(
                vm.alertTitle,
                isPresented: $vm.isAlertShown,
                actions: {
                    if vm.accNotAvailable == true {
                        Button("Sign Up", role: .destructive) {
                            // Add action to navigate to signup
                            coordinator.push(page: .signup)
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
        .customNavigationBar(title: "Login", showsBackButton: true, popAction: { coordinator.pop() }) // MARK: NAVIGATION BAR
        
        
    }
}

#Preview {
    LoginView()
}

// process with Login function
extension LoginView {
    func processWithSignIn() async {
        vm.startLoading()
        do {
            try await vm.processWithSignIn()
            
            // Navigate based on profile completion status
            if vm.isActive {
                // Profile is completed, navigate to home
                coordinator.push(page: .home)
            } else {
                // Profile is not completed, navigate to create profile
                coordinator.push(page: .createProfile)
            }
            
        } catch {
            // Handle specific error cases
            if vm.alertMessage.contains("Email not found") {
                vm.accNotAvailable = true
                // Show alert and navigate to signup
                vm.showAlert(
                    title: "Account Not Found",
                    message: "This email is not registered. Would you like to create a new account?"
                )
            } else if vm.alertTitle == "Valid Email Required" {
                vm.accNotAvailable = false
                vm.showAlert(
                    title: "Valid Email Required",
                    message: "Please enter a valid email address."
                )
            } else if vm.alertMessage == "Password must contain at least one letter & one number" {
                vm.accNotAvailable = false
                vm.showAlert(
                    title: "Valid Password Required",
                    message: "Please enter a valid password."
                )
            } else {
                vm.accNotAvailable = false
                vm.alertTitle = .Alert
                vm.handleErrorAndShowAlert(error: error)
            }
        }
        vm.stopLoading()
    }
}

