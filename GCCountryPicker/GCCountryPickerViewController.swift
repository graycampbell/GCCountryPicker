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
    
    fileprivate var countries: [[GCCountry]]!
    fileprivate var countryCodes: [String]!
    fileprivate var searchController: UISearchController!
    fileprivate var searchResultsController = GCSearchResultsController()
    
    fileprivate let currentCollation = UILocalizedIndexedCollation.current()
    
    fileprivate var defaultCountryCodes: [String] {
        
        if let url = Bundle(for: GCCountryPickerViewController.self).url(forResource: "CountryCodes", withExtension: "plist") {
            
            if let countryCodes = NSArray(contentsOf: url) as? [String] {
                
                return countryCodes
            }
        }
        
        return []
    }
    
    // MARK: Initializers
    
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter coder: An unarchiver object.
    /// - Returns: self, initialized using the data in decoder.
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.countryCodes = self.defaultCountryCodes
    }
    
    /// Initializes and returns a newly allocated country picker view controller object.
    ///
    /// By default, the country picker interface displays the 249 countries that have been officially assigned ISO 3166-1 alpha-2 codes as part of the ISO 3166 standard. You can customize which countries the country picker interface displays by initializing the controller with a collection of ISO 3166-1 alpha-2 country codes.
    ///
    /// - Parameter countryCodes: A collection of ISO 3166-1 alpha-2 country codes representing countries for the country picker interface to display.
    /// - Returns: An initialized country picker view controller object.
    
    public init(countryCodes: [String]? = nil) {
        
        super.init(style: .plain)
        
        self.countryCodes = countryCodes ?? self.defaultCountryCodes
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
        
        var unsortedCountries = [Int: [GCCountry]]()
        
        for countryCode in self.countryCodes {
            
            if let country = GCCountry(countryCode: countryCode) {
                
                let section = self.currentCollation.section(for: country, collationStringSelector: #selector(getter: GCCountry.localizedDisplayName))
                
                if unsortedCountries[section] == nil {
                    
                    unsortedCountries[section] = [country]
                }
                else {
                    
                    unsortedCountries[section]?.append(country)
                }
            }
        }
        
        self.countries = Array(repeating: [GCCountry](), count: self.currentCollation.sectionTitles.count)
        
        for (section, collection) in unsortedCountries {
            
            self.countries[section] = self.currentCollation.sortedArray(from: collection, collationStringSelector: #selector(getter: GCCountry.localizedDisplayName)) as! [GCCountry]
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
                
                searchResults = self.countries.joined().filter { $0.localizedDisplayName.localizedLowercase.range(of: "\\b\(searchText)", options: .regularExpression, range: nil, locale: .current) != nil }
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
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
    }
}

// MARK: - UITableViewDelegate

extension GCCountryPickerViewController {
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.countries.count
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return self.currentCollation.sectionIndexTitles
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView")
        
        headerView?.textLabel?.text = self.currentCollation.sectionTitles[section]
        
        return headerView
    }
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return self.currentCollation.section(forSectionIndexTitle: index)
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Parameter section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries[section].count
    }
    
    /// Tells the delegate that the specified row is now selected.
    ///
    /// The delegate handles selections in this method. One of the things it can do is exclusively assign the check-mark image (checkmark) to one row in a section (radio-list style). This method isn’t called when the isEditing property of the table is set to true (that is, the table view is in editing mode). See "Managing Selections" in Table View Programming Guide for iOS for further information (and code examples) related to this method.
    ///
    /// - Parameter tableView: A table-view object informing the delegate about the new row selection.
    /// - Parameter indexPath: An index path locating the new selected row in tableView.
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.countryPicker(self, didSelectCountry: self.countries[indexPath.section][indexPath.row])
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
        
        cell.textLabel?.text = self.countries[indexPath.section][indexPath.row].localizedDisplayName
        
        return cell
    }
}
