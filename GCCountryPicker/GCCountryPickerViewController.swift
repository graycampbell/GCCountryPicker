//
//  GCCountryPickerViewController.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit

// MARK: Properties & Initializers

/// The GCCountryPickerViewController class defines a view controller containing a country picker interface.

public final class GCCountryPickerViewController: UITableViewController {
    
    // MARK: Properties
    
    /// The object that acts as the delegate of the country picker view controller.
    
    public var delegate: GCCountryPickerDelegate?
    
    fileprivate var countries = [GCCountry]()
    fileprivate var searchController: UISearchController!
    fileprivate var searchResultsController = GCSearchResultsController()
    
    // MARK: Initializers
    
    /// Initializes and returns a newly allocated country picker view controller object.
    ///
    /// - Returns: An initialized country picker view controller object.
    
    public convenience init() {
        
        self.init(style: .plain)
        
        self.navigationItem.title = "Country"
    }
}

// MARK: - View

extension GCCountryPickerViewController {
    
    /// Called after the controller's view is loaded into memory.
    ///
    /// This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files.
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadCountries()
        self.configureNavigationBar()
        self.configureTableView()
    }
}

// MARK: - Countries

extension GCCountryPickerViewController {
    
    fileprivate func loadCountries() {
        
        if let url = Bundle(for: GCCountryPickerViewController.self).url(forResource: "CountryCodes", withExtension: "plist") {
            
            if let countryCodes = NSArray(contentsOf: url) as? [String] {

                for countryCode in countryCodes {

                    let country = GCCountry(countryCode: countryCode)
                    
                    self.countries.append(country)
                }

                self.countries.sort(by: { $0.localizedDisplayName < $1.localizedDisplayName })
            }
        }
    }
}

// MARK: - Navigation Bar

extension GCCountryPickerViewController {
    
    fileprivate func configureNavigationBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel(barButtonItem:)))
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self.searchResultsController
        self.searchResultsController.delegate = self
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.definesPresentationContext = true
    }
    
    @objc func cancel(barButtonItem: UIBarButtonItem) {
        
        self.delegate?.countryPickerDidCancel(self)
    }
}

// MARK: - UISearchResultsUpdating

extension GCCountryPickerViewController: UISearchResultsUpdating {
    
    /// Called when the search bar becomes the first responder or when the user makes changes inside the search bar.
    ///
    /// This method is automatically called whenever the search bar becomes the first responder or changes are made to the text in the search bar. Perform any required filtering and updating inside of this method.
    ///
    /// - Parameter searchController: The UISearchController object used as the search bar.
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        var searchResults = [GCCountry]()
        
        if let searchText = searchController.searchBar.text?.localizedLowercase.replacingOccurrences(of: "(^\\s+)|(\\s+$)", with: "", options: .regularExpression, range: nil) {
            
            if !searchText.isEmpty {
                
                searchResults = self.countries.filter { $0.localizedDisplayName.localizedLowercase.range(of: "\\b\(searchText)", options: .regularExpression, range: nil, locale: .current) != nil }
            }
        }
        
        self.searchResultsController.searchResults = searchResults
    }
}

// MARK: - GCSearchResultsDelegate

extension GCCountryPickerViewController: GCSearchResultsDelegate {
    
    func searchResultsController(_ searchResultsController: GCSearchResultsController, didSelectSearchResult searchResult: GCCountry) {
        
        self.delegate?.countryPicker(self, didSelectCountry: searchResult)
    }
}

// MARK: - Table View

extension GCCountryPickerViewController {
    
    fileprivate func configureTableView() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
}

// MARK: - UITableViewDelegate

extension GCCountryPickerViewController {
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Parameter section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries.count
    }
    
    /// Tells the delegate that the specified row is now selected.
    ///
    /// The delegate handles selections in this method. One of the things it can do is exclusively assign the check-mark image (checkmark) to one row in a section (radio-list style). This method isn’t called when the isEditing property of the table is set to true (that is, the table view is in editing mode). See "Managing Selections" in Table View Programming Guide for iOS for further information (and code examples) related to this method.
    ///
    /// - Parameter tableView: A table-view object informing the delegate about the new row selection.
    /// - Parameter indexPath: An index path locating the new selected row in tableView.
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.countryPicker(self, didSelectCountry: self.countries[indexPath.row])
    }
}

// MARK: - UITableViewDataSource

extension GCCountryPickerViewController {
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// The returned UITableViewCell object is frequently one that the application reuses for performance reasons. You should fetch a previously created cell object that is marked for reuse by sending a dequeueReusableCell(withIdentifier:) message to tableView. Various attributes of a table cell are set automatically based on whether the cell is a separator and on information the data source provides, such as for accessory views and editing controls.
    ///
    /// - Parameter tableView: A table-view object requesting the cell.
    /// - Parameter indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil.
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.countries[indexPath.row].localizedDisplayName
        
        return cell
    }
}
