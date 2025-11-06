package ucentral.edu.co.MediExpress.Repositorios;

import org.springframework.data.jpa.repository.JpaRepository;
import ucentral.edu.co.MediExpress.Entidades.Articulo;

public interface ArticuloRepositorio extends JpaRepository<Articulo, Long> {
}
