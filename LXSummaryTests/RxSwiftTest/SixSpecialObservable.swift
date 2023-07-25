//
//  SixSpecialObservable.swift
//  LXSummaryTests
//
//  Created by LingXiao Dai on 2023/7/25.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa

final class SixSpecialObservable: XCTestCase {

    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

extension SixSpecialObservable {
    /*
     Single, Maybe, Completable 三个特征序列 都是只能产生一个事件，都不共享附加作用
     - single ,         one ele or one err
     - maybe  ,         one ele or one err or one comp
     - completable  ,   one err or one comp
     */

    // MARK: Single
    func testCreateSingle() {
        struct NetModel {
            let name: String
            let age: Int
        }

        var originModel: NetModel?

        var shareCount = 0

        let single = Single<NetModel>.create { single in
            single(.success(.init(name: "lingxiao", age: 18)))
            shareCount += 1
            return Disposables.create()
        }
        /*
         ```
         public static func create(subscribe: @escaping (@escaping SingleObserver) -> Disposable) -> Single<Element> {
         // 创建 Single 时传入的 Observer 逻辑如下
             let source = Observable<Element>.create { observer in
                 return subscribe { event in
                     switch event {
                     case .success(let element):
                         observer.on(.next(element))
                         observer.on(.completed)
                     case .failure(let error):
                         observer.on(.error(error))
                     }
                 }
             }
             
             return PrimitiveSequence(raw: source)
         }
         ```
         */

        single.subscribe { model in
            print("model == ", model)
            originModel = model
        } onFailure: { err in
            print("err == ", err)
            originModel = nil
        }
        .disposed(by: disposeBag)

        single.subscribe { model in
            print("model == ", model)
            originModel = model
        } onFailure: { err in
            print("err == ", err)
            originModel = nil
        }.disposed(by: disposeBag)

        single.subscribe { model in
            print("model == ", model)
            originModel = model
        } onFailure: { err in
            print("err == ", err)
            originModel = nil
        }.disposed(by: disposeBag)

        XCTAssertEqual(shareCount, 3)

        XCTAssertNotNil(originModel)
        /*
         Single 和 Observable 最大的不同是 内部 的Event 不一样
         - Observable 内部 是
             ```
             @frozen public enum Event<Element> {
                 /// Next element is produced.
                 case next(Element)

                 /// Sequence terminated with an error.
                 case error(Swift.Error)

                 /// Sequence completed successfully.
                 case completed
             }
             ```
         - Single 对 Event 通过  SingleEvent(Result 类型) 进行了特殊处理 根据 singleEvent 不同的值，内部调用 不同 Event 的方法
         */
    }

    // MARK: Maybe
    func testCreateMaybe() {

        let maybe = Maybe<Int>.create { mayBe in
            mayBe(.completed)
            return Disposables.create()
        }
        /**
         let source = Observable<Element>.create { observer in
             return subscribe { event in
                 switch event {
                 case .success(let element):
                     observer.on(.next(element))
                     observer.on(.completed)
                 case .error(let error):
                     observer.on(.error(error))
                 case .completed:
                     observer.on(.completed)
                 }
             }
         }
         */
    }

    // MARK: Completable
    func testCreateCompletable() {
        let cmp = Completable.create { obv in
            obv(.completed)
            return Disposables.create()
        }

        /**
         public static func create(subscribe: @escaping (@escaping CompletableObserver) -> Disposable) -> PrimitiveSequence<Trait, Element> {
             let source = Observable<Element>.create { observer in
         // 只有 Complete 和  error的  事件
                 return subscribe { event in
                     switch event {
                     case .error(let error):
                         observer.on(.error(error))
                     case .completed:
                         observer.on(.completed)
                     }
                 }
             }
             
             return PrimitiveSequence(raw: source)
         }
         */
    }
}

extension SixSpecialObservable {
    func testDriver() {
        /*
         Driver 参考文档
         https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/driver.html
         */
    }

    func testSignal() {
        /*
         Signal 参考文档
         https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/signal.html
         */
    }
}

extension SixSpecialObservable {
    func testControlEvent() {
        /*
         ControlEvent 参考文档
         https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/control_event.html
         */
    }
}

extension SixSpecialObservable {
    func testSingle_Empty() {
        let scheduler = TestScheduler(initialClock: 0)

        let xs = scheduler.createHotObservable([
            .next(150, 1),
            .completed(250)
        ])

        let res = scheduler.start {
            xs.asSingle()
        }

        XCTAssertEqual(res.events, [
            .error(250, RxError.noElements)
        ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 250)
        ])
    }
}
