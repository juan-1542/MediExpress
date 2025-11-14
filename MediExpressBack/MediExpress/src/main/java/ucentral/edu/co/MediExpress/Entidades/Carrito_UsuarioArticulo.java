package ucentral.edu.co.MediExpress.Entidades;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "carrito_usuario_articulos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Carrito_UsuarioArticulo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "carrito_id")
    @JsonBackReference
    private Carrito_Usuario carrito;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "articulo_id")
    private Articulo articulo;

    @Column(name = "cantidad")
    private int cantidad;
}
