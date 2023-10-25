//
//  ContentView.swift
//  IDEATHON_ImageReplacement
//
//  Created by 新翌王 on 2023/10/22.
//  Device is iPad Pro 11-inch (4rd generation), size is 834.0 x 1194.0

import SwiftUI
import UIKit
import ARKit
import WebKit

var customPrompt = ""

struct ARUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }

}

struct CSSAnimationView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // transparent background
        webView.isOpaque = false
        if let url = Bundle.main.url(forResource: "animation", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the view if needed
    }
}  
// I want custumPrompt to be a global variable, but I don't know how to do it
// I have to pass it as a parameter, and I want it can be changed in the function
// Then I can use it in ARImageDetectedView

func readyToGenerate(styleSelected: [Bool], conditionSelected: [Bool], strengthSelected: [Bool]) -> Bool {
    let styleDict = ["Minimalist", "Candyland", "Old days", "Nature", "Game"]
    let conditionDict = ["Sunny", "Rainy", "Deserted", "Crowded"]
    let strengthDict = ["High", "Mid", "Low"]
    customPrompt = ""
    for i in 0...4 {
        if styleSelected[i] {
            customPrompt += styleDict[i]
            for j in 0...3 {
                if conditionSelected[j] {
                    customPrompt += conditionDict[j]
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
    @State private var imageDetected = false
    @State var readyToGenerate = false
    var style = "None"
    var condition = "None"
    var strength = "None"
    
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
        // Set ARview as background
        
        ZStack {
            ARUIView()
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
                        Text("  G.H")
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
                if imageDetected {
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
                            .padding(.leading, 50)
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
                            .padding(.leading, 4)
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
                            .padding(.leading, 10)
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
                        // if readyToGenerate(styleSelected: styleSelected, conditionSelected: conditionSelected, strengthSelected: strengthSelected) is true, it works
                        // Or it will not work
                        // If it can be pressed, it contains a image "GenerateButton"
                        // If it can not be pressed, it contains a image "NotReadyGenerateButton"
                        Button(action: {
                            if IDEATHON_ImageReplacement.readyToGenerate(styleSelected: styleSelected, conditionSelected: conditionSelected, strengthSelected: strengthSelected) {
                                print("Generate Started: \(customPrompt)")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartingGenerate"), object: nil)
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
                else {
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
                    CSSAnimationView()
                        .position(x: 150, y: UIScreen.main.bounds.height + 145)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "ARImagedetected"))) { _ in
            self.imageDetected = true
            print("Image detected")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
