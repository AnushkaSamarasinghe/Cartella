//
//  PasswordField.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct PasswordField:View {
    //MARK: - PROPERTIES
    @State var headingText:String = "Password"
    @State var showPassword:Bool = false
    @State var isChangePasswordView:Bool = false
    @Binding var password:String
    var cornerRadius:CGFloat = 25
    
    var body: some View{
        //MARK: - BODY
        VStack(alignment:.leading) {
            Text(headingText)
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundColor(Color.primaryTextColor)
            HStack {
                VStack {
                    if showPassword {
                        TextField("", text: $password)
                            .placeholder(when: password.isEmpty) {
                                Text(headingText)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(Color.primaryTextColor.opacity(0.4))
                            }
                    } else {
                        SecureField("", text: $password)
                            .placeholder(when: password.isEmpty) {
                                Text(isChangePasswordView ? "********" : "• • • • • • • •")
                                    .foregroundColor(Color.primaryTextColor)
                                    .opacity(0.4)
                                    .font(.system(size: isChangePasswordView ? 16 : 18))
                            }
                    }
                } //:VStack
                Button(action: {
                    showPassword.toggle()
                }, label: {
                    if !showPassword {
                        Image(systemName: isChangePasswordView ? "eye" : "eye.slash")
                    } else {
                        Image(systemName: isChangePasswordView ? "eye.slash" : "eye")
                    }
                }) //:Button
                .foregroundColor(Color.primaryTextColor.opacity(0.8))
                .frame(width: 22,height: 19)
                .padding(.trailing, password.isEmpty ? 16 : 10)
                
                if !password.isEmpty {
                    withAnimation {
                        Button(action: {
                            password = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.primaryTextColor.opacity(0.6))
                        })
                        .padding(.trailing, 16)
                        .transition(.move(edge: password.isEmpty ? .leading : .trailing))
                    }
                }
            } //:HStack
            .autocorrectionDisabled()
            .autocapitalization(.none)
            .padding(.leading, 16)
            .frame(height: 48)
            .foregroundColor(Color.primaryTextColor)
            .background(Color.secondaryTextColor.opacity(0.1))
            .cornerRadius(cornerRadius)
        } //:VStack
        .keyboardType(.default)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .shadow(color: .shadow, radius: 5, x: 0, y: 2)
        .validate(with: password,validation: Validator().isValidPasswordValidator(value:value2:))
    }
}

#Preview{
    PasswordField(password: .constant(""))
}
