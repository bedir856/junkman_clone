import SwiftUI

struct HelpView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Yardım")) {
                    Link(destination: URL(string: "mailto:support@example.com")!) {
                        Label("Geribildirim Gönder", systemImage: "envelope")
                    }
                    NavigationLink(destination: Text("Etkinleştirme Yönergeleri...")) {
                        Label("Etkinleştirme Yönergeleri", systemImage: "play.circle")
                    }
                }
                
                Section(header: Text("Sık Sorulan Sorular")) {
                    DisclosureGroup("SpamÖnleyici nedir?") {
                        Text("SpamÖnleyici, gelen SMS mesajlarını cihaz üzerinde yapay zeka ile analiz edip filtreleyen güvenli bir uygulamadır.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    DisclosureGroup("Mesajlarımı okuyor musunuz?") {
                        Text("Hayır. Tüm işlem cihazınızda (offline) yapılır. Mesajlarınız sunucuya gönderilmez.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    DisclosureGroup("Neden çalışmıyor?") {
                        Text("Ayarlar > Mesajlar > Bilinmeyen ve İstenmeyen kısmından uygulamayı aktif ettiğinizden emin olun.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(footer: Text("Version 1.0.0 (Build 1)")) {
                    EmptyView()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Yardım")
        }
    }
}
