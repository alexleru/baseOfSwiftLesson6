import Foundation

//task1
//Химчистка. В зависимости от размера одежды и наличия рукавов, на стирку расходуем разное кол-во порошка
//Detergent - переводится как порошок

protocol Detergent {
    var info: String {get}
    func calcDetergent() -> Double
}

class TopOfClothes {
    var name = ""
    let size: Int
    let hasSleeves: Bool
    let color: String
    
    init(name: String, size: Int, hasSleeves: Bool, color: String) {
        func checkSize(_ size: Int) -> Bool {
            let tempBool: Bool = size > 0 && size < 70
            if !tempBool {print("Введен неверный размер. Вы ввели \(size)")}
            return tempBool
        }
        self.name = name
        self.size = checkSize(size) ? size : 0
        self.hasSleeves = hasSleeves
        self.color = color
        print(info)
    }
    
    var info: String{
        return "\(name) Размер: \(size) Цвет: \(color)"
    }
    
    func printIfo() -> String {
        return info
    }
}

class Chemise: TopOfClothes, Detergent {
    let collar: Bool
    init(size: Int, hasSleeves: Bool, color: String, collar: Bool) {
        self.collar = collar
        super.init(name: "Сорочка", size: size, hasSleeves: hasSleeves, color: color)
        
    }
    
    func calcDetergent() -> Double {
        return Double(size) * 31.5 + Double((hasSleeves ? size * 5 : 0))
    }
}

class T_shirt: TopOfClothes, Detergent {
    
    let picture: Bool
    init(size: Int, hasSleeves: Bool = false, color: String, picture: Bool) {
        
        self.picture = picture
        super.init(name: "Футболка", size: size, hasSleeves: hasSleeves, color: color)
    }
    
    func calcDetergent() -> Double {
        return Double(size) * 22.5
    }
}

enum Material {
    case wool
    case synthetics
}

class Jumper: TopOfClothes, Detergent {
    
    let material: Material
    init(size: Int, hasSleeves: Bool = true, color: String, material: Material) {
        
        self.material = material
        super.init(name: "Джемпер", size: size, hasSleeves: hasSleeves, color: color)
    }
    
    func calcDetergent() -> Double {
        return Double(size) * 60.0
    }

}

//1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.
struct QueueForClean<T: Detergent> {
    var elements: [T] = []
    mutating func push(_ element: T){
        elements.append(element)
    }
    mutating func pop() {
        print("Удален \(elements[elements.count-1].info)")
        elements.removeLast()
    }
    
    var totalOfDetergent: Double {
        var gramsOfDetergent = 0.0
        for element in elements {
            gramsOfDetergent += element.calcDetergent()
        }
        return gramsOfDetergent
    }
//    3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.
    subscript(index: Int) -> String?{
       let tempBool = index >= 0 && index < elements.count
        return tempBool ? "subscript \(elements[index].info)" : nil
    }

//    2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)
//    Добавил только один метод. Больше не успеваю, пора спать )))
    
        func filter (el: [Detergent], predictade: (Detergent) -> String) {
            for one in el {
                print(predictade(one))
            }
        }

}


var stackOfJumper = QueueForClean<Jumper>()
var stackOfChemiste = QueueForClean<Chemise>()


stackOfJumper.push(Jumper(size: 58, color: "white", material: .synthetics))
stackOfJumper.push(Jumper(size: 44, color: "green", material: .synthetics))
stackOfJumper.push(Jumper(size: 34, color: "red", material: .synthetics))
stackOfJumper.pop()
print("Это отработал: \(stackOfJumper[1])")
print("Этого элемента нет, выводим: \(stackOfJumper[2])")

stackOfChemiste.push(Chemise(size: 46, hasSleeves: true, color: "white", collar: true))
stackOfChemiste.push(Chemise(size: 80, hasSleeves: true, color: "green", collar: false))
stackOfChemiste.push(Chemise(size: 62, hasSleeves: true, color: "blue", collar: true))

let isEconom: (Detergent) -> String = { element in
    let tempBool = element.calcDetergent() > 150
    let tempString = tempBool ? "Дорогая стирка" : "Экономичная стирка"
    return "Для элемента \(element.info) режим \(tempString)"
}


stackOfJumper.filter(el: stackOfJumper.elements, predictade: isEconom)



