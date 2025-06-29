//
//  CartItemView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartItemView: View {
    let cartItemWrapper: CartItemWrapper
    let onRemove: (String) -> Void
    let onUpdateQuantity: (String, Int) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Product Image
                WebImage(url: URL(string: cartItemWrapper.checkoutProduct.productDetails?.image ?? ""))
                    .resizable()
                    .placeholder(when: false) {
                        Image("GiftPlaceHolder")
                            .resizable()
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Product Title
                    Text(cartItemWrapper.checkoutProduct.productDetails?.title ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    // Product Category
                    Text(cartItemWrapper.checkoutProduct.productDetails?.category?.capitalized ?? "")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    // Price
                    Text("LKR \(formatNumber(number: cartItemWrapper.checkoutProduct.productDetails?.price ?? 0))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    // Remove Button
                    Button(action: {
                        onRemove(String(cartItemWrapper.checkoutProduct.productDetails?.id ?? 0))
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Spacer()
                }
            }
            
            // Quantity Controls
            HStack {
                Text("Quantity:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        if cartItemWrapper.quantity > 1 {
                            onUpdateQuantity(String(cartItemWrapper.checkoutProduct.productDetails?.id ?? 0), cartItemWrapper.quantity - 1)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                    .disabled(cartItemWrapper.quantity <= 1)
                    
                    Text("\(cartItemWrapper.quantity)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        onUpdateQuantity(String(cartItemWrapper.checkoutProduct.productDetails?.id ?? 0), cartItemWrapper.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                }
            }
            
            // Total for this item
            HStack {
                Spacer()
                Text("Total: LKR \(formatNumber(number: cartItemWrapper.totalPrice))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .padding(16)
        .background(.mainTitle.opacity(0.2))
        .cornerRadius(14)
        .padding(.bottom, 5)
        .shadow(color: .gray,radius: 9, x: 0, y: 3)
    }
}
