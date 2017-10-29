//
//  GCSearchResultsDelegate.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 10/1/17.
//

import UIKit

/// The delegate of a GCSearchResultsController object must adopt the GCSearchResultsDelegate protocol.

protocol GCSearchResultsDelegate {
    
    /// Tells the delegate that the user selected a search result.
    /// 
    /// - Parameter searchResultsController: The controller object managing the search results interface.
    /// - Parameter searchResult: The search result selected by the user.
    
    func searchResultsController(_ searchResultsController: GCSearchResultsController, didSelectSearchResult searchResult: GCSearchResult)
}
