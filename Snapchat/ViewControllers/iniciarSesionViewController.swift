//
//  ViewController.swift
//  Snapchat
//
//  Created by MAC17 on 9/05/19.
//  Copyright © 2019 deah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class iniciarSesionViewController: UIViewController {

    // Create a storage reference from our storage service
   
    
    // Create a storage reference from our storage service
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func btnFacebook(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            //2.
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            //2.
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            //3.
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            //4.
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                //5.
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                //6.
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                
            })
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        //1.
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){(user,error) in
            print("Intentando Iniciar Sesion")
            if(error != nil){
                print("Se presento el siguiente error \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user,error) in
                    print("intentando crear usuario")
                    if(error != nil){
                        print("Se presento el siguiente error al crear el usuario: \(error)")
                    }else{
                        print("El usuario fue creado exitosamente")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        
                        let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario \(self.emailTextField!.text!) se creo correctament", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in
                            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                        })
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                    }
                })
            }else{
                print("Inicio de sesion exitoso")
                
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
        
    }


}

