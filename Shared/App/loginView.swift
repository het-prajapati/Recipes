//
//  loginView.swift
//  Recipes
//
//  Created by Het Prajapati on 6/22/21.
//

import UIKit
import SwiftUI
import AudioToolbox
import Firebase

struct loginView: View {
    //MARK: - PROPERTIES
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var editingEmailTextField: Bool = false
    @State private var editingPasswordTextField: Bool = false
    @State private var emailIconBounce: Bool = false
    @State private var passwordIconBounce: Bool = false
    //    @State private var signupToggle: Bool = true
    @State private var showProfileView: Bool = false
    @State private var rotationAngle = 0.0
    @State private var fadeToggle: Bool = true
    @State private var showAlert = false
    @State private var alertMessage = "Something Went Wrong!"
    @State private var isLoading = false
    @State private var isSuccessfull = false
    @EnvironmentObject var user: UserStore
    
    private let generator = UISelectionFeedbackGenerator()
    
    
    func login() {
        self.isLoading = true
        generator.selectionChanged()
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            
            if error != nil {
                self.alertMessage = error?.localizedDescription ?? ""
                self.showAlert = true
            } else {
                
                self.isSuccessfull = true
                self.user.isLogged = true
                UserDefaults.standard.set(true, forKey: "isLogged")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.email = ""
                    self.password = ""
                    self.isSuccessfull = false
                    withAnimation(.easeOut) {
                        self.user.showLogin = false
                    }
                }
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //MARK: - VIEW
    var body: some View {
        ZStack {
            
            Image("background-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 1.0 : 0.0)
            
            
            Color("secondaryBackground")
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 0.0 : 1.0)
            
            VStack {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Sign In")
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Access all the amazing recipes by signing in")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    // Email Text Field
                    HStack(spacing: 12.0) {
                        
                        TextfieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextField)
                            .scaleEffect(emailIconBounce ? 1.2 : 1.0)
                        
                        TextField("Email", text: $email) { isEditing in
                            
                            editingEmailTextField = isEditing
                            editingPasswordTextField = false
                            generator.selectionChanged()
                            
                            if isEditing{
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    emailIconBounce.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)){
                                        emailIconBounce.toggle()
                                    }
                                }
                            }
                        }
                        .colorScheme(.dark)
                        .foregroundColor(Color.white.opacity(0.7))
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                    }
                    .frame(height: 52)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1.0)
                            .blendMode(.overlay)
                        
                    )
                    .background(Color("secondaryBackground")
                                    .cornerRadius(16.0)
                                    .opacity(0.8)
                    )
                    
                    //Password Text Field
                    HStack(spacing: 12.0) {
                        TextfieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextField)
                            .scaleEffect(passwordIconBounce ? 1.2 : 1.0)
                        SecureField("Password", text: $password)
                            .colorScheme(.dark)
                            .foregroundColor(Color.white.opacity(0.7))
                            .autocapitalization(.none)
                            .textContentType(.password)
                    }
                    .frame(height: 52)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1.0)
                            .blendMode(.overlay)
                        
                    )
                    .background(
                        Color("secondaryBackground")
                            .cornerRadius(16.0)
                            .opacity(0.8)
                    )
                    .onTapGesture {
                        editingPasswordTextField = true
                        editingEmailTextField = false
                        
                        generator.selectionChanged()
                        
                        if editingPasswordTextField {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                passwordIconBounce.toggle()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)){
                                    passwordIconBounce.toggle()
                                }
                            }
                        }
                    }
                    
                    /*
                     Past the text fields
                     Sign In Button
                     */
                    
                    GradientButton(buttonTitle: "Sign in") {
                        self.hideKeyboard()
                        self.login()
                    }
                    .alert(isPresented: $showAlert){
                        Alert(title: Text("Error!"), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    // Only Show Disclaimer if signupToggle = true
                    //                    if signupToggle {
                    //                        Text("By clicking on Sign up, you agree to our Terms of service and Privacy policy")
                    //                            .font(.footnote)
                    //                            .foregroundColor(Color.white.opacity(0.7))
                    //                        Rectangle()
                    //                            .frame(height: 1)
                    //                            .foregroundColor(Color.white.opacity(0.1))
                    //                    }
                    
                    //                    Divider()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.1))
                    
                    // Stack containing the last two buttons
                    VStack(alignment: .leading, spacing: 16, content: {
                        Button(action: {
                            
                            //                            withAnimation(.easeInOut(duration: 0.35)) {
                            //                                fadeToggle.toggle()
                            //                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            //                                    withAnimation(.easeInOut(duration: 0.35)) {
                            //                                        self.fadeToggle.toggle()
                            //                                    }
                            //                                }
                            //                            }
                            //
                            //                            withAnimation(
                            //                                .easeInOut(duration: 0.7)){
                            //                                signupToggle.toggle()
                            //                                self.rotationAngle += 180
                            //                            }
                        }, label: {
                            HStack(spacing: 4){
                                Text("Need an account?")
                                    .font(.footnote)
                                    .foregroundColor(Color.white.opacity(0.7))
                                GradientText(text:"Sign up")
                                    .font(Font.footnote.bold())
                                
                            }
                        })
                        
                        // Forgot Password Button
                        //                        if !signupToggle {
                        Button(action: {
                            print("Send Reset password email")
                        }, label: {
                            HStack(spacing: 4){
                                Text("Forgot Password?")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                GradientText(text: "Reset password")
                                    .font(.footnote.bold())
                            }
                        })
                        //                        }
                    })
                }
                .padding(20)
            }
            .rotation3DEffect(
                Angle(degrees: self.rotationAngle),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .background(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.2))
                            .background(Color("secondaryBackground").opacity(0.5))
                            .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark))
                            .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30.0)
            .padding(.horizontal)
            .rotation3DEffect(
                Angle(degrees: self.rotationAngle),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .onTapGesture {
                self.hideKeyboard()
            }
            
            if isLoading {
                LoadingView()
            }
            
            if isSuccessfull {
                SuccessView()
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
         
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        loginView()
    }
}
