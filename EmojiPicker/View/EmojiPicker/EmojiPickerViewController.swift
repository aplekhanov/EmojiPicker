//
//  EmojiPickerViewController.swift
//  EmojiPicker
//
//  Created by levantAJ on 15/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

public protocol EmojiPickerViewControllerDelegate: class {
    func emojiPickerViewController(_ controller: EmojiPickerViewController, didSelect emoji: String)
}

open class EmojiPickerViewController: UIViewController {
    open var isDimmer = true
    open var sourceRect: CGRect = .zero
    open var permittedArrowDirections: UIPopoverArrowDirection = .any
    open var emojiFontSize: CGFloat = 29
    open var backgroundColor: UIColor? = UIColor.white.withAlphaComponent(0.5)
    open var darkModeBackgroundColor: UIColor? = UIColor.black.withAlphaComponent(0.5)
    open var isDarkMode = false
    open var language: String?
    open var dismissAfterSelected = false
    open var size: CGSize = CGSize(width: 200, height: 300)
    open weak var delegate: EmojiPickerViewControllerDelegate?
    open var userDefaults: UserDefaults = UserDefaults.standard
    lazy var emojiPreviewer: EmojiPreviewable = EmojiPreviewer.shared
    var emojiPopoverVC: EmojiPopoverViewController!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "EmojiPopover", bundle: Bundle(for: EmojiPopoverViewController.self))
        emojiPopoverVC = storyboard.instantiateInitialViewController() as? EmojiPopoverViewController
        emojiPopoverVC.delegate = self
        emojiPopoverVC.userDefaults = userDefaults
        emojiPopoverVC.sourceView = view
        emojiPopoverVC.sourceRect = sourceRect
        emojiPopoverVC.delegate = self
        emojiPopoverVC.isDarkMode = isDarkMode
        emojiPopoverVC.language = language
        emojiPopoverVC.emojiFontSize = emojiFontSize
        emojiPopoverVC.dismissAfterSelected = dismissAfterSelected
        emojiPopoverVC.darkModeBackgroundColor = darkModeBackgroundColor
        emojiPopoverVC.backgroundColor = backgroundColor
        emojiPopoverVC.permittedArrowDirections = permittedArrowDirections
        emojiPopoverVC.preferredContentSize = size
        
        addChild(emojiPopoverVC)
        emojiPopoverVC.view.frame = view.frame
        view.addSubview(emojiPopoverVC.view)
        emojiPopoverVC.didMove(toParent: self)
    }
}

// MARK: - EmojiPickerContentViewControllerDelegate

extension EmojiPickerViewController: EmojiPopoverViewControllerDelegate {
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        emojiPreviewer.hide()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func emojiPickerViewController(_ controller: EmojiPopoverViewController, didSelect emoji: Emoji) {
        emojiPreviewer.hide()
        delegate?.emojiPickerViewController(self, didSelect: emoji.selectedEmoji ?? emoji.emojis.first!)
    }
    
    func emojiPickerViewController(_ controller: EmojiPopoverViewController, brief emoji: Emoji, sourceView: UIView) {
        let sourceRect = sourceView.convert(sourceView.bounds, to: view)
        emojiPreviewer.brief(sourceView: view.window!, sourceRect: sourceRect, emoji: emoji, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)
    }
    
    func emojiPickerViewController(_ controller: EmojiPopoverViewController, preview emoji: Emoji, sourceView: UIView) {
        let sourceRect = sourceView.convert(sourceView.bounds, to: view)
        emojiPreviewer.preview(sourceView: view.window!, sourceRect: sourceRect, emoji: emoji, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode) { [weak self] selectedEmoji in
            guard let strongSelf = self else { return }
            var emoji = emoji
            emoji.selectedEmoji = selectedEmoji
            strongSelf.emojiPopoverVC.select(emoji: emoji)
            strongSelf.delegate?.emojiPickerViewController(strongSelf, didSelect: selectedEmoji)
        }
    }

    func emojiPickerViewControllerHideDeselectEmoji(_ controller: EmojiPopoverViewController) {
        emojiPreviewer.hide()
    }
    
    func emojiPickerViewControllerDidDimiss(_ controller: EmojiPopoverViewController) {
        emojiPreviewer.hide()
        dismiss(animated: true, completion: nil)
    }
}
