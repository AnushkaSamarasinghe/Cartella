//
//  HomeView.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.navigationCoordinator) var coordinator: NavigationCoordinator
    
    @StateObject var vm = HomeVM()
    @State var selectedCategoryId: String = ""
    
    var body: some View {
        ZStack{
            GeometryReader { geo in
                VStack {
                    HStack (spacing: 16){
                        //MARK: - SEARCH BAR
                        SearchBar(searchText: $vm.searchText, placeholder: "Start typing here", clearAction: {
                            filterProducts(categoryId: selectedCategoryId == "" ? "" : String(selectedCategoryId), query: vm.searchText)
                        })
                        .onSubmit {
                            filterProducts(categoryId: selectedCategoryId == "" ? "" : String(selectedCategoryId), query: vm.searchText)
                            print("search categoryId: \(selectedCategoryId)")
                            print("search q: \(vm.searchText)")
                        }
                        .submitLabel(.search)
                        
                    }// : HStack
                    
                    VStack(alignment: .leading){
                        Text("Discover Items")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .padding(.top, 16)
                            .padding(.leading, 9)
                            .foregroundColor(.primary)
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                CategoryButton(categoryName: "All", categoryId: "", selectedCategoryId: $selectedCategoryId, action: {
                                    selectedCategoryId = ""
                                    print(selectedCategoryId)
                                    filterProducts(categoryId: "", query: vm.searchText)
                                })
                                
                                ForEach(vm.ProductCategories, id: \.self) { prod in
                                    CategoryButton(categoryName: prod.capitalized, categoryId: prod, selectedCategoryId: $selectedCategoryId, action: {
                                        selectedCategoryId = prod
                                        print(selectedCategoryId)
                                        filterProducts(categoryId: String(selectedCategoryId), query: vm.searchText)
                                    })
                                }
                            } // : HStack
                            .padding([.bottom, .trailing], 16)
                        } // : ScrollView
                        .padding(.trailing, -16)
                    }//:VStack
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0){
                            if !vm.ProductCards.isEmpty {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)) {
                                    ForEach(Array(vm.ProductCards.enumerated()), id: \.offset) { index, card in
                                        HomeItemCardView(itemCard: card, isFav: card.isFavourite ?? false, viewAction: {
                                            vm.selectedItemCard = card
                                            coordinator.push(page: .viewProduct(vm))
                                        }, addToFavAction: {
                                            Task {
                                                await AddOrRemoveFavorites(itemId: card.id ?? 0, favStatus: 1)
                                            }
                                        }, removeFromFavAction: {
                                            Task {
                                                await AddOrRemoveFavorites(itemId: card.id ?? 0, favStatus: 0)
                                            }
                                        })
                                    }
                                }
                                .padding(.top, 6)
                                .padding(.bottom, 120)
                            } else {
                                //MARK: placeholder
                                VStack {
                                    Spacer()
                                    Text("No data found")
                                        .padding(.top, UIScreen.screenHeight * 0.3)
                                    Spacer()
                                }//:VStack
                            }
                        } // : VStack
                    } //: Scroll view
                    .refreshable {
                        filterProducts()
                    }
                } //: VStack
                .padding(.horizontal, 16)
                .foregroundColor(.gray)
                .onAppear() {
                    self.filterProducts(categoryId: selectedCategoryId == "" ? "" : String(selectedCategoryId))
                    print(" count \(vm.ProductCards.count)")
                }
            } //: Geometry
        } //: ZStack
        .withBaseViewMod()
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func filterProducts(categoryId: String = "", query: String = ""){
        vm.startLoading()
        vm.fetchProductsWithCombine(categoryId: categoryId, query: query) { success, _  in
            vm.stopLoading()
            if success{
                vm.showSuccessLogger(message: "product data get success !")
            }else{
                vm.showErrorLogger(message:  "product data get Error !")
            }
        }
    }
    
    //MARK: - ADD OR REMOVE FAVORITE API CALL.
    func AddOrRemoveFavorites(itemId: Int, favStatus: Int) async {
        // TODO: Implement favorite functionality
    }
    
}


#Preview {
    HomeView()
}

