//
//  CreateProfileView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI
import SwiftData

struct CreateProfileView: View {
    // MARK: - PROPERTIES
    @Environment(\.navigationCoordinator) var coordinator: NavigationCoordinator
    @StateObject var vm = CreateProfileVM()

    var body: some View {
        // MARK: - BODY
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 10) {
                    
                    // Email
                    CommonTextField(headerText: "Email", placeHolderText: "Enter your email here", textField: $vm.email)
                    
                    // Name
                    CommonTextField(headerText: "Name", placeHolderText: "Enter your name here", textField: $vm.name)

                    // Complete Profile Button
                    CommonButton(title: "Complete Profile", isFilled: true, isFullWidth: false) {
                        Task {
                            await processWithCreateProfile()
                        }
                    }
                    .padding(.top, 16)

                    Spacer()
                } //:VStack
                .padding(.all, 16)
            } //:VStack
            .customNavigationBar(title: "Complete Profile", showsBackButton: false)
            .withBaseViewMod()
            
            //MARK: - ALERTS
            .alert(
                vm.alertTitle,
                isPresented: $vm.isAlertShown,
                actions: { Button("Ok", role: .cancel) {} },
                message: { Text(vm.alertMessage) }
            )
        } //:ZStack
        .onAppear {
            vm.loadEmailFromCoreData()
        }
    }
}

#Preview {
    CreateProfileView()
}

// process with Create Profile function
extension CreateProfileView {
    func processWithCreateProfile() async {
        vm.startLoading()
        do {
            try await vm.processWithCreateProfile()
            coordinator.push(page: .tabBar)
            
        } catch {
            vm.showAlert(
                title: .Alert,
                message: "The operation couldn't be completed. Please try again."
            )
        }
        vm.stopLoading()
    }
}

