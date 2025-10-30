package ucentral.edu.co.MediExpress.Controladores;
import ucentral.edu.co.MediExpress.Entidades.Usuario;
import ucentral.edu.co.MediExpress.Servicios.UsuarioServicio;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@RestController
@RequestMapping("/usuarios")
public class UsuarioControlador {

    @Autowired
    private UsuarioServicio servicio;

    @PostMapping("/post")
    public void crear(@RequestBody  Usuario usuario){
        this.servicio.registrar(usuario);
    }
    @GetMapping("/get")
    public List<Usuario> consultar(){
        return this.servicio.consultarTodos();

    }

}
