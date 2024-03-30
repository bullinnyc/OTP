//
//  OTPView.swift
//  OTP
//
//  Created by Dmitry Kononchuk on 24.03.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct OTPView: View {
    // MARK: - Property Wrappers
    
    @State private var text: String
    @State private var activeSquareIndex: Int
    @State private var isCursorFlashed = false
    
    @FocusState private var isCodeFocused: Bool
    
    // MARK: - Private Properties
    
    private let limit: Int
    private let error: String?
    private let isCursor: Bool
    private let isEnabled: Bool
    private let completion: (String) -> Void
    
    private static let sideOfSquare: CGFloat = 56
    
    // MARK: - Initializers
    
    init(
        text: String?,
        limit: Int = 4,
        error: String?,
        isCursor: Bool = true,
        isEnabled: Bool = true,
        completion: @escaping (String) -> Void
    ) {
        let filteredText = Self.filteredText(text ?? "", limit: limit)
        
        _text = State(wrappedValue: filteredText)
        _activeSquareIndex = State(wrappedValue: filteredText.count)
        
        self.limit = limit
        self.error = error
        self.isCursor = isCursor
        self.isEnabled = isEnabled
        self.completion = completion
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(0 ..< limit, id: \.self) { index in
                square(with: index)
            }
        }
        .background(
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .opacity(.zero)
                .focused($isCodeFocused)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if isEnabled {
                isCodeFocused = true
            }
        }
        .overlay {
            if let error = error {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.callout)
                    .padding(.top, 110)
                    .padding(.horizontal, 16)
            }
        }
        .onChange(of: text) { _, newValue in
            updateText(with: newValue)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateText(with newValue: String) {
        text = Self.filteredText(newValue, limit: limit)
        activeSquareIndex = text.count
        
        if text.count == limit {
            isCodeFocused = false
        }
        
        completion(text)
    }
    
    private static func filteredText(_ text: String, limit: Int) -> String {
        let filteredText = text.filter { "0123456789".contains($0) }
        return String(filteredText.prefix(limit))
    }
}

// MARK: - Ext. Configure views

extension OTPView {
    @ViewBuilder
    private var cursor: some View {
        let color: Color = error != nil ? .red : .black
        
        color
            .frame(width: 1, height: Self.sideOfSquare * 0.32)
            .opacity(isCursorFlashed ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.5).repeatForever(),
                value: isCursorFlashed
            )
            .onAppear {
                isCursorFlashed = true
            }
    }
    
    private func square(with index: Int) -> some View {
        ZStack {
            let isError = error != nil
            
            RoundedRectangle(cornerRadius: 13)
                .stroke(isError ? .red : .gray.opacity(0.8), lineWidth: 2)
            
            if text.count > index {
                let characterIndex = text.index(
                    text.startIndex, offsetBy: index
                )
                
                let textCharacter = String(text[characterIndex])
                
                Text(textCharacter)
                    .foregroundStyle(isError ? .red : .black)
                    .font(.title2)
            }
            
            if isCursor {
                cursor
                    .opacity(
                        isCodeFocused && index == activeSquareIndex ? 1 : 0
                    )
            }
        }
        .frame(width: Self.sideOfSquare, height: Self.sideOfSquare)
    }
}

// MARK: - Preview

#Preview {
    OTPView(text: nil, error: "Some error") { _ in }
}
