//
//  ViewController.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TagListViewDelegate, EditableTagViewDelegate {

    @IBOutlet weak var biggestTagListView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biggestTagListView.delegate = self
        biggestTagListView.editableTagDelegate = self
        biggestTagListView.textFont = UIFont.systemFont(ofSize: 24)
        // it is also possible to add all tags in one go
        biggestTagListView.canShowAddButton = true
        biggestTagListView.showsRightValues = true
        biggestTagListView.addTagLabel = "Add tag"
        biggestTagListView.addTags(["all", "your", "tag", "are", "belong", "to", "us"])
        biggestTagListView.alignment = .right
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
    
    func tagListOnNewTagAdded(tagsView: TagListView, tag: String) {
        self.biggestTagListView.resetEditableView()
        self.biggestTagListView.addTag(tag)
    }
    
    func tagListDidTapLinkClient(tagsView: TagListView, tag: String?) {
        self.biggestTagListView.addClient(client: "\(Date().timeIntervalSinceReferenceDate)")
    }
    
    func didTapRemove() {
        
    }
}

