//
//  ValidateViewModifier.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct Validate: ViewModifier {
    //MARK: - PROPERTIES
    var text: String
    var text2: String?
    var validation: (String, String?) -> ValidationStatus
    
    @State var active: Bool = false
    @State var latestValidation: ValidationStatus = .standard
    
    func body(content: Content) -> some View {
        //MARK: - BODY
        VStack {
            content
                .onTapGesture { active = true }
            Group {
                if active {
                    let validationResult = text.isEmpty ? .standard : validation(text, text2)
                    switch validationResult {
                        case .standard:
                            AnyView(EmptyView())
                        case .success:
                            AnyView(EmptyView())
                        case .failure(let message):
                            let text = Text(message)
                                .foregroundStyle(.red)
                                .font(.caption)
                                .padding(.leading, 16)
                            AnyView(text)
                    }
                }
            } //:Group
        } //:VStack
        
    }
}

extension View {
    func validate(with text: String, text2: String? = nil, validation: @escaping (String, String?) -> ValidationStatus) -> some View {
        self.modifier(Validate(text: text, text2: text2, validation: validation))
    }
}

enum ValidationStatus: Equatable {
    case standard
    case success
    case failure(message: String)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
