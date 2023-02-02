import UIKit

//let timer = Timer(
//    timeInterval: 0.1,
//    target: self,
//    selector: #selector(onTimerUpdate),
//    userInfo: nil,
//    repeats: true)
//
//RunLoop.main.add(timer, forMode: .common)

// Создаем переменную потока
var thread1 = pthread_t(bitPattern: 0)
// Создаем переменную аттрибутов очереди
var threadAttributes = pthread_attr_t()
// Инициализируем аттрибуты
pthread_attr_init(&threadAttributes)
// Создаем поток, передав все аргументы
pthread_create(
    &thread1,
    &threadAttributes,
    { _ in
        print("Hello world")
        return nil
    },
    nil)

// Создаем объект Thread
let thread2 = Thread {
    print("Hello world!")
}
// Стартуем выполнение операций на потоке
thread2.start()

//У Thread есть альтернативный способ создания, с использованием Target-Action паттерна:
//
//public convenience init(target: Any, selector: Selector, object argument: Any?)

// Создаем переменную потока
var thread3 = pthread_t(bitPattern: 0)
// Создаем переменную аттрибутов очереди
var threadAttributes3 = pthread_attr_t()
// Инициализируем аттрибуты
pthread_attr_init(&threadAttributes3)
// Задаем QOS в атрибуты потока
pthread_attr_set_qos_class_np(&threadAttributes3, QOS_CLASS_USER_INTERACTIVE, 0)
// Создаем поток, передав все аргументы
pthread_create(
    &thread3,
    &threadAttributes3,
    { _ in
        print("Hello world")
        // Переключаем QOS в ходе выполнения операции
        pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
        return nil
    },
    nil)


public enum QualityOfService : Int {

    
    case userInteractive = 33

    case userInitiated = 25

    case utility = 17

    case background = 9

    case `default` = -1
}

// Создаем объект Thread
let thread4 = Thread {
    print("Hello world!")
}
// Задаем потоку QOS
thread4.qualityOfService = .userInteractive
// Стартуем выполнение операций на потоке
thread4.start()

//Mutex — примитив синхронизации, позволяющий захватить ресурс. Подразумевается, что как только поток обратиться к ресурсу, захваченному мьютексом, никакой другой поток не сможет с ним взаимодействовать до тех пор, пока текущий поток не освободит этот ресурс
//
//Рассмотрим пример использования pthread mutex:

var mutex = pthread_mutex_t()
pthread_mutex_init(&mutex, nil)

func doSomething() {
    // Захватываем ресурс
    pthread_mutex_lock(&mutex)

    // Выполняем работу
    print("Hello World!")

    // Освобождаем ресурс
    pthread_mutex_unlock(&mutex)
}

//
//              NSLock
//
//NSLock - более удобная реализация базового mutex из фреймворка Foundation.
//
//Рассмотрим пример использования NSLock:

let lock = NSLock()

func doSomething0() {
    lock.lock()

    // Выполняем работу
    print("Hello World")

    lock.unlock()
}

// Рекурсивный мютекс

var mutex2 = pthread_mutex_t()
// Создаем переменную атрибутов мьютекса
var mutexAttributes = pthread_mutexattr_t()
pthread_mutexattr_init(&mutexAttributes)
// Сетим рекурсивный тип мьютекса
pthread_mutexattr_settype(&mutexAttributes, PTHREAD_MUTEX_RECURSIVE)
// Инициализируем мьютекс с атрибутами
pthread_mutex_init(&mutex2, &mutexAttributes)

func doSomething1() {
    pthread_mutex_lock(&mutex2)
    doSomething2()
    pthread_mutex_unlock(&mutex2)
}

func doSomething2() {
    pthread_mutex_lock(&mutex2)
    print("Hello World!`1")
    pthread_mutex_unlock(&mutex2)
}

doSomething1()
//Если бы в данном примере использовался обычный mutex, поток бы бесконечно ожидал, пока он же сам не освободит ресурс.

//NSRecursiveLock — более удобная реализация reqursive mutex из фреймворка Foundation.
//
//Рассмотрим пример использования NSRecursiveLock:

let recursiveLock = NSRecursiveLock()

func doSomething3() {
    recursiveLock.lock()
    doSomething4()
    recursiveLock.unlock()
}

func doSomething4() {
    recursiveLock.lock()
    print("Hello World!")
    recursiveLock.unlock()
}

// Condition - еще один примитив синхронизации. Задача, закрытая condition, не начнет свое выполнение до тех пор, пока не получит сигнал из другого потока. Сигнал является неким триггером для condition, который говорит о том, что поток должен выйти из состояния ожидания.

// Рассмотрим пример использования condition:

// Создаем переменную condition
var condition = pthread_cond_t()
var mutex3 = pthread_mutex_t()

// Создаем булевый предикат
var booleanPredicate = false

// Инициализируем condition
pthread_cond_init(&condition, nil)
pthread_mutex_init(&mutex3, nil)

func doSomething5() {
    pthread_mutex_lock(&mutex3)
    
    // Проверяем булевой предикат
    while !booleanPredicate {
        // Переход в состояние ожидания
        pthread_cond_wait(&condition, &mutex3)
    }
    
    // Выполняем работу
    print("Hello World!")
    
    pthread_mutex_unlock(&mutex3)
}

func doSomething6() {
    pthread_mutex_lock(&mutex3)
    
    booleanPredicate = true
    // Выпускаем сигнал в condition
    pthread_cond_signal(&condition)
    
    pthread_mutex_unlock(&mutex3)
}


//NSCondition — более удобная реализация condition из фреймворка Foundation. Удобство заключается в том, что используя NSCondition, в отличии от pthread_cond_t, у нас нет необходимости дополнительно создавать mutex, так как NSCondition самостоятельно поддерживает методы lock() и unlock().
//
//Рассмотрим пример использования NSCondition:

// Создаем булевый предикат
var boolPredicate = false

// Создаем condition
let condition2 = NSCondition()

func test1() {
    condition2.lock()
    
    // Проверяем булевой предикат
    while(!boolPredicate) {
        // Переход в состояние ожидания
        condition2.wait()
    }
    
    // Выполняем работу
    print("Hello World!")
    
    condition2.unlock()
}

func test2() {
    condition2.lock()
    
    boolPredicate = true
    // Выпускаем сигнал в condition
    condition2.signal()
    
    condition2.unlock()
}

// Read Write Lock

//Read Write Lock — примитив синхронизации, который предоставляет потоку доступ к ресурсу на чтение, в это время закрывая возможность записи в ресурс из других потоков.

//Необходимость использовать rwlock появляется тогда, когда много потоков читают данные, и только один поток их пишет (Reader-writers problem). На первый взгляд кажется, что данную проблему можно легко решить простым mutex, однако этот подход будет требовать больше ресурсов, нежели простой rwlock, так как фактически нет необходимости блокировать доступ к ресурсу полностью. rwlock имеет достаточно простое API:

// Создаем rwlock
var lock2 = pthread_rwlock_t()
// Создаем rwlock атрибуты
var attr = pthread_rwlockattr_t()

// Инициализируем rwlock
pthread_rwlock_init(&lock2, &attr)

// Блокируем чтение
pthread_rwlock_rdlock(&lock2)

// ...

// Освобождаем ресурс
pthread_rwlock_unlock(&lock2)

// Блокируем запись
pthread_rwlock_wrlock(&lock2)

// ...

// Освобождаем ресурс
pthread_rwlock_unlock(&lock2)

// Очищаем rwlock
pthread_rwlock_destroy(&lock2)

class RWLock {
    // Создаем rwlock
    var lock = pthread_rwlock_t()
    // Создаем rwlock аттрибуты
    var attr = pthread_rwlockattr_t()
    
    // Создаем ресурс
    private var resource: Int = 0
    
    init() {
        // Инициализируем rwlock
        pthread_rwlock_init(&lock, &attr)
    }
    
    var testProperty: Int {
            get {
                // Блокируем ресурс на чтение
                pthread_rwlock_rdlock(&lock)
                
                // Создаем временную переменную
                let tmp = resource
                
                // Освобождаем ресурс
                pthread_rwlock_unlock(&lock)
                
                return tmp
            }
            
            set {
                // Блокируем ресурс на запись
                pthread_rwlock_wrlock(&lock)
                
                // Записываем ресурс, гарантируя, что в данный момент времени он не будет перезаписан из другого потока
                resource = newValue
                
                // Освобождаем ресурс
                pthread_rwlock_unlock(&lock)
            }
        }
    }

//Spin Lock
//
//Spin lock — наиболее быстродействующий, но в то же время энергозатратный и ресурсотребователный mutex. Быстродействие достигается за счет непрерывного опрашивания, освобожден ресурс в данный момент времени или нет.

// Создаем spinlock
var lock3 = OS_SPINLOCK_INIT

// Блокируем ресурс
OSSpinLockLock(&lock3)

// Выполняем работу
print("Hello World!")

// Освобождаем ресурс
OSSpinLockUnlock(&lock3)

//Рекомендуется использовать spin lock лишь в редких случаях, когда к ресурсу обращается небольшое количество потоков непродолжительное время.

// Unfair Lock

//Unfair lock (iOS 10+) — примитив многопоточности, позволяющий наиболее эффективно захватывать ресурс. По большому счету, unfair lock является более производительной заменой spin lock. Производительность достигается путем максимального сокращения возможных context switch.
//
//    Context switch — процесс переключения между потоками. Для того, чтобы переключаться между потоками, необходимо прекратить работу на текущем потоке, сохранив при этом состояние и всю необходимую информацию, а далее восстановить и загрузить состояние задачи, к выполнению которой переходит процессор. Является энергозатратной и ресурсотребовательной операцией

//Вспоминаем, что обычный mutex работает по принципу FIFO, в то время, как unfair lock отдаст предпочтение тому потоку, который чаще обращается к ресурсу, таким образом и достигается сокращение context switch. Имеет достаточно простое API:

// Создаем unfair lock
var lock4 = os_unfair_lock_s()

// Блокируем ресурс
os_unfair_lock_lock(&lock4)

// Выполняем работу
print("Hello World!")

// Освобождаем ресурс
os_unfair_lock_unlock(&lock4)

// Многопоточность предназначена для решения проблем, но как и любые другие технологии может порождать новые. В большинстве случаев проблемы связанны с доступом к ресурсам. Самые распространенные из них:

//Deadlock — ситуация, в которой поток бесконечно ожидает доступ к ресурсу, который никогда не будет освобожден
//
//Priority inversion — ситуация, в которой высокоприоритетная задача ожидает выполнения низкоприоритетной задачи.
//
//Race condition — ситуация, в которой ожидаемый порядок выполнения операций становится непредсказуемым, в результате чего страдает закладываемая логика
//
//В данной статье мы рассмотрим только Deadlock, так как остальные проблемы стоит решать используя более высокоуровневые библиотеки.

//Deadlock — это ситуация в многозадачной среде, при которой несколько потоков находятся в состоянии ожидания ресурса, занятого друг другом, и ни один из них не может продолжать свое выполнение. Таким образом оба потока бесконечно ожидая друг друга никогда не выполнят задачу, что может привести к неожиданному поведению приложения.
//
//Попробуем воспроизвести самый примитивный кейс бесконечной блокировки ресурса:

class Deadlock {
    let lock = NSLock()
    var boolPredicate = true
    var counter = 0
    
    func test() {
        lock.lock()
        counter += 1
        boolPredicate = counter < 10
        
        if boolPredicate { test() }
        // Но тест() закрыт ! На этой строчке поток ждет открытия ресурса!
        // Поэтому здесь можно использовать рекурсив лок, что бы устранить проблему!
        lock.unlock()
    }
}

//Воспроизведем deadlock с использованием вложенных блокировок ресурсов:

class DeadLock {
    let lock1 = NSLock()
    let lock2 = NSLock()

    var resource1 = 0
    var resource2 = 0
    
    func test() {
        let thread1 = Thread(block: {
            self.lock1.lock()
            
            self.resource1 = 1
            
            self.lock2.lock()
            
            self.resource2 = 1
            
            self.lock2.unlock()
            
            self.lock1.unlock()
        })
        let thread2 = Thread(block: {
                    self.lock2.lock()
                    
                    self.resource2 = 1
                    
                    self.lock1.lock()
                    
                    self.resource1 = 1
                    
                    self.lock1.unlock()
                    
                    self.lock2.unlock()
                })
                
                thread1.start()
                thread2.start()
            }
        }


        let deadLock = DeadLock()
        deadLock.test()
