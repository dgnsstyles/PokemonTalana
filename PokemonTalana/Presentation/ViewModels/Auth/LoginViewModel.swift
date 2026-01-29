//
//  LoginViewModel.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//


import Foundation
import Combine
import SwiftUI

import GoogleSignIn

import FirebaseCore

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var showBiometricOption = false
    
    private let authenticateUserUseCase: AuthenticateUserUseCase
    private let biometricManager = BiometricAuthManager.shared
    
    init(authenticateUserUseCase: AuthenticateUserUseCase) {
        self.authenticateUserUseCase = authenticateUserUseCase
        checkIfUserExists()
    }
    
    func checkIfUserExists() {
        if authenticateUserUseCase.isLoggedIn() {
            showBiometricOption = biometricManager.canUseBiometrics()
        }
    }
    
    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter username and password"
            return
        }
        
        if authenticateUserUseCase.login(username: username, password: password) {
            isLoggedIn = true
            errorMessage = nil
        } else {
            errorMessage = "Invalid credentials"
        }
    }
    
    func register() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter username and password"
            return
        }
        
        if authenticateUserUseCase.register(username: username, password: password) {
            isLoggedIn = true
            errorMessage = nil
        } else {
            errorMessage = "Registration failed"
        }
    }
    
    func authenticateWithBiometrics() {
        biometricManager.authenticateWithBiometrics { [weak self] success, error in
            if success {
                self?.isLoggedIn = true
            } else {
                self?.errorMessage = error ?? "Biometric authentication failed"
            }
        }
    }
    
    func googleLogin() {
#if canImport(GoogleSignIn)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        FirebaseAuthManager.shared.signInWithGoogle(presentingViewController: rootViewController) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
#else
        // GoogleSignIn SDK not integrated; provide a helpful error.
        self.errorMessage = "Google Sign-In is not available. Add the GoogleSignIn SDK to enable this feature."
#endif
    }
}
