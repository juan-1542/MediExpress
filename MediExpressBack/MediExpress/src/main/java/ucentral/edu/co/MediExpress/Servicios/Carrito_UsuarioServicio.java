package ucentral.edu.co.MediExpress.Servicios;

import ucentral.edu.co.MediExpress.Entidades.Carrito_Usuario;
import ucentral.edu.co.MediExpress.Entidades.Carrito_UsuarioArticulo;
import ucentral.edu.co.MediExpress.Entidades.Usuario;
import ucentral.edu.co.MediExpress.Entidades.Articulo;
import ucentral.edu.co.MediExpress.Repositorios.Carrito_UsuarioArticuloRepositorio;
import ucentral.edu.co.MediExpress.Repositorios.Carrito_UsuarioRepositorio;
import ucentral.edu.co.MediExpress.Repositorios.UsuarioRepositorio;
import ucentral.edu.co.MediExpress.Repositorios.ArticuloRepositorio;
import ucentral.edu.co.MediExpress.Servicios.dto.CompraRequest;
import ucentral.edu.co.MediExpress.Servicios.dto.ItemDTO;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
@NoArgsConstructor
public class Carrito_UsuarioServicio {

    @Autowired
    private Carrito_UsuarioRepositorio repositorio;

    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    @Autowired
    private ArticuloRepositorio articuloRepositorio;

    @Autowired
    private Carrito_UsuarioArticuloRepositorio carritoArticuloRepositorio;

    public List<Carrito_Usuario> obtenerComprasPorUsuario(long usuarioId){
        return this.repositorio.findByUsuario_Id(usuarioId);
    }

    public Carrito_Usuario registrar(Carrito_Usuario carrito){
        return this.repositorio.save(carrito);
    }

    public Carrito_Usuario registrarPorUsuarioId(long usuarioId){
        Optional<Usuario> maybeUser = this.usuarioRepositorio.findById(usuarioId);
        if(maybeUser.isEmpty()){
            throw new IllegalArgumentException("Usuario con id " + usuarioId + " no encontrado");
        }
        Carrito_Usuario carrito = new Carrito_Usuario();
        carrito.setUsuario(maybeUser.get());
        return this.repositorio.save(carrito);
    }

    // Nuevo método: registrar una compra con items (articuloId + cantidad)
    public Carrito_Usuario registrarCompra(CompraRequest request){
        Optional<Usuario> maybeUser = this.usuarioRepositorio.findById(request.getUsuarioId());
        if(maybeUser.isEmpty()){
            throw new IllegalArgumentException("Usuario con id " + request.getUsuarioId() + " no encontrado");
        }

        Carrito_Usuario carrito = new Carrito_Usuario();
        carrito.setUsuario(maybeUser.get());

        // Guardar el carrito primero para obtener id si es necesario
        Carrito_Usuario carritoGuardado = this.repositorio.save(carrito);

        // Por cada item del request, validar articulo y crear Carrito_UsuarioArticulo
        for(ItemDTO item : request.getItems()){
            Optional<Articulo> maybeArticulo = this.articuloRepositorio.findById(item.getArticuloId());
            if(maybeArticulo.isEmpty()){
                throw new IllegalArgumentException("Articulo con id " + item.getArticuloId() + " no encontrado");
            }
            if(item.getCantidad() <= 0){
                throw new IllegalArgumentException("La cantidad debe ser mayor a cero para el articulo id " + item.getArticuloId());
            }

            Carrito_UsuarioArticulo carritoArticulo = new Carrito_UsuarioArticulo();
            carritoArticulo.setCarrito(carritoGuardado);
            carritoArticulo.setArticulo(maybeArticulo.get());
            carritoArticulo.setCantidad(item.getCantidad());

            // Agregar a la lista del carrito (manejo bidireccional)
            carritoGuardado.getItems().add(carritoArticulo);
        }

        // Guardar nuevamente el carrito con los items en cascada
        return this.repositorio.save(carritoGuardado);
    }
}
