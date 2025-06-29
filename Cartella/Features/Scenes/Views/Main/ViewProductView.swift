//
//  ViewProductView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct ViewProductView: View {
    
    @Environment(\.navigationCoordinator) var coordinator: NavigationCoordinator
    @State var isFav:Bool = false
    @StateObject var vm :ViewProductVM
    
    var body: some View {
        ZStack{
            VStack(alignment:.leading){
                    VStack(alignment:.leading, spacing: 6){
                        WebImage(url: URL(string: vm.product?.image ?? ""))
                            .resizable()
                            .placeholder(when: .random()) {
                                Image("GiftPlaceHolder")
                                    .resizable()
                                    .frame(height: 294)
                                    .cornerRadius(14)
                                    .foregroundColor(.white.opacity(0.5))
                            }
//                            .scaledToFit()
                            .frame(height: 294)
                            .cornerRadius(14)
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(.all, 16)
                        
                        Text(vm.product?.category ?? "")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundColor(.primaryText)
                            .padding(.leading, 16)
                            .padding(.top, 5)
                        
                        Text(vm.product?.title ?? "")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.mainTitle)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 16)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("LKR \(formatNumber(number: Double(vm.product?.price ?? 0)))")
                            .padding(.leading, 16)
                            .foregroundColor(.primaryText)
                            .padding(.bottom, 13)
                        
                        HStack {
                            CommonButton(
                                title: vm.isProductInCart() ? "Added to Cart" : "Add to cart",
                                isFilled: vm.isProductInCart(),
                                isFullWidth: false,
                                buttonWidth: 271
                            ) {
                                if !vm.isProductInCart() {
                                    AddToCart(itemId: String(vm.product?.id ?? 0))
                                }
                            }
                            .disabled(vm.isProductInCart())
                            .padding(.leading, 16)
                            
                            Button {
                                if isFav == false {
                                    isFav = true
//                                    AddOrRemoveFavorites(itemId: String(vm.product?.id ?? 0), favStatus: 1)
                                } else {
                                    isFav = false
//                                    AddOrRemoveFavorites(itemId: String(vm.product?.id ?? 0), favStatus: 0)
                                }
                                
                            } label: {
                                Image(systemName: isFav ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(height: 22)
                                    .padding(.trailing, 12)
                                    .padding(.top, 6)
                                    .padding(.bottom, 3)
                            }
                            .padding(.leading, 16)
                        } // : HStack
                        .padding(.bottom, 16)
                        
                    } // : VStack Item detail card
                    .frame(height: 500)
                    .background(.mainTitle.opacity(0.2))
                    .cornerRadius(14)
                    .padding(.bottom, 5)
                    .shadow(color: .gray,radius: 9, x: 0, y: 3)
                    
                VStack (alignment:.leading){
                    Text("Description")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.primaryText)
                        .padding(.bottom, 16)
                } // : VStack
                .padding(.top, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack (alignment:.leading){
                        Text(vm.product?.description ?? "")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .padding(.bottom, 10)
                            .foregroundColor(.gray)
                    } // :VStack
                } // :Scroll view
            } // :VStack
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .onAppear {
                // Refresh cart status when view appears
                vm.isProductInCart()
            }
        } // : ZStack
        .withBaseViewMod()
        .customNavigationBar(title: "View Product", showsBackButton: true, popAction: { coordinator.pop() })
    }
    
    //MARK: - ADD TO CART API CALL.
    func AddToCart(itemId: String){
        vm.startLoading()
        vm.processWithAddToCartItems(itemId: itemId) { success, _ in
            vm.stopLoading()
            if success{
                vm.showSuccessLogger(message: "add to cart success !")
            } else {
                vm.showErrorLogger(message:  "add to cart function Error !")
            }
        }
    }
    
}

#Preview {
    ViewProductView(vm: ViewProductVM(homeVM: HomeVM()))
}
