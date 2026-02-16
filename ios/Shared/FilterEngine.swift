import Foundation
import CoreML
import IdentityLookup

enum FilterAction {
    case allow
    case junk
    case transaction
    case promotion
}

class FilterEngine {
    static let shared = FilterEngine()
    
    private var vocab: [String: Int] = [:]
    private var model: SpamClassifier?
    
    private init() {
        loadVocab()
        loadModel()
    }
    
    // MARK: - Initialization
    
    private func loadVocab() {
        // Load vocab.json from bundle
        guard let url = Bundle.main.url(forResource: "vocab", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let list = try? JSONDecoder().decode([String].self, from: data) else {
            print("Failed to load vocab.json")
            return
        }
        
        // Create a fast lookup map
        for (index, word) in list.enumerated() {
            vocab[word] = index
        }
    }
    
    private func loadModel() {
        // Initialize the CoreML model
        // Note: SpamClassifier is the auto-generated class from the .mlmodel file
        do {
            let config = MLModelConfiguration()
            self.model = try SpamClassifier(configuration: config)
        } catch {
            print("Failed to load CoreML model: \(error)")
        }
    }
    
    // MARK: - Main Logic
    
    func filterMessage(sender: String, body: String) -> ILMessageFilterAction {
        // Increment Scan Count
        DataManager.shared.totalScanned += 1
        
        // 1. Check Blacklist/Whitelist (Overrides ML)
        if isWhitelisted(sender: sender, body: body) {
            return .allow
        }
        
        if isBlacklisted(sender: sender, body: body) {
            DataManager.shared.spamBlocked += 1
            return .junk // Or .filter
        }
        
        // 2. Check Gambling/Betting Keywords
        if DataManager.shared.isGamblingFilterEnabled {
            if isGambling(body: body) {
                DataManager.shared.spamBlocked += 1
                return .filter // or .junk
            }
        }
        
        // 3. ML Inference
        if DataManager.shared.isAiEnabled {
            let prediction = predict(body: body)
            
            switch prediction {
            case .junk:
                DataManager.shared.spamBlocked += 1
                return .filter // or .junk
            case .allow:
                return .allow // or .none
            default:
                return .none
            }
        }
        
        return .none
    }
    
    // MARK: - ML Prediction
    
    private func predict(body: String) -> FilterAction {
        guard let model = model else { return .allow }
        
        // Convert body to feature vector
        do {
            let inputVector = try textToVector(body)
            let output = try model.prediction(input_vector: inputVector)
            
            // Output is 1 (Spam) or 0 (Ham)
            if output.classLabel == 1 {
                return .junk
            } else {
                return .allow
            }
        } catch {
            print("Prediction error: \(error)")
            return .allow
        }
    }
    
    private func textToVector(_ text: String) throws -> MLMultiArray {
        // Create a MultiArray of size 4000 (must match Python training)
        let vector = try MLMultiArray(shape: [4000], dataType: .double)
        
        // Initialize to 0
        for i in 0..<vector.count {
            vector[i] = 0
        }
        
        // Simple Tokenization (split by whitespace, lowercase, remove punctuation)
        let words = text.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        for word in words {
            if let index = vocab[word] {
                // Determine if we are just setting to 1 (Binary) or counting
                // LogisticRegression expected counts? CountVectorizer produces counts.
                // So we should increment.
                let currentVal = vector[index].doubleValue
                vector[index] = NSNumber(value: currentVal + 1.0)
            }
        }
        
        return vector
    }
    
    // MARK: - Rules
    
    private func isWhitelisted(sender: String, body: String) -> Bool {
        let dm = DataManager.shared
        if dm.whitelistedSenders.contains(sender) { return true }
        for word in dm.whitelistedWords {
            if body.contains(word) { return true }
        }
        return false
    }
    
    private func isBlacklisted(sender: String, body: String) -> Bool {
        let dm = DataManager.shared
        if dm.blacklistedSenders.contains(sender) { return true }
        for word in dm.blacklistedWords {
            if body.contains(word) { return true }
        }
        return false
    }
    
    private func isGambling(body: String) -> Bool {
        let lowerBody = body.lowercased()
        let keywords = [
            "bahis", "casino", "bet", "bonus", "freespin", "çevrimsiz", 
            "yatırım", "deneme bonusu", "slot", "rulet", "poker", "iddaa",
            "kazanç", "şans", "jackpot", "betting", "kumar"
        ]
        
        for k in keywords {
            if lowerBody.contains(k) { return true }
        }
        return false
    }
}
