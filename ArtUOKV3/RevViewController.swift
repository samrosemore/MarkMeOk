import UIKit
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseInstanceID
import MessageUI
import GoogleSignIn
import CryptoKit
import AuthenticationServices








class RevViewController: UIViewController, MFMailComposeViewControllerDelegate
{
    
    
    var signUp: SignUp?
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    var setSettings: Settings?
    
    var setEmergencyContact: EmergencyContacts?
    
    var login: Login?
    
    var homeScreen: HomeScreen?
    
    var timerFiles: TimerFiles?
    
    var updateSettings:Settings?
    var updateEmergencyContacts: EmergencyContacts?
    
    var groups: Groups?
    var invitations: Invitations?
    
    var newGroup:NewGroup?
    
    
    var transferData: DataChannel?
    
    var userStorage:UserStorage?
    
    var helpScreen:Help?
    
    var initial:ContentView?
    
    var disclamer:Disclamer?
    
    var faq:FAQ?
    
    var tutorial:Tutorial?
    
    
    
    
    @IBSegueAction func loadAccount(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: Acount())
    }
    
    @IBSegueAction func loadFAQ(_ coder: NSCoder) -> UIViewController? {
        faq = FAQ()
        
        let storage = faq!.getUserStorage()
        
        let db = Firestore.firestore()
        let ref = db.collection("FAQ");
        
        ref.getDocuments()
           { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in querySnapshot!.documents
                    {
                        
                        let question = doc.get("Question") as! String
                        let answer = doc.get("Answer") as! String
                        
                        let fq = FCell(question: question, answer: answer)
                         
                        storage.faqQuestions.append(fq)
                    }
                    
                }
            }
        
        
        
        return UIHostingController(coder: coder, rootView: faq)
    }
    
    @IBSegueAction func loadAbout(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: About())
    }
    
    @IBSegueAction func loadDisclamer(_ coder: NSCoder) -> UIViewController?
    {
        
        
        disclamer = Disclamer()
        disclamer!.setVC(vc:self)
        return UIHostingController(coder: coder, rootView: disclamer)
    }
    
    @IBSegueAction func loadTutorial(_ coder: NSCoder) -> UIViewController?
    {
        tutorial = Tutorial()
        let storage = tutorial!.getUserStorage()
        tutorial!.setVC(vc: self)
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        docRef.getDocument()
        {
                (snapshot, error) in
                
                if error != nil{
                    print("well shit")
                }
                else
                {
                    let data = snapshot?.data()
                    if(data?["initialBootup"] != nil)
                    {
                        let isInitialBootup = data?["initialBootup"] as! Bool
                        
                        if(isInitialBootup)
                        {
                            storage.initialBootup = true
                        }
                        
                    }
                }
        }
        
        
        return UIHostingController(coder: coder, rootView: tutorial)
    }
    
    
    @IBSegueAction func loaoMSettings(_ coder: NSCoder) -> UIViewController?
    {
        setSettings = Settings()
        setSettings!.setVC(vc: self)
        setSettings!.userStorage.preset = false
        setSettings!.userStorage.groupUserIDs = transferData!.groupUserIDs
        setSettings!.userStorage.selectedGroup = transferData!.groupID
        setSettings!.userStorage.newGroupName = transferData!.groupName
        setSettings!.userStorage.hostName = transferData!.hostName
        return UIHostingController(coder: coder, rootView: setSettings)
    }
    
    @IBSegueAction func createNewGroup(_ coder: NSCoder) -> UIViewController? {
        newGroup = NewGroup()
        newGroup!.setVC(vc: self)
        
        let storage = newGroup!.getData()
         
        let uid = Auth.auth().currentUser!.uid
        let fullName = "Me"
        let email = Auth.auth().currentUser!.email
        let thisUser = User(ID: uid, displayName: fullName, pending: true)
        
        storage.usersInGroup.append(thisUser)
        storage.listUsersInGroup()
        
        
        
        return UIHostingController(coder: coder, rootView: newGroup)
    }
    @IBSegueAction func loadGroups(_ coder: NSCoder) -> UIViewController?
    {
        
        groups = Groups()
        
        
        
        
        groups!.setVC(vc: self)
        let storage = groups!.getData()
        
        let uid:String = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument
            {
                (snapshot, error) in
                
                if let err = error
                {
                    debugPrint("error fetching data\(err)")
                }
                else
                {
                    let data = snapshot!.data()
                    
                    if(data?["Groups"] != nil)
                    {
                        
                        //this is a temporary holding list
                        //storage.groupIDs = (data?["Groups"] as! [String])
                        
                        //this command will transfer data into a more usable form of
                        //storage
                        
                        
                        
                        for id in (data?["Groups"] as! [String])
                        {
                            let defaultGroup = (data?["defaultGroup"] as? String)
                            if(defaultGroup != nil)
                            {
                                    if((data?["defaultGroup"] as! String) == id)
                                    {
                                        var curr:Group = Group(id: id)
                                        curr.defaultStatus.isDefualtGroup = true
                                        storage.tempGroups.append(curr)
                                    }
                                    else
                                    {
                                        var curr:Group = Group(id: id)
                                        storage.tempGroups.append(curr)
                                    }
                            }
                            else
                            {
                                var curr:Group = Group(id: id)
                                storage.tempGroups.append(curr)
                            }
                            
                        }
                        storage.convertGroupIDsToName()
                        
                        
                        
                        
                        
                    }
                    
                    //first take into account the older versions of the app
                    if(data?["initialBootup"] != nil)
                    {
                        if(data!["initialBootup"] as! Bool)
                        {
                            
                            
                            
                            let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                            let newVc = storyboard.instantiateViewController(withIdentifier:"Tutorial")
                            newVc.isModalInPresentation = true
                            newVc.modalPresentationStyle = .fullScreen
                            self.present(newVc, animated: true, completion: nil)
                            
                        }
                        else if((data?["defaultGroup"] as? String) != nil)
                        {
                            
                           let storyboard = UIStoryboard(name: "Home", bundle: nil)
                           let vc : RootTabController = (storyboard.instantiateViewController(withIdentifier: "HomeLanding") as? RootTabController)!
                            vc.groupName = (data?["defaultGroup"] as! String)
                           self.present(vc, animated: true, completion: nil)
                        }
                        
                    }
                }
                
            }
        
        //get group id then another database call to get actual group name THEN finally
        //update user storage
        
        
        
        return UIHostingController(coder: coder, rootView: groups)
    }
    @IBSegueAction func loadInvitations(_ coder: NSCoder) -> UIViewController? {
        print("hello")
        invitations = Invitations()
        invitations!.setVC(vc: self)
        //recieve invitations
        let storage = invitations!.getData()
        
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("invitation").getDocuments()
        { (querySnapshot, err) in
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    for document in querySnapshot!.documents
                    {
                        let data = document.data()
                        storage.listDispaly.append(data["groupName"] as! String)
                        storage.groupIDs.append(document.documentID)
                        storage.invitationsToHosts[data["groupName"] as! String] = "host"
                    }
                }
        }
        
        
        return UIHostingController(coder: coder, rootView: invitations)
    }
    
    
    
    //really supposed to be "load update emergency contacts" but whatever
    @IBSegueAction func updateEmergencyContacts(_ coder: NSCoder) -> UIViewController?
    {
                
        updateEmergencyContacts = EmergencyContacts()
        let storage = updateEmergencyContacts!.getData()
       
        let db = Firestore.firestore()
        
        
        
        if self.transferData != nil
        {
            storage.selectedGroup = transferData!.groupName
            db.collection("Groups").document(storage.selectedGroup).getDocument(completion: { (snapshot, error) in
                if let err = error
                {
                    debugPrint("error fetching data\(err)")
                }
                else
                {
                    
                    let data = snapshot!.data()
                    //group IDs of user
                    storage.groupUsers = (data!["users"] as! [String])
                    storage.groupUsers.append(data!["host"] as! String)
                    
                    for id in storage.groupUsers
                    {
                        db.collection("users").document(id).getDocument
                        {
                            (snapshot, error) in
                            
                            if let err = error
                            {
                                debugPrint("error fetching data\(err)")
                            }
                            else
                            {
                                let data = snapshot!.data()
                                storage.listDispaly.append(data!["fullName"] as! String)
                                print(storage.listDispaly)
                            }
                            
                        }
                    }
                    
                    storage.pendingUsers =  data!["pendingUsers"] as! [String]
                    
                    for id in storage.pendingUsers
                    {
                        db.collection("users").document(id).getDocument
                        {
                            (snapshot, error) in
                            
                            if let err = error
                            {
                                debugPrint("error fetching data\(err)")
                            }
                            else
                            {
                                let data = snapshot!.data()
                                storage.altListDisplay2.append(data!["fullName"] as! String)
                                
                            }
                            
                        }
                    }
                    
                    
                    
                    //group IDs of checked in On
                    storage.checkedInOn =  (data!["checkedInOn"] as! [String])
                    
                    for id in storage.checkedInOn
                    {
                        db.collection("users").document(id).getDocument
                        {
                            (snapshot, error) in
                            
                            if let err = error
                            {
                                debugPrint("error fetching data\(err)")
                            }
                            else
                            {
                                let data = snapshot!.data()
                                storage.altListDisplay.append(data!["fullName"] as! String)
                                
                            }
                            
                        }
                    }
                    
                    
                }
            })
        }
        
        return UIHostingController(coder: coder, rootView: updateEmergencyContacts)
    }
    
    //really supposed to be "load update settings" but whatever
    @IBSegueAction func updateSettings(_ coder: NSCoder) -> UIViewController?
    {
    
        updateSettings = Settings()
        updateSettings!.setVC(vc:self)
        updateSettings!.updateUserStorage(userStorage: self.userStorage!)
        
        let storage = updateSettings!.getData()
        
        storage.preset = true;
        storage.selectedGroup = transferData!.groupName
        
        
        let db = Firestore.firestore()
        let docRef = db.collection("Groups").document(userStorage!.selectedGroup)
        
        docRef.getDocument
        { (snapshot, error) in
            if let err = error
            {
                debugPrint("error fetching data\(err)")
            }
            else
            {
                let data = snapshot!.data()
                
                storage.timePeriod = String(data?["timePeriod"] as! Int)
                storage.numWarnings = String(data?["numWarnings"] as! Int)
                
            
            }
        }
        
        return UIHostingController(coder: coder, rootView: updateSettings)
    }
    
    @IBSegueAction func loadHomeScreen(_ coder: NSCoder) -> UIViewController?
    {
       
        
        
        homeScreen = HomeScreen()
        homeScreen!.updateUserStorage(userStorage: self.userStorage!)
        
        let storage = homeScreen!.getData()
        
        
        
        if(self.transferData != nil)
        {
            self.userStorage!.selectedGroup = self.transferData!.groupName
            
            let db = Firestore.firestore()
            
       
            
           
            let docRef = db.collection("Groups").document(self.userStorage!.selectedGroup)
            
            docRef.getDocument
                { (snapshot, error) in
                    if let err = error {
                        debugPrint("error fetching data\(err)")
                    }
                    else
                    {
                        let data = snapshot!.data()
                        
                        if(data?["startingTime"] == nil || data?["timePeriod"] == nil || data?["checkedInOn"] == nil || data?["groupName"] == nil)
                        {
                            //delete the group
                            let docRef = db.collection("Groups").document(self.userStorage!.selectedGroup)
                            
                            docRef.delete()
                            {
                                err in
                                if err != nil
                                {
                                    print(err ?? "")
                                }
                                else
                                {
                                    //and send the user back
                                    let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                                    vc.isModalInPresentation = true
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                            
                            
                            
                            
                        }
                        else
                        {
                           storage.startingTime = data?["startingTime"] as! Double
                           storage.timePeriod = String(data?["timePeriod"] as! Int)
                           storage.numWarnings = String(data?["numWarnings"] as! Int)
                           storage.groupName = String(data?["groupName"] as! String)
                            
                            //make sure you should start the timer
                            storage.startTimer = data?["startTimer"] as! Bool
                            if(storage.startTimer)
                            {
                                 let expireTime = storage.startingTime + ((Double(storage.timePeriod) ?? .nan) * 3600)
                                 if(expireTime < NSDate().timeIntervalSince1970)
                                 {
                                     let date = NSDate(timeIntervalSince1970: expireTime)
                                     let formatter = DateFormatter()
                                     formatter.timeZone = TimeZone.current
                                     formatter.dateFormat = "hh:mm a dd-MM-yyyy"
                                     storage.endDate = formatter.string(from: date as Date)
                                 }
                                
                                self.timerFiles = TimerFiles(userStorage: storage)
                                self.timerFiles!.startHomeScreenTimer()
                                
                                //check for admin privliges
                                let checkInOn:[String] = (data?["checkedInOn"] as! [String])
                                
                                if(checkInOn.contains(Auth.auth().currentUser!.uid))
                                {
                                    storage.adminPriv = false;
                                }
                                else
                                {
                                    storage.adminPriv = true;
                                }

                            }
                            
                            
                            
                        }
                        
                        
                    }
                }
            
        }
        
        
       
        
        return UIHostingController(coder: coder, rootView: homeScreen)
    }
    @IBSegueAction func loadLogin(_ coder: NSCoder) -> UIViewController?
    {
        if(Auth.auth().currentUser != nil)
        {
            //if you went through google sign up
            //update rt
            InstanceID.instanceID().instanceID(handler:
                {
                    (result, error) in
                    
                    if let err = error
                    {
                        print("shit there was an err \(err)")
                    }
                    else if let res = result
                    {
                        //database call to register token
                        let db = Firestore.firestore()
                        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["rt" : res.token], merge: true)
                        
                        let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                        vc.isModalInPresentation = true
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                })
            
        }
        else
        {
            login = Login()
            login!.setVC(vc: self)
        }
        
        
        
        return UIHostingController(coder: coder, rootView: login)
    }
    
    
    
  
    @IBSegueAction func loadResetPassword(_ coder: NSCoder) -> UIViewController?
    {
        var resetPassword = ResetPassword()
        resetPassword.setVC(vc: self)
        return UIHostingController(coder: coder, rootView: resetPassword)
    }
    
    @IBSegueAction func loadSignUp(_ coder: NSCoder) -> UIViewController?
    {
        signUp = SignUp()
        signUp!.setVC(vc: self)
        //signUpErrorLabel.alpha = 0
        
        return UIHostingController(coder: coder, rootView: signUp)
    }
    
    func sendEmail(email:String)
    {
        
        
       
        
        
        print("this is the email: " + email)
        
        let swiftLink:String =  "https://itunes.apple.com/us/app/urbanspoon/id1521328421"
        let androidLink:String = "https://play.google.com/store/apps/details?id=com.ncourage.markmeok"
        
        let subject = "You are invited to join the MarkMeOK community"
        
        let msg = "<p>Join the MarkMeOK Community! Tap the Link Below to Download the App <br> <a href=\(swiftLink)> For IOS version</a> <br>  <a href=\(androidLink)>For Playstore Version></a></p>"

        if !MFMailComposeViewController.canSendMail()
        {
          // Device can't send email
          return
        }
        let mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        var array = [String]()
        array[0] = email
        mailer.setToRecipients(array)
        mailer.setSubject(subject)
        mailer.setMessageBody(msg, isHTML: true)
        self.present(mailer, animated: true, completion:
        {
            
        })
                    
             
        
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
            error: Error?)
    {
        controller.dismiss(animated: true)
    }
    
    
   
    @IBSegueAction func loadHelpScreen(_ coder: NSCoder) -> UIViewController?
    {
        helpScreen = Help()
        
        return UIHostingController(coder: coder, rootView: helpScreen )
    }
    
    
    
    //only called by log in screen
    func attemptGoogleLogin()
    {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow()
    {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String
    {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    
    
    
    /*
    @IBAction func signUpNewUser(_ sender: UIButton)
    {
        
        let storage = signUp!.getData()
        
        if(validateEmail(testStr: storage.email))
        {
            if(validatePassword(value: storage.password))
            {
                Auth.auth().createUser(withEmail: storage.email, password: storage.password) {(result, error) in
                
                    if error != nil
                    {
                        print(error!)
                        print("error creating user")
                        
                        self.showError(error: "username is already taken", errorLbl: self.signUpErrorLabel)
                    }
                    else
                    {
                      let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      let vc = storyboard.instantiateViewController(withIdentifier: "SetSettings")
                      
                      self.present(vc, animated: true, completion: nil)
                      print("created new user")
                    }
                
                }
            }
            else
            {
                showError(error: "password must be > 6 characters", errorLbl:signUpErrorLabel)
            }
            
        }
        else
        {
            showError(error: "please enter a valid email", errorLbl: signUpErrorLabel)
        }
        
        
        
    }
    
    
    @IBAction func setSettings(_ sender: Any)
    {
        let storage = setSettings!.getData()
        let db = Firestore.firestore()
        
        let uid:String = Auth.auth().currentUser!.uid
        
        let temp = storage.numWarnings
        print(temp)
        
        if(validateNumber(value: storage.numWarnings))
        {
            db.collection("users").document(uid).setData([
                "numWarnings" : Int(storage.numWarnings),
                "startTime" : NSDate().timeIntervalSince1970,
                "timeBetweenWarnings": Int(storage.timeBetweenWarnings),
                "timePeriod": Int(storage.timePeriod)
            ])
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SetEmergencyContact")
            
            self.present(vc, animated: true, completion: nil)
        }
        else
        {
            showError(error: "Please Enter a Valid Number", errorLbl: setSettingsErrorLabel)
        }
        
        
        
    }
    
    @IBAction func setEmergencyContact(_ sender: Any)
    {
        let storage = setEmergencyContact!.getData()
        let db = Firestore.firestore()
              
        let uid:String = Auth.auth().currentUser!.uid
        
        if(validateNumber(value: storage.onePhoneNumber) && validateNumber(value: storage.twoPhoneNumber))
        {
            if(validateEmail(testStr: storage.oneEmail) && validateEmail(testStr: storage.twoEmail))
            {
                db.collection("EmergencyContacts").document(uid).setData([
                    "contactOne" : storage.contactOne,
                    "contactTwo" : storage.contactTwo,
                    "onePhoneNumber" : Int(storage.onePhoneNumber),
                    "oneEmail" : storage.oneEmail,
                    "twoPhoneNumber" : Int(storage.twoPhoneNumber),
                    "twoEmail" : storage.twoEmail
                ])
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                
                self.present(vc, animated: true, completion: nil)
                
            }
            else
            {
                showError(error: "please enter a valid email", errorLbl: setEmergencyContactErrorLabel)
            }
        }
        else
        {
            showError(error: "Please enter a valid phone number", errorLbl: setEmergencyContactErrorLabel)
        }
        
    }
    
    @IBAction func login(_ sender: Any)
    {
        let storage = login!.getData()
        
        Auth.auth().signIn(withEmail: storage.email, password: storage.password)
        {
            (result, error) in
            
            if error != nil
            {
                self.showError(error: "wrong username/password combination", errorLbl: self.loginErrorLabel)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen")
                
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        
    }
    
    @IBAction func updateSettingsAction(_ sender: Any)
    {
       let storage = updateSettings!.getData()
        
        if(validateNumber(value: storage.numWarnings))
        {
            //update databse
            let uid:String = Auth.auth().currentUser!.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
             
             
             docRef.collection("users").document(uid).updateData([
                 "numWarnings" : Int(storage.numWarnings),
                 "timeBetweenWarnings": Int(storage.timeBetweenWarnings),
                 "timePeriod": Int(storage.timePeriod)
             ])
        }
        else
        {
            showError(error: "please enter a valid number", errorLbl: updateSettingsErrorLabel)
        }
        
        
    }
    
    @IBAction func updateEmergencyContactsAction(_ sender: Any)
    {
        let storage = updateEmergencyContacts!.getData()
        
        if(validateNumber(value: storage.onePhoneNumber) && validateNumber(value: storage.twoPhoneNumber))
        {
            if(validateEmail(testStr: storage.oneEmail) && validateEmail(testStr:storage.twoEmail))
            {
                //update databse
                let uid:String = Auth.auth().currentUser!.uid
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(uid)
                 
                 
                 db.collection("EmergencyContacts").document(uid).updateData([
                     "contactOne" : storage.contactOne,
                     "contactTwo" : storage.contactTwo,
                     "onePhoneNumber" : Int(storage.onePhoneNumber),
                     "oneEmail" : storage.oneEmail,
                     "twoPhoneNumber" : Int(storage.twoPhoneNumber),
                     "twoEmail" : storage.twoEmail
                 ])
            }
            else
            {
                self.showError(error: "please enter valid emails", errorLbl: updateEMCErrorLabel)
            }
        }
        else
        {
            self.showError(error: "please enter valid phone Numbers", errorLbl: updateEMCErrorLabel)
        }
        
         
    }
    
    func showError(error: String, errorLbl: UILabel)
    {
        errorLbl.alpha = 1
        errorLbl.text = error
        
    }
    
    
    func validateEmail(testStr: String) -> Bool
    {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: testStr)
            return result
        
    }
    
    func validatePhoneNumber(value: String) ->Bool
    {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        if phoneTest.evaluate(with: value)
            {
                 return (true)
            }
              
            return false
    }
    //000-000-0000
    func parsePhoneNumber(strPhone: String) -> Int
    {
        let index0 = strPhone.index(strPhone.startIndex, offsetBy: 3)
        let substring0 = String(strPhone[..<index0])
        
        let start = strPhone.index(strPhone.startIndex, offsetBy: 4)
        let end = strPhone.index(strPhone.endIndex, offsetBy: -5)
        let range = start..<end
        let substring1 = String(strPhone[range])
        
        let index1 = strPhone.index(strPhone.endIndex, offsetBy: -4)
        let substring2 = String(strPhone[index1...])
        
        let total = substring0 + substring1 + substring2
        
        let phoneNumber = Int(total)
        
        return phoneNumber!
        
    }
    
    func validatePassword(value:String) -> Bool
    {
        return (value.count > 6)
    }
    
    func validateNumber(value:String) -> Bool
    {
        let letters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")

        
        let range = value.lowercased().rangeOfCharacter(from: letters)

        // range will be nil if no letters is found
        //if it is nil than this string has a valid number
      
        //not nil
        if range != nil
        {
            return false
        }
        //nil
        else {
           return true
        }
    }
    */
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    

}

@available(iOS 13.0, *)
extension RevViewController: ASAuthorizationControllerDelegate
{

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil)
        {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
            print(error?.localizedDescription)
            return
        }
        else
        {
            if(authResult!.additionalUserInfo!.isNewUser)
            {
               //so new user
               //store extra data
                   let user = Auth.auth().currentUser!
                   let email = user.email
                   let name = user.displayName
                   
               
                   let db = FirebaseFirestore.Firestore.firestore();
                   
                   //now store the extra user info
               db.collection("users").document(Auth.auth().currentUser!.uid).setData(["fullName": name ?? "", "email": email ?? "", "Groups": [String](), "initialBootup": true])
                       { err in
                           if let err = err
                           {
                               print("Error writing document: \(err)")
                               //if this fails this will cause a ton of errors
                               //might want to just delete the users and send them back to the login screen
                           }
                            else
                           {
                                let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                                vc.isModalInPresentation = true
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                       }
            }
        }
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}

extension RevViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
