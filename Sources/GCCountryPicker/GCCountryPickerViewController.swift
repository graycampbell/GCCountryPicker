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
    
    fileprivate let displayMode: GCCountryPickerDisplayMode
    
    fileprivate var countries: [[GCCountry]]!
    fileprivate var searchController: UISearchController!
    fileprivate var searchResultsController: GCSearchResultsController!
    
    fileprivate var collation = UILocalizedIndexedCollation.current()
    fileprivate var sectionTitles = UILocalizedIndexedCollation.current().sectionTitles
    fileprivate var sectionIndexTitles = UILocalizedIndexedCollation.current().sectionIndexTitles
    
    fileprivate let defaultCountryCodes: [String] = ["AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW"]
    
    // MARK: Initializers
    
    /// Initializes and returns a newly allocated country picker view controller object.
    ///
    /// - Parameter displayMode: The display mode for the country picker.
    /// - Returns: An initialized country picker view controller object.
    
    public init(displayMode: GCCountryPickerDisplayMode) {
        
        self.displayMode = displayMode
        
        super.init(style: .plain)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        return nil
    }
}

// MARK: - View

extension GCCountryPickerViewController {
    
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
        
        switch self.displayMode {
            
            case .withCallingCodes:
                self.searchResultsController = GCSearchResultsController(displayMode: .withAccessoryTitles)
            
            case .withoutCallingCodes:
                self.searchResultsController = GCSearchResultsController(displayMode: .withoutAccessoryTitles)
        }
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController)
        
        self.searchController.searchResultsUpdater = self
        self.searchResultsController.delegate = self
        
        if #available(iOS 11.0, *) {
            
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        else {
            
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
        
        self.definesPresentationContext = true
    }
    
    @objc func cancel(barButtonItem: UIBarButtonItem) {
        
        self.delegate?.countryPickerDidCancel(self)
    }
}

// MARK: - UISearchResultsUpdating

extension GCCountryPickerViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        var searchResults = [GCSearchResult]()
        
        if let searchText = searchController.searchBar.text?.localizedLowercase.replacingOccurrences(of: "(^\\s+)|(\\s+$)", with: "", options: .regularExpression, range: nil) {
            
            if !searchText.isEmpty {
                
                for country in self.countries.joined() {
                    
                    var countryMatchesSearchText: Bool = false
                    
                    if let _ = country.localizedDisplayName.localizedLowercase.range(of: "\\b(\(searchText))", options: .regularExpression, range: nil, locale: .current) {
                        
                        countryMatchesSearchText = true
                    }
                    else if self.displayMode == .withCallingCodes, let _ = country.callingCode?.range(of: "^.{1}(\(searchText))", options: .regularExpression, range: nil, locale: nil) {
                        
                        countryMatchesSearchText = true
                    }
                    
                    if countryMatchesSearchText {
                        
                        let searchResult = GCSearchResult(object: country, displayTitle: country.localizedDisplayName, accessoryTitle: country.callingCode)
                        
                        searchResults.append(searchResult)
                    }
                }
            }
        }
        
        self.searchResultsController.update(withSearchResults: searchResults)
    }
}

// MARK: - GCSearchResultsDelegate

extension GCCountryPickerViewController: GCSearchResultsDelegate {
    
    func searchResultsController(_ searchResultsController: GCSearchResultsController, didSelectSearchResult searchResult: GCSearchResult) {
        
        if let country = searchResult.object as? GCCountry {
            
            self.delegate?.countryPicker(self, didSelectCountry: country)
        }
    }
}

// MARK: - Table View

extension GCCountryPickerViewController {
    
    fileprivate func configureTableView() {
        
        self.tableView.rowHeight = 44
        self.tableView.sectionHeaderHeight = 28
    }
}

// MARK: - UITableViewDelegate

extension GCCountryPickerViewController {
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") ?? UITableViewHeaderFooterView(reuseIdentifier: "SectionHeaderView")
        
        headerView.textLabel?.text = self.sectionTitles[section]
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        headerView.textLabel?.textColor = .black
        
        return headerView
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.countryPicker(self, didSelectCountry: self.countries[indexPath.section][indexPath.row])
    }
}

// MARK: - UITableViewDataSource

extension GCCountryPickerViewController {
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.countries.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries[section].count
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return self.sectionIndexTitles
    }
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return self.collation.section(forSectionIndexTitle: index)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        let country = self.countries[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = country.localizedDisplayName
        
        switch self.displayMode {
            
            case .withCallingCodes:
                cell.detailTextLabel?.text = country.callingCode
            
            case .withoutCallingCodes:
                break
        }
        
        return cell
    }
}
