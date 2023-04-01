//
//  UIButton+Extension.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 02.04.2023.
//

import UIKit

final class CustomButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate()
    }

    private func animate() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.08, delay: 0, options: .curveLinear) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.08, delay: 0, options: .curveLinear) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in
                self.isUserInteractionEnabled = true
            }
        }
    }
}
