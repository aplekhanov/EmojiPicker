import UIKit
import EmojiPicker

class ViewController: UIViewController {

    @IBOutlet weak var emojiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pickEmoji(_ sender: UIButton) {
        let picker = EmojiPicker.viewController
        picker.sourceRect = sender.frame
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
}

extension ViewController: EmojiPickerViewControllerDelegate {
    func emojiPickerViewController(_ controller: EmojiPickerViewController, didSelect emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
