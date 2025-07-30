//
//  ContentView.swift
//  iExpense
//
//  Created by Дарья on 16.07.2025.
//
import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Personal") {
                    let personalItems = expenses.items.filter { $0.type == "Personal" }
                    
                    ForEach(personalItems, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.headline)
                                .foregroundColor(item.amount < 10 ? .green : item.amount < 100 ? .yellow : .red)
                        }
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let item = personalItems[offset]
                            if let fullIndex = expenses.items.firstIndex(where: { $0.id == item.id }) {
                                expenses.items.remove(at: fullIndex)
                            }
                        }
                        
                    }
                }
                
                Section("Business") {
                    let businessItems = expenses.items.filter { $0.type == "Business" }
                    
                    ForEach(businessItems, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.headline)
                                .foregroundColor(item.amount < 500 ? .green : item.amount < 5000 ? .yellow : .red)
                        }
                        
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let item = businessItems[offset]
                            if let fullIndex = expenses.items.firstIndex (where: { $0.id == item.id}) {
                                expenses.items.remove(at: fullIndex)
                            }
                        }
                        
                    }
                    
                }
            }
            .navigationTitle("iExpence")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddView(expenses: expenses)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Label("Add Expence", systemImage: "plus")
                    }
                }
            }
        }
        
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
