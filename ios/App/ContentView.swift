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
            
            RulesView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Kurallar")
                }
                .tag(1)
            
            TestView()
                .tabItem {
                    Image(systemName: "play.rectangle.fill")
                    Text("Test Et")
                }
                .tag(2)
            
            ReportView()
                .tabItem {
                    Image(systemName: "exclamationmark.bubble.fill")
                    Text("Raporla")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Ayarlar")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

