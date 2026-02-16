import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "shield.checkerboard")
                    Text("Genel Bakış")
                }
                .tag(0)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Ayarlar")
                }
                .tag(1)
        }
        .accentColor(.blue)
    }
}

// MARK: - Dashboard View

struct DashboardView: View {
    @AppStorage("totalScanned", store: UserDefaults(suiteName: "group.com.yourcompany.junkman")) 
    var totalScanned: Int = 0
    
    @AppStorage("spamBlocked", store: UserDefaults(suiteName: "group.com.yourcompany.junkman")) 
    var spamBlocked: Int = 0
    
    @AppStorage("isAiEnabled", store: UserDefaults(suiteName: "group.com.yourcompany.junkman")) 
    var isAiEnabled: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Status Card
                    VStack {
                        Image(systemName: isAiEnabled ? "checkmark.shield.fill" : "xmark.shield.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(isAiEnabled ? .green : .red)
                            .padding(.bottom, 5)
                        
                        Text(isAiEnabled ? "Koruma Aktif" : "Koruma Devre Dışı")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(isAiEnabled ? .green : .red)
                        
                        Text(isAiEnabled ? "Spam mesajlar yapay zeka ile engelleniyor." : "Filtreleme şu anda kapalı.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(title: "Taranan", value: "\(totalScanned)", icon: "envelope.fill", color: .blue)
                        StatCard(title: "Engellenen", value: "\(spamBlocked)", icon: "trash.fill", color: .red)
                    }
                    
                    // Info Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nasıl Çalışır?")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.purple)
                            Text("Yapay zeka içeriği analiz eder.")
                        }
                        HStack {
                            Image(systemName: "list.clipboard")
                                .foregroundColor(.orange)
                            Text("Bahis ve kumar sitelerini otomatik tanır.")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("SpamÖnleyici")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(value)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @ObservedObject var dataManager = DataManagerWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("KORUMA AYARLARI")) {
                    Toggle(isOn: $dataManager.isAiEnabled) {
                        HStack {
                            Image(systemName: "brain")
                                .foregroundColor(.purple)
                            Text("Yapay Zeka Filtresi")
                        }
                    }
                    
                    Toggle(isOn: $dataManager.isGamblingEnabled) {
                        HStack {
                            Image(systemName: "suit.spade.fill")
                                .foregroundColor(.red)
                            Text("Bahis & Kumar Engelleyici")
                        }
                    }
                }
                
                Section(header: Text("LİSTELER")) {
                    NavigationLink(destination: ListView(title: "Engellenen Kelimeler", listType: .blacklistedWords)) {
                        HStack {
                            Image(systemName: "text.bubble.fill")
                                .foregroundColor(.orange)
                            Text("Yasaklı Kelimeler")
                        }
                    }
                    
                    NavigationLink(destination: ListView(title: "İzin Verilen Göndericiler", listType: .whitelistedSenders)) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text("Güvenli Göndericiler")
                        }
                    }
                }
                
                Section(footer: Text("Versiyon 1.0.0 • Build 1")) {
                    HStack {
                        Spacer()
                        Text("SpamÖnleyici")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

// Wrapper for DataManager to use in SwiftUI
class DataManagerWrapper: ObservableObject {
    @Published var isAiEnabled: Bool {
        didSet { DataManager.shared.isAiEnabled = isAiEnabled }
    }
    
    @Published var isGamblingEnabled: Bool {
        didSet { DataManager.shared.isGamblingFilterEnabled = isGamblingEnabled }
    }
    
    init() {
        self.isAiEnabled = DataManager.shared.isAiEnabled
        self.isGamblingEnabled = DataManager.shared.isGamblingFilterEnabled
    }
}

// Reuse existing ListView but clean up imports if needed
// (ListView implementation remains compatible)
