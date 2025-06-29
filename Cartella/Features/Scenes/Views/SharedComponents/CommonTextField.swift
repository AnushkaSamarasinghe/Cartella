//
//  CommonTextField.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct CommonTextField: View {
    let headerText:String
    let placeHolderText:String
    @Binding var textField:String
    var boder:Bool = false
    var cornerRadius:CGFloat = 25
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0){
            Text(headerText)
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundStyle(Color.primaryTextColor)
                .padding(.bottom, 6)
            
            TextField("", text: $textField)
                .placeholder(when: textField.isEmpty, placeholder: {
                    Text(placeHolderText)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundStyle(Color.primaryTextColor.opacity(0.4))
                })
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .frame(height: 48)
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundStyle(Color.primaryTextColor)
                .background(
                    ZStack{
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.secondaryTextColor.opacity(0.1))
                        
                        if boder == true{
                            
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.secondaryTextColor, lineWidth: 1)
                        }
                    }
                )
            
        } //: VStack
        .shadow(color: .shadow, radius: 5, x: 0, y: 2)
    }
}


struct TextView: View {
    @State var title:String
    @Binding var detail:String
    var cornerRadius:CGFloat = 25
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text(title)
                    .foregroundColor(Color.primaryTextColor)
                Spacer()
                Text(detail)
                    .foregroundColor(Color.secondaryTextColor.opacity(0.5))
                
            }//: HStack
            .font(.system(size: 14, weight: .regular, design: .default))
            .padding(.horizontal)
            .frame(height: 48)
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.secondaryTextColor.opacity(0.2)))
            
        }//: VStack
        .padding(.horizontal,16)
        .shadow(color: .shadow, radius: 5, x: 0, y: 2)
    }
}


struct GroupBox:View {
    @State var title:String = ""
    @State var icon:String = ""
    var cornerRadius:CGFloat = 25
    let action: (() -> ())?
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundStyle(Color.primaryTextColor)
                
                Spacer()
                Button {
                    
                } label: {
                    Image(icon).resizable().frame(width: 20, height:20)
                        .foregroundColor(Color.secondaryTextColor)
                }
                
            }//: HStack
            .padding(.horizontal,16)
                .frame(width: 343, height: 48, alignment: .center)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.secondaryTextColor.opacity(0.2)))
        }
        .shadow(color: .shadow, radius: 5, x: 0, y: 2)
    }
}
