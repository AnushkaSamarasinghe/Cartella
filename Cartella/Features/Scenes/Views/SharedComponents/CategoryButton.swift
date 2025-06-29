//
//  CategoryButton.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import SwiftUI

struct CategoryButton: View {
    @State var categoryName : String
    @State var categoryId: String
    @Binding var selectedCategoryId: String
    let action: (() -> ())?
    
    var body: some View {
        ZStack{
            Button {
                action?()
                
            } label: {
                Text(categoryName)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 27)
                            .strokeBorder(.mainTitle, lineWidth: 1)
                            .background(categoryId == selectedCategoryId ? Color.mainTitle : Color.mainTitle.opacity(0.2))
                    )
                    .cornerRadius(27)
            }
        }//:ZStack
    }
}
