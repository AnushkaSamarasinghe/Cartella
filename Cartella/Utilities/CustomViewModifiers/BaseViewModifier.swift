//
//  BaseViewModifier.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

extension View {
    func withBaseViewMod(isShowAppFooter: Bool = false,
                         footerAnimationsAppeared: Bool = false,
                         footerAnimationDuration: Double = 0.8,
                         footerAnimationDelay: Double = 0) -> some View {
        modifier(BaseViewModifier(isShowAppFooter: isShowAppFooter,
                                  footerAnimationsAppeared: footerAnimationsAppeared,
                                  footerAnimationDuration: footerAnimationDuration,
                                  footerAnimationDelay: footerAnimationDelay))
    }
}

struct BaseViewModifier: ViewModifier {
    //MARK: - For Network Monitoring Indicator
    static var networkMonitor = NetworkMonitor()
    @State private var networkMonitorIndicatorAutoDismissTime: TimeInterval = 2.0   /// 2 Seconds
    @State private var isShowNetworkMonitoringIndicator: Bool = false
    
    static var networkMonitorIndicatorString: String {
        var indicatorText: String = ""
        if let isConnected = networkMonitor.isNetworkConnected, isConnected,
           let connectionType = networkMonitor.connectionType {
            indicatorText = "Connected via \(connectionType)"
        } else {
            indicatorText = "No internet connection"
        }
        
        return indicatorText
    }
    
    //MARK: - For App Footer Details
    let isShowAppFooter: Bool
    static var currentYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: Date())
    }
    
    static var versionString: String {
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        return "Ver. \(appVersionString).\(buildNumber)"
    }
    
    //MARK: -  For View Animations
    @State var isFooterAnimating: Bool = false
    @State var footerAnimationsAppeared: Bool
    @State var footerAnimationDuration: Double
    @State var footerAnimationDelay: Double
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                Image(".imageHomeBgicons")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.primaryColor)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .clipped()
                    .blur(radius: 2)
            }
            .ignoresSafeArea()
            
            content   /// main content
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // MARK: - Footer
                    if isShowAppFooter {
                        footerView()
                            .padding(.bottom, isShowNetworkMonitoringIndicator ? 5 : 15)
                            .animation(.smooth(duration: footerAnimationDuration, extraBounce: 0).delay(footerAnimationDelay), value: isFooterAnimating)
                            .offset(y: footerAnimationsAppeared ? (isFooterAnimating ? UIScreen.screenHeight * 0.001 : UIScreen.screenHeight) : 0)
                    }
                    
                    // MARK: - Network Monitoring Indicator
                    if isShowNetworkMonitoringIndicator {
                        networkIndicatorView()
                            .transition(.move(edge: .bottom))
                    }
                }//: VStack
            }//: VStack
            .onAppear() { withAnimation{ isFooterAnimating = true }}
            .onChange(of: BaseViewModifier.networkMonitor.isNetworkConnected) { newValue, oldValue in
                handleNetworkChange(newValue: newValue)
            }
            
            //MARK: - Keyboard Dismiss
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    keyboardTopToolbar()
                }
            }
        }//: ZStack
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: - Footer View
    @ViewBuilder
    private func footerView() -> some View {
        VStack(spacing: 2) {
            VStack {
                Text("\(.DeveloperName) Copyright \(BaseViewModifier.currentYear)")
                    .font(.footnote)
                Text(BaseViewModifier.versionString)
                    .font(.footnote)
            }//: VStack
            .foregroundStyle(.black)
        }//: VStack
        .frame(maxWidth: .infinity)
        
        VStack(spacing: 2) {}
            .frame(maxWidth: .infinity)
    }
    
    // MARK: - Network Indicator View
    @ViewBuilder
    private func networkIndicatorView() -> some View {
        VStack {
            Text(BaseViewModifier.networkMonitorIndicatorString)
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
                .padding(.bottom, 15)
                .background(networkIndicatorColor())
                .foregroundColor(networkForegroundColor())
        }//: VStack
    }
    
    @MainActor
    private func handleNetworkChange(newValue: Bool?) {
        guard newValue == true else {
            Task {
                try await Task.sleep(for: .seconds(networkMonitorIndicatorAutoDismissTime))
                withAnimation {
                    isShowNetworkMonitoringIndicator = false
                }
            }
            return
        }
        withAnimation {
            isShowNetworkMonitoringIndicator = true
        }
    }
    
    // MARK: - Helpers for Network Indicator
    private func networkIndicatorColor() -> Color {
        BaseViewModifier.networkMonitor.isNetworkConnected == true ? .green.opacity(0.9) : .red.opacity(0.9)
    }
    
    private func networkForegroundColor() -> Color {
        BaseViewModifier.networkMonitor.isNetworkConnected == true ? .primary : .white
    }
    
    // MARK: - Keyboard Dismiss Area
    @ViewBuilder
    private func keyboardTopToolbar() -> some View {
        Button(action: {
            UIApplication.shared.endEditing()
        }, label: {
            Image(systemName: "keyboard.chevron.compact.down")
                .renderingMode(.template)
                .foregroundColor(.accentColor)
                .frame(width: 20, height: 20)
        })
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }
}

#Preview {
    Text("Base View Modifier Preview")
        .withBaseViewMod()
}

