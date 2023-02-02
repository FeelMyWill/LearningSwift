import UIKit

//convenience init(label: String, qos: DispatchQoS = .unspecified, attributes: DispatchQueue.Attributes = [], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit, target: DispatchQueue? = nil)

//Создадим serial очередь:

let serialQueue = DispatchQueue(label: "ru.denisegaluev.serial-queue")

//Для создания последовательной очереди достаточно передать в инициализатор label (идентификатор очереди). Таким образом очередь последовательная by default. Для того, чтобы создать параллельную очередь, необходимо передать соответствующий атрибут в аргумент инициализатора attributes:

let concurrentQueue = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)

//Стоит отметить, что все задачи, связанные с обновлением UI необходимо выполнять на главной очереди или на главном потоке. В ином случае приложение выбросит рантайм ошибку, что приведет к крешу приложения.

// DispatchQueue.global вернет системную concurrent очередь с приоритетом default.
let globalQueue = DispatchQueue.global()

// DispatchQueue.main вернет главную очередь.
let mainQueue = DispatchQueue.main

//Methods
//
//Существует два основных способа взаимодействия с очередями. Данные способы подразумевают под собой методы, в которые мы будем передавать наши задачи в виде замыканий.
//Sync
//
//sync – метод, позволяющий выполнять задачи синхронно по отношению к вызывающей очереди. Сперва взглянем на декларацию метода:

//@available(iOS 4.0, *)
//public func sync(execute block: () -> Void)

// Как это работает? Представим, что у нас есть 7 задач, которые нам необходимо выполнить последовательно. Задачи в нашем случае представлены в виде функций:

func task1() {
    print(1)
}

func task2() {
    print(2)
}

func task3() {
    print(3)
}

func task4() {
    print(4)
}

func task5() {
    print(5)
}

func task6() {
    print(6)
}

func task7() {
    print(7)
}

task1()
task2()
task3()
task4()
task5()
task6()
task7()
// Все выполняемые задачи будут выполняться в главной серийном потоке

let serialQueue2 = DispatchQueue(label: "ru.denisegaluev.serial-queue")
task1()
task2()
serialQueue2.sync(execute: task3)
task4()
task5()
task6()
task7()
// Теперь таск 3 будет выполняться на другом потоке, а главный поток будет ожидать ее завершения.

// async – метод, позволяющий выполнять задачи асинхронно по отношению к текущей очереди

//public func async(group: DispatchGroup? = nil, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void)

task1()
task2()
serialQueue.async(execute: task3)
task4()
task5()
task6()
task7()

//Как мы можем видеть, задача task3 все так же выполняется на очереди serialQueue, но при этом main не дожидается ее выполнения и продолжает свою работу асинхронно. В этом и заключется суть метода async, вызывающая очередь (в нашем случае main) не будет ожидать выполнения задач на выполняющей очереди (в нашем случае serialQueue), а сразу же приступит к выполнения стоящих в очереди задач.

//asyncAfter – метод, позволяющий отложить асинхронное выполнение задачи на определенное время. Данный метод идентичен async, за исключением аргумента deadline.

//public func asyncAfter(deadline: DispatchTime, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void)

let serialQueue3 = DispatchQueue(label: "ru.denisegaluev.serial-queue")

// Откладываем выполнение задачи в очереди serialQueue на 3 секунды и сразу же возвращаем управление
serialQueue3.asyncAfter(deadline: .now() + 3) {
    // ...
}

//DispatchWorkItem – класс, являющийся абстракцией над выполняемой задачей, который предоставляет нам ряд полезных методов. Например метод notify, позволяющий уведомить какую-либо очередь о выполнении задачи и следом выполнить какую-либо работу на уведомленной очереди. Рассмотрим пример реализации DispatchWorkItem:

// Создаем очередь
let serialQueue4 = DispatchQueue(label: "ru.denisegaluev.serial-queue")

// Создаем DispatchWorkItem и передаем в него замыкание (задачу)
let workItem1 = DispatchWorkItem {
    print("DispatchWorkItem task")
}

// Реализуем метод notify, передаем в него очередь, на которой необходимо будет выполнить задачу после завершения выполнения этого DispatchWorkItem
workItem1.notify(queue: DispatchQueue.main) {
    print("DispatchWorkItem completed")
}

// Выполняем DispatchWorkItem на очереди serialQueue
serialQueue4.async(execute: workItem1)

let serialQueue5 = DispatchQueue(label: "ru.denisegaluev.serial-queue")

serialQueue5.async {
    print("task")
    
    DispatchQueue.main.sync {
        print("completed")
    }
}

//Сравнивая данные примеры видно, что DispatchWorkItem позволяет нам более явно задать логику, без использования вложенных друг в друга замыканий и хаотичных вызовов методов async / sync.

//Помимо notify, DispatchWorkItem дает нам возможность отменять задачу с помощью метода cancel. Важно понимать, что задачу можно отменить только в том случае, если она на момент отмены ожидает в очереди. Если поток уже начал выполнять задачу, она не будет отменена. Рассмотрим пример реализации метода cancel:

// Создаем очередь
let serialQueue6 = DispatchQueue(label: "ru.denisegaluev.serial-queue")

// Создаем DispatchWorkItem и передаем в него замыкание (задачу)
let workItem2 = DispatchWorkItem {
    print("DispatchWorkItem task")
}

// Усыпляем serialQueue на 1 секунду и сразу возвращаем управление
serialQueue6.async {
    print("zzzZZZZ")
    sleep(1)
    print("Awaked")
}

// Ставим workItem в очередь serialQueue и сразу возвращаем управление
serialQueue6.async(execute: workItem2)

// Отменяем workItem
workItem2.cancel()

//Пока serialQueue будет спать, мы успеем отменить workItem, тем самым удалив его из очереди serialQueue.

//Semaphore
//
//Semaphore – базовый инструмент синхронизации в GCD. Semaphore позволяет нам ограничить количество потоков, которые могут единовременно обращаться к очереди. Для этого необходимо передать количество потоков в инициализатор класса DispatchSemaphore:

//Помимо ограничения количества потоков, семафор позволяет блокировать очередь до тех пор, пока не будет вызван метод signal. Рассмотрим пример

// Создаем очередь
let serialQueue7 = DispatchQueue(label: "ru.denisegaluev.serial-queue")

// Создаем семафор
let semaphore = DispatchSemaphore(value: 0)

// Усыпляем serialQueue на 5 секунд, после вызываем метод signal тем самым
serialQueue7.async {
    sleep(5)
    
    // Разблокировавыем семафор
    semaphore.signal()
}

// Блокируем очередь
semaphore.wait()

//Методы signal и wait работают по принципу инкрементирования / декрементирования внутреннего каунтера семафора (аналогично рекурсивному mutex). Это означает, что поток будет разблокирован только тогда, когда каунтер равен значению value, которое мы передаем в инициализатор.

//Dispatch group
//
//DispatchGroup – объект, позволяющий объединить задачи в группу и синхронизировать их поведение. Группа позволяет присоединить к ней несколько задачь или DispatchWorkItem и запланировать их асинхронное выполнение на одной или нескольких очередях. Когда все задачи в группе будут выполнены, группа уведомит об этом какую-либо очередь и выполнит на ней completion handler. Так же группа позволяет нам дождаться выполнения задач в группе синхронно, без использования уведомления.

// Создаем очередь
let serialQueue8 = DispatchQueue(label: "ru.denisegaluev.serial-queue")

// Создаем 2 DispatchWorkItem
let workItem3 = DispatchWorkItem {
    print("workItem3: zzzZZZ")
    sleep(3)
    print("workItem3: awaked")
}

let workItem4 = DispatchWorkItem {
    print("workItem4: zzzZZZ")
    sleep(3)
    print("workItem4: awaked")
}

// Создаем группу
let group = DispatchGroup()

// Добавляем workItem в группе, планируем его выполнение на очереди serialQueue и сразу возвращаем управление
serialQueue8.async(group: group, execute: workItem3)
serialQueue8.async(group: group, execute: workItem4)

// Устанавливаем уведомление. Замыкание будет выполнено на главной очереди сразу после того, как все задачи в группе будут выполнены.
group.notify(queue: DispatchQueue.main) {
    print("All tasks on group completed")
}

// Создаем параллельную очередь
let concurrentQueue9 = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)

// Создаем группу
let group2 = DispatchGroup()

// Создаем DispatchWorkItem
let workItem5 = DispatchWorkItem {
    print("workItem5: zzzZZZ")
    sleep(3)
    print("workItem5: awaked")
    
    // Покидаем группу
    group2.leave()
}

let workItem6 = DispatchWorkItem {
    print("workItem6: zzzZZZ")
    sleep(3)
    print("workItem6: awaked")
    
    group2.leave()
}

// Входим в группу
group2.enter()
// Вызы
concurrentQueue9.async(execute: workItem5)

group2.enter()
concurrentQueue9.async(execute: workItem6)

// Ожидаем, пока все задачи в группе закончат свое выполнение
group2.wait()
print("All tasks on group completed")

//Dispatch barrier
//
//Dispatch barrier – механизм синхронизации задач в очереди. Для того, чтобы добавить барьер, необходимо передать соответствующий флаг в метода async:

// Создаем параллельную очередь
let concurrentQueue10 = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)

// Помечаем асинхронный вызов флагом .barrier
concurrentQueue.async(flags: .barrier) {
    // ...
}

//Когда мы добавляем барьер в параллельную очередь, она откладывает выполнение задачи, помеченной барьером (и все остальные, которые поступят в очередь во время выполнения такой задачи), до тех пор, пока все предыдущие задачи не будут выполнены. После того, как все предудщие задачи будут выполнены, очередь выполнит задачу, помеченную барьером самостоятельно. Как только задача с барьером будет выполнена, очередь вернется к своему нормальному режиму работы.

class DispatchBarrierTesting {
    // Создаем параллельную очередь
    private let concurrentQueue = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)
    
    // Создаем переменную _value для внутреннего использования
    private var _value: String = ""
    
    // Создаем thread safe переменную value для внешнего использования
    var value: String {
        get {
            var tmp: String = ""
            
            concurrentQueue.sync {
                tmp = _value
            }
            
            return tmp
        }
        
        set {
            concurrentQueue.async(flags: .barrier) {
                self._value = newValue
            }
        }
    }
}

//Race Condition

// Race condition является одной из самых сложно отлавливаемых проблем

// 1
var value: Int = 0
let serialQueue11 = DispatchQueue(label: "ru.denisegaluev.serial-queue")

// 2
func increment() { value += 1 }

// 3
// Что бы устранить рейс кондишн, гарантировать работу с актуальным велью, нужно изменить асинк на синк ниже
serialQueue11.async {
    // 4
    sleep(5)
    increment()
}

// 5
print(value)

// 6
value = 10

// 7
serialQueue11.sync {
    increment()
}

// 8
print(value)

//     Создаем свойство value и последовательную очередь serialQueue

// 1 Описываем функцию инкрементирования value
//
// 2 Планируем задачу и сразу же возвращаем управление вызывающей очереди
//
// 3 Имитируем продолжительную работу усыпляя поток и тут же вызываем функцию increment
//
// 4 Выводим в консоль значение переменной value, получаем 0 и вот тут начинается самое интересное. Для полноты картины представьте, что начиная с этого пункта и до конца сниппета, код находится в другой части приложения, а зависимости (value, serialQueue) переданы через DI. То есть вы и понятия не имеете, что через 5 секунд value будет инкрементирован. Мы получаем в консоли значение 0 и для нас это своего рода source of truth.
//
// 5 Передаем в переменную value новое значение
//
// 6 На этот раз инкрементируем синхронно
//
// 7 Снова выводим значение value в консоль. Ожидаем получить 11, но получаем 12.
//
// 8 Такую ситуацию называют race condition:

//Состояние гонки (англ. race condition), также конкуренция[1] — ошибка проектирования многопоточной системы или приложения, при которой работа системы или приложения зависит от того, в каком порядке выполняются части кода. Своё название ошибка получила от похожей ошибки проектирования электронных схем (см. Гонки сигналов).
//
//Термин состояние гонки относится к инженерному жаргону и появился вследствие неаккуратного дословного перевода английского эквивалента. В более строгой академической среде принято использовать термин неопределённость параллелизма.
//
//Состояние гонки — «плавающая» ошибка (гейзенбаг), проявляющаяся в случайные моменты времени и «пропадающая» при попытке её локализовать.

let serialQueue12 = DispatchQueue(label: "ru.denisegaluev.serial-queue12")

print("Start")

//serialQueue12.sync {
//    serialQueue12.sync {
//        print("Deadlock")
//    }
//}

print("Finish")

// Решение 1
// serialQueue.sync {
//serialQueue.async {
//    // ...
//}
//}

// Решение 2
let concurrentQueue13 = DispatchQueue(label: "ru.denisegaluev.concurrent-queue", attributes: .concurrent)

print("Start")

concurrentQueue13.sync {
    concurrentQueue13.sync {
        print("No deadlock")
    }
}

print("Finish")
