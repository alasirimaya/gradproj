//
//  splashview.swift
//  skillIn
//
//  Created by maya alasiri  on 01/09/1447 AH.
//
import SwiftUI

struct splashview: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack {
                Image("") // or your logo name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)

                Text("SkillIn")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}
#Preview {
    splashview()
}

