//
//  JSONDataProviderTests.swift
//  AHAssessmentTests
//
//  Created by Sergei Podnebesnyi on 21.04.2023.
//

import XCTest
@testable import AHAssessment

final class JSONDataProviderTests: XCTestCase {

    let jsonDataProvider = JSONDataProvider()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPopulateTypes() throws {
        let dataJson = [["key": "print", "value" : 1234 as Int64],
                        ["key" : "coins", "value" : 12345 as Int64],
                        ["key" : "picture", "value" : 123456 as Int64],
                        ["key" : "", "value" : "abc"], //bad element,
                        ["key" : "medals", "value" : "abc"] //bad element
                        as [String : Any]]
        
        let resultArray = jsonDataProvider.populateTypes(dataJson)
        
        XCTAssertTrue(resultArray.count == 3, "Error while populating ArtTypes")
        
        let firstElement = resultArray.first!
        
        XCTAssertTrue(firstElement.name == "print", "Error while creating ArtType")
        XCTAssertTrue(firstElement.value == 1234 as Int64, "Error while creating ArtType")
        
        let lastElement = resultArray.last!
        
        XCTAssertTrue(lastElement.name == "picture", "Error while creating ArtType")
        XCTAssertTrue(lastElement.value == 123456 as Int64, "Error while creating ArtType")
    }
    
    
    func testPopulateArtObjects() throws {
        
        let testUrl = "https://lh4.ggpht.com/4GShr22iPXY9ehpzXmBS9W8XcD3iLCSXrtzSJU5JFZx3pVMOKvvIAhliRVh7GD-PHkwI938jK7ZxPjWZ87LbIWdiTFs=s0"
        let dataJson = //First Element with array in productionPlaces
        [["headerImage": ["url" : testUrl, "width" : 1920 as Int64] as [String : Any],
          "id" : "en-RP-P-H-1340",
          "title" : "Italianiserend landschap met herder en hond",
          "longTitle" : "Italianiserend landschap met herder en hond, 1854",
          "productionPlaces" : ["Netherlands", "Europe"], //With array
          "principalOrFirstMaker" : "Karel du Jardin",
          "webImage" : ["url" : testUrl]], //first element
         
         //Second element with single string in productionPlaces
         ["headerImage": ["url" : testUrl, "width" : 1920 as Int64] as [String : Any],
          "id" : "en-RP-P-H-1340",
          "title" : "Italianiserend landschap met herder en hond",
          "longTitle" : "Italianiserend landschap met herder en hond, 1854",
          "productionPlaces" : "Netherlands", //second element with single string in productionPlaces
          "principalOrFirstMaker" : "Karel du Jardin",
          "webImage" : ["url" : testUrl]] as [String : Any],
         
         //Third element with missing url in header image
         
         ["headerImage": ["url" : "", "width" : 1920 as Int64] as [String : Any],
          "id" : "en-RP-P-H-1340",
          "title" : "Italianiserend landschap met herder en hond",
          "longTitle" : "Italianiserend landschap met herder en hond, 1854",
          "productionPlaces" : "Netherlands", //second element with single string in productionPlaces
          "principalOrFirstMaker" : "Karel du Jardin",
          "webImage" : ["url" : "https://lh4.ggpht.com/4GShr22iPXY9ehpzXmBS9W8XcD3iLCSXrtzSJU5JFZx3pVMOKvvIAhliRVh7GD-PHkwI938jK7ZxPjWZ87LbIWdiTFs=s0"]],
         
         //Forth element with missing webImage url
         ["headerImage": ["url" : "https://lh4.ggpht.com/4GShr22iPXY9ehpzXmBS9W8XcD3iLCSXrtzSJU5JFZx3pVMOKvvIAhliRVh7GD-PHkwI938jK7ZxPjWZ87LbIWdiTFs=s0", "width" : 1920 as Int64] as [String : Any],
          "id" : "en-RP-P-H-1340",
          "title" : "Italianiserend landschap met herder en hond",
          "longTitle" : "Italianiserend landschap met herder en hond, 1854",
          "productionPlaces" : "Netherlands", //second element with single string in productionPlaces
          "principalOrFirstMaker" : "Karel du Jardin",
          "webImage" : ["url" : ""]]]

        
        let resultArray = jsonDataProvider.populateArtObjects(dataJson)
        
        XCTAssertTrue(resultArray.count == 2, "Error while populating ArtTypes: Array count is wrong")
        
        let firstElement = resultArray.first!
        
        XCTAssertTrue(firstElement.id == "en-RP-P-H-1340", "Error while creating ArtObject")
        XCTAssertTrue(firstElement.title == "Italianiserend landschap met herder en hond",
                      "Error while creating ArtObject")
        XCTAssertTrue(firstElement.principalOrFirstMaker == "Karel du Jardin", "Error while creating ArtObject")
        XCTAssertTrue(firstElement.productionPlaces == "Netherlands, Europe", "Error while creating ArtObject")
        XCTAssertTrue(firstElement.longTitle == "Italianiserend landschap met herder en hond, 1854",
                      "Error while creating ArtObject")
        XCTAssertTrue(firstElement.webImageUrl == testUrl, "Error while creating ArtObject")
        XCTAssertTrue(firstElement.headerImageUrl == testUrl, "Error while creating ArtObject")

        let lastElement = resultArray.last!
        
        XCTAssertTrue(lastElement.productionPlaces == "Netherlands", "Error while creating ArtObject")
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
