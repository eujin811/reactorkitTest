//
//  CounterReactorTests.swift
//  TestReactorKitTests
//
// 참고: https://ios-development.tistory.com/783?category=1021553

import XCTest
import RxSwift

@testable import TestReactorKit

class CounterReactorTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // View에서 Reactor에 Action
    func testAction_whenDidTapDecreaseButtonInView_thenMutationIsDecreaseInReactor() {
    // given
        
        // reactor 준비.
        let counterReactor = CounterViewReactor()
        counterReactor.isStubEnabled = true
        
        let counterViewController = CounterViewController()
        counterViewController.loadView()
        counterViewController.reactor = counterReactor
        
    // when
        counterViewController.decreaseButton.sendActions(for: .touchUpInside)
        
    // then
        XCTAssertEqual(counterReactor.stub.actions.last, .decrease)
    }
    
    // view에서 reactor 구독 잘하고 있니?
    // indicator 잘 돌고있니?
    func testState_whenChangeLoadingStateToTrueInReactor_thenActivityIndicatorViewIsAnimatingInView() {
    // given
        let counterReactor = CounterViewReactor()
        counterReactor.isStubEnabled = true

        let counterViewController = CounterViewController()
        counterViewController.loadView()
        counterViewController.reactor = counterReactor

    // when
        counterReactor.stub.state.value = CounterViewReactor.State(value: 0, isLoading: true)
        
    // then
        XCTAssertEqual(counterViewController.activityIndicatorView.isAnimating, true)
    }
    
    // action 받을 때 비즈니스 로직(Mutation) 잘 처리되는지 State값이 기대하는 값으로 변경되는지 확인.
    func testAction_whenDidTapIncreaseButtonTapActionInView_thenStateIsLoadingInReactor() {
        // given
        let reactor = CounterViewReactor()
        
        // when
        reactor.action.onNext(.increase)
        
        // then
        XCTAssertEqual(reactor.currentState.isLoading, true)
    }
    
    // 비동기 처리 test
    func testReactor_whenExecuteIncreaseButtonTapActionInView_thenStateValueIsChanged() {
        // given
        let reactor = CounterViewReactor()
        let expectation = XCTestExpectation(description: "Test Description")
        reactor.state.map(\.value)
            .distinctUntilChanged()
            .filter { $0 == 1 }
            .subscribe(onNext: { value in expectation.fulfill() })
            .disposed(by: disposeBag)
        
        // when
        reactor.action.onNext(.increase)
        
        // then
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
