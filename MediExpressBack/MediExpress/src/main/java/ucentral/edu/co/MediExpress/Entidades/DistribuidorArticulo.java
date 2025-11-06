package ucentral.edu.co.MediExpress.Entidades;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "distribuidor_articulos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class DistribuidorArticulo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne
    @JoinColumn(name = "distribuidor_id")
    @JsonBackReference  // Evita bucle al serializar Distribuidor -> DistribuidorArticulo
    private Distribuidor distribuidor;

    @ManyToOne
    @JoinColumn(name = "articulo_id")
    @JsonBackReference  // Evita bucle al serializar Articulo -> DistribuidorArticulo
    private Articulo articulo;

    @Column(name = "cantidad")
    private int cantidad;
}


