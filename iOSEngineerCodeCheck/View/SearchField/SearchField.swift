//
//  SearchField.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

final class SearchField: UIView {

    @Published var text: String? {
        didSet {
            textField.text = text
            viewModel.text = text
        }
    }

    @Published private(set) var state: SearchFieldState = .none

    var placeholder: String? {
        get {
            placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }

    private let searchIconView = UIImageView(frame: .zero)
    private let textField = UITextField(frame: .zero)
    private let placeholderLabel = UILabel(frame: .zero)

    private let viewModel = SearchFieldModel()

    private var stateSubscription: AnyCancellable?
    private var textFieldFocusAnimator: UIViewPropertyAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        configureConstraints()
        subscribeState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var bounds: CGRect {
        didSet {
            updateViewCornerRadius()
        }
    }

    private func configureViews() {
        let searchIcon = UIImage(systemName: "magnifyingglass")
        assert(searchIcon != nil, "Search icon does not exist in SF Symbols")
        searchIconView.image = searchIcon

        searchIconView.tintColor = UIColor.systemGray2

        textField.font = UIFont.systemFont(ofSize: 24)
        textField.delegate = self
        textField.returnKeyType = .search
        textField.addTarget(self, action: #selector(handleTextFieldEditingChanged(sender:)), for: .editingChanged)

        placeholderLabel.font = UIFont.systemFont(ofSize: 24)
        placeholderLabel.textColor = UIColor.systemGray2

        backgroundColor = .systemBackground

        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 2

        layer.cornerCurve = .continuous
    }

    private func configureConstraints() {
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(searchIconView)
        addSubview(placeholderLabel)
        addSubview(textField)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),

            searchIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchIconView.widthAnchor.constraint(equalToConstant: 32),
            searchIconView.heightAnchor.constraint(equalTo: searchIconView.widthAnchor),

            textField.centerYAnchor.constraint(equalTo: searchIconView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            placeholderLabel.centerYAnchor.constraint(equalTo: searchIconView.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 8),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    private func updateViewCornerRadius() {
        layer.cornerRadius = bounds.height * 0.5
    }

    private func subscribeState() {
        stateSubscription = viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state) in
                self?.handleState(state)
            }
    }

    private func handleState(_ state: SearchFieldModelState) {
        print(#function, state)
        switch state {
        case .none:
            break

        case .didBeginEditing:
            updateTextFieldStyle(isFocus: true)
            self.state = .didBeginEditing

        case .didEndEditing:
            updateTextFieldStyle(isFocus: false)
            self.state = .didEndEditing

        case .updatePlaceholderHidden(let isHidden):
            placeholderLabel.isHidden = isHidden
        }
    }

    private func updateTextFieldStyle(isFocus: Bool) {
        textFieldFocusAnimator?.stopAnimation(true)
        textFieldFocusAnimator = UIViewPropertyAnimator(duration: 3, curve: .easeIn) {
            self.layer.shadowRadius = isFocus ? 10 : 2
        }
        textFieldFocusAnimator!.startAnimation()
    }

    @objc private func handleTextFieldEditingChanged(sender: UITextField) {
        text = sender.text
    }
}

extension SearchField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.textFieldDidBeginEditing()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.textFieldDidEndEditing()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        state = .searchButtonClicked
        textField.resignFirstResponder()

        return true
    }
}
