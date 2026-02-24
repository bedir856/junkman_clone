import Foundation

func cleanText(_ text: String) -> String {
    let invisibleChars: Set<Character> = ["\u{200B}", "\u{200C}", "\u{200D}", "\u{FEFF}", "\u{00AD}", "\u{2060}"]
    let filtered = String(text.filter { !invisibleChars.contains($0) })
    return filtered.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
}

func isGambling(body: String) -> Bool {
    let cleanBody = cleanText(body)
    let foldedBody = cleanBody.folding(options: .diacriticInsensitive, locale: .current).lowercased()
    print("Normalleştirilmiş metin: \(foldedBody)")
    
    // Diacritic-free keywords
    let keywords = [
        "cassinox", "kazan365", "sheratonbet", "vayda", "vaysms", "salla kazan",
        "cevrim sarti", "havale", "iade", "cark", "global site", "rtp",
        "casinoroys", "roys",
    
        "bahis", "casino", "bet", "bonus", "freespin", "free spin",
        "cevrimsiz", "yatirim", "deneme bonusu", "slot", "rulet",
        "poker", "iddaa", "kazanc", "sans", "jackpot", "betting",
        "kumar", "canli bahis", "kacak bahis", "bedava", "yuksek oran",
        "hosgeldin bonusu", "sartsiz", "katla", "tikla", "hemen uye ol",
        "giris yap", "promosyon", " discount", "aviator", "sweet bonanza",
        "gates of olympus", "yasal bahis", "guvenilir bahis"
    ]
    
    var matched = false
    for k in keywords {
        if foldedBody.contains(k) {
            print("EŞLEŞME BULUNDU: \(k)")
            matched = true
        }
    }
    return matched
}

// Görünmez karakterlerle dolu simüle edilmiş bir mesaj (Örneğin ZWSP)
let simulatedBody = "5000 TL D\u{200B}eneme B\u{200B}ONUSU AKTIF ! ÇARK ILE KAZAN KAYBEDERSEN 1000TL DAHA ! %30 D\u{200B}ISCOUNT SINIRSIZ ÇEKİN ÇAPRAZ RTP 99.7 yüksek oran"

print("Mesaj: \(simulatedBody)")
let result = isGambling(body: simulatedBody)
print("Sonuç: \(result ? "SPAM" : "TEMİZ")")
