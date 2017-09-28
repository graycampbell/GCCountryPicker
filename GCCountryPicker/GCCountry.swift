//
//  GCCountry.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit

// MARK: Properties & Initializers

public struct GCCountry {
    
    // MARK: Properties
    
    public let countryCode: String!
    public let localizedDisplayName: String!
    
    // MARK: Initializers
    
    public init(countryCode: String) {
        
        self.countryCode = countryCode
        self.localizedDisplayName = Locale.current.localizedString(forRegionCode: countryCode)
    }
}
