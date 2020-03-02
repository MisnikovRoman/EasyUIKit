//
//  Button.swift
//  Created by Роман Мисников on 02.03.2020.
//

import UIKit

public enum ButtonStyle {
    case accent, outline, ghost
}

final public class Button: UIButton {
    
    private let title: String
    private let style: ButtonStyle
    private let color: UIColor
    private let foregroundColor: UIColor
    private var cornerRadius: CGFloat
    
    public var action: (() -> Void)?
    
    public init(_ text: String,
         style: ButtonStyle = .accent,
         color: UIColor = .blue,
         foregroundColor: UIColor = .white,
         cornerRadius: CGFloat = 8,
         action: (() -> Void)? = nil) {
        self.title = text
        self.style = style
        self.color = color
        self.cornerRadius = cornerRadius
        self.foregroundColor = foregroundColor
        self.action = action
        
        super.init(frame: .zero)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Button {
    func setup() {
        self.setTitle(self.title, for: .normal)
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(self.tapHandler), for: .touchUpInside)
        
        switch self.style {
        case .accent:
            self.backgroundColor = self.color
            self.setTitleColor(self.foregroundColor, for: .normal)
        case .outline:
            self.layer.borderColor = self.color.cgColor
            self.layer.borderWidth = 1
            self.setTitleColor(self.color, for: .normal)
        case .ghost:
            self.setTitleColor(self.color, for: .normal)
        }
    }
    
    @objc func tapHandler() {
        self.action?()
    }
}