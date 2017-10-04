//
//  GCCountry.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit

// MARK: Properties & Initializers

/// The GCCountry class defines an object that contains the ISO 3166-1 alpha-2 country code and localized display name for a country.

public final class GCCountry: NSObject {
    
    // MARK: Properties
    
    /// The ISO 3166-1 alpha-2 code for the country.
    
    public let countryCode: String!
    
    /// The localized display name for the country.
    ///
    /// This value is automatically generated using the supplied country code and the current locale.
    
    @objc public let localizedDisplayName: String!
    
    // MARK: Initializers
    
    /// Initializes and returns a newly allocated country.
    ///
    /// - Parameter countryCode: An ISO 3166-1 alpha-2 code representing a country.
    /// - Returns: An initialized country containing a country code and localized display name.
    
    public init?(countryCode: String) {
        
        if let localizedDisplayName = Locale(identifier: Locale.preferredLanguages.first!).localizedString(forRegionCode: countryCode) {
            
            self.countryCode = countryCode
            self.localizedDisplayName = localizedDisplayName
        }
        else {
            
            return nil
        }
    }
}
