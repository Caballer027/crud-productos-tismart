package com.tismart.productos.service;

import com.tismart.productos.dto.ProductoRequest;
import com.tismart.productos.dto.ProductoResponse;
import com.tismart.productos.entity.Producto;
import com.tismart.productos.exception.CodigoDuplicadoException;
import com.tismart.productos.exception.ProductoNoEncontradoException;
import com.tismart.productos.repository.ProductoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ProductoService {

    private final ProductoRepository repository;

    @Transactional
    public ProductoResponse crear(ProductoRequest request) {
        if (repository.existsByCodigoAndEstado(request.getCodigo(), "A")) {
            throw new CodigoDuplicadoException(request.getCodigo());
        }
        Producto producto = Producto.builder()
                .codigo(request.getCodigo())
                .nombre(request.getNombre())
                .marca(request.getMarca())
                .modelo(request.getModelo())
                .precio(request.getPrecio())
                .stock(request.getStock())
                .estado("A")
                .build();
        Producto saved = repository.save(producto);
        // Re-fetch para obtener FECHA_CREACION puesta por el trigger de Oracle
        return toResponse(repository.findByIdProductoAndEstado(saved.getIdProducto(), "A")
                .orElse(saved));
    }

    @Transactional(readOnly = true)
    public Page<ProductoResponse> listar(String marca, String modelo, Pageable pageable) {
        String m   = StringUtils.hasText(marca)  ? marca  : null;
        String mod = StringUtils.hasText(modelo) ? modelo : null;
        return repository.listarActivos(m, mod, pageable).map(this::toResponse);
    }

    @Transactional(readOnly = true)
    public ProductoResponse obtener(Long id) {
        return toResponse(findActivo(id));
    }

    @Transactional
    public ProductoResponse actualizar(Long id, ProductoRequest request) {
        Producto producto = findActivo(id);
        if (repository.existsByCodigoAndEstadoAndIdProductoNot(request.getCodigo(), "A", id)) {
            throw new CodigoDuplicadoException(request.getCodigo());
        }
        producto.setCodigo(request.getCodigo());
        producto.setNombre(request.getNombre());
        producto.setMarca(request.getMarca());
        producto.setModelo(request.getModelo());
        producto.setPrecio(request.getPrecio());
        producto.setStock(request.getStock());
        producto.setFechaModif(LocalDateTime.now());
        return toResponse(repository.save(producto));
    }

    @Transactional
    public void eliminar(Long id) {
        Producto producto = findActivo(id);
        producto.setEstado("I");
        producto.setFechaModif(LocalDateTime.now());
        repository.save(producto);
    }

    private Producto findActivo(Long id) {
        return repository.findByIdProductoAndEstado(id, "A")
                .orElseThrow(() -> new ProductoNoEncontradoException(id));
    }

    private ProductoResponse toResponse(Producto p) {
        return ProductoResponse.builder()
                .idProducto(p.getIdProducto())
                .codigo(p.getCodigo())
                .nombre(p.getNombre())
                .marca(p.getMarca())
                .modelo(p.getModelo())
                .precio(p.getPrecio())
                .stock(p.getStock())
                .estado(p.getEstado())
                .fechaCreacion(p.getFechaCreacion())
                .fechaModif(p.getFechaModif())
                .build();
    }
}
