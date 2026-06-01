package com.tismart.productos.repository;

import com.tismart.productos.entity.Producto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProductoRepository extends JpaRepository<Producto, Long> {

    Optional<Producto> findByIdProductoAndEstado(Long idProducto, String estado);

    boolean existsByCodigoAndEstado(String codigo, String estado);

    boolean existsByCodigoAndEstadoAndIdProductoNot(String codigo, String estado, Long idProducto);

    @Query(
        value = "SELECT * FROM PRODUCTO " +
                "WHERE ESTADO = 'A' " +
                "AND (:marca IS NULL OR MARCA LIKE '%' || :marca || '%') " +
                "AND (:modelo IS NULL OR MODELO LIKE '%' || :modelo || '%') " +
                "ORDER BY ID_PRODUCTO",
        countQuery = "SELECT COUNT(*) FROM PRODUCTO " +
                     "WHERE ESTADO = 'A' " +
                     "AND (:marca IS NULL OR MARCA LIKE '%' || :marca || '%') " +
                     "AND (:modelo IS NULL OR MODELO LIKE '%' || :modelo || '%')",
        nativeQuery = true
    )
    Page<Producto> listarActivos(@Param("marca") String marca,
                                 @Param("modelo") String modelo,
                                 Pageable pageable);
}
