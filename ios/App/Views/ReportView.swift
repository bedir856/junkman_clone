import SwiftUI

struct ReportView: View {
    @State private var sender = ""
    @State private var selectedCategory = 0
    @State private var notes = ""
    @State private var showConfirmation = false
    
    let categories = ["İstenmeyen (Spam)", "İzin Verilen", "İşlem", "Promosyon"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mesaj Detayları")) {
                    TextField("Gönderici (+90...)", text: $sender)
                        .keyboardType(.phonePad)
                    
                    Picker("Sınıflandırmanız", selection: $selectedCategory) {
                        ForEach(0..<categories.count) {
                            Text(categories[$0])
                        }
                    }
                }
                
                Section(header: Text("Eylemler")) {
                    HStack {
                        Image(systemName: "tray.full.fill")
                            .foregroundColor(.red)
                        Toggle("Gönderici için Kural Oluştur", isOn: .constant(true))
                    }
                    Text("Bu göndericiden gelen tüm mesajlar seçiminize göre otomatik filtrelenecek.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Ek Notlar")) {
                    TextField("Notlarınız...", text: $notes)
                }
                
                Section {
                    Button(action: sendReport) {
                        HStack {
                            Spacer()
                            Label("Rapor Gönder", systemImage: "paperplane.fill")
                            Spacer()
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Mesaj Raporla")
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("Teşekkürler"),
                    message: Text("Raporunuz başarıyla gönderildi. Veritabanımızı geliştirmemize yardımcı olduğunuz için teşekkürler."),
                    dismissButton: .default(Text("Tamam"))
                )
            }
        }
    }
    
    func sendReport() {
        // Logic to send report (mock for now)
        // In real app, this would send data to API
        
        // Also auto-add to local rules if requested
        if !sender.isEmpty {
           if selectedCategory == 0 { // Spam
               DataManager.shared.addToBlacklist(word: sender) // Using sender as 'word' is fine for simplistic filter
           } else if selectedCategory == 1 { // Allow
               // Add to whitelist sender logic
               var list = DataManager.shared.whitelistedSenders
               if !list.contains(sender) {
                   list.append(sender)
                   DataManager.shared.whitelistedSenders = list
               }
           }
        }
        
        showConfirmation = true
        resetForm()
    }
    
    func resetForm() {
        sender = ""
        notes = ""
        selectedCategory = 0
    }
}
