//
//  GCCountryTests.swift
//  GCCountryPickerTests
//
//  Created by Gray Campbell on 11/3/17.
//

import XCTest
@testable import GCCountryPicker

class GCCountryTests: XCTestCase {
    
    func testFailableInitializer() {
        
        let country1 = GCCountry(countryCode: "LOL")
        let country2 = GCCountry(countryCode: "DE")
        
        XCTAssertNil(country1)
        XCTAssertNotNil(country2)
    }
    
    func testCountryCode() {
        
        let country1 = GCCountry(countryCode: "us")
        let country2 = GCCountry(countryCode: "uS")
        let country3 = GCCountry(countryCode: "Us")
        let country4 = GCCountry(countryCode: "US")
        
        XCTAssertNotNil(country1)
        XCTAssertNotNil(country2)
        XCTAssertNotNil(country3)
        XCTAssertNotNil(country4)
        
        XCTAssert(country1?.countryCode == "US", String(describing: country1?.countryCode))
        XCTAssert(country2?.countryCode == "US", String(describing: country2?.countryCode))
        XCTAssert(country3?.countryCode == "US", String(describing: country3?.countryCode))
        XCTAssert(country4?.countryCode == "US", String(describing: country4?.countryCode))
    }
    
    func testCallingCode() {
        
        let country1 = GCCountry(countryCode: "HM")
        let country2 = GCCountry(countryCode: "US")
        
        XCTAssertNotNil(country1)
        XCTAssertNotNil(country2)
        
        XCTAssertNil(country1?.callingCode)
        XCTAssertNotNil(country2?.callingCode)
        
        XCTAssert(country2?.callingCode == "+1", String(describing: country2?.callingCode))
    }
    
    func testPossibleCountries() {
        
        for countryCode in Locale.isoRegionCodes {
            
            let country = GCCountry(countryCode: countryCode)
            
            XCTAssertNotNil(country, "Country Code: \(countryCode)")
        }
    }
}
