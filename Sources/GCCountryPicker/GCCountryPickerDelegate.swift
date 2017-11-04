//
//  GCCountryPickerDelegate.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit

/// The delegate of a GCCountryPickerViewController object must adopt the GCCountryPickerDelegate protocol.

public protocol GCCountryPickerDelegate {
    
    /// Tells the delegate that the user cancelled the pick operation.
    ///
    /// Your delegate’s implementation of this method should dismiss the country picker.
    ///
    /// - Parameter countryPicker: The controller object managing the country picker interface.
    
    func countryPickerDidCancel(_ countryPicker: GCCountryPickerViewController)
    
    /// Tells the delegate that the user picked a country.
    ///
    /// Your delegate’s implementation of this method should pass the country on to any custom code that needs it, and then it should dismiss the picker view.
    ///
    /// - Parameter countryPicker: The controller object managing the country picker interface.
    /// - Parameter country: The country selected by the user.
    
    func countryPicker(_ countryPicker: GCCountryPickerViewController, didSelectCountry country: GCCountry)
}
