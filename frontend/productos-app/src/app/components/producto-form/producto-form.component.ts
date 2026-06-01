import { Component, OnInit, inject } from '@angular/core';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ProductoService } from '../../services/producto.service';

@Component({
  selector: 'app-producto-form',
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule],
  templateUrl: './producto-form.component.html',
  styleUrl: './producto-form.component.css'
})
export class ProductoFormComponent implements OnInit {
  private readonly fb      = inject(FormBuilder);
  private readonly service = inject(ProductoService);
  private readonly route   = inject(ActivatedRoute);
  private readonly router  = inject(Router);

  form!: FormGroup;
  editando = false;
  id?: number;
  errorMsg = '';
  enviando = false;

  ngOnInit(): void {
    this.form = this.fb.group({
      codigo: ['', [Validators.required, Validators.maxLength(20)]],
      nombre: ['', [Validators.required, Validators.maxLength(120)]],
      marca:  ['', [Validators.required, Validators.maxLength(60)]],
      modelo: ['', [Validators.required, Validators.maxLength(60)]],
      precio: [null, [Validators.required, Validators.min(0)]],
      stock:  [null, [Validators.required, Validators.min(0)]]
    });

    const paramId = this.route.snapshot.paramMap.get('id');
    if (paramId) {
      this.editando = true;
      this.id = +paramId;
      this.service.obtener(this.id).subscribe({
        next:  p  => this.form.patchValue(p),
        error: () => this.router.navigate(['/'])
      });
    }
  }

  get f() { return this.form.controls; }

  guardar(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.enviando = true;
    this.errorMsg = '';
    const data = this.form.value;
    const op   = this.editando
      ? this.service.actualizar(this.id!, data)
      : this.service.crear(data);

    op.subscribe({
      next:  () => this.router.navigate(['/']),
      error: err => {
        this.enviando = false;
        this.errorMsg = err?.error?.message ?? 'Error al guardar el producto.';
      }
    });
  }

  cancelar(): void { this.router.navigate(['/']); }
}
