package ucentral.edu.co.MediExpress.Repositorios;
import org.springframework.data.jpa.repository.JpaRepository;
import ucentral.edu.co.MediExpress.Entidades.Usuario;

public interface UsuarioRepositorio extends JpaRepository<Usuario,Integer> {
}
