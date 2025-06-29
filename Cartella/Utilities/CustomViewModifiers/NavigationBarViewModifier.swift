//
//  NavigationBarViewModifier.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation
import SwiftUI

//:MARK: - Right Button Customizations
enum CustomNavigationBarRightButton: Hashable {
    case logout
    case map
    case sync
    case notAvailable
    
    var icon: String {
        switch self {
        case .logout: ""
        case .map: "location.fill.viewfinder"
        case .sync: "arrow.trianglehead.2.clockwise.rotate.90.icloud.fill"
        case .notAvailable: ""
        }
    }
    
    var title: String {
        switch self {
        case .logout: "Logout"
        case .map: ""
        case .sync: "Sync"
        case .notAvailable: ""
        }
    }
    
    var forgroundColor: Color {
        switch self {
        case .logout: .red
        case .map: .red
        case .sync: .blue
        case .notAvailable: .clear
        }
    }
}

//MARK: - Custom Navigation Bar View Modifier
extension View {
    func customNavigationBar(title: String,
                             showsBackButton: Bool = true,
                             rightButton: CustomNavigationBarRightButton? = .notAvailable,
                             popAction: (() -> Void)? = nil,
                             onRightButtonTap: (() -> Void)? = nil) -> some View {
        modifier(CustomNavigationBar(title: title,
                                     showsBackButton: showsBackButton,
                                     rightButton: rightButton,
                                     popAction: popAction,
                                     onRightButtonTap: onRightButtonTap))
    }
}

struct CustomNavigationBar: ViewModifier {
    //MARK: - PROPERTIES
    let title: String
    var showsBackButton: Bool
    var rightButton: CustomNavigationBarRightButton?
    let popAction: (() -> Void)?
    let onRightButtonTap: (() -> Void)?
    
    func body(content: Content) -> some View {
        //MARK: - BODY
        content
            .navigationBarBackButtonHidden(true) // Hides the default back button
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline)
                }
                if showsBackButton {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { popAction?() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primaryColor)
                        }
                    }
                }
                
                if rightButton != .notAvailable {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { onRightButtonTap?() }) {
                            HStack(spacing: 3) {
                                if rightButton?.icon != "" {
                                    Image(systemName: rightButton?.icon ?? "")
                                        .renderingMode(.template)
                                }
                                Text(rightButton?.title ?? "")
                            }//: HStack
                            .foregroundStyle(rightButton?.forgroundColor ?? .clear)
                        }
                    }
                }
                
            }
    }
}

#Preview {
    AnyView(Text("Test Preview for CustomNavigationBar"))
        .modifier(CustomNavigationBar(
            title: "Navigation Bar",
            showsBackButton: true,
            popAction: {},
            onRightButtonTap: {}
        ))
}
