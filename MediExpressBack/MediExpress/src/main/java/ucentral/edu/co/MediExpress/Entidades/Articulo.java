package ucentral.edu.co.MediExpress.Entidades;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "articulos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Articulo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private long id;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "precio_unitario")
    private double precioUnitario;

    @Column(name = "descripcion")
    private String descripcion;

    @Column(name = "dosis")
    private String dosis;

    @Column(name = "tipo_medicamento")
    private String tipoMedicamento;
}
