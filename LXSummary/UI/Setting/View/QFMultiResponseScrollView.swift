//
//  QFMultiResponseScrollView.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/8/3.
//

import UIKit

class QFMultiResponseScrollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
