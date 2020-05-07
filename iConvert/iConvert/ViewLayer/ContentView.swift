//
//  ContentView.swift
//  iConvert
//
//  Created by Josh Franco on 5/7/20.
//  Copyright © 2020 Josh Franco. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var currentVolumeUnitIndex = 0
    @State private var desiredVolumeUnitIndex = 0
    @State private var volumeUnitAmountStr = ""
    
    @State private var volumeUnits: [VolumeUnit] = [.milliliters, .liters, .cups, .pints, .gallons]
    
    private var desiredUnitStr: String {
        if let desiredUnit = desiredUnit {
            return "\(String(format: "%g", desiredUnit)) \(volumeUnits[desiredVolumeUnitIndex].abbrevation)"
        } else {
            return "--"
        }
    }
    private var desiredUnit: Double? {
        guard let volumeUnitAmount = Double(volumeUnitAmountStr) else { return nil }
        let currentUnit = volumeUnits[currentVolumeUnitIndex]
        let desiredUnit = volumeUnits[desiredVolumeUnitIndex]
        
        return convert(volumeUnitAmount, from: currentUnit, to: desiredUnit)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Units")) {
                    TextField("Unit Amount", text: $volumeUnitAmountStr)
                        .keyboardType(.decimalPad)
                    Picker("Current Units", selection: $currentVolumeUnitIndex) {
                        ForEach(0..<self.volumeUnits.count) {
                            Text("\(self.volumeUnits[$0].rawValue.capitalized)") }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Desired Units")) {
                    Text(desiredUnitStr)
                    Picker("Desired Units", selection: $desiredVolumeUnitIndex) {
                        ForEach(0..<self.volumeUnits.count) {
                            Text("\(self.volumeUnits[$0].rawValue.capitalized)") }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("iConvert")
        }
    }
}

private extension ContentView {
    enum VolumeUnit: String {
        case milliliters
        case liters
        case cups
        case pints
        case gallons
        
        var abbrevation: String {
            switch self {
            case .milliliters:
                return "ml"
            case .liters:
                return "ltr"
            case .cups:
                return "cups"
            case .pints:
                return "pt"
            case .gallons:
                return "gal"
            }
        }
    }
    
    func convert(_ amount: Double, from fromUnit: VolumeUnit, to toUnit: VolumeUnit) -> Double {
        switch fromUnit {
        case .milliliters where toUnit == .liters:
            return amount / 1000
        case .milliliters where toUnit == .cups:
            return amount / 237
        case .milliliters where toUnit == .pints:
            return amount / 473
        case .milliliters where toUnit == .gallons:
            return amount / 3785
        case .liters where toUnit == .milliliters:
            return amount * 1000
        case .liters where toUnit == .cups:
            return amount * 4.227
        case .liters where toUnit == .pints:
            return amount * 2.113
        case .liters where toUnit == .gallons:
            return amount / 3.785
        case .cups where toUnit == .milliliters:
            return amount * 237
        case .cups where toUnit == .liters:
            return amount / 4.227
        case .cups where toUnit == .pints:
            return amount / 2
        case .cups where toUnit == .gallons:
            return amount / 16
        case .pints where toUnit == .milliliters:
            return amount * 473
        case .pints where toUnit == .liters:
            return amount / 2.113
        case .pints where toUnit == .cups:
            return amount * 2
        case .pints where toUnit == .gallons:
            return amount / 8
        case .gallons where toUnit == .milliliters:
            return amount * 3785
        case .gallons where toUnit == .liters:
            return amount * 3.785
        case .gallons where toUnit == .cups:
            return amount * 16
        case .gallons where toUnit == .pints:
            return amount * 8
        default:    // this case whould be the units equal eachother
            return amount
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
