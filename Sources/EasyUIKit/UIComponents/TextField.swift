//
//  File.swift
//  
//
//  Created by Роман Мисников on 04.03.2020.
//

import UIKit

protocol UITextFieldProperties {
    var clearButtonMode: UITextField.ViewMode { get set }
    var delegate: UITextFieldDelegate? { get set }
    var isEditing: Bool { get }
    var isSecureTextEntry: Bool { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var keyboardAppearance: UIKeyboardAppearance { get set }
    var keyboardType: UIKeyboardType { get set }
}

@available(iOS 13.0, *)
public final class TextField: UIView {
    // MARK: Internal types
    public enum Status {
        case `default`, success, failure
    }

    private enum Constant {
        static let iconsSize: CGFloat = 20
        static let textFieldInset: CGFloat = 8
        static let minLabelTrailing: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let descriptionFontSize: CGFloat = 12
    }

    // MARK: UI components
    private var textField = UITextField()
    private let textFieldContainer = UIView()
    private let label = UILabel()
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
    private let descriptionLabel = UILabel()
    // MARK: Constraints
    private var leftImageWidthConstraint: NSLayoutConstraint?
    private var rightImageWidthConstraint: NSLayoutConstraint?
    private var descriptionLabelHeightConstraint: NSLayoutConstraint?

    // MARK: Delegate
    public weak var delegate: UITextFieldDelegate? {
        didSet {
            self.textField.delegate = self.delegate
        }
    }

    // MARK: Global
    public var status: Status = .default {
        didSet {
            self.updateColors()
            self.updateRightImage()
            self.updateDescription()
        }
    }

    public var text: String {
        return self.textField.text ?? ""
    }

    public var isValid: Bool {
        return self.checkIfTextIsValid?(self.text) ?? false
    }

    // MARK: Colors
    public var failureColor: UIColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    public var successColor: UIColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    public var descriptionColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3519905822)
    // MARK: Icons
    public var leftIcon: UIImage? { didSet { self.updateLeftImage() } }
    public var successIcon = UIImage(systemName: "checkmark.circle")
    public var failureIcon = UIImage(systemName: "exclamationmark.circle")
    // MARK: Variables
    public var placeholderText: String? { willSet { self.textField.placeholder = newValue } }
    public var labelText: String? { willSet { self.label.text = newValue } }
    public var descriptionText: String? { didSet { self.updateDescription() } }
    public var validationSuccessText: String?
    public var validationFailureText: String?
    public var checkIfTextIsValid: ((String) -> Bool)?
    public var valueChangedHandler: ((String) -> Void)?
    // MARK: Sizes
    public var cornerRadius: CGFloat = 8

    // MARK: Superclass
    // swiftlint:disable:next implicitly_unwrapped_optional
    public override var tintColor: UIColor! {
        didSet { self.updateColors() }
    }

    public init(_ label: String? = nil,
         placeholder: String? = nil,
         icon: UIImage? = nil,
         cornerRadius: CGFloat = 8,
         validationAction: ((String) -> Bool)? = nil,
         valueChangedHandler: ((String) -> Void)? = nil) {

        self.labelText = label
        self.placeholderText = placeholder
        self.leftIcon = icon
        self.cornerRadius = cornerRadius
        self.checkIfTextIsValid = validationAction
        self.valueChangedHandler = valueChangedHandler

        super.init(frame: .zero)

        self.setupProperties()
        self.setupConstraints()
        self.updateColors()
        self.updateLeftImage()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(self.textFieldContainer.bounds.height / 2, self.cornerRadius)
        self.textFieldContainer.layer.cornerRadius = radius
    }

    public func validate() {
        guard let isValidText = self.checkIfTextIsValid?(text) else { return }
        self.status = text.isEmpty
            ? .default
            : isValidText ? .success : .failure
    }
}

// MARK: - UITextFieldProperties
@available(iOS 13.0, *)
extension TextField: UITextFieldProperties {
    public var clearButtonMode: UITextField.ViewMode {
        get { return self.textField.clearButtonMode }
        set { self.textField.clearButtonMode = newValue }
    }

    public var isEditing: Bool {
        return self.textField.isEditing
    }

    public var isSecureTextEntry: Bool {
        get { return self.textField.isSecureTextEntry }
        set { self.textField.isSecureTextEntry = newValue }
    }

    public var returnKeyType: UIReturnKeyType {
        get { return self.textField.returnKeyType }
        set { self.textField.returnKeyType = newValue }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        get { return self.textField.keyboardAppearance }
        set { self.textField.keyboardAppearance = newValue }
    }

    public var keyboardType: UIKeyboardType {
        get { return self.textField.keyboardType }
        set { self.textField.keyboardType = newValue }
    }
}

// MARK: - Private
@available(iOS 13.0, *)
private extension TextField {
    // MARK: Computed
    var needLeftImage: Bool {
        return self.leftIcon != nil
    }

    var needRightImage: Bool {
        switch self.status {
        case .default:
            return false
        case .success, .failure:
            return true
        }
    }

    var needDescripitionLabel: Bool {
        return self.helperText != nil
    }

    var helperText: String? {
        switch self.status {
        case .default:
            return self.descriptionText
        case .success:
            return self.validationSuccessText
        case .failure:
            return self.validationFailureText
        }
    }

    var helperTextColor: UIColor {
        switch self.status {
        case .default:
            return self.descriptionColor
        case .success:
            return self.successColor
        case .failure:
            return self.failureColor
        }
    }

    var attributedHelperText: NSAttributedString? {
        guard let text = self.helperText else { return nil }
        return NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: Constant.descriptionFontSize),
                .foregroundColor: self.helperTextColor,
        ])
    }

    // MARK: Setup
    func setupConstraints() {
        self.addSubview(self.textFieldContainer)
        self.addSubview(self.label)
        self.addSubview(self.descriptionLabel)
        self.textFieldContainer.addSubview(self.textField)
        self.textFieldContainer.addSubview(self.leftImageView)
        self.textFieldContainer.addSubview(self.rightImageView)

        // label
        self.label.top(to: self)
        self.label.leading(to: self.textField)
        self.label.trailing(to: self, offset: Constant.minLabelTrailing, relation: .equalOrLess, priority: .defaultLow)
        // text field container
        self.textFieldContainer.top(to: self.label, self.label.centerYAnchor)
        self.textFieldContainer.leadingToSuperview()
        self.textFieldContainer.trailingToSuperview()
        // left image
        self.leftImageView.leading(to: self.textFieldContainer, offset: Constant.textFieldInset)
        self.leftImageWidthConstraint = self.leftImageView.width(0)
        self.leftImageView.heightToWidth(of: self.leftImageView)
        self.leftImageView.centerYToSuperview()
        // text field
        self.textField.topToBottom(of: self.label, offset: Constant.textFieldInset)
        self.textField.leadingToTrailing(of: self.leftImageView, offset: Constant.textFieldInset)
        self.textField.centerYToSuperview()
        // right image
        self.rightImageView.leadingToTrailing(of: self.textField, offset: Constant.textFieldInset)
        self.rightImageWidthConstraint = self.rightImageView.width(0)
        self.rightImageView.heightToWidth(of: self.rightImageView)
        self.rightImageView.trailing(to: self.textFieldContainer, offset: -Constant.textFieldInset)
        self.rightImageView.centerYToSuperview()
        // description label
        self.descriptionLabel.topToBottom(of: self.textFieldContainer)
        self.descriptionLabel.leading(to: self.textField)
        self.descriptionLabel.trailingToSuperview()
        self.descriptionLabel.bottomToSuperview()
        self.descriptionLabelHeightConstraint = self.descriptionLabel.height(0)
    }

    func setupProperties() {
        self.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.684369649)
        self.label.backgroundColor = .white
        self.label.text = self.labelText
        self.textField.placeholder = self.placeholderText

        self.textFieldContainer.layer.borderWidth = Constant.borderWidth
        self.textFieldContainer.layer.masksToBounds = true
        self.textField.addTarget(self, action: #selector(self.didChangeText), for: .editingChanged)
    }

    // MARK: Update
    func updateLeftImage() {
        self.leftImageView.image = self.leftIcon
        self.leftImageWidthConstraint?.constant = self.needLeftImage ? Constant.iconsSize : 0
    }

    func updateRightImage() {
        switch self.status {
        case .success:
            self.rightImageView.image = self.successIcon
        case .failure:
            self.rightImageView.image = self.failureIcon
        case .default:
            break
        }
        self.rightImageWidthConstraint?.constant = self.needRightImage ? Constant.iconsSize : 0
    }

    func updateDescription() {
        self.descriptionLabel.attributedText = self.attributedHelperText
        self.descriptionLabelHeightConstraint?.constant = self.needDescripitionLabel
            ? self.descriptionLabel.intrinsicContentSize.height
            : 0
    }

    func updateColors() {
        switch self.status {
        case .default:
            self.label.textColor = self.tintColor
            self.leftImageView.tintColor = self.tintColor
            self.textFieldContainer.layer.borderColor = self.tintColor.cgColor
        case .success:
            self.label.textColor = self.successColor
            self.rightImageView.tintColor = self.successColor
            self.textFieldContainer.layer.borderColor = self.successColor.cgColor
        case .failure:
            self.label.textColor = self.failureColor
            self.rightImageView.tintColor = self.failureColor
            self.textFieldContainer.layer.borderColor = self.failureColor.cgColor
        }
    }

    // MARK: Handlers
    @objc func didChangeText() {
        guard let text = self.textField.text else { return }
        self.valueChangedHandler?(text)
        self.validate()
    }
}
