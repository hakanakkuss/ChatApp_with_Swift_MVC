struct Constants {
    static let appName = "⚡️Chat App"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "fromRegisterVC"
    static let loginSegue = "fromLoginVC"
    
    struct BrandColors {
        static let green = "BrandGreen"
        static let lightGreen = "BrandLightGreen"
        static let lighBlue = "BrandLightBlue"
        static let lightGray = "BrandLightGray"
        static let white = "BrandWhite"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

