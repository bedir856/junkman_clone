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
    
    // Lazy load model to prevent cold-start timeout
    // We now use staticVocab natively compiled, no JSON required
    private lazy var model: SpamClassifier? = loadModel()
    
    private init() {}
    
    // MARK: - Initialization
    

    
    private func loadModel() -> SpamClassifier? {
        // Initialize the CoreML model
        do {
            let config = MLModelConfiguration()
            return try SpamClassifier(configuration: config)
        } catch {
            print("Failed to load CoreML model: \(error)")
            return nil
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
            return .junk
        }
        
        // 2. Check Gambling/Betting Keywords
        if DataManager.shared.isGamblingFilterEnabled {
            if isGambling(body: body) {
                DataManager.shared.spamBlocked += 1
                return .junk
            }
        }
        
        // 3. ML Inference
        if DataManager.shared.isAiEnabled {
            let prediction = predict(body: body)
            
            switch prediction {
            case .junk:
                DataManager.shared.spamBlocked += 1
                return .junk
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
        let count = 4000
        let vector = try MLMultiArray(shape: [count] as [NSNumber], dataType: .double)
        
        // Direct memory access for millisecond-level initialization and filling
        let pointer = vector.dataPointer.bindMemory(to: Double.self, capacity: count)
        pointer.initialize(repeating: 0.0, count: count)
        
        // Simple Tokenization (split by whitespace, lowercase, remove punctuation)
        let words = text.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        for word in words {
            if let index = staticVocab[word] {
                // Increment counts directly in memory
                pointer[index] += 1.0
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
            // User Reported Keywords
            "cassinox", "kazan365", "sheratonbet", "vayda", "vaysms", "salla kazan",
            "çevrim şartı", "cevrim sarti", "havale", "iade", "çark", "cark",
            "global site", "rtp", "casinoroys", "roys",
        
            // Turkish Keywords
            "bahis", "casino", "bet", "bonus", "freespin", "free spin",
            "çevrimsiz", "yatırım", "deneme bonusu", "slot", "rulet",
            "poker", "iddaa", "kazanç", "şans", "jackpot", "betting",
            "kumar", "canlı bahis", "kaçak bahis", "bedava", "yüksek oran",
            "hoşgeldin bonusu", "şartsız", "katla", "tıkla", "hemen üye ol",
            "giriş yap", "promosyon", " discount", "aviator", "sweet bonanza",
            "gates of olympus", "yasal bahis", "güvenilir bahis",
            
            // Site names (Common fragments)
            "betgaranti", "vaycasino", "holiganbet", "jojobet", "betturkey",
            "casinomega", "maxwin", "meritroyal", "tempobet", "bets10",
            
            // English Keywords
            "deposit", "withdraw", "wager", "prize", "gamstop", "igaming",
            "claim now", "sign up", "welcome offer", "exclusive deal"
        ]
        
        for k in keywords {
            if lowerBody.contains(k) { return true }
        }
        return false
    }
    // MARK: - Debug
    
    var debugVocabSize: Int {
        return staticVocab.count
    }
    
    var debugModelStatus: String {
        return model == nil ? "Nil" : "Loaded"
    }
}
