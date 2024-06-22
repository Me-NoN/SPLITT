// Models.swift
import Foundation

struct Bill: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var people: [Person]
    var items: [BillItem]
    var tax: Double
    var totalAmount: Double {
        let itemsTotal = items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        return itemsTotal + tax
    }
    
    func taxShare(for person: Person) -> Double {
        let totalItemPrices = items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let personItemPrices = items.filter { $0.assignedTo.contains(where: { $0.id == person.id }) }.reduce(0) { $0 + ($1.price * Double($1.quantity)) / Double($1.assignedTo.count) }
        return (personItemPrices / totalItemPrices) * tax
    }
    
    func totalPay(for person: Person) -> Double {
        let itemsTotal = person.items.reduce(0) { $0 + ($1.price * Double($1.quantity)) / Double($1.assignedTo.count) }
        return itemsTotal + taxShare(for: person)
    }
}

struct Person: Identifiable, Codable {
    var id = UUID()
    var name: String
    var icon: String // URL or Image name
    var items: [BillItem] = []
}

struct BillItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var price: Double
    var quantity: Int
    var assignedTo: [Person] = []
}
