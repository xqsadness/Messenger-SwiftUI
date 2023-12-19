//
//  ChangeDarkLightView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 16/12/2023.
//

import SwiftUI

enum ToggleState: String, CaseIterable {
    case off = "Off"
    case on = "On"
    case system = "System"
}

struct ChangeDarkLightView: View {
    @AppStorage("colorScheme") var colorScheme = "light"
    @Binding var isShowDarkMode: Bool
    
    enum ToggleState: String, CaseIterable {
        case off = "Off"
        case on = "On"
        case system = "System"
    }
    
    @State private var selectedToggle: ToggleState = .off
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.medium)
                    .foregroundStyle(.text)
                
                Text("Dark mode")
                    .font(.semibold(size: 16))
                    .foregroundStyle(.text)
            }
            .hAlign(.leading)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isShowDarkMode.toggle()
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: Binding(
                    get: { selectedToggle == .off },
                    set: { newValue in
                        selectedToggle = .off
                        updateColorScheme()
                    }
                )) {
                    Text(ToggleState.off.rawValue)
                        .font(.bold(size: 14))
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                
                Toggle(isOn: Binding(
                    get: { selectedToggle == .on },
                    set: { newValue in
                        selectedToggle = .on
                        updateColorScheme()
                    }
                )) {
                    Text(ToggleState.on.rawValue)
                        .font(.bold(size: 14))
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                
                Toggle(isOn: Binding(
                    get: { selectedToggle == .system },
                    set: { newValue in
                        selectedToggle = .system
                        updateColorScheme()
                    }
                )) {
                    Text(ToggleState.system.rawValue)
                        .font(.bold(size: 14))
                }
                .toggleStyle(iOSCheckboxToggleStyle())
            }
            .padding(.vertical, 15)
            .hAlign(.leading)
            
            Text("If system is selected Messager will automatically adjust your appearance based on your device's system setting.")
                .font(.regular(size: 13))
                .foregroundStyle(.text)
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            setSelectedToggleFromColorScheme()
        }
    }
    
    private func updateColorScheme() {
        switch selectedToggle {
        case .off:
            colorScheme = "light"
        case .on:
            colorScheme = "dark"
        case .system:
            colorScheme = "nil"
        }
    }
    
    private func setSelectedToggleFromColorScheme() {
        switch colorScheme {
        case "light":
            selectedToggle = .off
        case "dark":
            selectedToggle = .on
        default:
            selectedToggle = .system
        }
    }
}


#Preview {
    ChangeDarkLightView(isShowDarkMode: .constant(true))
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {
            // 2
            withAnimation {
                configuration.isOn.toggle()
            }
        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.circle" : "circle")
                    .foregroundStyle(.text)
                    .imageScale(.large)
                
                configuration.label
                    .foregroundStyle(.text)
            }
        })
    }
}
