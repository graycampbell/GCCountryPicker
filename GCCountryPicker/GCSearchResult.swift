//
//  GCSearchResult.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 10/28/17.
//

import UIKit

/// The GCSearchResult struct contains information for a search result.

struct GCSearchResult {
    
    /// The object the search result represents.
    
    let object: Any
    
    /// The display title for the search result.
    
    let displayTitle: String
    
    /// The accessory title for the search result.
    
    let accessoryTitle: String?
}
