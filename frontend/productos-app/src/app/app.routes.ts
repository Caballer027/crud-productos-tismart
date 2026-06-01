import { Routes } from '@angular/router';
import { ProductoListComponent } from './components/producto-list/producto-list.component';
import { ProductoFormComponent } from './components/producto-form/producto-form.component';
import { ProductoDetailComponent } from './components/producto-detail/producto-detail.component';

export const routes: Routes = [
  { path: '',            component: ProductoListComponent },
  { path: 'nuevo',       component: ProductoFormComponent },
  { path: 'editar/:id',  component: ProductoFormComponent },
  { path: 'detalle/:id', component: ProductoDetailComponent },
  { path: '**',          redirectTo: '' }
];
