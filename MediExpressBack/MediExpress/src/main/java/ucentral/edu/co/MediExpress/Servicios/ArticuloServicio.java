package ucentral.edu.co.MediExpress.Servicios;

import ucentral.edu.co.MediExpress.Entidades.Articulo;
import ucentral.edu.co.MediExpress.Repositorios.ArticuloRepositorio;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
@NoArgsConstructor
public class ArticuloServicio {

    @Autowired
    private ArticuloRepositorio repositorio;

    public void registrar(Articulo articulo){
        this.repositorio.save(articulo);
    }

    public void actualizar(Articulo articulo){
        this.repositorio.save(articulo);
    }

    public void eliminar(long id){
        this.repositorio.deleteById(id);
    }

    public List<Articulo> consultarTodos(){
        return this.repositorio.findAll();
    }

    public Optional<Articulo> consultarPorId(long id){
        return this.repositorio.findById(id);
    }
}
