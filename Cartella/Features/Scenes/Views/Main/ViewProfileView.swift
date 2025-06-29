//
//  ViewProfileView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct ViewProfileView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.navigationCoordinator) var coordinator: NavigationCoordinator
    @StateObject var vm = ViewProfileVM()
    
    var body: some View {
        VStack {
            // MARK: - BODY
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    VStack(spacing: 16) {
                        // Email
                        CommonTextField(headerText:"Email", placeHolderText:"Email", textField:.constant(vm.email))
                        
                        //Name
                        CommonTextField(headerText:"Name", placeHolderText:"Name", textField:.constant(vm.name))
                    } //:VStack
                    .padding(.top, 24)
                    
                    // Delete Account Button
                    CommonButton(title: "Delete Account", isFilled: true, isFullWidth: false, buttonColor: .red) {
                        vm.showDeleteAlert = true
                        vm.showAlert(
                            title: "Delete Account",
                            message: "Do you want to delete your account?"
                        )
                    }
                    .padding(.top, 50)
                } //:VStack
                .padding(.bottom, 78)
            } //:ScrollView
            .padding(.horizontal, 16)
            // Alert
            .alert(
                vm.alertTitle,
                isPresented: $vm.isAlertShown,
                actions: {
                    if vm.showDeleteAlert {
                    Button("Delete Account", role: .destructive) {
                            Task { await deleteAccount() }
                            coordinator.popToRoot()
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
        .navigationTitle("View Profile")
        .navigationBarTitleDisplayMode(.inline)

        .task {
            vm.loadCurrentUser()
            await processWithProfile()
        }
    }
}

#Preview {
    ViewProfileView()
}

extension ViewProfileView {
    func processWithProfile() async {
        vm.stopLoading()
    }
    
    func deleteAccount() async {
        vm.startLoading()
        do {
            try await vm.deleteAccount()
        } catch {
            vm.showAlert(
                title: .Alert,
                message: "The operation couldn't be completed. Please try again."
            )
        }
        vm.stopLoading()
    }
}
