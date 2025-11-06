package ucentral.edu.co.MediExpress.Servicios;

import ucentral.edu.co.MediExpress.Entidades.Articulo;
import ucentral.edu.co.MediExpress.Entidades.Distribuidor;
import ucentral.edu.co.MediExpress.Entidades.DistribuidorArticulo;
import ucentral.edu.co.MediExpress.Repositorios.DistribuidorArticuloRepositorio;
import ucentral.edu.co.MediExpress.Repositorios.DistribuidorRepositorio;
import ucentral.edu.co.MediExpress.Repositorios.ArticuloRepositorio;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
@NoArgsConstructor
public class DistribuidorServicio {

    @Autowired
    private DistribuidorRepositorio distribuidorRepositorio;

    @Autowired
    private DistribuidorArticuloRepositorio distribuidorArticuloRepositorio;

    @Autowired
    private ArticuloRepositorio articuloRepositorio;

    public Distribuidor crear(Distribuidor distribuidor){
        return distribuidorRepositorio.save(distribuidor);
    }

    public Distribuidor actualizar(Distribuidor distribuidor){
        return distribuidorRepositorio.save(distribuidor);
    }

    public void eliminar(long id){
        distribuidorRepositorio.deleteById(id);
    }

    public List<Distribuidor> consultarTodos(){
        return distribuidorRepositorio.findAll();
    }

    public Optional<Distribuidor> consultarPorId(long id){
        return distribuidorRepositorio.findById(id);
    }

    @Transactional
    public DistribuidorArticulo agregarOActualizarArticuloEnDistribuidor(long distribuidorId, long articuloId, int cantidad){
        Distribuidor distribuidor = distribuidorRepositorio.findById(distribuidorId)
                .orElseThrow(() -> new IllegalArgumentException("Distribuidor no encontrado"));

        Articulo articulo = articuloRepositorio.getReferenceById(articuloId);
        // ↑ Usa getReferenceById (no findById) para que Hibernate obtenga una referencia válida (proxy administrado)

        Optional<DistribuidorArticulo> existente = distribuidorArticuloRepositorio.findByDistribuidorIdAndArticuloId(distribuidorId, articuloId);
        DistribuidorArticulo da;
        if (existente.isPresent()) {
            da = existente.get();
            da.setCantidad(cantidad);
        } else {
            da = new DistribuidorArticulo();
            da.setDistribuidor(distribuidor);
            da.setArticulo(articulo);
            da.setCantidad(cantidad);
        }
        return distribuidorArticuloRepositorio.save(da);
    }

    public List<DistribuidorArticulo> listarArticulosPorDistribuidor(long distribuidorId){
        return distribuidorArticuloRepositorio.findByDistribuidorId(distribuidorId);
    }

    @Transactional
    public void eliminarArticuloDeDistribuidor(long distribuidorId, long articuloId){
        Optional<DistribuidorArticulo> existente = distribuidorArticuloRepositorio.findByDistribuidorIdAndArticuloId(distribuidorId, articuloId);
        existente.ifPresent(distribuidorArticuloRepositorio::delete);
    }
}
