//
//  CommonButton.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct CommonButton: View {
    //MARK: - PROPERTIES
    let title: String
    let isFilled: Bool
    let isFullWidth: Bool
    @State var cornerRadius:CGFloat = 25
    @State var buttonColor: Color? = .primaryColor
    @State var isImg: Bool?
    @State var imageName = ""
    @State var imageWidth: CGFloat = 24
    @State var imageHeight: CGFloat = 24
    @State var borderWidth: CGFloat?
    @State var buttonWidth: CGFloat = 219
    @State var buttonHeight: CGFloat = 48
    let action: (() -> Void)?
    
    var body: some View {
        //MARK: - BODY
        VStack {
            Button {
                action?()
            } label: {
                HStack(spacing: 12) {
                    if isImg == true {
                        Image(imageName)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: imageWidth, height: imageHeight)
                            .foregroundColor(.primaryColor)
                    }
                    Text(title)
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .padding(.vertical, 12)
                        .foregroundStyle(self.isFilled ? .primaryBackgroundColor : (buttonColor != nil ? buttonColor! : .secondaryTextColor).opacity(0.7))
                } //:HStack
                .frame(maxWidth: isFullWidth == true ? UIScreen.screenWidth : buttonWidth, maxHeight: buttonHeight)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(self.isFilled ? (buttonColor != nil ? buttonColor! : .primaryColor) : .clear)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(self.isFilled ? .clear : buttonColor != nil ? buttonColor! : .primaryColor, lineWidth: borderWidth ?? 1)
                    } //:ZStack
                )
            } //:Button
            .shadow(color: .shadow, radius: 5, x: 0, y: 2)
        } //:VStack
    }
}

#Preview {
    CommonButton(title: "Button", isFilled: true, isFullWidth: false, action: {})
}
