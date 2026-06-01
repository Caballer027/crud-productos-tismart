export interface Producto {
  idProducto: number;
  codigo: string;
  nombre: string;
  marca: string;
  modelo: string;
  precio: number;
  stock: number;
  estado: string;
  fechaCreacion?: string;
  fechaModif?: string;
}

export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  number: number;   // página actual (0-indexed)
  size: number;
}
