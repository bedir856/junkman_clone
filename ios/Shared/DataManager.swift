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
