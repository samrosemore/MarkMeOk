//
//  Tutorial.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import WebKit

struct Tutorial: View
{
    @ObservedObject var userStorage = UserStorage()
    var vc:RevViewController?
    
    var player:Player?
    
    @State var shouldAnimate:Bool = true
    
    @ObservedObject var loadingStatus:LoadingStatus = LoadingStatus()
    
    
    
    
    
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 30)
        {
            Spacer()
            
            Text("Tutorial").fontWeight(.bold).font(.system(size: 28))
            
            
            ZStack
            {
                Player(loadingStatus: loadingStatus).frame(height: UIScreen.main.bounds.height / 2.5)
                
                LoadingView(loadingStatus: loadingStatus)
            }
           
            
            
            
            Spacer().frame(height: 30)
            
            if(userStorage.initialBootup)
            {
                Button(action:
                {
                    
                    let storyBoard = UIStoryboard(name: "GroupsListings", bundle: nil)
                    let chosenVC = storyBoard.instantiateViewController(identifier: "NewGroup") as! RevViewController
                    chosenVC.transferData = DataChannel()
                    
                    self.vc!.isModalInPresentation = true
                    self.vc!.modalPresentationStyle = .fullScreen
                    self.vc!.present(chosenVC, animated: true)
                    
                    self.userStorage.initialBootup = false
                    
                }) {
                    Text("Start Setting Up Your Default Group").frame(width: 150, alignment: .center).foregroundColor(Color.black).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }.background(Color.init("Grayish"))
                
                Spacer().frame(height: 40)
            }
            
            
        }.background(Color.init("Logo Color"))
    }
    mutating func setVC(vc:RevViewController)
    {
        self.vc = vc
    }
    func getUserStorage() -> UserStorage
    {
        return userStorage
    }
}

struct Tutorial_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial()
    }
}


struct Player:UIViewRepresentable
{
    typealias UIViewType = WKWebView
    
    
    @ObservedObject var loadingStatus:LoadingStatus
    
    
    func makeCoordinator() -> (Coordinator)
    {
        return Coordinator(loadingStatus: loadingStatus)
    }
    
    
    func makeUIView(context: Context) -> WKWebView
    {
        let url = URL(string: "https://www.youtube.com/embed/Gy_3Q241QNE")!
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: Player.UIViewType, context: Context)
    {
        //something super cool that you wouldn't understand
    }
    
    
    
}

class Coordinator: NSObject, WKNavigationDelegate
{
    private var loadingStatus: LoadingStatus

    init(loadingStatus: LoadingStatus)
    {
        self.loadingStatus = loadingStatus
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        //print("WebView: navigation finished")
        self.loadingStatus.isLoading = false
        print("done loading")
    }
}






