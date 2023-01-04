import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let db = Firestore.firestore()
    
    var message : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///xib dosyasının tanımlanması
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
 

        navigationItem.title = "⚡️FlashChat"
        navigationItem.hidesBackButton = true
        
        loadMessage()
        
    }
    func loadMessage(){
        
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { QuerySnapshots, error in
            self.message = []
            if let e = error {
                print(e)
            }else {
                if let snapshotDocuments = QuerySnapshots?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.message.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        ///Yazılan mesajın Firestore'a gönderilmesi.
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email { //Mevcut kullanıcıyı kontrol ettik
            ///Dictionary yapısını kullanarak sender-message yapısını database' e gönderdik.
            db.collection(Constants.FStore.collectionName).addDocument(data:  [Constants.FStore.senderField : messageSender, Constants.FStore.bodyField: messageBody, Constants.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print(error?.localizedDescription)
                }
                else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
    do {
        try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
        }
      
    }
    
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messagesSender = message[indexPath.row]

        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message[indexPath.row].body
        
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .hour,
            .minute
        ]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

        var hour : String = String(dateTimeComponents.hour!)
        var minute : String = String(dateTimeComponents.minute!)

        if messagesSender.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightGray)
            cell.label.textColor = UIColor(named: Constants.BrandColors.white)
            cell.timeLabel.text = "\(hour):\(minute)"
        }else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.green)
            cell.label.textColor = UIColor(named: Constants.BrandColors.white)
            cell.timeLabel.text = "\(hour):\(minute)"
            
        }
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
  
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {
              self.message.remove(at: indexPath.row)
              self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }

        }
}



