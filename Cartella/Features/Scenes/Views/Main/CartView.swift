//
//  CartView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-28.
//

import SwiftUI

struct CartView: View {
    @State var sheetVisible:Bool = false
    @StateObject var vm = CartVM()
    
    @State var navigationTitle:String = "Cart"
    @State var defaultCardIndex:Int = 100
    @State private var showPaymentSuccessAlert = false
    @State private var paymentSuccessMessage = "Payment successful!"
    
    var body: some View {
        ZStack{
            VStack {
                    VStack(spacing: 16) {
                        if !vm.cartItems.isEmpty{
                            ScrollView(showsIndicators: false) {
                                // Cart Items
                                ForEach(vm.cartItems, id: \.checkoutProduct.id) { itemWrapper in
                                    CartItemView(
                                        cartItemWrapper: itemWrapper,
                                        onRemove: { productId in
                                            removeItems(productId: productId)
                                        },
                                        onUpdateQuantity: { productId, quantity in
                                            updateItemQuantity(productId: productId, quantity: quantity)
                                        }
                                    )
                                }
                            } //: Scroll View
                            
                            // Cart Summary
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Items in Cart:")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(vm.cartItemCount)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                HStack {
                                    Text("Total:")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("LKR \(formatNumber(number: vm.getCartTotal()))")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)
                                }
                                
                                // Action Buttons
                                HStack(spacing: 12) {
                                    CommonButton(
                                        title: "Clear Cart",
                                        isFilled: false,
                                        isFullWidth: false,
                                        buttonColor: .red,
                                        buttonWidth: 120
                                    ) {
                                        clearCart()
                                    }
                                    
                                    CommonButton(
                                        title: "Pay",
                                        isFilled: true,
                                        isFullWidth: false,
                                        buttonWidth: 120
                                    ) {
                                        withAnimation(.easeIn(duration: 0.3)){
                                            sheetVisible = true
                                        }
                                    }
                                }
                                .padding(.top, 10)
                            }
                            .padding(16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.bottom, 100)
                            
                            .sheet(isPresented: $sheetVisible) {
                                CustomCardSelectView(action: {
                                    // Dismiss sheet, then show payment success alert
                                    sheetVisible = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showPaymentSuccessAlert = true
                                    }
                                })
                                .background(Color.gray)
                                .presentationDetents([.medium, .large])
                            }
                        } else {
                            // Empty Cart State
                            HStack {
                                VStack(spacing: 20) {
                                    Spacer()
                                    Image(systemName: "cart")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                    
                                    Text("Your cart is empty")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Text("Add some products to get started")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                }
                                .frame(maxHeight: UIScreen.screenHeight * 0.85)
                            }
                            .frame(maxWidth: UIScreen.screenWidth)
                        }
                    } // : VStack
                    .padding(.top, 16)
            } //: VStack
            .padding(.horizontal, 16)
            .foregroundColor(Color.white)
            .onAppear{
                getAllCartItems()
            }
        } // : ZStack
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        
        .alert(isPresented: $showPaymentSuccessAlert) {
            Alert(
                title: Text("Payment Success"),
                message: Text(paymentSuccessMessage),
                dismissButton: .default(Text("OK")) {
                    clearCart()
                }
            )
        }
    }
    
    func getAllCartItems(){
        //MARK: - GET ITEM CARDS API CALL
        vm.startLoading()
        vm.processWithCart() { success, _  in
            vm.stopLoading()
            if success{
                vm.showSuccessLogger(message: "cart data get success !")
            }else{
                vm.showErrorLogger(message:  "cart data get Error !")
            }
        }
    }
    
    func removeItems(productId: String){
        //MARK: - Remove CARDS API CALL
        vm.startLoading()
        vm.processWithRemoveItem(productId: productId) { success, _  in
            vm.stopLoading()
            if success{
                vm.showSuccessLogger(message: "cart Item remove success !")
            }else{
                vm.showErrorLogger(message:  "cart Item remove Error !")
            }
        }
    }
    
    func updateItemQuantity(productId: String, quantity: Int) {
        vm.startLoading()
        vm.updateItemQuantity(productId: productId, quantity: quantity) { success, _ in
            vm.stopLoading()
            if success {
                vm.showSuccessLogger(message: "Quantity updated successfully!")
            } else {
                vm.showErrorLogger(message: "Failed to update quantity!")
            }
        }
    }
    
    func clearCart() {
        vm.startLoading()
        vm.clearCart { success, _ in
            vm.stopLoading()
            if success {
                vm.showSuccessLogger(message: "Cart cleared successfully!")
            } else {
                vm.showErrorLogger(message: "Failed to clear cart!")
            }
        }
    }
    
    func payForItems(productId: String){
        //MARK: - GET ITEM CARDS API CALL
        vm.startLoading()
        vm.processWithPayForItem(productId: productId) { success, _  in
            vm.stopLoading()
            if success{
                getAllCartItems()
                vm.showSuccessLogger(message: "cart data get success !")
            }else{
                vm.showErrorLogger(message:  "cart data get Error !")
            }
        }
    }
    
}

#Preview {
    CartView()
}

// MARK: - CUSTOM TOPICS SELECTION
private struct CustomCardSelectView: View {
    @State var defaultCardIndex:Int = 100
    @State var savedCards:[LocalPaymentCardData] = []
    @State var defaultCard:LocalPaymentCardData?
    let action: ()->()?
    // Add Payment Card Sheet State
    @State private var showAddCardSheet = false
    @State private var cardNumber = ""
    @State private var cardType = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var addCardError: String? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Recommended Method(s)")
                .font(.system(size: 14, weight: .medium, design: .default))
                .padding(.bottom, 14)
                .padding(.trailing, UIScreen.screenWidth * 0.47)
            
            ScrollView(showsIndicators: false) {
                ForEach(Array(savedCards.enumerated()), id: \.offset) { index, card in
                    Button {
                        defaultCardIndex = index
                        if defaultCardIndex == index{
                            defaultCard = savedCards[index]
                            print("Selected card: \(card.cardNumber ?? "")")
                        }
                    } label: {
                        HStack{
                            Image(systemName: defaultCardIndex == index ? "checkmark.circle" : "circle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            SavedCardView(paymentCard: savedCards[index])
                        }
                        .padding(.bottom, 16)
                        .padding(.leading, 8)
                    }
                }//:ForEach
                Spacer()
            }
            CommonButton(title: "Pay now", isFilled: true, isFullWidth: false) {
                action()
            }
            .padding(.top, 10)
            Spacer()
            // Add Payment Card Button
            CommonButton(title: "Add Payment Card", isFilled: true, isFullWidth: false, buttonColor: .mainTitle) {
                showAddCardSheet = true
            }
            .padding(.top, 32)
        }//:VStack
        .background(Color.clear)
        .padding(.top, 16)
        .padding()
        .onAppear {
            loadSavedCards()
        }
        .sheet(isPresented: $showAddCardSheet) {
            VStack(spacing: 16) {
                Text("Add Payment Card")
                    .font(.headline)
                    .foregroundColor(.mainTitle)
                
                CommonTextField(headerText: "Card Number", placeHolderText: "Card Number", textField: $cardNumber)
                
                CommonTextField(headerText: "Card Type", placeHolderText: "Card Type (e.g. Visa, MasterCard)", textField: $cardType)
                
                CommonTextField(headerText: "Expiry Date", placeHolderText: "Expiry Date (MM/YY)", textField: $expiryDate)
                
                CommonTextField(headerText: "CVV", placeHolderText: "CVV", textField: $cvv)
                
                CommonTextField(headerText: "Cardholder Name", placeHolderText: "Cardholder Name", textField: $cardholderName)
                if let error = addCardError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                HStack {
                    Button("Cancel") {
                        showAddCardSheet = false
                        clearCardFields()
                    }
                    .padding()
                    .foregroundColor(.blue)
                    Spacer()
                    Button("Save") {
                        if addPaymentCard() {
                            showAddCardSheet = false
                            clearCardFields()
                            loadSavedCards()
                        }
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
        }
        .presentationDetents([.medium, .large])
    }
    
    private func loadSavedCards() {
        savedCards = PersistenceController.shared.loadAllPaymentCards()
    }
    private func clearCardFields() {
        cardNumber = ""
        cardType = ""
        expiryDate = ""
        cvv = ""
        cardholderName = ""
        addCardError = nil
    }
    private func addPaymentCard() -> Bool {
        // Basic validation
        guard !cardNumber.isEmpty, !cardType.isEmpty, !expiryDate.isEmpty, !cvv.isEmpty, !cardholderName.isEmpty else {
            addCardError = "All fields are required."
            return false
        }
        guard cardNumber.count >= 12 && cardNumber.count <= 19 else {
            addCardError = "Card number must be 12-19 digits."
            return false
        }
        guard cvv.count >= 3 && cvv.count <= 4 else {
            addCardError = "CVV must be 3 or 4 digits."
            return false
        }
        PersistenceController.shared.savePaymentCard(cardNumber: cardNumber, cardType: cardType, expiryDate: expiryDate, cvv: cvv, cardholderName: cardholderName)
        addCardError = nil
        return true
    }
}

struct SavedCardView: View {
    var paymentCard: LocalPaymentCardData
    var body: some View {
        HStack(spacing: 8){
            Image(detectCardType())
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .padding(.leading, 8)
                .padding(.vertical, 12)
            Text(maskCardNumber())
                .font(.system(size: 14, weight: .bold, design: .default))
                .padding(.vertical, 12)
                .padding(.trailing, 113)
        } // : HStack
        .background(.white.opacity(0.13))
        .cornerRadius(10)
        .frame(width: UIScreen.screenWidth * 0.826)
    }
    
    private func detectCardType() -> String {
        let cardNumber = paymentCard.cardNumber ?? ""
        let cleanedNumber = cardNumber.replacingOccurrences(of: " ", with: "")
            
        if cleanedNumber.hasPrefix("4") {
            return "Visa"
        } else if let firstDigit = cleanedNumber.first, let digit = Int(String(firstDigit)), digit >= 5 && digit <= 6 {
            return "MasterCard"
        } else if cleanedNumber.hasPrefix("34") || cleanedNumber.hasPrefix("37") {
            return "AmericanExpress"
        } else {
            return "Visa"
        }
    }
    
    private func maskCardNumber() -> String {
        let cardNumber = paymentCard.cardNumber ?? ""
        let cleanedNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        
        guard cleanedNumber.count >= 4 else {
            return cardNumber
        }
        
        let lastFour = String(cleanedNumber.suffix(4))
        return "**** **** **** \(lastFour)"
    }
}
