import UIKit

class VocabularyTestController: UIViewController {
    var vocabularyDict:[String:[[String: String]]] = [:]
    var word = ""
    var whichSide = true
    var wordIndex = 0
    
    @IBOutlet weak var wordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("テストビュー")
        print(word)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print(vocabularyDict.keys)
//        wordButton.setTitle(vocabularyDict.keys.first, for: .normal)
    }
    
    @IBAction func switchSideButton(_ sender: Any) {
        if(whichSide){
            print(vocabularyDict.keys)
            print("表")
            //            vocabularyDict.keys[wordIndex]
        } else{
            print("裏")
        }
    }
}
