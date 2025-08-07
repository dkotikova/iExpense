//
//  ContentView.swift
//  iExpense
//
//  Created by Дарья on 16.07.2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var allItems: [ExpenseItem]
    
    @State private var selectedType = "All"
    @State private var sortOrder = SortDescriptor(\ExpenseItem.name)
    
    let types = ["All", "Personal", "Business"]
    
    var filteredItems: [ExpenseItem] {
        let filtered = selectedType == "All" ? allItems : allItems.filter { expense in
            expense.type == selectedType }
        return filtered.sorted(using: [sortOrder])
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    ExpenseRow(item: item)
                }
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("iExpence")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Label("Add Expence", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Name")
                                .tag(SortDescriptor(\ExpenseItem.name))
                            Text("Sort by Amount")
                                .tag(SortDescriptor(\ExpenseItem.amount))
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Picker("Filter", selection: $selectedType) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredItems[index])
        }
    }
    
}

struct ExpenseRow: View {
    var item: ExpenseItem
    
    var body: some View {
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
}


#Preview {
    ContentView()
}
