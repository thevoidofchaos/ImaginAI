//
//  DalleCustomizationView.swift
//  DalleApp
//
//  Created by Kushagra Shukla on 28/08/23.
//

import SwiftUI

struct DalleCustomizationView: View {
    @Binding var sliderValue: CGFloat
    @Binding var imageResolutionString: Resolution
    var resolutions: [Resolution] = [Resolution.low, Resolution.medium, Resolution.high]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            
            VStack(alignment: .leading, spacing: 4) {
                    Text("Number of Images")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                Slider(value: $sliderValue, in: 1...10, step: 1,
                       minimumValueLabel: Text("1"), maximumValueLabel: Text("10")) {EmptyView()}
            }
            
            VStack(alignment: .leading, spacing: 6) {
                    Text("Image Resolution")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                Picker("Select the resolution for the image", selection: $imageResolutionString) {
                    ForEach(resolutions, id: \.self) {
                        Text($0.resolutionString)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
        }
        .padding()
        .background(.regularMaterial)
        .mask (
        RoundedRectangle(cornerRadius: 15)
        )
    }
}

struct DalleCustomizationView_Preview: PreviewProvider {
    static var previews: some View {
        DalleCustomizationView(sliderValue: .constant(1), imageResolutionString: .constant(Resolution.medium))
    }
}
