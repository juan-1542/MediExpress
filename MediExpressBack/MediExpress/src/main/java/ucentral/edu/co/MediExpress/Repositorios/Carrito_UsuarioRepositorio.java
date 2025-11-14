package ucentral.edu.co.MediExpress.Repositorios;

import org.springframework.data.jpa.repository.JpaRepository;
import ucentral.edu.co.MediExpress.Entidades.Carrito_Usuario;

import java.util.List;

public interface Carrito_UsuarioRepositorio extends JpaRepository<Carrito_Usuario, Long> {
    List<Carrito_Usuario> findByUsuario_Id(long usuarioId);
}
