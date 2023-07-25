//
//  CombiningOperators.swift
//  LXSummaryTests
//
//  Created by LingXiao Dai on 2023/7/25.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa

final class CombiningOperators: XCTestCase {

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

    // MARK: startWith
    func testStartWith() {
        let animals = ["🐶", "🐱", "🐭", "🐹"] // last excuted

        Observable.from(animals)
            .startWith("1", "2", "3") // second excuted
            .startWith("4", "5", "6") // first excuted
            .subscribe { print("value", $0) }
            .disposed(by: disposeBag)
        /**
         value next(4)
         value next(5)
         value next(6)
         value next(1)
         value next(2)
         value next(3)
         value next(🐶)
         value next(🐱)
         value next(🐭)
         value next(🐹)
         */

        XCTAssertTrue(true)
    }

    // MARK: merge
    func testMerge() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()

        /// **Combines elements from source Observable sequences into a single new Observable sequence, and will emit each element as it is emitted by each source Observable sequence.**

        Observable.merge([subject1, subject2])
            .subscribe(onNext: { print("value == ", $0) })
            .disposed(by: disposeBag)

        subject1.onNext("🅰️")

        subject1.onNext("🅱️")

        subject2.onNext("①")

        subject2.onNext("②")

        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print("value of 2 == ", $0) })
            .disposed(by: disposeBag)

        subject1.onNext("🆎")

        subject2.onNext("③")

        /*
         value ==  🅰️
         value ==  🅱️
         value ==  ①
         value ==  ②
         value ==  🆎
         value ==  ③
         */
    }

    // MARK: zip
    func testZip() {
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()

        var subscribeCount = 0

        Observable.zip(stringSubject, intSubject).map { "\($0) \($1)" }
            .subscribe(onNext: {
                subscribeCount += 1
                print("value == ", $0)
            })
            .disposed(by: disposeBag)

        /*
         zip 操作符将多个(最多不超过8个) Observables 的元素通过一个函数组合起来，然后将这个组合的结果发出来。它会严格的按照序列的索引数进行组合。例如，返回的 Observable 的第一个元素，是由每一个源 Observables 的第一个元素组合出来的。它的第二个元素 ，是由每一个源 Observables 的第二个元素组合出来的。它的第三个元素 ，是由每一个源 Observables 的第三个元素组合出来的，以此类推。它的元素数量等于源 Observables 中元素数量最少的那个。
         */

        stringSubject.onNext("🅰️")
        stringSubject.onNext("🅱️")

        intSubject.onNext(1)
        intSubject.onNext(2)

        stringSubject.onNext("🆎")
        intSubject.onNext(3)
        intSubject.onNext(4)
        intSubject.onNext(5)

        /**
         value ==  🅰️ 1
         value ==  🅱️ 2
         value ==  🆎 3
         */
        XCTAssertEqual(subscribeCount, 3)
    }

    func testCombineLatest() {

        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        /*
         combineLatest 操作符将多个 Observables 中最新的元素通过一个函数组合起来，然后将这个组合的结果发出来。这些源 Observables 中任何一个发出一个元素，他都会发出一个元素（前提是，这些 Observables 曾经都发出过元素）。
         */

        Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
                "\(stringElement) \(intElement)"
        }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        stringSubject.onNext("🅰️")

        stringSubject.onNext("🅱️")
        intSubject.onNext(1)

        intSubject.onNext(2)

        stringSubject.onNext("🆎")
        
        intSubject.onNext(3)
        /*
         🅱️ 1
         🅱️ 2
         🆎 2
         🆎 3
         */
    }
}
