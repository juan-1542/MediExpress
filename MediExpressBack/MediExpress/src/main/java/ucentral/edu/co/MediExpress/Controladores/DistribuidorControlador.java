package ucentral.edu.co.MediExpress.Controladores;

import lombok.Getter;
import lombok.Setter;
import ucentral.edu.co.MediExpress.Entidades.Distribuidor;
import ucentral.edu.co.MediExpress.Entidades.DistribuidorArticulo;
import ucentral.edu.co.MediExpress.Repositorios.UsuarioRepositorio;
import ucentral.edu.co.MediExpress.Servicios.DistribuidorServicio;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@AllArgsConstructor
@NoArgsConstructor
@RestController
@RequestMapping("/distribuidores")
public class DistribuidorControlador {

    @Autowired
    private DistribuidorServicio servicio;

    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    private static final String ROL_ADMIN = "AdminDistribucion";

    private void checkAdmin(Long usuarioId, String tipoUsuario){
        if(usuarioId != null){
            usuarioRepositorio.findById(usuarioId).ifPresentOrElse(u -> {
                if(!ROL_ADMIN.equals(u.getTipoUsuario())){
                    throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Acceso denegado: se requiere rol AdminDistribuicion");
                }
            }, () -> {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Usuario no encontrado");
            });
        } else {
            if(!ROL_ADMIN.equals(tipoUsuario)){
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Acceso denegado: se requiere rol AdminDistribuicion");
            }
        }
    }

    @PostMapping("/post")
    public Distribuidor crear(@RequestBody Distribuidor distribuidor,
                              @RequestHeader(value = "Usuario-Id", required = false) Long usuarioId,
                              @RequestHeader(value = "Tipo-Usuario", required = false) String tipoUsuario){
        checkAdmin(usuarioId, tipoUsuario);
        return servicio.crear(distribuidor);
    }

    @GetMapping("/get")
    public List<Distribuidor> consultar(){
        return servicio.consultarTodos();
    }

    @GetMapping("/get/{id}")
    public Optional<Distribuidor> consultarPorId(@PathVariable long id){
        return servicio.consultarPorId(id);
    }

    @PutMapping("/put")
    public Distribuidor actualizar(@RequestBody Distribuidor distribuidor,
                                   @RequestHeader(value = "Usuario-Id", required = false) Long usuarioId,
                                   @RequestHeader(value = "Tipo-Usuario", required = false) String tipoUsuario){
        checkAdmin(usuarioId, tipoUsuario);
        return servicio.actualizar(distribuidor);
    }

    @DeleteMapping("/delete/{id}")
    public void eliminar(@PathVariable long id,
                        @RequestHeader(value = "Usuario-Id", required = false) Long usuarioId,
                        @RequestHeader(value = "Tipo-Usuario", required = false) String tipoUsuario){
        checkAdmin(usuarioId, tipoUsuario);
        servicio.eliminar(id);
    }

    @PostMapping("/{distribuidorId}/articulos")
    public DistribuidorArticulo agregarArticulo(@PathVariable long distribuidorId,
                                                @RequestBody ArticuloCantidadDTO dto,
                                                @RequestHeader(value = "Usuario-Id", required = false) Long usuarioId,
                                                @RequestHeader(value = "Tipo-Usuario", required = false) String tipoUsuario){
        checkAdmin(usuarioId, tipoUsuario);
        return servicio.agregarOActualizarArticuloEnDistribuidor(distribuidorId, dto.getArticuloId(), dto.getCantidad());
    }

    @GetMapping("/{distribuidorId}/articulos")
    public List<DistribuidorArticulo> listarArticulos(@PathVariable long distribuidorId){
        return servicio.listarArticulosPorDistribuidor(distribuidorId);
    }

    @DeleteMapping("/{distribuidorId}/articulos/{articuloId}")
    public void eliminarArticulo(@PathVariable long distribuidorId,
                                 @PathVariable long articuloId,
                                 @RequestHeader(value = "Usuario-Id", required = false) Long usuarioId,
                                 @RequestHeader(value = "Tipo-Usuario", required = false) String tipoUsuario){
        checkAdmin(usuarioId, tipoUsuario);
        servicio.eliminarArticuloDeDistribuidor(distribuidorId, articuloId);
    }

    // DTO interno para recibir articuloId y cantidad
    @Setter
    @Getter
    public static class ArticuloCantidadDTO{
        private long articuloId;
        private int cantidad;

    }
}
