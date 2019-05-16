//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by MAC17 on 16/05/19.
//  Copyright © 2019 deah. All rights reserved.
//

import UIKit
import Firebase

class ImagenViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(NSUUID().uuidString).jpg").putData(imagenData!,metadata: nil){(metadata,error) in
            if error != nil{
                self.mostrarAlerta(titulo: "error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion de internet y vuelva a intentarlo", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir imagen: \(error)")
            }else{
               
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
            }
        }
        let alertaCarga = UIAlertController(title: "cargando Imagen...",message: "0%",preferredStyle: .alert)
        let progesoCarga : UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress){(snapshot)in
            let porcentaje = Double(snapshot.progress!.completedUnitCount)
            print(porcentaje)
            progesoCarga.setProgress(Float(porcentaje), animated: true)
            progesoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + "%"
            if porcentaje>=1.0{
                alertaCarga.dismiss(animated: true, completion: nil)
                
            }
            
        }
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(progesoCarga)
        present(alertaCarga, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        imagenesFolder.child("imagenes.jpg").putData(imagenData!,metadata:nil){(metadata, error)in
            if error != nil{
                print("Ocurrio un error al subir imagen; \(error)")
            }
        }
    }
    func mostrarAlerta(titulo: String,mensaje: String, accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta,animated: true,completion: nil)
    }
}
