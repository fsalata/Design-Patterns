/*:
 # Model-View-ViewModel (MVVM)
 - - - - - - - - - -
 ![MVVM Diagram](MVVM_Diagram.png)
 
 The Model-View-ViewModel (MVVM) pattern separates objects into three types: models, views and view-models.
 
 - **Models** hold onto application data. They are usually structs or simple classes.
 - **View-models** convert models into a format that views can use.
 - **Views** display visual elements and controls on screen. They are usually subclasses of `UIView`.
 
 ## Code Example
 */
import UIKit

import Foundation

enum Rarity: String {
    case common
    case uncommon
    case rare
    case veryRare
}

class Pet {
    let name: String
    let birthday: Date
    let rarity: Rarity
    
    init(name: String, birthday: Date, rarity: Rarity) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
    }
}

class PetViewModel {
    
    private let pet: Pet
    private let calendar: Calendar
    
    var name: String {
        return pet.name
    }
    
    var age: Int {
        return calendar.component(.year, from: pet.birthday)
    }
    
    var adoptionFee: String {
        switch pet.rarity {
        case .common:
            return "$50.00"
        case .uncommon:
            return "$75.00"
        case .rare:
            return "$150.00"
        case .veryRare:
            return "$500.00"
        }
    }
    
    init(pet: Pet) {
        self.pet = pet
        self.calendar = Calendar(identifier: .gregorian)
    }
}
