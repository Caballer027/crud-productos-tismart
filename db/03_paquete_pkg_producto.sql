-- ============================================================
-- PACKAGE SPEC
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_PRODUCTO AS

    PROCEDURE SP_CREAR_PRODUCTO(
        p_codigo   IN  PRODUCTO.CODIGO%TYPE,
        p_nombre   IN  PRODUCTO.NOMBRE%TYPE,
        p_marca    IN  PRODUCTO.MARCA%TYPE,
        p_modelo   IN  PRODUCTO.MODELO%TYPE,
        p_precio   IN  PRODUCTO.PRECIO%TYPE,
        p_stock    IN  PRODUCTO.STOCK%TYPE,
        p_id_out   OUT PRODUCTO.ID_PRODUCTO%TYPE
    );

    PROCEDURE SP_ACTUALIZAR_PRODUCTO(
        p_id       IN  PRODUCTO.ID_PRODUCTO%TYPE,
        p_codigo   IN  PRODUCTO.CODIGO%TYPE,
        p_nombre   IN  PRODUCTO.NOMBRE%TYPE,
        p_marca    IN  PRODUCTO.MARCA%TYPE,
        p_modelo   IN  PRODUCTO.MODELO%TYPE,
        p_precio   IN  PRODUCTO.PRECIO%TYPE,
        p_stock    IN  PRODUCTO.STOCK%TYPE
    );

    PROCEDURE SP_ELIMINAR_LOGICO_PRODUCTO(
        p_id IN PRODUCTO.ID_PRODUCTO%TYPE
    );

    PROCEDURE SP_OBTENER_PRODUCTO_ID(
        p_id     IN  PRODUCTO.ID_PRODUCTO%TYPE,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_LISTAR_PRODUCTOS(
        p_marca  IN  VARCHAR2,
        p_modelo IN  VARCHAR2,
        p_offset IN  NUMBER,
        p_size   IN  NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_PRODUCTO;
/

-- ============================================================
-- PACKAGE BODY
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_PRODUCTO AS

    PROCEDURE SP_CREAR_PRODUCTO(
        p_codigo   IN  PRODUCTO.CODIGO%TYPE,
        p_nombre   IN  PRODUCTO.NOMBRE%TYPE,
        p_marca    IN  PRODUCTO.MARCA%TYPE,
        p_modelo   IN  PRODUCTO.MODELO%TYPE,
        p_precio   IN  PRODUCTO.PRECIO%TYPE,
        p_stock    IN  PRODUCTO.STOCK%TYPE,
        p_id_out   OUT PRODUCTO.ID_PRODUCTO%TYPE
    ) AS
    BEGIN
        INSERT INTO PRODUCTO (CODIGO, NOMBRE, MARCA, MODELO, PRECIO, STOCK)
        VALUES (p_codigo, p_nombre, p_marca, p_modelo, p_precio, p_stock)
        RETURNING ID_PRODUCTO INTO p_id_out;
        COMMIT;
    END SP_CREAR_PRODUCTO;

    -- ----------------------------------------------------------

    PROCEDURE SP_ACTUALIZAR_PRODUCTO(
        p_id       IN  PRODUCTO.ID_PRODUCTO%TYPE,
        p_codigo   IN  PRODUCTO.CODIGO%TYPE,
        p_nombre   IN  PRODUCTO.NOMBRE%TYPE,
        p_marca    IN  PRODUCTO.MARCA%TYPE,
        p_modelo   IN  PRODUCTO.MODELO%TYPE,
        p_precio   IN  PRODUCTO.PRECIO%TYPE,
        p_stock    IN  PRODUCTO.STOCK%TYPE
    ) AS
    BEGIN
        UPDATE PRODUCTO
        SET CODIGO      = p_codigo,
            NOMBRE      = p_nombre,
            MARCA       = p_marca,
            MODELO      = p_modelo,
            PRECIO      = p_precio,
            STOCK       = p_stock,
            FECHA_MODIF = SYSTIMESTAMP
        WHERE ID_PRODUCTO = p_id
          AND ESTADO = 'A';
        COMMIT;
    END SP_ACTUALIZAR_PRODUCTO;

    -- ----------------------------------------------------------

    PROCEDURE SP_ELIMINAR_LOGICO_PRODUCTO(
        p_id IN PRODUCTO.ID_PRODUCTO%TYPE
    ) AS
    BEGIN
        UPDATE PRODUCTO
        SET ESTADO      = 'I',
            FECHA_MODIF = SYSTIMESTAMP
        WHERE ID_PRODUCTO = p_id
          AND ESTADO = 'A';
        COMMIT;
    END SP_ELIMINAR_LOGICO_PRODUCTO;

    -- ----------------------------------------------------------

    PROCEDURE SP_OBTENER_PRODUCTO_ID(
        p_id     IN  PRODUCTO.ID_PRODUCTO%TYPE,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_PRODUCTO, CODIGO, NOMBRE, MARCA, MODELO,
                   PRECIO, STOCK, ESTADO, FECHA_CREACION, FECHA_MODIF
            FROM   PRODUCTO
            WHERE  ID_PRODUCTO = p_id
              AND  ESTADO = 'A';
    END SP_OBTENER_PRODUCTO_ID;

    -- ----------------------------------------------------------

    PROCEDURE SP_LISTAR_PRODUCTOS(
        p_marca  IN  VARCHAR2,
        p_modelo IN  VARCHAR2,
        p_offset IN  NUMBER,
        p_size   IN  NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_PRODUCTO, CODIGO, NOMBRE, MARCA, MODELO,
                   PRECIO, STOCK, ESTADO, FECHA_CREACION, FECHA_MODIF
            FROM   PRODUCTO
            WHERE  ESTADO = 'A'
              AND  (p_marca  IS NULL OR MARCA  LIKE '%' || p_marca  || '%')
              AND  (p_modelo IS NULL OR MODELO LIKE '%' || p_modelo || '%')
            ORDER BY ID_PRODUCTO
            OFFSET p_offset ROWS FETCH NEXT p_size ROWS ONLY;
    END SP_LISTAR_PRODUCTOS;

END PKG_PRODUCTO;
/
