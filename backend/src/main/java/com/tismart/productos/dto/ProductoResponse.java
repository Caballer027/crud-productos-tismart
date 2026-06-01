package com.tismart.productos.dto;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductoResponse {
    private Long idProducto;
    private String codigo;
    private String nombre;
    private String marca;
    private String modelo;
    private BigDecimal precio;
    private Integer stock;
    private String estado;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaModif;
}
