//SummaryView
import SwiftUI

struct SummaryView: View {
    var bill: Bill
    
    var body: some View {
        List {
            Section(header: Text("Bill Details")) {
                Text("Place: \(bill.name)")
                Text("Date: \(bill.date, formatter: dateFormatter)")
                Text("Tax: $\(bill.tax, specifier: "%.2f")")
                Text("Total: $\(bill.totalAmount, specifier: "%.2f")")
            }
            
            Section(header: Text("Items")) {
                ForEach(bill.items) { item in
                    VStack(alignment: .leading) {
                        Text("\(item.name) x\(item.quantity)")
                        Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                        Text("Assigned to: \(item.assignedTo.map { $0.name }.joined(separator: ", "))")
                    }
                }
            }
            
            Section(header: Text("People")) {
                ForEach(bill.people) { person in
                    VStack(alignment: .leading) {
                        Text(person.name)
                        Text("To Pay: $\(bill.totalPay(for: person), specifier: "%.2f")")
                    }
                }
            }
        }
        .navigationTitle("Summary")
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
