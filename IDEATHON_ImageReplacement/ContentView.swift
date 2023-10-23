//
//  ContentView.swift
//  IDEATHON_ImageReplacement
//
//  Created by 新翌王 on 2023/10/22.
//  Device is iPad Pro 11-inch (4rd generation), size is 834.0 x 1194.0

import SwiftUI
import UIKit
import ARKit

struct ARUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
}


struct ContentView: View {
    var body: some View {
        // Overlay ARview and UI
        // ARview is defined in ViewController.swift
        // Set ARview as background
        // ZStack follows the size of 834.0 x 1194.0
        ZStack {
           ARUIView()
           ZStack {
               Image("TopVector1")
               VStack(alignment: .leading) {
                   HStack {
                       Image("VRHeadset")
                           .frame(width: 35.12657, height: 17.15551)
                           .padding()
                       Text("客製化你的城市")
                           .font(.custom("NotoSansCJKTC", size: 17.68))
                           .kerning(9.6356)
                           .foregroundColor(.white)
                   }
                   .position(x: 130, y: 25)
                   
                   HStack {
                       Text("Customize your city")
                         .font(Font.custom("Syncopate", size: 15.5272))
                         .foregroundColor(.white)
                         .position(x: 130, y: 20)
                       Spacer()
                       Text("G.H.                                   頭盔畫面測試 Beta v2.5.3")
                         .font(
                           Font.custom("Syncopate", size: 17.68)
                               .weight(.bold)
                         )
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
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
