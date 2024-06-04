//
//  PaywallView.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 01/09/23.
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    
    @Binding var isPaywallPresented: Bool
    @State var isPurchasing: Bool = false
    @State var isPresented: Bool = true
    @EnvironmentObject var userViewModel: UserViewModel
    @State var error: NSError?
    @State var currentOffering: Offering?
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: 8) {
                
                Spacer()
                
                Text("\(DevelopmentEnviroment.appName) Premium")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Unlimited prompts")
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Bring your creative potential to life with unlimited prompts.")
                                .foregroundStyle(.gray)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("HD image quality")
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Create your arts in higher definition quality. Afterall, art is all about quality.")
                                .foregroundStyle(.gray)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Unlock all styles")
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("There's always more creative potential and so should be your inpirations with more styles.")
                                .foregroundStyle(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Generate image variations")
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Sometimes you want more from the same art, something different. Unlock image variations from premium.")
                                .foregroundStyle(.gray)
                        }
                                                
                    }
                }
                .padding(.horizontal)
                
                Spacer()

                if currentOffering != nil {
                    
                    ForEach(currentOffering!.availablePackages) { pkg in
                        Button {
                            //BUY
                            
                            /// - Set 'isPurchasing' state to 'true'
                            isPurchasing = true
                            
                            /// - Purchase a package
                            Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                               
                                /// - Set 'isPurchasing' state to 'false'
                                isPurchasing = false
                                
                                /// - If the user didn't cancel and there wasn't an error with the purchase, close the paywall
                                if !userCancelled, error == nil {
                                    isPresented = false
                                } else if let error = error {
                                    self.error = error as NSError
                                    
                                }
                                if customerInfo?.entitlements[DevelopmentEnviroment.revenueCatOffer]?.isActive == true {
                                    // Unlock that great "Premium" content
                                    userViewModel.isSubscriptionActive = true
                                    isPaywallPresented = false
                                }
                            }
                        } label: {
                            Text("\(pkg.storeProduct.subscriptionPeriod!.periodTitle) \(pkg.storeProduct.localizedPriceString)")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 350, height: 45)
                                .background(.blue)
                                .mask(
                                    RoundedRectangle(cornerRadius: 30)
                                        .frame(height: 45)
                                )
                            
                        } //:BUTTON
                        .padding(.horizontal)
                
                    }
                }
                
                Text("Automatic renewal. Cancel anytime.")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                
                Button {
                    Purchases.shared.restorePurchases { customerInfo, error in
                        if let error = error {
                            self.error = error
                            print(self.error as Any)
                        }
                    
                        if customerInfo?.entitlements[DevelopmentEnviroment.revenueCatOffer]?.isActive == true {
                            // Unlock that great "Premium" content
                            userViewModel.isSubscriptionActive = true
                            isPaywallPresented = false
                        }

                    }
                } label: {
                    Text("restore purchases")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .underline()
                }
                .padding(.horizontal)
                
                Spacer()

            } //:VSTACK
            
            /// - Display an overlay during a purchase
            Rectangle()
                .foregroundStyle(Color.black)
                .opacity(isPurchasing ? 0.5 : 0.0)
                .ignoresSafeArea(.all)
        } //:ZSTACK
        .onAppear {
            Purchases.shared.getOfferings { offerings, error in
                if let offer = offerings?.current, error == nil {
                    currentOffering = offer
                    print(offer)
                }
            }
        }
    }
}

struct PaywallView_Preview: PreviewProvider {
    static var previews: some View {
        PaywallView(isPaywallPresented: .constant(true))
    }
}
