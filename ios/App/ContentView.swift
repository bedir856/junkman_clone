import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ListView(title: "Blacklisted Words", listType: .blacklistedWords)
                .tabItem {
                    Image(systemName: "text.bubble")
                    Text("Junk Words")
                }
                .tag(0)
            
            ListView(title: "Whitelisted", listType: .whitelistedSenders)
                .tabItem {
                    Image(systemName: "checkmark.shield")
                    Text("Allowed")
                }
                .tag(1)
            
            Text("Settings & About")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

enum ListType {
    case blacklistedWords
    case whitelistedSenders
    // Add more...
}

struct ListView: View {
    let title: String
    let listType: ListType
    @State private var items: [String] = []
    @State private var newItem = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add new...", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .padding()
                
                List {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .navigationTitle(title)
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        switch listType {
        case .blacklistedWords:
            items = DataManager.shared.blacklistedWords
        case .whitelistedSenders:
            items = DataManager.shared.whitelistedSenders
        }
    }
    
    func addItem() {
        guard !newItem.isEmpty else { return }
        switch listType {
        case .blacklistedWords:
            DataManager.shared.addToBlacklist(word: newItem)
        case .whitelistedSenders:
            // Add logic for senders
            var list = DataManager.shared.whitelistedSenders
            if !list.contains(newItem) {
                list.append(newItem)
                DataManager.shared.whitelistedSenders = list
            }
        }
        newItem = ""
        loadData()
    }
    
    func deleteItem(at offsets: IndexSet) {
        // Logic to remove...
        // Simplifying for prototype
        items.remove(atOffsets: offsets)
        // Ideally should update DataManager
    }
}
