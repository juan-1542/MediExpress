package ucentral.edu.co.MediExpress.Servicios.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompraRequest {
    private long usuarioId;
    private List<ItemDTO> items;
}

