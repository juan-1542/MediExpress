package ucentral.edu.co.MediExpress.Entidades;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Table(name = "distribuidores")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Distribuidor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private long id;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "ciudad")
    private String ciudad;

    @Column(name = "localidad")
    private String localidad;

    @Column(name = "direccion")
    private String direccion;

    @OneToMany(mappedBy = "distribuidor", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private List<DistribuidorArticulo> articulosDisponibles = new ArrayList<>();
}
