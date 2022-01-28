# VidozaExtractor

Extracts raw video urls from any vidoza.net video.

## Usage
Get video path from vidoza url:
```swift
let url = URL(string: "https://vidoza.net/embed-6mdl4lhngypq.html")!
VidozaExtractor.extract(fromURL: url) { videoURL in
    // do stuff with retrieved videoURL
}
```
or using async/await:
```swift
let videoURL = try await VidozaExtractor.extract(fromURL: url)
```
