import UIKit
import SwiftyDropbox

class ViewController: UIViewController {
    var vocabularyDict:[String:[[String: String]]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dropBoxSinginButton(_ sender: Any) {
        myButtonInControllerPressed()
    }
    
    @IBAction func downloadFileButton(_ sender: Any) {
        downloadTextFile()
        
        self.practice = "aaaa"
        self.segueToVocabularyTestController()
    }
    
    func myButtonInControllerPressed() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.openURL(url)
        })
    }
    
    func downloadTextFile(){
        if let client = DropboxClientsManager.authorizedClient{
            let fileManager = FileManager.default
            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destURL = directoryURL.appendingPathComponent("myTestFile.csv")
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return destURL
            }
            client.files.download(path: "/vocabulary.csv", overwrite: true, destination: destination)
                .response { response, error in
                    if let response = response {
//                        print(response)
                        if let data = try? Data(contentsOf: destURL) {
                            let csvStringData = String(data: data, encoding: String.Encoding.utf8)?.trimmingCharacters(in: NSCharacterSet.newlines)
                            
                            let dataRowsArray = csvStringData!.components(separatedBy: "\n")
                            
                            var wordInfo:[String: String]=[:]
                            
                            for i in 1..<dataRowsArray.count{
                                let elementList = dataRowsArray[i].components(separatedBy: ",")
                                
                                let word = elementList[0]
                                let meanings = ["意味": elementList[1]]
                                let englishText = ["例文": elementList[2]]
                                let japaneseText = ["訳": elementList[3]]
                                let correctAnswerCounter = ["正解数": elementList[4]]
                                
                                self.vocabularyDict.updateValue([meanings, englishText, japaneseText, correctAnswerCounter], forKey: word)
                            }
                            
                        } else{
                            print("error")
                        }
                        
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print(progressData)
            }
        }
    }
    
    func segueToVocabularyTestController(){
        self.performSegue(withIdentifier: "toTestView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTestView"{
            print("seque")
            let secondViewController = segue.destination as! VocabularyTestController
            secondViewController.vocabularyDict = self.vocabularyDict
            print("ファーストビュー\(self.vocabularyDict.keys)")
//            secondViewController.word = self.vocabularyDict.keys.first!
        }
    }
}
