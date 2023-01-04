import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ///**For döngüsü ile animasyon oluşturma**

        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = Constants.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * Double(charIndex), repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1

        }
       
    }
    

}
