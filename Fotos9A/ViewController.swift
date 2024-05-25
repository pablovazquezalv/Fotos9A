//
//  ViewController.swift
//  Fotos9A
//
//  Created by Igmar Salazar on 06/05/24.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, PHPickerViewControllerDelegate
{
    @IBOutlet weak var scrImagen: UIScrollView!
    @IBOutlet weak var btnAnterior: UIButton!
    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var imvImagen: UIImageView!
    @IBOutlet weak var lblContador: UILabel!
    var fotos:[UIImage] = []
    var indice = -1
    
    //MARK: - Métodos clase UIViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Acciones
    @IBAction func mostrarMenu()
    {
        let menu = UIAlertController(title: "MENÚ DE OPCIONES", message: "Selecciona una opción", preferredStyle: .actionSheet)
        let camara = UIAlertAction(title: "Tomar foto de cámara", style: .default) { sender in
            self.tomarFotoCamara()
        }
        let galeria = UIAlertAction(title: "Tomar foto de galería", style: .default) { sender in
            self.tomarFotoGaleria()
        }
        let guardar = UIAlertAction(title: "Guardar foto en galería", style: .default) { sender in
            self.guardarFotoGaleria()
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        
        menu.addAction(camara)
        menu.addAction(galeria)
        menu.addAction(guardar)
        menu.addAction(cancelar)
        present(menu, animated: true)
    }
    
    @IBAction func irAnterior()
    {
        indice -= 1
        setearFoto()
    }
    
    @IBAction func irSiguiente()
    {
        indice += 1
        setearFoto()
    }
    
    //MARK: - Métodos propios de la clase
    func tomarFotoCamara()
    {
        let camara = UIImagePickerController()
        camara.sourceType = .camera
        camara.delegate = self
        present(camara, animated: true)
    }
    
    func tomarFotoGaleria()
    {
        var conf = PHPickerConfiguration()
        conf.filter = .images
        conf.selectionLimit = 3
        
        let galeria = PHPickerViewController(configuration: conf)
        galeria.delegate = self
        present(galeria, animated: true)
    }
    
    func guardarFotoGaleria()
    {
    }
    
    func setearFoto()
    {
        lblContador.text = "\(indice+1)/\(fotos.count)"
        if indice == 0
        {
            btnAnterior.isHidden = true
        }
        else
        {
            btnAnterior.isHidden = false
        }
        if indice == fotos.count - 1
        {
            btnSiguiente.isHidden = true
        }
        else
        {
            btnSiguiente.isHidden = false
        }
        
        imvImagen.image = fotos[indice]
        scrImagen.minimumZoomScale = 1
        scrImagen.maximumZoomScale = 10
        scrImagen.zoomScale = 1
    }
    
    //MARK: - Métodos de delegados (Protocolos)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        dismiss(animated: true)
        fotos.append(info[.originalImage] as! UIImage)
        indice = fotos.count - 1
        setearFoto()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imvImagen
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        var contador = 0
        let limite = results.count
        dismiss(animated: true)
        
        for resultado in results
        {
            resultado.itemProvider.loadObject(ofClass: UIImage.self) { objeto, error in
                contador += 1
                if let obj = objeto
                {
                    self.fotos.append(obj as! UIImage)
                }
                
                if contador == limite
                {
                    self.indice = self.fotos.count - 1
                    DispatchQueue.main.async {
                        self.setearFoto()
                    }
                }
            }
        }
    }
}
