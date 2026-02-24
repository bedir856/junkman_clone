import Foundation

// In a real iOS app, this would use UserDefaults(suiteName: "group.com.yourcompany.junkman")
// to share data between the App and the Extension.

class DataManager {
    static let shared = DataManager()
    
    // App Group Identifier
    private let suiteName = "group.com.yourcompany.junkman"
    private let defaults: UserDefaults
    
    // In-memory cache for extension fast read
    private var _isAiEnabled: Bool?
    private var _isGamblingFilterEnabled: Bool?
    private var _blacklistedWords: [String]?
    private var _whitelistedWords: [String]?
    private var _blacklistedSenders: [String]?
    private var _whitelistedSenders: [String]?
    
    private init() {
        // Fallback to standard if suite is not available (dev mode)
        self.defaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }
    
    // MARK: - Settings
    
    var isAiEnabled: Bool {
        get {
            if let cached = _isAiEnabled { return cached }
            let val = defaults.object(forKey: "isAiEnabled") as? Bool ?? true
            _isAiEnabled = val
            return val
        }
        set {
            _isAiEnabled = newValue
            defaults.set(newValue, forKey: "isAiEnabled")
        }
    }
    
    var isGamblingFilterEnabled: Bool {
        get {
            if let cached = _isGamblingFilterEnabled { return cached }
            let val = defaults.object(forKey: "isGamblingFilterEnabled") as? Bool ?? true
            _isGamblingFilterEnabled = val
            return val
        }
        set {
            _isGamblingFilterEnabled = newValue
            defaults.set(newValue, forKey: "isGamblingFilterEnabled")
        }
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
        get {
            if let cached = _blacklistedWords { return cached }
            let val = defaults.stringArray(forKey: "blacklistedWords") ?? []
            _blacklistedWords = val
            return val
        }
        set {
            _blacklistedWords = newValue
            defaults.set(newValue, forKey: "blacklistedWords")
        }
    }
    
    var whitelistedWords: [String] {
        get {
            if let cached = _whitelistedWords { return cached }
            let val = defaults.stringArray(forKey: "whitelistedWords") ?? []
            _whitelistedWords = val
            return val
        }
        set {
            _whitelistedWords = newValue
            defaults.set(newValue, forKey: "whitelistedWords")
        }
    }
    
    var blacklistedSenders: [String] {
        get {
            if let cached = _blacklistedSenders { return cached }
            let val = defaults.stringArray(forKey: "blacklistedSenders") ?? []
            _blacklistedSenders = val
            return val
        }
        set {
            _blacklistedSenders = newValue
            defaults.set(newValue, forKey: "blacklistedSenders")
        }
    }
    
    var whitelistedSenders: [String] {
        get {
            if let cached = _whitelistedSenders { return cached }
            let val = defaults.stringArray(forKey: "whitelistedSenders") ?? []
            _whitelistedSenders = val
            return val
        }
        set {
            _whitelistedSenders = newValue
            defaults.set(newValue, forKey: "whitelistedSenders")
        }
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
