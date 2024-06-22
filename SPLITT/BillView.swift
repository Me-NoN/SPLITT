//BillView
import SwiftUI

struct BillView: View {
    @State private var name = ""
    @State private var date = Date()
    @State private var tax = ""
    
    var body: some View {
        Form {
            Section(header: Text("Bill Details")) {
                TextField("Name of the place", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Tax", text: $tax)
                    .keyboardType(.decimalPad)
            }
            Section {
                NavigationLink(destination: PeopleView(billName: name, billDate: date, billTax: Double(tax) ?? 0.0)) {
                    Text("Next: Add People")
                }
            }
        }
        .navigationTitle("Enter Bill")
    }
}
