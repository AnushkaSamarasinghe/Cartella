//
//  AddItemCard.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddItemCard:View {
    
    var cart:ProductModel?
    @State var ItemCount:Int
    let action: ()->()?
    
    var body: some View{
        HStack{
            if cart?.image != "" {
                WebImage(url: URL(string: cart?.image ?? ""))
                    .resizable()
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                    .frame(height: 100)
                    .padding(.vertical, 8)

            } else {
                Image("Cloth_Placeholder")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .padding(12)
                    .opacity(0.5)
                    .foregroundColor(.white)
            }
            VStack(alignment:.leading, spacing:0){
                HStack {
                    Text(cart?.title ?? "")
                        .font(.system(size: 14, weight: .medium, design: .default))
                    .lineLimit(1)
                    .padding(.trailing, 39)
                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                    Button {
                        action()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .padding(.trailing,16)

                }
                Text("\(cart?.category?.capitalized ?? "N/A")")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(.primaryText)
                    .frame(width: 100,height: 20,alignment: .leading)

                HStack {
                    Text("LKR \(formatNumber(number: Double(cart?.price ?? 0)))")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .padding(.top, 24)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
            } // : Vstack
            
            
        } // : HStack
        .background(.white.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: .gray,radius: 9, x: 0, y: 3)
    }
    
}
