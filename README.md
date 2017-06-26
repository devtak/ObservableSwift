# Observable

swift observer pattern

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


## Usage

#### Subject

```swift
protocol SubjectEvent {
    func subjectEventFoo()
    func subjectEventBar(param: String)
}
extension SubjectEvent {
    func subjectEventFoo() {}
    func subjectEventBar(param: String) {}
}

class Subject: NSObject {
    fileprivate var _observers: Observable.ObserverContainer = []
    fileprivate var _observersLock: NSRecursiveLock = NSRecursiveLock()
    
    public class var shared : Subject {
        struct Static {
            static let instance : Subject = Subject()
        }
        return Static.instance
    }
    
    public func doSomething() {
        self.notify {
            $0.subjectEventBar(param: "test")
        }
    }
}

extension Subject: Observable {
    var observersLock: NSRecursiveLock? {
        get {
            return self._observersLock
        }
    }
    
    typealias Observer = SubjectEvent
    var observers: Observable.ObserverContainer {
        get {
            return self._observers
        }
        set {
            self._observers = newValue
        }
    }
}
```

#### Observer

```swift
class Observer: SubjectEvent {
    init() {
        Subject.shared.addObserver(self)
    }
    
    deinit {
        Subject.shared.removObserver(self)
    }
    
    func subjectEventBar(param: String) {
        print(param)
    }
}
```

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Observable into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "devtak/ObservableSwift" ~> 0.0.1
```

Run `carthage update` to build the framework and drag the built `Observable.framework` into your Xcode project.


## License

**Observable** is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
