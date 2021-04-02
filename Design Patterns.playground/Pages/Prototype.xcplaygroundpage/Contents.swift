/*:
 # Prototype
 - - - - - - - - - -
 ![Prototype Diagram](Prototype_Diagram.png)
 
 The prototype pattern is a creational pattern that allows an object to copy itself. It involves two types:
 
 1. A **copying** protocol declares copy methods.
 
 2. A **prototype** is a class that conforms to the copying protocol.
 
 ## Code Example
 */
protocol Copying: AnyObject {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}

class Monster: Copying {
    var health: Int
    var level: Int
    
    init(health: Int, level: Int) {
        self.health = health
        self.level = level
    }
    
    required convenience init(_ monster: Monster) {
        self.init(health: monster.health, level: monster.level)
    }
}

class EyeballMonster: Monster {
    var redness = 0
    
    init(health: Int, level: Int, redness: Int) {
        self.redness = redness
        super.init(health: health, level: level)
    }
    
    @available(*, unavailable, message: "Call copy() instead")
    required convenience init(_ prototype: Monster) {
        let eyeballMonster = prototype as! EyeballMonster
        self.init(health: eyeballMonster.health, level: eyeballMonster.level, redness: eyeballMonster.redness)
    }
}

let monster = Monster(health: 700, level: 37)
let monster2 = monster.copy()

print("Watch out! That monster's level is \(monster2.level)")

let eyeball = EyeballMonster(health: 3000, level: 60, redness: 999)
let eyeball2 = eyeball.copy()
print("Eww! Its eyeball redness is \(eyeball2.redness)!")

//let eyeball3 = EyeballMonster(monster)
