import UIKit
import SwiftUI
import FirebaseAuth
import Firebase





class RevViewController: UIViewController
{
    var signUp: SignUp?
    
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
    
    
    
    @IBSegueAction func loaoMSettings(_ coder: NSCoder) -> UIViewController? {
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
        return UIHostingController(coder: coder, rootView: newGroup)
    }
    @IBSegueAction func loadGroups(_ coder: NSCoder) -> UIViewController?
    {
        print("loading groups")
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
                    storage.groupIDs = Utilities.unstringify(value: (data?["Groups"] as! String))
                    storage.convertGroupIDsToName()
                    
                    
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
        let uid:String = Auth.auth().currentUser!.uid
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
                    storage.groupUsers = Utilities.unstringify(value: data!["users"] as! String)
                    
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
                    
                    storage.pendingUsers = Utilities.unstringify(value: data!["pendingUsers"] as! String)
                    
                    //group IDs of checked in On
                    storage.checkedInOn = Utilities.unstringify(value: data!["checkedInOn"] as! String)
                    
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
                storage.timeBetweenWarnings = String(data?["timeBetweenWarnings"] as! Int)
            
            }
        }
        
        return UIHostingController(coder: coder, rootView: updateSettings)
    }
    
    @IBSegueAction func loadHomeScreen(_ coder: NSCoder) -> UIViewController?
    {
        print("hello")
        
        
        homeScreen = HomeScreen()
        homeScreen!.updateUserStorage(userStorage: self.userStorage!)
        
        let storage = homeScreen!.getData()
        
        
        if(self.transferData != nil)
        {
            self.userStorage!.selectedGroup = self.transferData!.groupName
            
            let db = Firestore.firestore()
            
            //make this a reference to a specific group
            
            //using dummy group for now
            let docRef = db.collection("Groups").document(self.userStorage!.selectedGroup)
            
            docRef.getDocument
                { (snapshot, error) in
                    if let err = error {
                        debugPrint("error fetching data\(err)")
                    }
                    else
                    {
                        let data = snapshot!.data()
                        
                        //I think its already a double
                        storage.startingTime = data?["startingTime"] as! Double
                        storage.timePeriod = String(data?["timePeriod"] as! Int)
                        
                        self.timerFiles = TimerFiles(userStorage: storage)
                        self.timerFiles!.startHomeScreenTimer()
                        
                        //check for admin privliges
                        let checkInOn:[String] = Utilities.unstringify(value: data?["checkedInOn"] as! String)
                        
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
        
        
       
        
        return UIHostingController(coder: coder, rootView: homeScreen)
    }
    @IBSegueAction func loadLogin(_ coder: NSCoder) -> UIViewController?
    {
        login = Login()
        login!.setVC(vc: self)
        return UIHostingController(coder: coder, rootView: login)
    }
    
    @IBSegueAction func loadInitialVC(_ coder: NSCoder) -> UIViewController?
    {
        
        
        
        var contentView = ContentView()
        contentView.setVC(vc: self)
        return UIHostingController(coder: coder, rootView: contentView)
    }
    
    
    
    
    @IBSegueAction func loadSignUp(_ coder: NSCoder) -> UIViewController?
    {
        signUp = SignUp()
        signUp!.setVC(vc: self)
        //signUpErrorLabel.alpha = 0
        
        return UIHostingController(coder: coder, rootView: signUp)
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
