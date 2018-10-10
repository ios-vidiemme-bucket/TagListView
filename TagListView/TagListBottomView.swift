//
//  TagListBottomView.swift
//  TagListViewDemo
//
//  Created by Pasquale Ambrosini on 09/10/2018.
//  Copyright © 2018 Ela. All rights reserved.
//

import UIKit

protocol TagListBottomViewEventHandler: class {
    func onRightViewTapped(bottomView: TagListBottomView)
    func onTagNameChanged(bottomView: TagListBottomView, tag: String)
}

class TagListBottomView: UIStackView {
    
    @IBOutlet weak var tagCell: UIStackView!
    @IBOutlet weak var addCell: UIStackView!
    @IBOutlet weak var addTitleButton: UIButton!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var tagNameTextField: UITextField!
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var tagHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var addHeightConstraint: NSLayoutConstraint?
    weak var eventHandler: TagListBottomViewEventHandler?
    
    public var showsRightValues: Bool = false {
        didSet {
            if self.rightStackView != nil {
                self.rightStackView.isHidden = !self.showsRightValues
                self.dividerView.isHidden = !self.showsRightValues
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.tagCell.isHidden = true
        self.dividerView.isHidden = true
        
        let rightViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(rightViewTapped))
        rightStackView.addGestureRecognizer(rightViewTapGesture)
        self.tagNameTextField.delegate = self
    }
    
    @objc func rightViewTapped() {
        self.eventHandler?.onRightViewTapped(bottomView: self)
    }
    
    func onTagNameChanged() {
        guard self.tagNameTextField.text ?? "" != "" else { return }
        self.eventHandler?.onTagNameChanged(bottomView: self, tag: self.tagNameTextField.text ?? "")
        self.tagNameTextField.endEditing(true)
    }
    
    func addDetailsLabels(labels: [String]) {
        func gimmeTheLabel(text: String) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = .black
            label.font = label.font.withSize(15)
            label.heightAnchor.constraint(equalToConstant: self.tagNameTextField.frame.size.height).isActive = true
            return label
        }
        self.rightStackView.tagsListRemoveAllArrangedSubviews()
        for l in labels {
            let label = gimmeTheLabel(text: l)
            self.rightStackView.addArrangedSubview(label)
        }
        self.rightStackView.layoutIfNeeded()
    }
    
    static func fromXib() -> TagListBottomView {
        return UINib(nibName: "TagListBottomView", bundle: Bundle(for: self.self)).instantiate(withOwner: nil, options: nil)[0] as! TagListBottomView
    }
    
    @IBAction func onAddLabelSelected(_ sender: Any) {
        guard self.tagCell.isHidden else { return }
        self.tagCell.isHidden = false
        self.tagCell.alpha = 0.0
        self.tagHeightConstraint?.constant = self.addHeightConstraint?.constant ?? 100
        self.tagCell.layoutIfNeeded()
        self.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
            self.superview?.invalidateIntrinsicContentSize()
            self.tagCell.alpha = 1.0
        }
    }
    @IBAction func onRemoveButtonSelected(_ sender: Any) {
        (self.superview as? TagListView)?.resetEditableView()
    }
}

extension TagListBottomView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onTagNameChanged()
        return true
    }
}

fileprivate extension UIStackView {
    
    func tagsListRemoveAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
