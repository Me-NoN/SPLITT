//
//  DetailedBillView.swift
//  SPLITT
//
//  Created by Rohit Menon on 06/07/24.
//

import SwiftUI

struct DetailedBillView: View {
    var billEntity: BillEntity
    
    var body: some View {
        List {
            Section(header: Text("Bill Details")) {
                Text("Place: \(billEntity.name ?? "Unknown")")
                Text("Date: \(billEntity.date ?? Date(), formatter: dateFormatter)")
                Text("Tax: $\(billEntity.tax, specifier: "%.2f")")
                if let itemsData = billEntity.items as! Data?,
                   let items = try? JSONDecoder().decode([BillItem].self, from: itemsData) {
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text("$\(item.price, specifier: "%.2f")")
                            Text("Assigned to: \(item.assignedTo.map { $0.name }.joined(separator: ", "))")
                        }
                    }
                }
            }
        }
        .navigationTitle("Bill Details")
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
