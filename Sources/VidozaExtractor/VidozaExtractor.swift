import Foundation

public class VidozaExtractor {
    
    public enum ExtractionError: Error {
        case htmlDecodingError
        case videoNotFound
        case invalidVideoURL
    }
    
    /// extracts direct video url from raw html of embedded vidoza page
    /// - parameter html: HTML of video page on vidoza embedded frame
    /// - throws: ExtractionError
    /// - returns: video url when found
    public class func extract(fromHTML html: String) throws -> URL {
        
        let pattern = #"<source .*src="(?<url>\S*)"[^>]+>"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        guard let match = regex?.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count)) else {
            throw ExtractionError.videoNotFound
        }
        
        let matchRange = match.range(at: 1)
        guard let range = Range(matchRange, in: html) else {
            throw ExtractionError.videoNotFound
        }
        
        let videoURL = String(html[range])
        
        guard let url = URL(string: videoURL) else {
            throw ExtractionError.invalidVideoURL
        }
        
        return url
    }
    
    
    /// extracts direct video url from standard or embedded vidoza url
    /// - parameter url: vidoza url (e.g.: https://vidoza.net/embed-z3gtfm6ezhvb.html)
    /// - parameter completion: called when result is found. returns video url
    public class func extract(fromURL url: URL, completion: @escaping (URL?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                let htmlContent = String(data: data, encoding: .utf8) else {
                completion(nil)
                return
            }
            
            completion(try? extract(fromHTML: htmlContent))
            
        }.resume()
        
    }
    
    
    /// extracts direct video url from standard or embedded vidoza url
    /// - parameter url: vidoza url (e.g.: https://vidoza.net/embed-z3gtfm6ezhvb.html)
    /// - returns: direct video url
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    public class func extract(fromURL url: URL) async throws -> URL {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let htmlContent = String(data: data, encoding: .utf8) else {
            throw ExtractionError.htmlDecodingError
        }
        
        return try extract(fromHTML: htmlContent)
    }
    
}
