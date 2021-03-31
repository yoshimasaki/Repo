//
//  SearchFieldModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

final class SearchFieldModel {

    @Published private(set) var state: SearchFieldModelState = .none

    var text: String? {
        didSet {
            updateState(with: text, oldText: oldValue)
        }
    }

    func textFieldDidBeginEditing() {
        state = .didBeginEditing
    }

    func textFieldDidEndEditing() {
        state = .didEndEditing
    }

    private func updateState(with text: String?, oldText: String?) {
        guard isNeedUpdatePlaceholderHidden(text: text, oldText: oldText) else {
            return
        }

        guard let aText = text, !aText.isEmpty else {
            state = .updatePlaceholderHidden(false)
            return
        }

        state = .updatePlaceholderHidden(true)
    }

    private func isNeedUpdatePlaceholderHidden(text: String?, oldText: String?) -> Bool {
        guard
            let aText = text,
            let aOldText = oldText
        else {
            return true
        }

        return aText.isEmpty != aOldText.isEmpty
    }
}
