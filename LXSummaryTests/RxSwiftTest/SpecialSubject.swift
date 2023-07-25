//
//  SpecialSubject.swift
//  LXSummaryTests
//
//  Created by LingXiao Dai on 2023/7/25.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import RxRelay

final class SpecialSubject: XCTestCase {

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
}

extension SpecialSubject {
    // MARK: - AsyncSubject
    func testAsyncSubject() {
        let subject = AsyncSubject<String>()
        /*
         如果最后一个事件是 onCompleted ,那么会发送 onCompleted 之前的 ele 和  onCompleted 事件
         如果最后一个事件是 onErr, 那么 就只会 发送 err,
         */
        subject.onNext("🐶")
        subject.onNext("🐱")
        subject.onNext("🐹")
        subject.onCompleted()

        /*
         txt ==  🐹
         onCompleted
         onDisposed
         */
        // subject.onError("error")

        subject.subscribe(onNext: { txt in
            print("txt == ", txt)
        }, onError: { err in
            print("err == ", err)
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        }).disposed(by: disposeBag)
    }

    // MARK: - PublishSubject
    func testPublishSubject() {
        /*
         PublishSubject 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者。
         */
        let subject = PublishSubject<String>()
        var subject1Count: Int = 0
        var subject2Count: Int = 0

        subject.subscribe { txt in
            subject1Count += 1
            print("sub1 txt == ", txt)
        } onError: { err in
            print("err1 == ", err)
        } onCompleted: {
            print("sub1 onCompleted")
        } onDisposed: {
            print("sub1 onDisposed")
        }.disposed(by: disposeBag)

        subject.onNext("1🐶")
        subject.onNext("1🐱")

        subject.subscribe { txt in
            subject2Count += 1
            print("sub2 txt == ", txt)
        } onError: { err in
            print("err2 == ", err)
        } onCompleted: {
            print("sub2 onCompleted")
        } onDisposed: {
            print("sub2 onDisposed")
        }.disposed(by: disposeBag)

        subject.onNext("2🐶")
        subject.onNext("2🐱")

        XCTAssertEqual(subject1Count, 4)
        XCTAssertEqual(subject2Count, 2)
    }

    // MARK: - PublishRelay
    func aboutPublishRelay() {
        /// PublishRelay is a wrapper for `PublishSubject`.
        /// Unlike `PublishSubject` it can't terminate with error or completed.
    }

    // MARK: - ReplaySubject
    func testReplaySubject() {

        /*
         ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。
         buffersize 表示给新的订阅者 回放 的元素个数
         */

        let bufferSize = 2
        var count = 0

        let subject = ReplaySubject<String>.create(bufferSize: bufferSize)

        subject.subscribe { txt in
            print("sub1 txt == ", txt)
        } onError: { err in
            print("err1 == ", err)
        } onCompleted: {
            print("sub1 onCompleted")
        } onDisposed: {
            print("sub1 onDisposed")
        }.disposed(by: disposeBag)

        subject.onNext("1🐶")
        subject.onNext("1🐱")
        subject.onNext("1🅰️")
        subject.onNext("1🅱️")
        subject.onNext("2🐶")
        subject.onNext("2🐱")
        subject.onNext("2🅰️")
        subject.onNext("2🅱️")

        subject.subscribe { txt in
            print("sub2 txt == ", txt)
            count += 1
        } onError: { err in
            print("err2 == ", err)
        } onCompleted: {
            print("sub2 onCompleted")
        } onDisposed: {
            print("sub2 onDisposed")
        }.disposed(by: disposeBag)

        /*
         sub1 txt ==  1🐶
         sub1 txt ==  1🐱
         sub1 txt ==  1🅰️
         sub1 txt ==  1🅱️
         sub1 txt ==  2🐶
         sub1 txt ==  2🐱
         sub1 txt ==  2🅰️
         sub1 txt ==  2🅱️
         sub2 txt ==  2🅰️
         sub2 txt ==  2🅱️
         */

        XCTAssertEqual(count, bufferSize)
    }

    // MARK: - ReplayRelay
    func aboutReplayRelay() {
        /// ReplayRelay is a wrapper for `ReplaySubject`.
        ///
        /// Unlike `ReplaySubject` it can't terminate with an error or complete.
    }

    // MARK: - BehaviorSubject
    func testBehaviorSubject() {
        /*
         当观察者对 BehaviorSubject 进行订阅时，它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。
         */

        let disposeBag = DisposeBag()
        let subject = BehaviorSubject(value: "🔴")

        /*
         这个订阅 会 监听到 默认的 元素 "🔴" 和接下来的元素
         Subscription: 1 Event: next(🔴)
         Subscription: 1 Event: next(🐶)
         Subscription: 1 Event: next(🐱)
         Subscription: 1 Event: next(🅰️)
         Subscription: 1 Event: next(🅱️)
         Subscription: 1 Event: next(🍐)
         Subscription: 1 Event: next(🍊)
         */
        subject
          .subscribe { print("Subscription: 1 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🐶")
        subject.onNext("🐱")

        /*
         这个订阅 会 监听到 默认的 元素 "🐱" 和接下来的元素
         Subscription: 2 Event: next(🐱)
         Subscription: 2 Event: next(🅰️)
         Subscription: 2 Event: next(🅱️)
         Subscription: 2 Event: next(🍐)
         Subscription: 2 Event: next(🍊)
         */
        subject
          .subscribe { print("Subscription: 2 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🅰️")
        subject.onNext("🅱️")

        /*
         这个订阅 会 监听到 默认的 元素 "🅱️" 和接下来的元素
         Subscription: 3 Event: next(🅱️)
         Subscription: 3 Event: next(🍐)
         Subscription: 3 Event: next(🍊)
         */
        subject
          .subscribe { print("Subscription: 3 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🍐")
        subject.onNext("🍊")
    }

    // MARK: - BehaviorRelay
    func aboutBehaviorRelay() {
        /// BehaviorRelay is a wrapper for `BehaviorSubject`.
        ///
        /// Unlike `BehaviorSubject` it can't terminate with error or completed.
    }

    // MARK: - ControlProperty
    func testControlProperty() {
        /*
         ControlProperty 专门用于描述 UI 控件属性的，它具有以下特征：
         不会产生 error 事件
         一定在 MainScheduler 订阅（主线程订阅）
         一定在 MainScheduler 监听（主线程监听）
         共享附加作用
         https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable_and_observer/control_property.html
         */
    }
}

extension String: Error {
}
