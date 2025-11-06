package ucentral.edu.co.MediExpress.Servicios;
import ucentral.edu.co.MediExpress.Entidades.Usuario;
import ucentral.edu.co.MediExpress.Repositorios.UsuarioRepositorio;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@AllArgsConstructor
@NoArgsConstructor
public class UsuarioServicio {
    @Autowired
    private UsuarioRepositorio repositorio;

    public void registrar(Usuario usuario){
        this.repositorio.save(usuario);
    }
    public void actualizar(Usuario usuario){
        this.repositorio.save(usuario);
    }
    public List<Usuario> consultarTodos(){
        return this.repositorio.findAll();
    }
    public void eliminar(long id){this.repositorio.deleteById(id);}
}
