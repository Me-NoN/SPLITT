//ItemsView
import SwiftUI

struct ItemsView: View {
    @Binding var people: [Person]
    var billName: String
    var billDate: Date
    var billTax: Double
    
    @State private var items: [BillItem] = []
    @State private var newItemName = ""
    @State private var newItemPrice = ""
    @State private var newItemQuantity = 1
    @State private var selectedPersonID: UUID?
    @State private var sharedToggle: Bool = false
    @State private var selectedPeople: Set<UUID> = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var itemSuggestions: [String] = []
    
    var body: some View {
        Form {
            Section(header: Text("Add Items")) {
                TextField("Item Name", text: $newItemName)
                    .onChange(of: newItemName) { newValue in
                        updateItemSuggestions()
                    }
                if !itemSuggestions.isEmpty {
                    List(itemSuggestions, id: \.self) { suggestion in
                        Text(suggestion).onTapGesture {
                            newItemName = suggestion
                            itemSuggestions = []
                        }
                    }
                }
                TextField("Price", text: $newItemPrice)
                    .keyboardType(.decimalPad)
                Stepper(value: $newItemQuantity, in: 1...100) {
                    Text("Quantity: \(newItemQuantity)")
                }
                
                Toggle(isOn: $sharedToggle) {
                    Text("Shared Item")
                }
                
                if sharedToggle {
                    Text("Assign To:")
                    ForEach(people) { person in
                        Toggle(person.name, isOn: Binding(
                            get: { selectedPeople.contains(person.id) },
                            set: { isSelected in
                                if isSelected {
                                    selectedPeople.insert(person.id)
                                } else {
                                    selectedPeople.remove(person.id)
                                }
                            }
                        ))
                    }
                } else {
                    Picker("Choose Person", selection: $selectedPersonID) {
                        Text("Choose Person").tag(UUID?.none)
                        ForEach(people) { person in
                            Text(person.name).tag(person.id as UUID?)
                        }
                    }
                }
                
                Button("Add Item") {
                    if let price = Double(newItemPrice) {
                        var assignedPeople: [Person] = []
                        if sharedToggle {
                            assignedPeople = people.filter { selectedPeople.contains($0.id) }
                        } else if let personID = selectedPersonID, let person = people.first(where: { $0.id == personID }) {
                            assignedPeople = [person]
                        }
                        
                        let item = BillItem(name: newItemName, price: price, quantity: newItemQuantity, assignedTo: assignedPeople)
                        
                        for person in assignedPeople {
                            if let index = people.firstIndex(where: { $0.id == person.id }) {
                                people[index].items.append(item)
                            }
                        }
                        
                        items.append(item)
                        newItemName = ""
                        newItemPrice = ""
                        newItemQuantity = 1
                        selectedPersonID = nil
                        selectedPeople.removeAll()
                        sharedToggle = false
                    }
                }
            }
            
            Section(header: Text("Items")) {
                List {
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text("\(item.name) x\(item.quantity)")
                            Text("$\(item.price, specifier: "%.2f")")
                            Text("Assigned to: \(item.assignedTo.map { $0.name }.joined(separator: ", "))")
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteItem(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                editItem(item)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                }
            }
            
            Section {
                NavigationLink(destination: SummaryView(bill: Bill(name: billName, date: billDate, people: people, items: items, tax: billTax))) {
                    Text("Summary")
                }
                
                Button("Save Split") {
                    let bill = Bill(name: billName, date: billDate, people: people, items: items, tax: billTax)
                    PersistenceController.shared.saveBill(bill)
                    alertMessage = "History saved successfully!"
                    showAlert = true
                }
            }
        }
        .navigationTitle("Add Items")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func updateItemSuggestions() {
        let allItemNames = items.map { $0.name }
        itemSuggestions = allItemNames.filter { $0.lowercased().contains(newItemName.lowercased()) }
        if newItemName.isEmpty {
            itemSuggestions = []
        }
    }
    
    private func deleteItem(_ item: BillItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
            for person in people {
                if let itemIndex = person.items.firstIndex(where: { $0.id == item.id }) {
                    people[people.firstIndex(where: { $0.id == person.id })!].items.remove(at: itemIndex)
                }
            }
        }
    }
    
    private func editItem(_ item: BillItem) {
        newItemName = item.name
        newItemPrice = String(item.price)
        newItemQuantity = item.quantity
        selectedPeople = Set(item.assignedTo.map { $0.id })
        deleteItem(item)
    }
}
