//
//  VerticalScrollView.swift
//  
//
//  Created by Роман Мисников on 22.03.2020.
//

import UIKit
import TinyConstraints

public class VerticalScrollView: UIScrollView {
    
    private var container: UIView!
    
    public init(container: UIView) {
        self.container = container
        super.init(frame: .zero)
        self.setup()
    }
    
    public convenience init(views: [UIView], spacing: CGFloat = 8) {
        let container = UIView()
        container.stack(views, spacing: spacing)
        self.init(container: container)
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension VerticalScrollView {
    func setup() {
        self.addSubview(self.container)
        self.container.edgesToSuperview()
        self.container.widthToSuperview()
    }
}
