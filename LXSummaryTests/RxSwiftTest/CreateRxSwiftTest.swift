//
//  CreateRxSwiftTest.swift
//  LXSummaryTests
//
//  Created by LingXiao Dai on 2023/7/24.
//

import XCTest
import RxSwift
import RxTest

final class CreateRxSwiftTest: XCTestCase {

    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: just
    // create a specific ele
    func testCreateObservableUsingJust() {
        let given = 2
        let obv: Observable<Int> = Observable.just(2)
        var result = 0
        obv.subscribe { txt in
            result = txt
        }.disposed(by: disposeBag)
        XCTAssertEqual(given, result, "isEqual")
    }

    // MARK: Timer
    // create a timer using RX, and no need to concerned to runloop. 底层通过GCD 的 DispatchSource 来实现的
    func testCreateObservalbleUsingTimer() {

        let exp = expectation(description: "Test RX Timer")

        let target = 10

        var result = 0

        let observable = Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler())
        observable.take(11).subscribe { value in
            print("value", value)
            result = value
            if value == target { exp.fulfill() }
        }.disposed(by: disposeBag)

        waitForExpectations(timeout: 11)
        XCTAssertEqual(target, result, "isEqual")
    }
    // MARK: from
    func testCreateObservableUsFrom() {
        let arr = ["licus", "lingxiao", "daiman"]
        let observable = Observable.from(arr)

        var target = 0

        let observe = AnyObserver<String>.init { event in
            switch event {
            case .next(let name):
                print("name == ", name)
                target += 1

            case .error(let err):
                print("err == ", err)

            case .completed:
                print("completed")
            }
        }
        observable.subscribe(observe).disposed(by: disposeBag)

        XCTAssertEqual(target, arr.count, "isEqual")
    }

    // MARK: repeatElement
    func testCreateObservableRepeatElement() {
        Observable.repeatElement("🔴")
            .take(3)
            .subscribe(onNext: { print($0 + "repeat") })
            .disposed(by: disposeBag)
        XCTAssertTrue(true)
    }

    // MARK: deferred
    func testCreateObservableUsingDeferred() {
        var count = 0
        /// `deferred` ； defer: 推迟， 只有当有订阅的时候 才会 创建 队列
        let deferredSequence = Observable<String>.deferred {
            count += 1
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }

        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        print("count == ", count)
        XCTAssertEqual(count, 4, "isEqual")
    }
    // MARK: interval 定时器
    func testCreateObservableUsingInterval() {

        let target = 9

        let exp = expectation(description: "timer ")

        var result = 0

        //  每隔一段时间，发出一个索引数
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler())
        observable.take(10).subscribe(onNext: { index in
            print("index == ", index)
            result = index
        }, onError: { err in
            print("err == ", err)
        }, onCompleted: {
            print("onCompleted")
            exp.fulfill()
        }).disposed(by: disposeBag)

        waitForExpectations(timeout: 11)

        XCTAssertEqual(target, result, "isEqual")
    }
    // MARK: empty
    func testCreateObservableUsingEmpty() {
        let observable = Observable<Any>.empty()
        /*
         only completed event emitted
         */

        var onlyOnCompleted = false

        observable.subscribe(onNext: { _ in
            print("onNext")
            onlyOnCompleted = false
        }, onError: { _ in
            print("Error")
            onlyOnCompleted = false
        }, onCompleted: {
            print("onCompleted")
            onlyOnCompleted = true
        }).disposed(by: disposeBag)

        XCTAssertTrue(onlyOnCompleted)
    }
    // MARK: never
    func testCreateObservableUsingNever() {
        let observable = Observable<Any>.never()

        var noEle = true

        observable.subscribe(onNext: { _ in
            print("onNext")
            noEle = false
        }, onError: { _ in
            print("Error")
            noEle = false
        }, onCompleted: {
            print("onCompleted")
            noEle = false
        }).disposed(by: disposeBag)

        XCTAssertTrue(noEle)
    }
    // MARK: of
    func testCreateObservableUsingOf() {
        var target = 0
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .subscribe(onNext: { element in
                target += 1
                print(element)
            }, onError: { err in
                print(err)
            }, onCompleted: {
                print("complete")
            }, onDisposed: {
                print("source dispose")
            })
            .disposed(by: disposeBag)
        XCTAssertEqual(target, 4, "isEqual")
    }

    // MARK: range
    func testCreateObservableUsingRange() {
        var target = 0

        Observable<Int>.range(start: 1, count: 20).subscribe { value in
            target = value
            print("value == ", value)
        }.disposed(by: disposeBag)

        XCTAssertEqual(target, 20, "isEqual")
    }

    // MARK: generate
    func testCreateObservableUsingGenerate() {
        Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            iterate: { $0 + 1 })
        .subscribe { value in
            print("value == ", value)
        }.disposed(by: disposeBag)
        /*
         value ==  next(0)
         value ==  next(1)
         value ==  next(2)
         value ==  completed
         */

        XCTAssertTrue(true)
    }
    // MARK: - doOn
    func testCreateObservableUsingDoOn() {
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { print("Intercepted:", $0) },
                afterNext: { print("Intercepted after:", $0) },
                onError: { print("Intercepted error:", $0) },
                afterError: { print("Intercepted after error:", $0) },
                onCompleted: { print("Completed") },
                afterCompleted: { print("After completed") })
            .subscribe(onNext: { print("onNext" + $0) })
            .disposed(by: disposeBag)

        XCTAssertTrue(true)

                /*
                 Intercepted: 🍎
                 onNext🍎
                 Intercepted after: 🍎
                 Intercepted: 🍐
                 onNext🍐
                 Intercepted after: 🍐
                 Intercepted: 🍊
                 onNext🍊
                 Intercepted after: 🍊
                 Intercepted: 🍋
                 onNext🍋
                 Intercepted after: 🍋
                 Completed
                 After completed
                 */
    }

    // MARK: create
    func testCreateObservable() {
        /*
         create 操作符将创建一个 Observable，你需要提供一个构建函数，在构建函数里面描述事件（next，error，completed）的产生过程。

         通常情况下一个有限的序列，只会调用一次观察者的 onCompleted 或者 onError 方法。并且在调用它们后，不会再去调用观察者的其他方法。
         */
        let observable = Observable<Int>.create { observer in
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onNext(7)
            observer.onNext(8)
            observer.onNext(9)
            observer.onCompleted()
            return Disposables.create()
        }

        let observe = AnyObserver<Int>.init { event in
            switch event {
            case .next(let name):
                print("name == ", name)

            case .error(let err):
                print("err == ", err)

            case .completed:
                print("completed")
            }
        }
        observable.subscribe(observe).disposed(by: disposeBag)

        observable.subscribe { value in
            print("value == ", value)
        } onError: { err in
            print("err == ", err)
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("onDisposed")
        }
        .disposed(by: disposeBag)

        XCTAssertTrue(true)
    }
}
