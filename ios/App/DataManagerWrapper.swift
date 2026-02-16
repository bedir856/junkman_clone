import SwiftUI

// Global Wrapper for SwiftUI
class DataManagerWrapper: ObservableObject {
    @Published var isAiEnabled: Bool {
        didSet { DataManager.shared.isAiEnabled = isAiEnabled }
    }
    
    @Published var isGamblingEnabled: Bool {
        didSet { DataManager.shared.isGamblingFilterEnabled = isGamblingEnabled }
    }
    
    @Published var blacklistedWords: [String] {
        didSet { DataManager.shared.blacklistedWords = blacklistedWords }
    }
    
    @Published var whitelistedWords: [String] {
        didSet { DataManager.shared.whitelistedWords = whitelistedWords }
    }
    
    @Published var totalScanned: Int = DataManager.shared.totalScanned
    @Published var spamBlocked: Int = DataManager.shared.spamBlocked
    
    init() {
        self.isAiEnabled = DataManager.shared.isAiEnabled
        self.isGamblingEnabled = DataManager.shared.isGamblingFilterEnabled
        self.blacklistedWords = DataManager.shared.blacklistedWords
        self.whitelistedWords = DataManager.shared.whitelistedWords
    }
}
