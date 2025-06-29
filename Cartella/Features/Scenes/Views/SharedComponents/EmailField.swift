//
//  EmailField.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct EmailField: View {
    //MARK: - PROPERTIES
    @State var headingText: String = "Email"
    @State var textFieldName: String = "example@email.com"
    @Binding var email: String
    var cornerRadius:CGFloat = 25
    
    var body: some View {
        //MARK: - BODY
        VStack(alignment: .leading, spacing: 0) {
            Text(headingText)
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundStyle(Color.primaryTextColor)
                .padding(.bottom, 5)
            
            HStack {
                TextField("", text: $email, prompt: Text(textFieldName)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundStyle(Color.primaryTextColor.opacity(0.4))
                )
                
                Spacer()
                
                if !email.isEmpty {
                    withAnimation {
                        Button(action: {
                            email = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.primaryTextColor.opacity(0.6))
                        })
                        .transition(.move(edge: email.isEmpty ? .leading : .trailing))
                    }
                }
            } //:HStack
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(height: 48)
            .foregroundStyle(Color.primaryTextColor)
            .background(Color.secondaryTextColor.opacity(0.1))
            .cornerRadius(cornerRadius)
        } //:VStack
        .keyboardType(.emailAddress)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .shadow(color: .shadow, radius: 5, x: 0, y: 2)
        .validate(with: email, validation: Validator().isValidEmailValidator(value:value2:))
    }
}

#Preview {
    EmailField(email: .constant("test@email.com"))
}
