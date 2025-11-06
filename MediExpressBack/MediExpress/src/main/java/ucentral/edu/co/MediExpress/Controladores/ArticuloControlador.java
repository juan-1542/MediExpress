package ucentral.edu.co.MediExpress.Controladores;

import ucentral.edu.co.MediExpress.Entidades.Articulo;
import ucentral.edu.co.MediExpress.Servicios.ArticuloServicio;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@AllArgsConstructor
@NoArgsConstructor
@RestController
@RequestMapping("/articulos")
public class ArticuloControlador {

    @Autowired
    private ArticuloServicio servicio;

    @PostMapping("/post")
    public void crear(@RequestBody Articulo articulo){
        this.servicio.registrar(articulo);
    }

    @GetMapping("/get")
    public List<Articulo> consultar(){
        return this.servicio.consultarTodos();

    }

    @GetMapping("/get/{id}")
    public Optional<Articulo> consultarPorId(@PathVariable long id){
        return this.servicio.consultarPorId(id);
    }

    @PutMapping("/put")
    public void actualizar(@RequestBody Articulo articulo){
        this.servicio.actualizar(articulo);
    }

    @DeleteMapping("/delete/{id}")
    public void eliminar(@PathVariable long id){
        this.servicio.eliminar(id);
    }
}
