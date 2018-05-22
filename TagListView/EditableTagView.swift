//
//  TagView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

public protocol EditableTagViewDelegate {
    func didTapLinkClient(tag: String?)
    func didTapRemove()
}

@IBDesignable
open class EditableTagView: UIView {
    
    var linkedClients: [String] = [] {
        didSet {
            
            for view in subviews {
                if #available(iOS 9.0, *) {
                    if (view is UIStackView) {
                        view.removeFromSuperview()
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            
            setupViews()
        }
    }
    
    var delegate : EditableTagViewDelegate?
    
    var closeButton: CloseButton = CloseButton()
    var separatorView: UIView = UIView()
    var accessoryImageView: UIImageView = UIImageView()
    var textfield: UITextField = UITextField()
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        textfield = UITextField(frame: CGRect(x: 40.0, y: 4.0, width: UIScreen.main.bounds.size.width / 2 - 76.0, height: 20.0))
        textfield.placeholder = "Tag name"
        addSubview(textfield)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        textfield = UITextField(frame: CGRect(x: 40.0, y: 4.0, width: UIScreen.main.bounds.size.width / 2 - 76.0, height: 20.0))
        textfield.placeholder = "Tag name"
        addSubview(textfield)
    }
    
    public init(frame: CGRect, linkedClients: [String]) {
        super.init(frame: frame)
    
        self.linkedClients = linkedClients
        
        textfield = UITextField(frame: CGRect(x: 40.0, y: 4.0, width: frame.size.width / 2 - 36.0, height: 20.0))
        textfield.placeholder = "Tag name"
        addSubview(textfield)
        
        setupViews()
    }
    
    private func setupViews() {
        textfield.addTarget(self, action: #selector(textfieldTextDidChange), for: .editingChanged)
        
        closeButton.frame = CGRect(x: 4.0, y: 2.0, width: 24.0, height: 24.0)
        closeButton.layer.cornerRadius = closeButton.frame.size.width / 2
        closeButton.lineWidth = 1
        closeButton.iconSize = 12
        closeButton.lineColor = UIColor.white
        closeButton.backgroundColor = UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1)
        closeButton.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        addSubview(closeButton)
        
        separatorView.frame = CGRect(x: center.x - 0.5, y: 1.0, width: 1.0, height: frame.size.height - 2.0)
        separatorView.center.x = center.x
        separatorView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        addSubview(separatorView)
        
        //accessoryImageView = UIImageView(image: #imageLiteral(resourceName: "gray_disclosure"))
        accessoryImageView.frame.origin = CGPoint(x: UIScreen.main.bounds.size.width - 32.0 - accessoryImageView.frame.size.width, y: 8.0)
        let accessoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        accessoryImageView.addGestureRecognizer(accessoryTapGesture)
        addSubview(accessoryImageView)
        
        if #available(iOS 9.0, *) {
            let stackView = UIStackView()
            stackView.axis = UILayoutConstraintAxis.vertical
            stackView.distribution = UIStackViewDistribution.equalSpacing
            stackView.alignment = UIStackViewAlignment.top
            stackView.spacing = 8.0
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            if (linkedClients.count > 0) {
                for i in 0...linkedClients.count - 1 {
                    let textLabel = UILabel()
                    textLabel.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
                    textLabel.text  = linkedClients[i]
                    textLabel.textAlignment = .left
                    textLabel.textColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
                
                    stackView.addArrangedSubview(textLabel)
                }
            }
            
            addSubview(stackView)
            
            //Constraints
            stackView.leftAnchor.constraint(equalTo: centerXAnchor, constant: 16.0).isActive = true
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0).isActive = true
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4.0).isActive = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
            stackView.addGestureRecognizer(tapGesture)
            
        } else {
            // TODO: Fallback on earlier versions
            // no need for this, no one is using iOS 8.0
        }
    }
    
    public func text() -> String {
        return textfield.text ?? ""
    }
    
    public func clearSubViews() {
        closeButton.removeFromSuperview()
        separatorView.removeFromSuperview()
        accessoryImageView.removeFromSuperview()
    }
    
    public func textfieldBecomeFirstResponder() {
        textfield.becomeFirstResponder()
    }
    
    public func textfieldResignFirstResponder() {
        textfield.resignFirstResponder()
        // endEditing(true)
    }
    
    // notify the delegate that the stack view has been tapped
    @objc func stackViewTapped() {
        delegate?.didTapLinkClient(tag: textfield.text)
    }
    
    @objc func removeButtonTapped() {
        delegate?.didTapRemove()
    }
    
    @objc func textfieldTextDidChange() {
        textfield.text = textfield.text?.replacingOccurrences(of: " ", with: "")
    }
}

