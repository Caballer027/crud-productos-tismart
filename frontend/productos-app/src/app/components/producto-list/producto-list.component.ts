import { Component, OnInit, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ProductoService } from '../../services/producto.service';
import { Producto } from '../../models/producto.model';

@Component({
  selector: 'app-producto-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './producto-list.component.html',
  styleUrl: './producto-list.component.css'
})
export class ProductoListComponent implements OnInit {
  private readonly service = inject(ProductoService);

  productos: Producto[] = [];
  totalPages    = 0;
  totalElements = 0;
  currentPage   = 0;
  readonly pageSize = 10;

  filtroMarca  = '';
  filtroModelo = '';
  cargando     = false;
  errorMsg     = '';

  ngOnInit(): void { this.cargar(); }

  cargar(): void {
    this.cargando = true;
    this.errorMsg = '';
    this.service.listar(this.filtroMarca, this.filtroModelo, this.currentPage, this.pageSize)
      .subscribe({
        next: page => {
          this.productos     = page.content;
          this.totalPages    = page.totalPages;
          this.totalElements = page.totalElements;
          this.currentPage   = page.number;
          this.cargando      = false;
        },
        error: () => {
          this.errorMsg = 'Error al cargar los productos.';
          this.cargando = false;
        }
      });
  }

  buscar(): void {
    this.currentPage = 0;
    this.cargar();
  }

  limpiar(): void {
    this.filtroMarca  = '';
    this.filtroModelo = '';
    this.currentPage  = 0;
    this.cargar();
  }

  anterior(): void {
    if (this.currentPage > 0) { this.currentPage--; this.cargar(); }
  }

  siguiente(): void {
    if (this.currentPage < this.totalPages - 1) { this.currentPage++; this.cargar(); }
  }

  eliminar(id: number, nombre: string): void {
    if (confirm(`¿Desea eliminar el producto "${nombre}"?\nEsta acción es irreversible.`)) {
      this.service.eliminar(id).subscribe({
        next: () => this.cargar(),
        error: () => { this.errorMsg = 'Error al eliminar el producto.'; }
      });
    }
  }
}
