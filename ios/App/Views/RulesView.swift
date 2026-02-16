import SwiftUI

struct RulesView: View {
    @ObservedObject var dataManager = DataManagerWrapper()
    @State private var newRuleText = ""
    @State private var selectedList = 0 // 0: Block, 1: Allow
    
    var body: some View {
        List {
            Picker("Liste Seçimi", selection: $selectedList) {
                Text("İstenmeyen").tag(0)
                Text("İzin Verilen").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .listRowBackground(Color.clear)
            .padding(.bottom, 5)
            
            Section(header: Text("Yeni Ekle")) {
                HStack {
                    TextField(selectedList == 0 ? "Örn: bahis, +905..." : "Örn: banka, kargo...", text: $newRuleText)
                    Button(action: addRule) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                    .disabled(newRuleText.isEmpty)
                }
            }
            
            Section(header: Text(selectedList == 0 ? "Engellenenler" : "İzin Verilenler")) {
                let items = selectedList == 0 ? dataManager.blacklistedWords : dataManager.whitelistedWords
                
                if items.isEmpty {
                    Text("Henüz kural yok.")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Image(systemName: selectedList == 0 ? "hand.raised.fill" : "checkmark.circle.fill")
                                .foregroundColor(selectedList == 0 ? .red : .green)
                            Text(item)
                        }
                    }
                    .onDelete(perform: deleteRule)
                }
            }
            
            Section(footer: Text("Numara (+90...) veya kelime (bahis, casino) ekleyebilirsiniz.")) {
                EmptyView()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Kural Listeleri")
    }
    
    func addRule() {
        guard !newRuleText.isEmpty else { return }
        if selectedList == 0 {
            // Block functionality
             DataManager.shared.addToBlacklist(word: newRuleText)
        } else {
            // Allow functionality
            // Assuming we add a method to DataManager for whitelist words or use existing logic
            // reusing whitelist sender logic for simplicity in this prototype if needed, 
            // but FilterEngine checks 'whitelistedWords' too.
            // Let's ensure DataManager has addToWhitelist
             var list = DataManager.shared.whitelistedWords
             if !list.contains(newRuleText) {
                 list.append(newRuleText)
                 DataManager.shared.whitelistedWords = list
             }
        }
        newRuleText = ""
        // Trigger UI update via ObservedObject
        dataManager.objectWillChange.send()
    }
    
    func deleteRule(at offsets: IndexSet) {
        // Simple delete logic
        if selectedList == 0 {
            var list = DataManager.shared.blacklistedWords
            list.remove(atOffsets: offsets)
            DataManager.shared.blacklistedWords = list
        } else {
            var list = DataManager.shared.whitelistedWords
            list.remove(atOffsets: offsets)
            DataManager.shared.whitelistedWords = list
        }
        dataManager.objectWillChange.send()
    }
}
