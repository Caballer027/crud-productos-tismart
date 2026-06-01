package com.tismart.productos.entity;

import lombok.*;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "PRODUCTO")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Producto {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seqProducto")
    @SequenceGenerator(name = "seqProducto", sequenceName = "SEQ_PRODUCTO", allocationSize = 1)
    @Column(name = "ID_PRODUCTO")
    private Long idProducto;

    @Column(name = "CODIGO", nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(name = "NOMBRE", nullable = false, length = 120)
    private String nombre;

    @Column(name = "MARCA", nullable = false, length = 60)
    private String marca;

    @Column(name = "MODELO", nullable = false, length = 60)
    private String modelo;

    @Column(name = "PRECIO", nullable = false, precision = 10, scale = 2)
    private BigDecimal precio;

    @Column(name = "STOCK", nullable = false)
    private Integer stock;

    @Column(name = "ESTADO", nullable = false, length = 1)
    private String estado;

    // insertable=false, updatable=false: Oracle trigger y DEFAULT manejan este campo
    @Column(name = "FECHA_CREACION", insertable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    @Column(name = "FECHA_MODIF")
    private LocalDateTime fechaModif;
}
