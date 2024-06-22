//
//  HistoryView.swift
//  SPLITT
//
//  Created by Rohit Menon on 23/06/24.
//
import SwiftUI

struct HistoryView: View {
    @State private var bills: [BillEntity] = []
    
    var body: some View {
        List {
            ForEach(bills, id: \.self) { billEntity in
                NavigationLink(destination: DetailedBillView(billEntity: billEntity)) {
                    HStack {
                        Text(billEntity.name ?? "Unknown")
                        Spacer()
                        Text(billEntity.date ?? Date(), formatter: dateFormatter)
                        Spacer()
                        if let itemsData = billEntity.items as! Data?,
                           let items = try? JSONDecoder().decode([BillItem].self, from: itemsData) {
                            let totalAmount = items.reduce(0) { $0 + $1.price } + (billEntity.tax ?? 0)
                            Text("$\(totalAmount, specifier: "%.2f")")
                        }
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        deleteBill(billEntity)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("History")
        .onAppear {
            bills = PersistenceController.shared.fetchBills()
        }
    }
    
    private func deleteBill(_ billEntity: BillEntity) {
        let context = PersistenceController.shared.container.viewContext
        context.delete(billEntity)
        do {
            try context.save()
            bills = PersistenceController.shared.fetchBills()
        } catch {
            print("Failed to delete bill: \(error)")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
