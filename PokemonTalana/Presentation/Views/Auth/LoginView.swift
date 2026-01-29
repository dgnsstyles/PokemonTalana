//
//  LoginView.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @State private var isRegisterMode = false
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "FF6B6B"), Color(hex: "4ECDC4")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                Image(systemName: "circle.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Text("Pokédex")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer().frame(height: 20)
                
                // Form
                VStack(spacing: 20) {
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(CustomTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        if isRegisterMode {
                            viewModel.register()
                        } else {
                            viewModel.login()
                        }
                    }) {
                        Text(isRegisterMode ? "Register" : "Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        isRegisterMode.toggle()
                    }) {
                        Text(isRegisterMode ? "Already have an account? Login" : "Don't have an account? Register")
                            .foregroundColor(.white)
                            .font(.footnote)
                    }
                    
                    Divider()
                        .background(Color.white)
                    
                    Button(action: {
                        viewModel.googleLogin()
                    }) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                            Text("Sign in with Google")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    
                    if viewModel.showBiometricOption {
                        Button(action: {
                            viewModel.authenticateWithBiometrics()
                        }) {
                            HStack {
                                Image(systemName: "faceid")
                                Text("Login with Biometrics")
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.top, 60)
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            MainTabView()
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
    }
}
