import XCTest
@testable import VidozaExtractor

final class VidozaExtractorTests: XCTestCase {
    
    func testSourceURL(_ sourceURL: URL) -> URL? {
        
        let expectation = self.expectation(description: "extraction")
        var url: URL?
        
        VidozaExtractor.extract(fromURL: sourceURL) { videoURL in
            url = videoURL
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
        
        return url
    }
    
    func testUnavailableURL() {
        let url = testSourceURL(URL(string: "https://vidoza.net/embed-z3gtgg6ezddb.html")!)
        
        XCTAssertNil(url)
    }
    
    func testBunnyVideo() {
        let url = testSourceURL(URL(string: "https://vidoza.net/embed-eejmlkkjw45s.html")!)
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.pathExtension, "mp4")
    }
    

    static var allTests = [
        ("testUnavailableURL", testUnavailableURL),
        ("testBunnyVideo", testBunnyVideo)
    ]
}
