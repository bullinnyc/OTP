//
//  ContentView.swift
//  OTP
//
//  Created by Dmitry Kononchuk on 24.03.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Body
    
    var body: some View {
        OTPView(text: nil, error: nil) { code in
            print("Code: \(code)")
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
