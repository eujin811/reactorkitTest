//
//  UserViewController.swift
//  TestReactorKit
//
//

import UIKit

import Then
import SnapKit

import ReactorKit
import RxCocoa
import RxSwift


final class CounterViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let countLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .black
    }
    private let increaseButton = UIButton().then {
        $0.setTitle("follow", for: .normal)
        $0.backgroundColor = .gray
    }
    
    override func loadView() {
        super.loadView()
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(increaseButton)
        view.addSubview(countLabel)
        
        increaseButton.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.centerX.centerY.equalToSuperview()
        }
        countLabel.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(increaseButton.snp.top)
        }
    }
    
    func bind(reactor: CounterViewReactor) {
        bindAction()
        bindState()
    }
    
    // ui -> reactor
    private func bindAction() {
        guard let reactor = reactor else { return }
        increaseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    // reactor -> ui
    private func bindState() {
        reactor?.state
            .map { String($0.value) }
            .distinctUntilChanged()
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
