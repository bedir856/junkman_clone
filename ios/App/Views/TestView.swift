import SwiftUI
import IdentityLookup

struct TestView: View {
    @State private var sender = ""
    @State private var messageBody = ""
    @State private var result: ILMessageFilterAction?
    @State private var showResult = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mesaj Simülasyonu")) {
                    TextField("Gönderici (Örn: +905...)", text: $sender)
                        .keyboardType(.phonePad)
                    
                    TextEditor(text: $messageBody)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                    
                    Button(action: runTest) {
                        HStack {
                            Spacer()
                            Label("Testi Başlat", systemImage: "play.fill")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 5)
                    .disabled(messageBody.isEmpty)
                }
                
                if showResult, let result = result {
                    Section(header: Text("Sonuç")) {
                        HStack {
                            Image(systemName: icon(for: result))
                                .foregroundColor(color(for: result))
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                Text(title(for: result))
                                    .font(.headline)
                                    .foregroundColor(color(for: result))
                                
                                Text(description(for: result))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Filtre Testi")
        }
    }
    
    func runTest() {
        // Run the actual filter engine logic
        // We use a dummy request object or just call the logic function directly if we refactored it
        // The FilterEngine has filterMessage(sender:body:) -> ILMessageFilterAction
        
        let action = FilterEngine.shared.filterMessage(sender: sender, body: messageBody)
        self.result = action
        self.showResult = true
    }
    
    func icon(for action: ILMessageFilterAction) -> String {
        switch action {
        case .allow: return "checkmark.shield.fill"
        case .junk: return "xmark.bin.fill" // iOS 14+ junk symbol
        case .promotion: return "tag.fill"
        case .transaction: return "cart.fill"
        case .filter: return "hand.raised.fill" // Generic filter
        case .none: return "questionmark.circle"
        @unknown default: return "questionmark.circle"
        }
    }
    
    func color(for action: ILMessageFilterAction) -> Color {
        switch action {
        case .allow: return .green
        case .junk, .filter: return .red
        case .promotion, .transaction: return .blue
        case .none: return .gray
        @unknown default: return .gray
        }
    }
    
    func title(for action: ILMessageFilterAction) -> String {
        switch action {
        case .allow: return "İzin Verilen"
        case .junk: return "İstenmeyen (Junk)"
        case .filter: return "Filtrelendi (Spam)"
        case .promotion: return "Promosyon"
        case .transaction: return "İşlem"
        case .none: return "Bilinmiyor"
        @unknown default: return "Bilinmiyor"
        }
    }
    
    func description(for action: ILMessageFilterAction) -> String {
        switch action {
        case .allow: return "Bu mesaj gelen kutunuza düşer."
        case .junk, .filter: return "Bu mesaj 'İstenmeyen' klasörüne düşer ve bildirim gelmez."
        case .promotion: return "Bu mesaj 'Promosyon' kategorisine gider."
        case .transaction: return "Bu mesaj 'İşlem' kategorisine gider."
        case .none: return "Filtre bu mesaj için bir işlem yapmadı."
        @unknown default: return ""
        }
    }
}
