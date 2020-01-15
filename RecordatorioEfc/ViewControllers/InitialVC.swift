//
//  ViewController.swift
//  RecordatorioEfc
//
//  Created by eduardo fulgencio on 10/01/2020.
//  Copyright © 2020 Eduardo Fulgencio Comendeiro. All rights reserved.
//

import UIKit
import CoreLocation

class InitialVC: UIViewController, ObtenerPosicion {
    

    @IBOutlet weak var cancelarAvisos: UIButton!
    @IBOutlet weak var activarAvisos: UIButton!
    @IBOutlet weak var ubicacionActiva: UILabel!
    @IBOutlet weak var ubicacionHogar: UILabel!
    @IBOutlet weak var txtfEmailEnviarAviso: UITextField!
    
    @IBOutlet weak var txtvUbicaciones: UITextView!
    @IBOutlet weak var txtfLatitud: UITextField!
    @IBOutlet weak var txtfLongitud: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterRegion),
                                               name: NSNotification.Name("internalNotification.enteredRegion"),
                                               object: nil)
        txtvUbicaciones.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        UNService.shared.authorize()
        CLService.shared.authorize()
        CLService.shared.delegate = self
    }
    
    // la posición actual es la del hogar
    @IBAction func actionObtenerHogar(_ sender: Any) {
        CLService.shared.seleccionPosicion = SeleccionPosicion.hogar
        CLService.shared.updateLocation()
    }

    
    // Paso la información a localizacion para que active
    @IBAction func actionAplicarHogar(_ sender: Any) {
        let valoresArray = ubicacionHogar.text?.split(separator: "-")
        if valoresArray!.count > 1 {
            txtfLatitud.text = String(valoresArray![0])
            txtfLongitud.text = String(valoresArray![1])
        }
    }
    
    
    func posicionActual(location: CLLocation) {
        if CLService.shared.seleccionPosicion == SeleccionPosicion.hogar || true {
            ubicacionHogar.text = ("\(location.coordinate.latitude.description)-\(location.coordinate.longitude.description)")
        }
        DispatchQueue.main.async {
            self.txtvUbicaciones.text.append(location.coordinate.latitude.description + "\r")
         //   self.txtvUbicaciones.text.append(contentsOf: "info")
        }
        
    
        // Volver a estado aviso
        CLService.shared.seleccionPosicion = SeleccionPosicion.aviso
    }
    
    @IBAction func actionActivar(_ sender: Any) {
        if txtfLatitud.text!.count > 0 && txtfLongitud.text!.count > 0 {
            ubicacionActiva.text = "\(txtfLatitud.text!)-\(txtfLongitud.text!)"
            CLService.shared.updateLocation()
        }
    }
    
    @IBAction func actionCancelar(_ sender: Any) {
        ubicacionActiva.text = ""
        txtfLongitud.text = ""
        txtfLatitud.text = ""
    }
    
    // MARK: - ENVIO DE LA NOTIFICACION
    @objc func didEnterRegion() {
        txtfEmailEnviarAviso.text = "entrada region"
        UNService.shared.locationRequst()
    }
    
}
