//
//  TagView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

public protocol EditableTagViewDelegate {
    func didTapLinkClient()
}

@IBDesignable
open class EditableTagView: UIView {
    
    var linkedClients: [String] = []
    
    var delegate : EditableTagViewDelegate?
    
    var textfield: UITextField = UITextField()
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(frame: CGRect, linkedClients: [String]) {
        super.init(frame: frame)
    
        self.linkedClients = linkedClients
        
        setupViews()
    }
    
    private func setupViews() {
        let closeButton = CloseButton()
        closeButton.frame = CGRect(x: 2.0, y: 2.0, width: 24.0, height: 24.0)
        closeButton.layer.cornerRadius = closeButton.frame.size.width / 2
        closeButton.lineWidth = 1
        closeButton.iconSize = 12
        closeButton.lineColor = UIColor.white
        closeButton.backgroundColor = UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1)
        closeButton.clipsToBounds = true
        addSubview(closeButton)
        
        textfield = UITextField(frame: CGRect(x: 40.0, y: 4.0, width: frame.size.width / 2 - 36.0, height: 20.0))
        textfield.placeholder = "Tag name"
        
        let separatorView = UIView()
        separatorView.frame = CGRect(x: center.x - 0.5, y: 1.0, width: 1.0, height: frame.size.height - 2.0)
        separatorView.center.x = center.x
        separatorView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        addSubview(separatorView)
        
        let accessoryImageView = UIImageView(image: #imageLiteral(resourceName: "client_disclosure"))
        accessoryImageView.frame.origin = CGPoint(x: frame.size.width - accessoryImageView.frame.size.width, y: 8.0)
        addSubview(accessoryImageView)
        
        if #available(iOS 9.0, *) {
            let stackView   = UIStackView()
            
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
        
        addSubview(textfield)
    }
    
    public func textfieldResignFirstResponder() {
        textfield.becomeFirstResponder()
    }
    
    // notify the delegate that the stack view has been tapped
    @objc func stackViewTapped() {
        delegate?.didTapLinkClient()
    }
}

