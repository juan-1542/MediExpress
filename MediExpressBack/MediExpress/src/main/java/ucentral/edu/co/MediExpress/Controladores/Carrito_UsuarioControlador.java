package ucentral.edu.co.MediExpress.Controladores;

import ucentral.edu.co.MediExpress.Entidades.Carrito_Usuario;
import ucentral.edu.co.MediExpress.Servicios.Carrito_UsuarioServicio;
import ucentral.edu.co.MediExpress.Servicios.dto.CompraRequest;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@RestController
@RequestMapping("/carritos")
public class Carrito_UsuarioControlador {

    @Autowired
    private Carrito_UsuarioServicio servicio;

    @GetMapping("/usuario/{id}")
    public List<Carrito_Usuario> obtenerComprasPorUsuario(@PathVariable long id){
        return this.servicio.obtenerComprasPorUsuario(id);
    }

    @PostMapping("/post")
    public void crearCompra(@RequestBody Carrito_Usuario carrito){
        this.servicio.registrar(carrito);
    }

    @PostMapping("/post/usuario/{id}")
    public Carrito_Usuario crearCompraPorUsuarioId(@PathVariable long id){
        return this.servicio.registrarPorUsuarioId(id);
    }

    // Nuevo endpoint: registrar compra con items
    @PostMapping("/comprar")
    public Carrito_Usuario crearCompraConItems(@RequestBody CompraRequest request){
        return this.servicio.registrarCompra(request);
    }
}
