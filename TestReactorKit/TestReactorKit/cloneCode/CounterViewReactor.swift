//
//  UserViewReactor.swift
//  TestReactorKit
//
//

import Foundation

import ReactorKit
import RxCocoa
import RxSwift

final class CounterViewReactor: Reactor {
    
    // view로 부터 받을 Action
    enum Action {
        case increase
        case decrease
    }
    
    // 전달 받은 action들의 작업단위 (기능)
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    // 현재상태의 기록.
    // view에서 해당 정보 사용, ui update, reactor에서 image 얻어올 때 page 정보 저장.
    struct State {
        var value: Int
        var isLoading: Bool
    }
    
    let initialState: State //= State(value: 0, isLoading: false)
    
    init() {
        self.initialState = State(value: 0, isLoading: false)
    }
    
    // action 들어온 경우 처리.
    // 작업단위 처리.
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.increaseValue)
                    .delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        }
    }
    
    // 현재상태와 작업단위 받아서 최종 상태 반환
    // mutate 실행 후 바로 해당 메소드 실행.
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
}
