import UIKit
import CoreData

class CoreDataHelper {

    // MARK: - Core Data Context
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    // MARK: - Trip Functions

    func createTrip(tripName: String, startLocation: String, endLocation: String, startDate: String, endDate: String, todoItems: [String]) -> UserTrip? {
        let newTrip = UserTrip(context: context)
        newTrip.tripName = tripName
        newTrip.startLocation = startLocation
        newTrip.endLocation = endLocation
        newTrip.startDate = startDate
        newTrip.endDate = endDate
        newTrip.todoItem = todoItems as NSObject // Assuming `todoItem` is stored as `Transformable`
        
        do {
            try context.save()
            return newTrip
        } catch {
            print("Failed to save trip: \(error)")
            return nil
        }
    }

    func fetchTrips() -> [UserTrip] {
        let fetchRequest: NSFetchRequest<UserTrip> = UserTrip.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch trips: \(error)")
            return []
        }
    }

    func updateTrip(trip: UserTrip, newTripName: String, newStartLocation: String, newEndLocation: String, newStartDate: String, newEndDate: String, newTodoItems: [String]) {
        trip.tripName = newTripName
        trip.startLocation = newStartLocation
        trip.endLocation = newEndLocation
        trip.startDate = newStartDate
        trip.endDate = newEndDate
        trip.todoItem = newTodoItems as NSObject
        
        do {
            try context.save()
        } catch {
            print("Failed to update trip: \(error)")
        }
    }

    func deleteTrip(trip: UserTrip) {
        context.delete(trip)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete trip: \(error)")
        }
    }

    // MARK: - Expense Functions

    func createExpense(forTrip tripName: String, expenseName: String, amount: String) {
        let newExpense = UserTripExpense(context: context)
        newExpense.expenseName = expenseName
        newExpense.expenseAmount = amount
        newExpense.tripName = tripName
        
        do {
            try context.save()
        } catch {
            print("Failed to save expense: \(error)")
        }
    }

    func fetchExpenses(forTrip tripName: String) -> [UserTripExpense] {
        let fetchRequest: NSFetchRequest<UserTripExpense> = UserTripExpense.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tripName == %@", tripName)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch expenses: \(error)")
            return []
        }
    }

    func updateExpense(expense: UserTripExpense, newExpenseName: String, newAmount: String) {
        expense.expenseName = newExpenseName
        expense.expenseAmount = newAmount
        
        do {
            try context.save()
        } catch {
            print("Failed to update expense: \(error)")
        }
    }

    func deleteExpense(expense: UserTripExpense) {
        context.delete(expense)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete expense: \(error)")
        }
    }
}
