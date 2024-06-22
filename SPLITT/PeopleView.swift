// PeopleView.swift
import SwiftUI

struct PeopleView: View {
    @State private var people: [Person] = []
    @State private var newPersonName = ""
    var billName: String
    var billDate: Date
    var billTax: Double
    
    var body: some View {
        Form {
            Section(header: Text("Add People")) {
                TextField("Name", text: $newPersonName)
                Button("Add Person") {
                    let person = Person(name: newPersonName, icon: "person.fill")
                    people.append(person)
                    newPersonName = ""
                }
            }
            
            Section(header: Text("People")) {
                List(people) { person in
                    Text(person.name)
                }
            }
            
            Section {
                NavigationLink(destination: ItemsView(people: $people, billName: billName, billDate: billDate, billTax: billTax)) {
                    Text("Add Items")
                }
            }
        }
        .navigationTitle("Add People")
    }
}
