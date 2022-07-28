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
    
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    func testUnavailableURLAsync() async {
        let url = URL(string: "https://vidoza.net/embed-z3gtgg6ezddb.html")!
        do {
            _ = try await VidozaExtractor.extract(fromURL: url)
            XCTFail("didn't throw")
        } catch let error {
            XCTAssertEqual(error as? VidozaExtractor.ExtractionError, .videoNotFound)
        }
    }
    
    func testInvalidURL() {
        let url = testSourceURL(URL(string: "https://fakevidoza.net/embed-z3gtgg6ezddb.html")!)
        
        XCTAssertNil(url)
    }
    
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    func testInvalidURLAsync() async {
        let url = URL(string: "https://fakevidoza.net/embed-z3gtgg6ezddb.html")!
        do {
            _ = try await VidozaExtractor.extract(fromURL: url)
            XCTFail("didn't throw")
        } catch let error {
            #if os(Linux)
            XCTAssert(!(error is VidozaExtractor.ExtractionError))
            #else
            XCTAssert(error is URLError)
            #endif
        }
    }
    
    func testBunnyVideo() {
        let url = testSourceURL(URL(string: "https://vidoza.net/embed-7msgas7ncac1.html")!)
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.pathExtension, "mp4")
    }
    
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    func testBunnyVideoAsync() async throws {
        let url = URL(string: "https://vidoza.net/embed-7msgas7ncac1.html")!
        let videoURL = try await VidozaExtractor.extract(fromURL: url)
        
        XCTAssertEqual(videoURL.pathExtension, "mp4")
    }
    

    static var allTests = [
        ("testUnavailableURL", testUnavailableURL),
        ("testInvalidURL", testInvalidURL),
        ("testBunnyVideo", testBunnyVideo)
    ]
}
