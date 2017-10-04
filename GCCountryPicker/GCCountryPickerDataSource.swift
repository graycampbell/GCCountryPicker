//
//  GCCountryPickerDataSource.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 10/4/17.
//

import UIKit

/// The data source of a GCCountryPickerViewController object must adopt the GCCountryPickerDataSource protocol.

public protocol GCCountryPickerDataSource {
    
    /// Asks the data source to provide a collection of ISO 3166-1 alpha-2 country codes for the specified country picker view controller.
    ///
    /// - Parameter countryPicker: The country picker view controller requesting this information.
    /// - Returns: A collection of ISO 3166-1 alpha-2 country codes for the specified country picker view controller.
    
    func countryCodes(for countryPicker: GCCountryPickerViewController) -> [String]
}
