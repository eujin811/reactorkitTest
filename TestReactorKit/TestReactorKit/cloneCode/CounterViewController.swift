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
    
    let countLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .black
    }
    let increaseButton = UIButton().then {
        $0.setTitle("follow", for: .normal)
        $0.backgroundColor = .gray
    }
    let decreaseButton = UIButton().then {
        $0.setTitle("down", for: .normal)
        $0.backgroundColor = .lightGray
    }
    let activityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .large
    }
    
    override func loadView() {
        super.loadView()
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(increaseButton)
        view.addSubview(decreaseButton)
        view.addSubview(countLabel)
        
        view.addSubview(activityIndicatorView)
        
        increaseButton.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.trailing.equalTo(view.snp.centerX)
            $0.centerY.equalToSuperview()
        }
        decreaseButton.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.leading.equalTo(view.snp.centerX)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(increaseButton.snp.top)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.centerY.equalToSuperview()
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
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
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
        
        reactor?.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
