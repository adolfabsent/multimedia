//
//  CustomButton.swift
//  Multimedia
//
//  Created by Максим Зиновьев on 17.10.2023.
//

import UIKit

class CustomButton: UIButton {

    var closure = {}

    init(title: String, width: CGFloat? = nil, height: CGFloat? = nil, titleColor: UIColor = .black, backgroundColor: UIColor = .white, translate: Bool = false) {

        super.init(frame: .zero)

        self.backgroundColor = backgroundColor
        translatesAutoresizingMaskIntoConstraints = translate
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addTarget(nil, action: #selector(ButtonDidTap), for: .touchUpInside)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)

        if width != nil {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: width!)
                ])
        }

        if height != nil {
                NSLayoutConstraint.activate([
                    self.heightAnchor.constraint(equalToConstant: height!)
                    ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func ButtonDidTap() {
        closure()
    }
}
