//
//  TagListView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

public protocol EditableTagViewDelegate {
    func tagListDidTapLinkClient(tagsView: TagListView, tag: String?)
    func tagListOnNewTagAdded(tagsView: TagListView, tag: String)
    func didTapRemove()
}

@objc public protocol TagListViewDelegate {
    @objc optional func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    @objc optional func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
}

@IBDesignable
open class TagListView: UIView {
    
    public var bottomCellHeight: CGFloat = 30 {
        didSet {
            self.rearrangeViews()
        }
    }
    
    public var showVertical:Bool = false
    public var addingTag = false
    public var canShowAddButton = false
    public var tempTag: String?
    public var addTagLabel: String = ""
    
    public var editableTagDelegate : EditableTagViewDelegate?
    
    public var editableTagText: String? {
        return self.editableView?.tagNameTextField.text
    }
    
    open var addButton: UIButton? {
        return self.editableView?.addButton
    }
    
    open var removeButton: UIButton? {
        return self.editableView?.removeButton
    }
    
    @IBInspectable open dynamic var textColor: UIColor = UIColor.white {
        didSet {
            for tagView in tagViews {
                tagView.textColor = textColor
            }
        }
    }
    
    @IBInspectable open dynamic var selectedTextColor: UIColor = UIColor.white {
        didSet {
            for tagView in tagViews {
                tagView.selectedTextColor = selectedTextColor
            }
        }
    }

    @IBInspectable open dynamic var tagLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            for tagView in tagViews {
                tagView.titleLineBreakMode = tagLineBreakMode
            }
        }
    }
    
    @IBInspectable open dynamic var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            for tagView in tagViews {
                tagView.tagBackgroundColor = tagBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var tagHighlightedBackgroundColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var tagSelectedBackgroundColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.selectedBackgroundColor = tagSelectedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var cornerRadius: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.cornerRadius = cornerRadius
            }
        }
    }
    @IBInspectable open dynamic var borderWidth: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.borderWidth = borderWidth
            }
        }
    }
    
    @IBInspectable open dynamic var borderColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.borderColor = borderColor
            }
        }
    }
    
    @IBInspectable open dynamic var selectedBorderColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.selectedBorderColor = selectedBorderColor
            }
        }
    }
    
    @IBInspectable open dynamic var paddingY: CGFloat = 2 {
        didSet {
            for tagView in tagViews {
                tagView.paddingY = paddingY
            }
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var paddingX: CGFloat = 5 {
        didSet {
            for tagView in tagViews {
                tagView.paddingX = paddingX
            }
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var marginY: CGFloat = 2 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc public enum Alignment: Int {
        case left
        case center
        case right
    }
    @IBInspectable open var alignment: Alignment = .left {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowColor: UIColor = UIColor.white {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowRadius: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOffset: CGSize = CGSize.zero {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOpacity: Float = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    // MARK: remove button
    
    @IBInspectable open dynamic var enableRemoveButton: Bool = false {
        didSet {
            for tagView in tagViews {
                tagView.enableRemoveButton = enableRemoveButton
            }
            rearrangeViews()
        }
    }
    
    @IBInspectable open dynamic var removeButtonIconSize: CGFloat = 12 {
        didSet {
            for tagView in tagViews {
                tagView.removeButtonIconSize = removeButtonIconSize
            }
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var removeIconLineWidth: CGFloat = 1 {
        didSet {
            for tagView in tagViews {
                tagView.removeIconLineWidth = removeIconLineWidth
            }
            rearrangeViews()
        }
    }
    
    @IBInspectable open dynamic var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            for tagView in tagViews {
                tagView.removeIconLineColor = removeIconLineColor
            }
            rearrangeViews()
        }
    }
    
    @objc open dynamic var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            for tagView in tagViews {
                tagView.textFont = textFont
            }
            rearrangeViews()
        }
    }
    
    @IBOutlet open weak var delegate: TagListViewDelegate?
    
    open private(set) var tagViews: [TagView] = []
    private(set) var tagBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    var linkedClients: [String] = ["Client name"]
    
    open func addClient(client: String) {
        if (linkedClients.contains(where: { $0 == "Client name" })) {
            linkedClients.removeAll()
        }
        
        linkedClients.append(client)
        rearrangeViews()
    }
    
    open func removeClient(client: String) {
        if let index = linkedClients.index(where: {$0 == client}) {
            linkedClients.remove(at: index)
            
            if (linkedClients.count == 0) {
                linkedClients.append("Client name")
            }
        }
        
        rearrangeViews()
    }
    
    open func removeAllClients() {
        linkedClients.removeAll()
        
        linkedClients.append("Client name")
        rearrangeViews()
    }
    
    public weak var bottomView: UIStackView?
    public var showsRightValues: Bool = false
    
    fileprivate weak var editableView: TagListBottomView? {
        return self.bottomView as? TagListBottomView
    }
    // MARK: - Interface Builder
    
    open override func prepareForInterfaceBuilder() {
        addTag("Welcome")
        addTag("to")
        addTag("TagListView").isSelected = true
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func rearrangeViews() {
        let views = tagViews as [UIView] + tagBackgroundViews + rowViews
        for view in views {
            view.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        for (index, tagView) in tagViews.enumerated() {
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height
            
            if showVertical || (currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > frame.width) {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)

                tagView.frame.size.width = min(tagView.frame.size.width, frame.width)
            }
            
            let tagBackgroundView = tagBackgroundViews[index]
            tagBackgroundView.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            tagBackgroundView.frame.size = tagView.bounds.size
            tagBackgroundView.layer.shadowColor = shadowColor.cgColor
            tagBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: tagBackgroundView.bounds, cornerRadius: cornerRadius).cgPath
            tagBackgroundView.layer.shadowOffset = shadowOffset
            tagBackgroundView.layer.shadowOpacity = shadowOpacity
            tagBackgroundView.layer.shadowRadius = shadowRadius
            tagBackgroundView.addSubview(tagView)
            currentRowView.addSubview(tagBackgroundView)
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + marginX
            
            switch alignment {
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frame.width - (currentRowWidth - marginX)) / 2
            case .right:
                currentRowView.frame.origin.x = frame.width - (currentRowWidth - marginX)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
        if tagViews.count == 0 {
            tagViewHeight = 31
        }
        
        if self.canShowAddButton {
            let isTagViewHidden = (self.bottomView as? TagListBottomView)?.tagCell.isHidden ?? true
            
            if let bottomView = self.bottomView {
                bottomView.removeFromSuperview()
            }
            let bottom = TagListBottomView.fromXib()
            self.addSubview(bottom)
            bottom.addTitleButton.setTitle(self.addTagLabel, for: .normal)
            bottom.translatesAutoresizingMaskIntoConstraints = false
            bottom.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
            bottom.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            bottom.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            self.bottomView = bottom
            bottom.addDetailsLabels(labels: self.showsRightValues ? self.linkedClients : [])
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: bottom.frame.maxY + 40.0)
            bottom.addHeightConstraint?.constant = self.bottomCellHeight
            bottom.tagHeightConstraint?.constant = self.bottomCellHeight
            bottom.addButton.layer.cornerRadius = (self.bottomCellHeight-10)/2
            bottom.removeButton.layer.cornerRadius = (self.bottomCellHeight-10)/2
            bottom.layoutIfNeeded()
            bottom.showsRightValues = self.showsRightValues
            bottom.eventHandler = self
            
            if !isTagViewHidden {
                bottom.onAddLabelSelected("")
            }
        }
        
        invalidateIntrinsicContentSize()
    }
    
    @objc func bottomViewTapped() {
        addingTag = true
        
        rearrangeViews()
    }
    
    // MARK: - Manage tags
    
    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        
        if canShowAddButton {
            height += self.bottomView?.frame.size.height ?? bottomCellHeight
            height = height == 0 ? bottomCellHeight : height
            //height += (editableTagView.frame.size.height + 20.0 + (bottomView?.frame.size.height ?? 0) + 20.0)
        }
        
        return CGSize(width: frame.width, height: height)
    }
    
    private func createNewTagView(_ title: String) -> TagView {
        let tagView = TagView(title: title)
        
        tagView.textColor = textColor
        tagView.selectedTextColor = selectedTextColor
        tagView.tagBackgroundColor = tagBackgroundColor
        tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
        tagView.selectedBackgroundColor = tagSelectedBackgroundColor
        tagView.titleLineBreakMode = tagLineBreakMode
        tagView.cornerRadius = cornerRadius
        tagView.borderWidth = borderWidth
        tagView.borderColor = borderColor
        tagView.selectedBorderColor = selectedBorderColor
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = textFont
        tagView.removeIconLineWidth = removeIconLineWidth
        tagView.removeButtonIconSize = removeButtonIconSize
        tagView.enableRemoveButton = enableRemoveButton
        tagView.removeIconLineColor = removeIconLineColor
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
        tagView.removeButton.addTarget(self, action: #selector(removeButtonPressed(_:)), for: .touchUpInside)
        
        // On long press, deselect all tags except this one
        tagView.onLongPress = { [unowned self] this in
            for tag in self.tagViews {
                tag.isSelected = (tag == this)
            }
        }
        
        return tagView
    }

    
    @discardableResult
    open func addTag(_ title: String) -> TagView {
        return addTagView(createNewTagView(title))
    }
    
    @discardableResult
    open func addTags(_ titles: [String]) -> [TagView] {
        var tagViews: [TagView] = []
        for title in titles {
            tagViews.append(createNewTagView(title))
        }
        return addTagViews(tagViews)
    }
    
    @discardableResult
    open func addTagViews(_ tagViews: [TagView]) -> [TagView] {
        for tagView in tagViews {
            self.tagViews.append(tagView)
            tagBackgroundViews.append(UIView(frame: tagView.bounds))
        }
        rearrangeViews()
        return tagViews
    }

    @discardableResult
    open func insertTag(_ title: String, at index: Int) -> TagView {
        return insertTagView(createNewTagView(title), at: index)
    }
    
    @discardableResult
    open func addTagView(_ tagView: TagView) -> TagView {
        tagViews.append(tagView)
        tagBackgroundViews.append(UIView(frame: tagView.bounds))
        rearrangeViews()
        
        return tagView
    }

    @discardableResult
    open func insertTagView(_ tagView: TagView, at index: Int) -> TagView {
        tagViews.insert(tagView, at: index)
        tagBackgroundViews.insert(UIView(frame: tagView.bounds), at: index)
        rearrangeViews()
        
        return tagView
    }
    
    open func setTitle(_ title: String, at index: Int) {
        tagViews[index].titleLabel?.text = title
    }
    
    open func setTitle(_ title: String, oldTitle: String) {
        if let index = tagViews.index(where: {
            let labelText = ($0.titleLabel?.text)!
            let regex = try! NSRegularExpression(pattern: "(\\([0-9]+)\\)", options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, labelText.count)
            let labelTitle = regex.stringByReplacingMatches(in: labelText, options: [], range: range, withTemplate: "")
            return labelTitle.trimmingCharacters(in: .whitespacesAndNewlines) == oldTitle
        }) {
            tagViews[index].titleLabel?.text = title
        }
    }
    
    open func removeTag(_ title: String) {
        // loop the array in reversed order to remove items during loop
        for index in stride(from: (tagViews.count - 1), through: 0, by: -1) {
            let tagView = tagViews[index]
            if tagView.currentTitle == title {
                removeTagView(tagView)
            }
        }
    }
    
    open func removeTagView(_ tagView: TagView) {
        tagView.removeFromSuperview()
        if let index = tagViews.index(of: tagView) {
            tagViews.remove(at: index)
            tagBackgroundViews.remove(at: index)
        }
        
        rearrangeViews()
    }
    
    open func removeAllTags() {
        let views = tagViews as [UIView] + tagBackgroundViews
        for view in views {
            view.removeFromSuperview()
        }
        
        tempTag = nil
        removeAllClients()
        tagViews = []
        tagBackgroundViews = []
        rearrangeViews()
    }

    open func selectedTags() -> [TagView] {
        return tagViews.filter() { $0.isSelected == true }
    }
    
    // MARK: - Events
    
    @objc func tagPressed(_ sender: TagView!) {
        sender.onTap?(sender)
        delegate?.tagPressed?(sender.currentTitle ?? "", tagView: sender, sender: self)
    }
    
    @objc func removeButtonPressed(_ closeButton: CloseButton!) {
        if let tagView = closeButton.tagView {
            delegate?.tagRemoveButtonPressed?(tagView.currentTitle ?? "", tagView: tagView, sender: self)
        }
    }
    
    public func resetEditableView() {
        for c in self.linkedClients { self.removeClient(client: c) }
        self.editableView?.addDetailsLabels(labels: [])
        self.editableView?.tagNameTextField.text = ""
        self.editableView?.tagCell.isHidden = true
        self.rearrangeViews()
    }
}

extension TagListView : UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.tempTag = textField.text
    }
}

extension TagListView: TagListBottomViewEventHandler {
    
    func onRightViewTapped(bottomView: TagListBottomView) {
        self.editableTagDelegate?.tagListDidTapLinkClient(tagsView: self, tag: bottomView.tagNameTextField.text?.lowercased())
    }
    
    func onTagNameChanged(bottomView: TagListBottomView, tag: String) {
        self.editableTagDelegate?.tagListOnNewTagAdded(tagsView: self, tag: tag.lowercased())
    }
}
