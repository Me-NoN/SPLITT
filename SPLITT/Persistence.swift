//
//  Persistence.swift
//  SPLITT
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newBill = BillEntity(context: viewContext)
            newBill.name = "Sample Bill"
            newBill.date = Date()
            newBill.tax = 5.0
            // Add sample items and people as needed
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SPLITT")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveBill(_ bill: Bill) {
        let context = container.viewContext
        let newBill = BillEntity(context: context)
        newBill.name = bill.name
        newBill.date = bill.date
        newBill.tax = bill.tax
        newBill.items = try? JSONEncoder().encode(bill.items) as NSData
        newBill.people = try? JSONEncoder().encode(bill.people) as NSData
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func fetchBills() -> [BillEntity] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<BillEntity> = BillEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}
