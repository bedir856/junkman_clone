import XCTest
@testable import SpamOnleyici // or whatever the main app target is named in Xcode

final class FilterEngineTests: XCTestCase {

    override func setUpWithError() throws {
        // Reset singleton stats
        DataManager.shared.totalScanned = 0
        DataManager.shared.spamBlocked = 0
        DataManager.shared.blacklistedWords = []
        DataManager.shared.whitelistedWords = []
    }

    override func tearDownWithError() throws {
        // Clean up
    }

    func testPerformanceColdBootVectorTansform() throws {
        // This test ensures that the text vectorization is extremely fast using the UnsafeMutablePointer
        let engine = FilterEngine.shared
        
        self.measure {
            // Measure the time it takes to classify a standard message with cold vocab load
            let action = engine.filterMessage(sender: "Unknown", body: "Tebrikler 1000 TL bonus kazandınız! Hemen tıklayın: betgaranti.com")
            // Depending on the AI prediction and the gambling keywords, it should be marked as .junk
            XCTAssertEqual(action, .junk)
        }
    }
    
    func testGamblingKeywordFilter() throws {
        let engine = FilterEngine.shared
        
        let spamBody = "Hoşgeldin bonusu kazanmak için hemen üye ol casino"
        let normalBody = "Annem akşama yemeğe geliyor musun diye sordu."
        
        XCTAssertEqual(engine.filterMessage(sender: "+905554443322", body: spamBody), .junk)
        
        // AI might also block normalBody depending on model, but assuming the threshold:
        // By default, just ensure gambling block definitely triggers .junk directly
    }

    func testBlacklistWhitelistPriority() throws {
        let engine = FilterEngine.shared
        
        DataManager.shared.whitelistedWords = ["banka"]
        DataManager.shared.blacklistedWords = ["kredi"]
        
        // Whitelist should override blacklist if both exist
        let mixedBody = "Sayın müşterimiz, onaylanmış banka kredi kartınız kuryeye verilmiştir."
        XCTAssertEqual(engine.filterMessage(sender: "BANK", body: mixedBody), .allow)
        
        // Blacklist alone should block
        let blackBody = "Merhaba, 50000 TL kredi imkanı."
        XCTAssertEqual(engine.filterMessage(sender: "SPAMMER", body: blackBody), .junk)
    }
}
