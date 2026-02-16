import Foundation

// In a real iOS app, this would use UserDefaults(suiteName: "group.com.yourcompany.junkman")
// to share data between the App and the Extension.

class DataManager {
    static let shared = DataManager()
    
    // App Group Identifier
    private let suiteName = "group.com.yourcompany.junkman"
    private let defaults: UserDefaults
    
    private init() {
        // Fallback to standard if suite is not available (dev mode)
        self.defaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }
    
    // MARK: - Settings
    
    var isAiEnabled: Bool {
        get { defaults.object(forKey: "isAiEnabled") as? Bool ?? true }
        set { defaults.set(newValue, forKey: "isAiEnabled") }
    }
    
    var isGamblingFilterEnabled: Bool {
        get { defaults.object(forKey: "isGamblingFilterEnabled") as? Bool ?? true }
        set { defaults.set(newValue, forKey: "isGamblingFilterEnabled") }
    }
    
    // MARK: - Stats
    
    var totalScanned: Int {
        get { defaults.integer(forKey: "totalScanned") }
        set { defaults.set(newValue, forKey: "totalScanned") }
    }
    
    var spamBlocked: Int {
        get { defaults.integer(forKey: "spamBlocked") }
        set { defaults.set(newValue, forKey: "spamBlocked") }
    }

    // MARK: - Lists
    
    var blacklistedWords: [String] {
        get { defaults.stringArray(forKey: "blacklistedWords") ?? [] }
        set { defaults.set(newValue, forKey: "blacklistedWords") }
    }
    
    var whitelistedWords: [String] {
        get { defaults.stringArray(forKey: "whitelistedWords") ?? [] }
        set { defaults.set(newValue, forKey: "whitelistedWords") }
    }
    
    var blacklistedSenders: [String] {
        get { defaults.stringArray(forKey: "blacklistedSenders") ?? [] }
        set { defaults.set(newValue, forKey: "blacklistedSenders") }
    }
    
    var whitelistedSenders: [String] {
        get { defaults.stringArray(forKey: "whitelistedSenders") ?? [] }
        set { defaults.set(newValue, forKey: "whitelistedSenders") }
    }
    
    // MARK: - Helpers
    
    func addToBlacklist(word: String) {
        var list = blacklistedWords
        if !list.contains(word) {
            list.append(word)
            blacklistedWords = list
        }
    }
    
    func removeFromBlacklist(word: String) {
        var list = blacklistedWords
        list.removeAll { $0 == word }
        blacklistedWords = list
    }
    
    // Similar methods for other lists...
}

// Global Wrapper for SwiftUI
import SwiftUI

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
