import SwiftUI

struct DashboardView: View {
    @ObservedObject var dataManager = DataManagerWrapper()
    
    var body: some View {
        NavigationView {
            List {
                // Section 1: Pro Badge & Status
                Section {
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("Pro Paket")
                                .font(.headline)
                            Text("Tüm özellikler aktif")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("Aktif")
                            .foregroundColor(.green)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 5)
                }
                
                // Section 2: AI & Smart Filter
                Section(header: Text("Yapay Zeka")) {
                    Toggle(isOn: $dataManager.isAiEnabled) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.purple)
                                .font(.title3)
                            VStack(alignment: .leading) {
                                Text("Akıllı Filtre")
                                    .font(.headline)
                                Text("Türkçe ve İngilizce spam mesajları otomatik algılar.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                }
                
                // Section 3: Database & Updates
                Section(header: Text("Spam ve Tehdit Veritabanı")) {
                    Button(action: {
                        // Simulate update
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.blue)
                                .font(.title3)
                            VStack(alignment: .leading) {
                                Text("Veritabanını Yenile")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Son güncelleme: Bugün 09:41")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // Section 4: Personalization (Quick Access to Rules)
                Section(header: Text("Kişiselleştirme")) {
                    NavigationLink(destination: RulesView()) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle.portrait")
                                .foregroundColor(.orange)
                                .font(.title3)
                            VStack(alignment: .leading) {
                                Text("Kural Listeleriniz")
                                    .font(.headline)
                                Text("\(dataManager.blacklistedWords.count + dataManager.whitelistedWords.count) kural devrede")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // Section 5: Stats (Mini)
                Section(header: Text("İstatistikler"), footer: Text("Not: Geliştirici hesabı kısıtlamaları (App Groups) nedeniyle arka plan filtre verileri anlık senkronize edilemeyebilir.")) {
                    HStack {
                        VStack {
                            Text("\(dataManager.totalScanned)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Taranan")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        VStack {
                            Text("\(dataManager.spamBlocked)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Engellenen")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("SpamÖnleyici")
            .onAppear {
                dataManager.refreshStats()
            }
        }
    }
}
