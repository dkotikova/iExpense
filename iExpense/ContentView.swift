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
    
    @Query(filter: #Predicate<ExpenseItem> { expense in
        expense.type == "Personal"}) var personalItems: [ExpenseItem]
    @Query(filter: #Predicate<ExpenseItem> { expense in
        expense.type == "Business"}) var businessItems: [ExpenseItem]
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Personal") {
                    ForEach(personalItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete(perform: deletePersonalItem)
                }
                
                Section("Business") {
                    ForEach(businessItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete(perform: deleteBusinessItem)
                    
                }
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
            }
        }
    }
    
    func deletePersonalItem(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(personalItems[index])
        }
    }
    
    func deleteBusinessItem(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(businessItems[index])
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
