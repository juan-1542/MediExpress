package ucentral.edu.co.MediExpress.Repositorios;

import org.springframework.data.jpa.repository.JpaRepository;
import ucentral.edu.co.MediExpress.Entidades.DistribuidorArticulo;

import java.util.List;
import java.util.Optional;

public interface DistribuidorArticuloRepositorio extends JpaRepository<DistribuidorArticulo, Long> {
    Optional<DistribuidorArticulo> findByDistribuidorIdAndArticuloId(long distribuidorId, long articuloId);
    List<DistribuidorArticulo> findByDistribuidorId(long distribuidorId);
}

