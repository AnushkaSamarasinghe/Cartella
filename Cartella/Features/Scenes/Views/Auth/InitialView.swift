//
//  InitialView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct InitialView: View {
    //MARK: - PROPERTIES
    @Environment(\.navigationCoordinator) var coordinator: NavigationCoordinator
    
    var body: some View {
        //MARK: - BODY
        VStack {
            Image(.logo)
                .frame(width: 150, height: 150)
                .cornerRadius(24)
                .padding(.top, 198)
            
            Text("Cartella")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.primary.opacity(0.6))
                .padding(.top, 32)
            
            // Login Button
            CommonButton(title: "Log In", isFilled: true, isFullWidth: false) {
                coordinator.push(page: .login)
            }
            .padding(.top, 32)
            
            //Signup Button
            CommonButton(title: "Sign up", isFilled: false, isFullWidth: false) {
                coordinator.push(page: .signup)
            }
            .padding(.top, 8)
            
            Spacer()
        } //:VStack
        .withBaseViewMod(isShowAppFooter: true)
    }
}

#Preview {
    InitialView()
}
