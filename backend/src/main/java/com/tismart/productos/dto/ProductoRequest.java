package com.tismart.productos.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.*;
import java.math.BigDecimal;

@Getter
@Setter
public class ProductoRequest {

    @NotBlank(message = "El código es obligatorio")
    @Size(max = 20, message = "El código no puede superar 20 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 120, message = "El nombre no puede superar 120 caracteres")
    private String nombre;

    @NotBlank(message = "La marca es obligatoria")
    @Size(max = 60, message = "La marca no puede superar 60 caracteres")
    private String marca;

    @NotBlank(message = "El modelo es obligatorio")
    @Size(max = 60, message = "El modelo no puede superar 60 caracteres")
    private String modelo;

    @NotNull(message = "El precio es obligatorio")
    @DecimalMin(value = "0.0", inclusive = true, message = "El precio no puede ser negativo")
    private BigDecimal precio;

    @NotNull(message = "El stock es obligatorio")
    @Min(value = 0, message = "El stock no puede ser negativo")
    private Integer stock;
}
