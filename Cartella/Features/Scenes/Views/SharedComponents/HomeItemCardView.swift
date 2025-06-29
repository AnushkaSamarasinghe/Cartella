//
//  HomeItemCardView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct HomeItemCardView:View {
    @State var itemCard : ProductModel?
    @State var isFav:Bool = false
    let viewAction: (() -> ())?
    var addToFavAction: (() -> ())?
    var removeFromFavAction: (() -> ())?

    var body: some View{
        VStack(alignment: .leading){
            HStack(){
                Text("LKR \(formatNumber(number: Double(itemCard?.price ?? 0)))")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .bold()
                    .foregroundColor(.primaryText)
                    .padding(.leading, 8.5)
                    .padding(.top, 15)
                    .padding(.bottom, 7)
                
                Spacer()
                
                Button {
                    if isFav == false {
                        isFav = true
                        addToFavAction?()
                    } else {
                        isFav = false
                        removeFromFavAction?()
                    }
                    
                } label: {
                    Image(isFav ? "icon.heart" : "icon.heartBorder")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.mainTitle)
                        .frame(height: 22)
                        .padding(.trailing, 12)
                        .padding(.top, 12)
                        .padding(.bottom, 3)
                }
            } // : HStack
            
            if (itemCard?.image) != "" {
                WebImage(url: URL(string: itemCard?.image ?? ""))
                    .resizable()
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                    .frame(height: 120)
            } else {
                Image("Placeholder")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 22)
                    .padding(.bottom, 7)
                    .opacity(0.5)
                    .foregroundColor(.white)

            }
            
            Text(itemCard?.category ?? "")
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .padding(.top, 5)

            Text(itemCard?.title ?? "")
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundStyle(.black.opacity(0.8))
                .padding(.leading, 8)
                .padding(.trailing, 11)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.top, 1)
                .padding(.bottom, 10)
        } // : VStack
        .background(.mainTitle.opacity(0.2))
        .cornerRadius(14)
        .frame(height: 240)
        .padding(.bottom, 5)
        .shadow(color: .gray,radius: 9, x: 0, y: 3)
        .onTapGesture {
            viewAction?()
        }
        
    }
}

#Preview {
    HomeView()
}
