import Foundation

public class VidozaExtractor {
    
    /// extracts direct video url from raw html of embedded vidoza page
    /// - parameter html: HTML of video page on vidoza embedded frame
    /// - returns: video url when found
    public class func extract(fromHTML html: String) -> URL? {
        
        let pattern = #"<source .*src="(?<url>\S*)"[^>]+>"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        guard let match = regex?.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count)) else { return nil }
        
        let matchRange = match.range(at: 1)
        guard let range = Range(matchRange, in: html) else { return nil }
        
        let videoURL = String(html[range])
        
        return URL(string: videoURL)
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
            
            completion(extract(fromHTML: htmlContent))
            
        }.resume()
        
    }
    
}
