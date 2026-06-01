import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ProductoService } from '../../services/producto.service';
import { Producto } from '../../models/producto.model';

@Component({
  selector: 'app-producto-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './producto-detail.component.html',
  styleUrl: './producto-detail.component.css'
})
export class ProductoDetailComponent implements OnInit {
  private readonly service = inject(ProductoService);
  private readonly route   = inject(ActivatedRoute);
  private readonly router  = inject(Router);

  producto?: Producto;

  ngOnInit(): void {
    const id = +(this.route.snapshot.paramMap.get('id') ?? 0);
    this.service.obtener(id).subscribe({
      next:  p  => this.producto = p,
      error: () => this.router.navigate(['/'])
    });
  }
}
