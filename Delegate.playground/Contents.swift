import UIKit

protocol InterchangeViaElevatorProtocol {
    func cookOrder(order: String) -> Bool
}

class Waiter {
    
    // Oфицианту добавим свойство "получатель заказа через лифт". Официанту известно, что этот получатель знает правила и приготовит то, что в записке.
    // Это свойство и есть делегат
    var receiverOfOrderViaElevator: InterchangeViaElevatorProtocol?
    /// Свойство "заказ" - опциональная информация о текущем заказе. (О заказе может узнать только официант, поэтому "private".)
    var order: String?
    
    /// Метод "принять заказ".
    func takeOrder(_ food: String) {
        order = food
        print("What would you like?")
        print("\(food)? ")
        print("Yes, of course!")
        sendOrderToCook()
    }
    
    /// Метод "отправить заказ повару". Мог бы сделать только официант. Но как?
    private func sendOrderToCook() {
        // ??? Как передать повару заказ?
        //Добавим вызов метода cookOrder у нашего "получателя заказов через лифт":
               receiverOfOrderViaElevator?.cookOrder(order: order!)
    }
    
    /// Метод "доставить блюдо клиенту". Умеет только официант.
    private func serveFood() {
        print("Your \(order!). Enjoy your meal!")
    }
}

class Cook: InterchangeViaElevatorProtocol {

    /// Свойство "сковорода". Есть только у повара.
    private let pan: Int = 1

    /// Свойство "плита". Есть только у повара.
    private let stove: Int = 1

    /// Метод "приготовить". Умеет только повар.
    private func cookFood(_ food: String) -> Bool {
        print("Let's take a pan")
        print("Let's put \(food) on the pan")
        print("Let's put the pan on the stove")
        print("Wait a few minutes")
        print("\(food) is ready!")
        return true
    }
    func cookOrder(order: String) -> Bool {
        cookFood(order)
    }

}

// Нанимаем на работу официанта и повара (создаем экземпляры):
let waiter = Waiter()
let cook = Cook()

// Сначала скажем официанту получить заказ. Допустим, он получает курицу:
waiter.takeOrder("Chiken")

// Теперь скажем официанту, что его "получатель заказа через лифт" - это наш повар:
waiter.receiverOfOrderViaElevator = cook

// Теперь официант может нашего "получателя заказа через лифт" попросить приготовить заказ:
waiter.sendOrderToCook()
waiter.serveFood()

// Создадим класс Шеф-Повара, который нанимает на работу официанта
class Chief: InterchangeViaElevatorProtocol {

    private let pan: Int = 1
    private let stove: Int = 1

    private func cookFood(_ food: String) -> Bool {
        print("Let's take a pan")
        print("Let's put \(food) on the pan")
        print("Let's put the pan on the stove")
        print("Wait a few minutes")
        print("\(food) is ready!")
        return true
    }

    // Необходимый метод, согласно правилу(протоколу):
    func cookOrder(order: String) -> Bool {
        cookFood(order)
    }

    // Шеф-повар умеет нанимать официантов в свое кафе:
    func hireWaiter() -> Waiter {
        return Waiter()
    }

}

// Создаем экземпляр шеф-повара (шеф-повар открывает кафе):
let chief = Chief()

// Шев-повар нанимает официанта:
let newWaiter = chief.hireWaiter()

// Добавим официанту заказ:
newWaiter.takeOrder("Chiken")

// Обучаем официанта, что его "получатель заказа через лифт" - это наш шеф-повар:
newWaiter.receiverOfOrderViaElevator = chief
// Теперь официант может нашего "получателя заказа через лифт" попросить приготовить заказ:
newWaiter.receiverOfOrderViaElevator?.cookOrder(order: waiter.order!)


// А теперь представим, что появился новый шеф-повар, который рассказывает официанту ещё при найме на работу, что его «получателем заказа через лифт» будет сам шеф-повар.
class SmartChief: Chief {

    override func hireWaiter() -> Waiter {
        let waiter = Waiter()
        waiter.receiverOfOrderViaElevator = self // Сразу же настраивает официанту свойство получателя заказа через лифт
        return waiter
    }

}

let smartChief = SmartChief()
let smartWaiter = smartChief.hireWaiter()
smartWaiter.takeOrder("Fish")

//  CALLBACK
// Представьте себе, что в другом ресторане шеф-повар очень ленивый (или усталый, или заболел). Официант принял заказ, звонит повару, а тот ему говорит: «Давай-ка сам приготовь! Возьми мою сковородку, поставь на плиту и приготовь по рецепту!» Наш официант оказался не из робкого десятка, берет инструкцию, инструменты повара и все делает сам. Это и есть подход через колбэк.

class TalentedWaiter {

    var order: String?

    // Добавим опциональное свойство функционального  типа. Это функция, которая принимает на вход аргумент с типом String и возвращает результат с типом Bool.
    var doEverything: ((String) -> Bool)?

    func takeOrder(_ food: String) {
        print("What would you like?")
        print("Yes, of course we have \(food)!")
        order = food
        // Вместо передачи заказа шев-повару официант попытается сделать сам:
        doOwnself()
    }

    private func doOwnself() -> Bool {
        // Если инструкция существует, то он ее выполнит:
        if let doEverything = doEverything {
            let doOwnself = doEverything(order!)
            return doOwnself
        } else {
            return false
        }
    }

}

// Создаем класс ленивого шеф-повара
class LazyChief {

    private let pan: Int = 1
    private let stove: Int = 1

    private func cookFood(_ food: String) -> Bool {
        print("I have \(pan) pan")
        print("Let's put \(food) on the pan!")
        print("I have \(stove) stove. Let's put the pan on the stove!")
        print("Wait a few minutes...")
        print("\(food) is ready!")
        return true
    }

    // Умение нанимать талантливых официантов:
    func hireWaiter() -> TalentedWaiter {
        let talentedWaiter = TalentedWaiter()

        // Повар учит официанта готовить самому. Он передает ему инструкцию в виде замыкания, в котором прописывает свой собственный метод cookFood:
        talentedWaiter.doEverything = { [weak self] order in
                    self!.cookFood(order)
                }
        return talentedWaiter
    }

}

let lazyChief = LazyChief()
let talentedWaiter = lazyChief.hireWaiter()
talentedWaiter.takeOrder("Meat")
