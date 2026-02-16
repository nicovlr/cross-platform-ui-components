import XCTest
import UIKit

final class ImageCacheTests: XCTestCase {
    func testCacheStoresAndRetrieves() {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/test.png")!
        let image = UIImage(systemName: "star")!
        cache.set(image, for: url)
        let retrieved = cache.get(for: url)
        XCTAssertNotNil(retrieved)
    }

    func testCacheReturnsNilForMissing() {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/nonexistent-\(UUID()).png")!
        XCTAssertNil(cache.get(for: url))
    }
}
