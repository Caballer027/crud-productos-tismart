import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Producto, PageResponse } from '../models/producto.model';

@Injectable({ providedIn: 'root' })
export class ProductoService {
  private readonly http    = inject(HttpClient);
  private readonly baseUrl = '/api/productos';

  listar(marca: string, modelo: string, page: number, size: number): Observable<PageResponse<Producto>> {
    let params = new HttpParams()
      .set('page', String(page))
      .set('size', String(size));
    if (marca)  params = params.set('marca',  marca);
    if (modelo) params = params.set('modelo', modelo);
    return this.http.get<PageResponse<Producto>>(this.baseUrl, { params });
  }

  obtener(id: number): Observable<Producto> {
    return this.http.get<Producto>(`${this.baseUrl}/${id}`);
  }

  crear(data: Partial<Producto>): Observable<Producto> {
    return this.http.post<Producto>(this.baseUrl, data);
  }

  actualizar(id: number, data: Partial<Producto>): Observable<Producto> {
    return this.http.put<Producto>(`${this.baseUrl}/${id}`, data);
  }

  eliminar(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
