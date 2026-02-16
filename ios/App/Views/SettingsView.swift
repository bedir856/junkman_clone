import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataManager = DataManagerWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Versiyon 1.0.0 • Build 1")) {
                    HStack {
                        Spacer()
                        Text("SpamÖnleyici")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                
                Section(header: Text("Veri Yönetimi")) {
                    Button(action: {
                        // Reset stats logic
                        DataManager.shared.totalScanned = 0
                        DataManager.shared.spamBlocked = 0
                        dataManager.objectWillChange.send()
                    }) {
                        Text("İstatistikleri Sıfırla")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}
