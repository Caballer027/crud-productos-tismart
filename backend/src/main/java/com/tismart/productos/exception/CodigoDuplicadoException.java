package com.tismart.productos.exception;

public class CodigoDuplicadoException extends RuntimeException {
    public CodigoDuplicadoException(String codigo) {
        super("Ya existe un producto activo con el código: " + codigo);
    }
}
