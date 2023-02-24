//
//  BlueCapsuleButtonStyle.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/24.
//

import SwiftUI

struct BlueCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color(red: 0.537, green: 0.812, blue: 0.941))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
}
