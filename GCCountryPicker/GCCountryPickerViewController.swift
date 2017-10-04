//
//  GCCountryPickerViewController.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit

// MARK: Properties & Initializers

/// The GCCountryPickerViewController class defines a view controller containing a country picker interface.
///
/// By default, the country picker interface displays the 249 countries that have been officially assigned ISO 3166-1 alpha-2 country codes as part of the ISO 3166 standard. You can customize which countries the country picker interface displays by setting the data source property and adopting the GCCountryPickerDataSource protocol.

public final class GCCountryPickerViewController: UITableViewController {
    
    // MARK: Properties
    
    /// The object that acts as the delegate of the country picker view controller.
    
    public var delegate: GCCountryPickerDelegate?
    
    /// The object that acts as the data source of the country picker view controller.
    
    public var dataSource: GCCountryPickerDataSource?
    
    fileprivate var countries: [[GCCountry]]!
    fileprivate var searchController: UISearchController!
    fileprivate var searchResultsController = GCSearchResultsController()
    
    fileprivate var collation = UILocalizedIndexedCollation.current()
    fileprivate var sectionTitles = UILocalizedIndexedCollation.current().sectionTitles
    fileprivate var sectionIndexTitles = UILocalizedIndexedCollation.current().sectionIndexTitles
    
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
    }
    
    /// Initializes and returns a newly allocated country picker view controller object.
    ///
    /// - Returns: An initialized country picker view controller object.
    
    public init() {
        
        super.init(style: .plain)
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
        
        self.countries = Array(repeating: [GCCountry](), count: self.sectionTitles.count)
        
        let keys = 0...self.sectionTitles.count - 1
        let values = Array(repeating: [GCCountry](), count: self.sectionTitles.count)
        
        var sections = Dictionary(uniqueKeysWithValues: zip(keys, values))
        
        let countryCodes = self.dataSource?.countryCodes(for: self) ?? self.defaultCountryCodes
        
        for countryCode in countryCodes {
            
            if let country = GCCountry(countryCode: countryCode) {
                
                let section = self.collation.section(for: country, collationStringSelector: #selector(getter: GCCountry.localizedDisplayName))
                
                sections[section]?.append(country)
            }
        }
        
        var emptySections = [Int]()
        
        for (section, value) in sections {
            
            if value.isEmpty {
                
                emptySections.append(section)
            }
            else {
                
                self.countries[section] = self.collation.sortedArray(from: value, collationStringSelector: #selector(getter: GCCountry.localizedDisplayName)) as! [GCCountry]
            }
        }
        
        for section in emptySections.sorted(by: { $0 > $1 }) {
            
            self.countries.remove(at: section)
            self.sectionTitles.remove(at: section)
            self.sectionIndexTitles.remove(at: section)
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
    
    /// Asks the delegate for a view object to display in the header of the specified section of the table view.
    ///
    /// The returned object can be a UILabel or UIImageView object, as well as a custom view. This method only works correctly when tableView(_:heightForHeaderInSection:) is also implemented.
    ///
    /// - Parameter tableView: The table-view object asking for the view object.
    /// - Parameter section: An index number identifying a section of tableView.
    /// - Returns: A view object to be displayed in the header of section.
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView")
        
        headerView?.textLabel?.text = self.sectionTitles[section]
        headerView?.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        headerView?.textLabel?.textColor = .black
        
        return headerView
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
    
    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView. The default value is 1.
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.countries.count
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Parameter section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries[section].count
    }
    
    /// Asks the data source to return the titles for the sections for a table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Returns: An array of strings that serve as the title of sections in the table view and appear in the index list on the right side of the table view. The table view must be in the plain style (UITableViewStylePlain). For example, for an alphabetized list, you could return an array containing strings “A” through “Z”.
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return self.sectionIndexTitles
    }
    
    /// Asks the data source to return the index of the section having the given title and section title index.
    ///
    /// This method is passed the index number and title of an entry in the section index list and should return the index of the referenced section. To be clear, there are two index numbers in play here: an index to a section index title in the array returned by sectionIndexTitles(for:), and an index to a section of the table view; the former is passed in, and the latter is returned. You implement this method only for table views with a section index list—which can only be table views created in the plain style (plain). Note that the array of section titles returned by sectionIndexTitles(for:) can have fewer items than the actual number of sections in the table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Parameter title: The title as displayed in the section index of tableView.
    /// - Parameter index: An index number identifying a section title in the array returned by sectionIndexTitles(for:).
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return self.collation.section(forSectionIndexTitle: index)
    }
    
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
