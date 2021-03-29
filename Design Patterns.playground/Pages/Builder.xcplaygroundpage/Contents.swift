/*: 
 # Builder
 - - - - - - - - - -
 ![Builder Diagram](Builder_Diagram.png)
 
 The builder pattern allows complex objects to be created step-by-step instead of all-at-once via a large initializer.
 
 The builder pattern involves three parts:
 
 (1) The **product** is the complex object to be created.
 
 (2) The **builder** accepts inputs step-by-step and ultimately creates the product.
 
 (3) The **director** supplies the builder with step-by-step inputs and requests the builder create the product once everything has been provided.
 
 ## Code Example
 */
import Foundation

// MARK: - Product
struct Hamburger {
    let meat: Meat
    let sauce: Sauces
    let toppings: Toppings
}

extension Hamburger: CustomStringConvertible {
    var description: String {
        return meat.rawValue + " burger"
    }
}

enum Meat: String {
    case beef
    case chicken
    case kitten
    case tofu
}

struct Sauces: OptionSet {
    static let mayonnaise = Sauces(rawValue: 1 << 0)
    static let mustard = Sauces(rawValue: 1 << 1)
    static let ketchup = Sauces(rawValue: 1 << 2)
    static let secret = Sauces(rawValue: 1 << 3)
    
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

struct Toppings: OptionSet {
    static let cheese = Toppings(rawValue: 1 << 0)
    static let lettuce = Toppings(rawValue: 1 << 1)
    static let pickles = Toppings(rawValue: 1 << 2)
    static let tomatoes = Toppings(rawValue: 1 << 3)
    
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Builder
class HamburgerBuilder {
    enum Error: Swift.Error {
        case soldOut
    }
    
    private(set) var meat: Meat = .beef
    private(set) var sauces: Sauces = []
    private(set) var toppings: Toppings = []
    
    private var soldOutMeats: [Meat] = [.kitten]
    
    func addSauces(_ sauce: Sauces) {
        sauces.insert(sauce)
    }
    
    func removeSauces(_ sauce: Sauces) {
        sauces.remove(sauce)
    }
    
    func addToppings(_ topping: Toppings) {
        toppings.insert(topping)
    }
    
    func removeToppings(_ topping: Toppings) {
        toppings.remove(topping)
    }
    
    func setMeat(_ meat: Meat) throws {
        guard isAvailable(meat) else { throw Error.soldOut }
        self.meat = meat
    }
    
    func isAvailable(_ meat: Meat) -> Bool {
        return !soldOutMeats.contains(meat)
    }
    
    func build() -> Hamburger {
        return Hamburger(meat: meat, sauce: sauces, toppings: toppings)
    }
}

// MARK: - Director
class Employee {
    func createCombo1() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.beef)
        builder.addSauces(.secret)
        builder.addToppings([.lettuce, .tomatoes, .pickles])
        return builder.build()
    }
    
    func createKittenSpecial() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.kitten)
        builder.addSauces(.mustard)
        builder.addToppings([.lettuce, .tomatoes])
        return builder.build()
    }
}

// MARK: - Example
let burgerFlipper = Employee()

if let combo1 = try? burgerFlipper.createCombo1() {
    print("Nom nom " + combo1.description)
}

if let kittenBurger = try?
    burgerFlipper.createKittenSpecial() {
    print("Nom nom nom " + kittenBurger.description)
    
} else {
    print("Sorry, no kitten burgers here... :[")
}
