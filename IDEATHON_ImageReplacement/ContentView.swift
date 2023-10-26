//
//  ContentView.swift
//  IDEATHON_ImageReplacement
//
//  Created by 新翌王 on 2023/10/22.
//  Device is iPad Air (4th Gen)
import SwiftUI
import UIKit
import ARKit
import WebKit
import Combine

var customPrompt = ""
var startRender = false


struct ARUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }

}

struct LoadingAnimationInitializing: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // transparent background
        webView.isOpaque = false
        if let url = Bundle.main.url(forResource: "loadingAnimationInitializing", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}  

struct LoadingAnimationLoading: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // transparent background
        webView.isOpaque = false
        if let url = Bundle.main.url(forResource: "loadingAnimationLoading", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct LoadingAnimationCompleted: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // transparent background
        webView.isOpaque = false
        if let url = Bundle.main.url(forResource: "loadingAnimationCompleted", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

func readyToGenerate(styleSelected: [Bool], conditionSelected: [Bool], strengthSelected: [Bool]) -> Bool {
    let styleDict = ["極簡", "童話", "古老", "自然", "遊戲"]
    let conditionDict = ["晴", "雨", "稀少", "擁擠"]
    let strengthDict = ["高", "中", "低"]
    customPrompt = ""
    for i in 0...4 {
        if styleSelected[i] {
            customPrompt += styleDict[i] + " "
            for j in 0...3 {
                if conditionSelected[j] {
                    customPrompt += conditionDict[j] + " "
                    for k in 0...2 {
                        if strengthSelected[k] {
                            customPrompt += strengthDict[k]
                            return true
                        }
                    }
                }
            }
        }
    }
    
    return false
}

struct ContentView: View {
    var style = "None"
    var condition = "None"
    var strength = "None"
    
    @EnvironmentObject var stageObject: StageObject
    // Style contains five options: Minimalist, Candyland, Old Days, Nature, Game
    // Condition contains four options: Sunny, Rainy, Deserted, Crowded
    // Strength contains three options: High, Mid, Low
    @State var styleSelected = [false, false, false, false, false]
    @State var conditionSelected = [false, false, false, false]
    @State var strengthSelected = [false, false, false]
    @State var shouldRender = false
    var body: some View {
        // Overlay ARview and UI
        // ARview is defined in ViewController.swift
        // If option is not all selected, the background is black with a image "Exclude"
        // If options are all selected, the background is ARview with a image "Exclude"
        
        ZStack {
            if stageObject.stage == "initializing" {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                LoadingAnimationInitializing()
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 + 200)
                    .scaleEffect(1.3)
            }
            else {
                ARUIView()
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "ARImageDetected"))) { _ in
                        print("ARImageDetected")
                    }
            }
            Image("Exclude")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                
            ZStack {
                Image("TopVector1")
                VStack {
                    HStack {
                        Image("VRHeadset")
                        .frame(width: 35.12657, height: 17.15551)
                        .padding()
                    Text("客製化你的城市")
                        .font(.custom("NotoSansCJKTC", size: 17.68))
                        .kerning(9.6356)
                        .foregroundColor(.white)
                    }
                    .position(CGPoint(x: 140, y: 32))

                    HStack (alignment: .center) {
                        Text("Customize your city")
                            .font(Font.custom("Syncopate", size: 15.5272))
                            .foregroundColor(.white)
                            .padding(20)

                        Spacer()
                        Text("    G.H.")
                            .font(Font.custom("Syncopate", size: 17.68).weight(.bold))
                            .foregroundColor(.black)
                            .padding()
                        
                        Spacer()

                        Text("頭盔畫面測試 Beta v2.5.3")
                            .font(Font.custom("Syncopate", size: 17.68).weight(.bold))
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                .zIndex(2)
                Image("TopVector2")
                    .frame(width: 83.41927, height: 16.79277)
                    .offset(x: -230, y: 3)
            }
            .frame(width: UIScreen.main.bounds.width, height: 89)
            .position(x: UIScreen.main.bounds.width / 2, y: 20)

            ZStack {
                Image("ChatBoxContent")
                    .frame(width: 1136, height: 203)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150)
                
                Image("ChatBoxFrame")
                    .frame(width: 1137.53748, height: 205.00616)
                    .shadow(color: .white.opacity(0.25), radius: 5.50315, x: 0, y: 3.38656)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150)
                // Swtich the content of the chatbox with the stage

                if stageObject.stage == "generating" {
                    Text("目 標 鎖 定 中...")
                        .font(Font.custom("Syncopate", size: 25).weight(.medium))
                        .kerning(3.1)
                        .foregroundColor(Color(red: 0.11, green: 0.44, blue: 0.85))
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180)
                    Text("Targeting...")
                        .font(Font.custom("Syncopate", size: 20).weight(.bold))
                        .kerning(3.1)
                        .foregroundColor(Color(red: 0.11, green: 0.44, blue: 0.85))
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 130)
                    LoadingAnimationLoading()
                        .position(x: 150, y: UIScreen.main.bounds.height + 135)
                }
                else if stageObject.stage == "completed" {
                    LoadingAnimationCompleted()
                        .position(x: 650, y: UIScreen.main.bounds.height + 150)
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("生成完成，數據將上傳至頭盔。")
                                .font(Font.custom("Noto Sans CJK TC", size: 20).weight(.medium)
                                )
                                .kerning(4)
                                .foregroundColor(Color("SystemBlue"))
                                .frame(width: 471, height: 45, alignment: .topLeading)
                            Text("Generation complete.\nData will be uploaded to the helmet.")
                                .font(Font.custom("Syncopate", size: 16).weight(.bold))
                                .kerning(2)
                                .foregroundStyle(Color("SystemBlue"))
                                .frame(width: 700, height: 50, alignment: .topLeading)
                        }
                    
                        Button(action: {
                            stageObject.stage = "initializing"
                        }) {
                            Image("RegenerateButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 310, height: 60)
                                .padding(.leading, -130)
                        }
                    }
                    .position(x: UIScreen.main.bounds.height - 140, y: 670)
                    
                    
                }
                else if stageObject.stage == "initializing" {
                    HStack(alignment: .lastTextBaseline) {
                        Text("請選擇客製化的樣貌 ")
                            .font((Font.custom("", size: 20)).weight(.medium))
                            .kerning(4)
                            .foregroundColor(Color(red: 0.11, green: 0.44, blue: 0.85))
                        
                        Text("Please Select Your Preferences. ")
                            .font((Font.custom("Syncopate", size: 16)).weight(.bold))
                            .kerning(2)
                            .foregroundColor(Color(red: 0.11, green: 0.44, blue: 0.85))
                    }
                    .position(x: 420, y: UIScreen.main.bounds.height - 220)
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text("Style")
                            .font(Font.custom("Syncopate", size: 15).weight(.bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("SystemBlue"))
                        
                        Image("Triangle")
                            .padding(.leading, 51)
                            .padding(.trailing, 20)
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $styleSelected[0], color: Color("SystemBlue"), text: "Minimalist")
                                .onTapGesture {
                                    print("Minimalist")
                                    styleSelected[0].toggle()
                                    for i in 0...4 {
                                        if i != 0 {
                                            styleSelected[i] = false
                                        }
                                    }
                                }
                        }
                        .padding(.trailing, 20)
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $styleSelected[1], color: Color("SystemBlue"), text: "Candyland")
                                .onTapGesture {
                                    print("Candyland")
                                    styleSelected[1].toggle()
                                    for i in 0...4 {
                                        if i != 1 {
                                            styleSelected[i] = false
                                        }
                                    }
                                }
                        }
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $styleSelected[2], color: Color("SystemBlue"), text: "Old days")
                                .onTapGesture {
                                    print("Old days")
                                    styleSelected[2].toggle()
                                    for i in 0...4 {
                                        if i != 2 {
                                            styleSelected[i] = false
                                        }
                                    }
                                }
                        }
                        .padding(.leading, 20)
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $styleSelected[3], color: Color("SystemBlue"), text: "Nature")
                                .onTapGesture {
                                    print("Nature")
                                    styleSelected[3].toggle()
                                    for i in 0...4 {
                                        if i != 3 {
                                            styleSelected[i] = false
                                        }
                                    }
                                }
                        }
                        .padding(.leading, 20)
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $styleSelected[4], color: Color("SystemBlue"), text: "Game")
                                .onTapGesture {
                                    print("Game")
                                    styleSelected[4].toggle()
                                    for i in 0...4 {
                                        if i != 4 {
                                            styleSelected[i] = false
                                        }
                                    }
                                }
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .frame(width: 1000, height: 100)
                    .position(x: 560, y: UIScreen.main.bounds.height - 180)
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text("Condition")
                            .font(Font.custom("Syncopate", size: 15).weight(.bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("SystemBlue"))
                        
                        Image("Triangle")
                            .padding(.leading, 5)
                            .padding(.trailing, 20)
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $conditionSelected[0], color: Color("SystemBlue"), text: "Sunny")
                                .onTapGesture {
                                    print("Sunny")
                                    conditionSelected[0].toggle()
                                    for i in 0...3 {
                                        if i != 0 {
                                            conditionSelected[i] = false
                                        }
                                    }
                                }
                        }
                        .padding(.trailing, 69)
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $conditionSelected[1], color: Color("SystemBlue"), text: "Rainy")
                                .onTapGesture {
                                    print("Rainy")
                                    conditionSelected[1].toggle()
                                    for i in 0...3 {
                                        if i != 1 {
                                            conditionSelected[i] = false
                                        }
                                    }
                                }
                        }
                        .padding(.trailing, 81)
                        
                        Button(action: {
                            
                        }) {
                            Image("Lock")
                                .offset(x: 5, y: -2)
                            SelectButton(isSelected: $conditionSelected[2], color: Color(.gray), text: "Deserted")
                                .onTapGesture {
                                    print("Deserted")
                                }
                        }
                        .padding(.trailing, 57)
                        
                        Button(action: {
                        }) {
                            Image("Lock")
                                .offset(x: 5, y: -2)
                            SelectButton(isSelected: $conditionSelected[3], color: Color(.gray), text: "Crowded")
                                .onTapGesture {
                                    print("Crowded")
                                }
                        }
                        Spacer()
                    }
                    .frame(width: 1000, height: 100)
                    .position(x: 560, y: UIScreen.main.bounds.height - 139)
                    
                    HStack (alignment: .lastTextBaseline) {
                        Text("Strength")
                            .font(Font.custom("Syncopate", size: 15).weight(.bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("SystemBlue"))
                        
                        Image("Triangle")
                            .padding(.leading, 10.5)
                            .padding(.trailing, 20)
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $strengthSelected[0], color: Color("SystemBlue"), text: "High")
                                .onTapGesture {
                                    print("High")
                                    strengthSelected[0].toggle()
                                    for i in 0...2 {
                                        if i != 0 {
                                            strengthSelected[i] = false
                                        }
                                    }
                                }
                        }
                        .padding(.trailing, 90)
                        
                        Button(action: {
                        }) {
                            Image("Lock")
                                .offset(x: 5, y: -2)
                            SelectButton(isSelected: $strengthSelected[1], color: Color(.gray), text: "Mid")
                                .onTapGesture {
                                    print("Mid")
                                }
                        }
                        .padding(.trailing, 95)
                        
                        Button(action: {
                        }) {
                            SelectButton(isSelected: $strengthSelected[2], color: Color("SystemBlue"), text: "Low")
                                .onTapGesture {
                                    print("Low")
                                    strengthSelected[2].toggle()
                                    for i in 0...2 {
                                        if i != 2 {
                                            strengthSelected[i] = false
                                        }
                                    }
                                }
                        }
                        Spacer()
                    }
                    .frame(width: 1000, height: 100)
                    .position(x: 560, y: UIScreen.main.bounds.height - 96)
                    
                    HStack {
                        Button(action: {
                            if IDEATHON_ImageReplacement.readyToGenerate(styleSelected: styleSelected, conditionSelected: conditionSelected, strengthSelected: strengthSelected) {
                                print("Generate Started: \(customPrompt)")
                                stageObject.stage = "generating"
                                print("Stage: \(stageObject.stage)")
                            }
                        }) {
                            if IDEATHON_ImageReplacement.readyToGenerate(styleSelected: styleSelected, conditionSelected: conditionSelected, strengthSelected: strengthSelected) {
                                Image("GenerateButton")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, height: 50)
                            }
                            else {
                                Image("NotReadyGenerateButton")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, height: 50)
                            }
                        }
                    }
                    .position(x: UIScreen.main.bounds.width - 180, y: UIScreen.main.bounds.height - 140)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "ARImagedetected"))) { _ in   
            print("ARImagedetected")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(stageObject)
    }
}
