set serveroutput on;

create table categoria(
idCategoria int not null,
nombre varchar(30) not null,
constraint pk_categoria primary key (idCategoria)
);
create table cargo(
idCargo int not null,
nombre varchar(30) not null,
salarioBase int not null,
constraint pk_cargo primary key (idCargo)
);
create table producto(
idProducto int not null,
nombre varchar(30) not null,
descripcion varchar(100),
idCategoria int not null,
precioUnitario int not null,
constraint pk_producto primary key (idProducto),
constraint fk_producto_categoria foreign key (idCategoria) references categoria(idCategoria)
);
create table inventario(
idInventario int not null,
idProducto int not null,
fechaCompra date not null,
fechaVencimiento date,
cantidad int not null,
constraint pk_inventario primary Key (idInventario, idProducto, fechaCompra),
constraint fk_inventario_producto foreign key (idProducto) references producto(idProducto)
);
create table empleado(
idEmpleado int not null,
nombre varchar(20) not null,
apellido1 varchar(15) not null,
apellido2 varchar(15) not null,
cedula int not null,
telefono varchar(10) not null,
direccion varchar(40) not null,
idCargo int not null,
idJefe int,
constraint pk_empleado primary key (idEmpleado),
constraint fk_empleado_cargo foreign key (idCargo) references cargo(idCargo),
constraint fk_empleado_jefe foreign key (idJefe) references empleado(idEmpleado)
);
create table proveedor(
idProveedor int not null,
idCategoria int not null,
nombre varchar(20) not null,
nit int not null,
telefono varchar(10),
direccion varchar(40),
email varchar(35),
constraint pk_proveedor primary key (idProveedor),
constraint fk_proveedor_categoria foreign key (idCategoria) references categoria(idCategoria)
);
create table pedido(
idPedido int not null,
idProveedor int not null,
fechaCompra date not null,
fechaEntrega date not null,
cantidadProductosPedidos int not null,
cantidadProductosCambio int,
estado varchar(8) not null,
descripcionEstado varchar(35),
total int not null,
constraint chk_estado check (estado in ('Recibido', 'Devuelto')),
constraint pk_pedido primary key (idPedido),
constraint fk_pedido_proveedor foreign key (idProveedor) references proveedor(idProveedor)
);
create table detallePedido(
idDetallePedido int not null,
idPedido int not null,
idProducto int not null,
cantidad int not null,
precioUnitario int not null,
total int not null,
fechaVencimiento date,
constraint pk_detallePedido primary key (idDetallePedido),
constraint fk_detallePedido_pedido foreign key (idPedido) references Pedido(idPedido),
constraint fk_detallePedido_producto foreign key (idProducto) references Producto(idProducto)
);
create table detalleCambio(
idDetalleCambio int not null,
idPedido int not null,
idProducto int not null,
cantidad int not null,
fechaVencimiento date,
constraint pk_detalleCambio primary key (idDetalleCambio),
constraint fk_detalleCambio_pedido foreign key (idPedido) references Pedido(idPedido),
constraint fk_detalleCambio_producto foreign key (idProducto) references Producto(idProducto)
);
create table cliente(
idCliente int not null,
nombre varchar(15),
apellido1 varchar(15),
apellido2 varchar(15),
cedula int,
constraint pk_cliente primary key (idCliente)
);
create table nivelSuscripcion(
idNivelSuscripcion int not null,
nombre varchar(15) not null,
descripcion varchar(45) not null,
constraint pk_nivelSuscripcion primary key (idNivelSuscripcion)
);
create table suscripcion(
idSuscripcion int not null,
idCliente int not null,
idNivelSuscripcion int not null,
fechaIncinio date not null,
fechaFin date,
credito int,
estado varchar(8) not null,
constraint chk_estadoS check (estado in ('Activa', 'Inactiva')),
constraint pk_suscripcion primary key (idSuscripcion),
constraint fk_suscripcion_cliente foreign key (idCliente) references cliente(idCliente),
constraint fk_suscripcion_nivelS foreign key (idNivelSuscripcion) references nivelSuscripcion(idNivelSuscripcion)
);
create table asociado(
idAsociado int not null,
idSuscripcion int not null,
nombre varchar(15),
apellido1 varchar(15),
apellido2 varchar(15),
cedula int,
vinculoCliente varchar(15),
constraint pk_asociado primary key (idAsociado),
constraint fk_asociado_suscripcion foreign key (idSuscripcion) references suscripcion(idSuscripcion)
);
create table fiado(
idFiado int not null,
idSuscripcion int not null,
cedulaFiador int not null,
idEmpleado int not null,
fechaFiado date not null,
estadoFiado varchar(5) not null,
total int not null,
constraint chk_estadoFiado check (estadoFiado in ('Fiado', 'Pago')),
constraint pk_fiado primary key (idFiado),
constraint fk_asociado_nivelSuscripcion foreign key (idSuscripcion) references suscripcion(idSuscripcion),
constraint fk_asociado_empleado foreign key (idEmpleado) references empleado(idEmpleado)
);
create table detalleFiado(
idDetalleFiado int not null,
idFiado int not null,
idProducto int not null,
cantidad int not null,
total int not null,
constraint pk_detalleFiado primary key (idDetalleFiado),
constraint fk_detalleFiado_fiado foreign key (idFiado) references fiado(idFiado),
constraint fk_detalleFiado_producto foreign key (idProducto) references Producto(idProducto)
);
create table perdida(
idPerdida int not null,
idProducto int not null,
cantidad int not null,
motivoPerdida varchar(30) not null,
total int not null,
constraint pk_perdida primary key (idPerdida),
constraint fk_perdida_producto foreign key (idProducto) references Producto(idProducto)
);
create table venta(
idVenta int not null,
idCliente int not null,
idEmpleado int not null,
fechaVenta date not null,
tipoPago varchar(13) not null,
tipoVenta varchar(9) not null,
total int not null,
constraint chk_tipoPago check (tipoPago in ('Fisico','Transferencia')),
constraint chk_tipoVenta check (tipoVenta in ('Local','Domicilio')),
constraint pk_venta primary key (idVenta),
constraint fk_venta_cliente foreign key (idCliente) references cliente(idCliente),
constraint fk_venta_empleado foreign key (idEmpleado) references empleado(idEmpleado)
);
create table domicilio(
idDomicilio int not null,
idVenta int not null,
direccion varchar(60),
constraint pk_domicilio primary key (idDomicilio),
constraint fk_domicilio_venta foreign key (idVenta) references venta(idVenta)
);
create table detalleVenta(
idDetalleVenta int not null,
idVenta int not null,
idProducto int not null,
cantidad int not null,
total int not null,
constraint pk_detalleVenta primary key (idDetalleVenta),
constraint fk_detalleVenta_venta foreign key (idVenta) references venta(idVenta),
constraint fk_detalleVenta_producto foreign key (idProducto) references producto(idProducto)
);
create table devolucion(
idDevolucion int not null,
idVenta int not null,
idEmpleado int not null,
fechaDevolucion date not null,
cantidadProductosDevueltos int not null,
total int not null,
constraint pk_devolucion primary key (idDevolucion),
constraint fk_devolucion_venta foreign key (idVenta) references venta(idVenta),
constraint fk_devolucion_empleado foreign key (idEmpleado) references empleado(idEmpleado)
);
create table detalleDevolucion(
idDetalleDevolucion int not null,
idDevolucion int not null,
idProducto int not null,
cantidad int not null,
motivoDevolucion varchar(30),
total int not null,
constraint pk_detalleD primary key (idDetalleDevolucion),
constraint fk_detalleDD foreign key (idDevolucion) references devolucion(idDevolucion),
constraint fk_detalleDP foreign key (idProducto) references producto(idProducto)
);
create table horarioLaboral(
idHorarioLaboral int not null,
horaInicio timestamp not null,
horaFin timestamp not null,
dias varchar(60) not null,
turno varchar(10) not null,
horaDescanso timestamp not null,
constraint chk_turno check (turno in ('Mañana', 'Tarde', 'Noche')),
constraint pk_horarioLaboral primary key (idHorarioLaboral)
);
create table asignacion(
idAsignacion int not null,
idHorarioLaboral int not null,
idEmpleado int not null,
constraint pk_asignacion primary key (idAsignacion, idHorarioLaboral, idEmpleado),
constraint fk_asignacion_horarioLaboral foreign key (idHorarioLaboral) references horarioLaboral(idHorarioLaboral),
constraint fk_asignacion_empleado foreign key (idEmpleado) references empleado(idEmpleado)
);

create sequence seq_asignacion start with 1 increment by 1 nocache nocycle;
create sequence seq_asociado start with 1 increment by 1 nocache nocycle;
create sequence seq_cargo start with 1 increment by 1 nocache nocycle;
create sequence seq_categoria start with 1 increment by 1 nocache nocycle;
create sequence seq_cliente start with 1 increment by 1 nocache nocycle;
create sequence seq_detallecambio start with 1 increment by 1 nocache nocycle;
create sequence seq_DETALLEDEVOLUCION start with 1 increment by 1 nocache nocycle;
create sequence seq_DETALLEFIADO start with 1 increment by 1 nocache nocycle;
create sequence seq_DETALLEPEDIDO start with 1 increment by 1 nocache nocycle;
create sequence seq_DETALLEVENTA start with 1 increment by 1 nocache nocycle;
create sequence seq_DEVOLUCION start with 1 increment by 1 nocache nocycle;
CREATE SEQUENCE seq_DOMICILIO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_EMPLEADO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_FIADO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_HORARIOLABORAL START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_INVENTARIO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_NIVELSUSCRIPCION START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_PEDIDO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_PERDIDA START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_PRODUCTO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_PROVEEDOR START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_SUSCRIPCION START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_VENTA START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


create table controlCambioSalario(
    id int,
    idCargo int,
    salarioAntiguo int,
    salarioNuevo int,
    usuario varchar(25),
    fechaModificacion date,
    constraint pk_CntrlCS primary key (id),
    constraint fk_CntrlCS_C foreign key (idCargo) references cargo(idCargo)
);
create sequence seq_CntrlCS start with 1 increment by 1 nocache nocycle;
create or replace trigger trgControlCambioSalario
after update on cargo
for each row
begin
    if :old.salarioBase != :new.salarioBase then
        insert into controlCambioSalario values (seq_CntrlCS.nextval, :old.idcargo, :old.salarioBase, :new.salarioBase,  user, sysdate);
    end if;
end;

create or replace trigger trgActualizarPedido
after insert on detallePedido
for each row
declare
    ttl int;
    cant int;
begin
    select total into ttl from pedido where idPedido = :new.idPedido;
    select cantidadProductosPedidos into cant from pedido where idPedido = :new.idPedido;
    update pedido set total = (ttl + :new.total) where idPedido = :new.idPedido;
    update pedido set cantidadProductosPedidos = (cant + :new.cantidad) where idPedido = :new.idPedido;
end;

create or replace trigger trgActualizarPedidoCambios
after insert on detalleCambio
for each row
declare
    cant int;
begin
    select cantidadProductosCambio into cant from pedido where idPedido = :new.idPedido;
    update pedido set cantidadProductosCambio = (cant + :new.cantidad) where idPedido = :new.idPedido;
end;

create or replace trigger trgCrearNuevoLote
after insert on detallePedido
for each row
declare
    fechaCom date;
begin
    select fechaCompra into fechaCom from pedido where idPedido = :new.idPedido;
    insert into inventario values (seq_inventario.nextval, :new.idProducto, fechaCom, :new.fechaVencimiento,:new.cantidad);
end;

create or replace trigger trgActualizarNuevoPrecio
after insert on detallePedido
for each row
declare
    precioVie int;
begin
    select precioUnitario into precioVie from producto where idProducto = :new.idProducto;
    if precioVie != :new.precioUnitario then
        update producto set precioUnitario = :new.precioUnitario where idProducto = :new.idProducto;
    end if;
end;

create or replace trigger trgActualizarFiado
after insert on detalleFiado
for each row
declare
    ttl int;
begin
    select total into ttl from fiado where idFiado = :new.idFiado;
    update fiado set total = ttl + :new.total where idFiado = :new.idFiado;
end;

create or replace trigger trgTotalDetalleFiado
before insert on detalleFiado
for each row
declare
    precio int;
begin
    select precioUnitario into precio from producto where idProducto = :new.idProducto;
    :new.total := :new.cantidad*precio;
end;

create or replace trigger trgValorPerdida
before insert on perdida
for each row
declare
    precio int;
begin
    select precioUnitario into precio from producto where idProducto = :new.idProducto;
    :new.total := :new.cantidad * precio;
end;

create or replace trigger trgValorDetalleVenta
before insert on detalleventa
for each row
declare
    precio int;
begin
    select precioUnitario into precio from producto where idProducto = :new.idProducto;
    :new.total := :new.cantidad*precio;
end;

create or replace trigger trgActualizarVenta
after insert on detalleVenta
for each row
declare
    ttl int;
begin
    select total into ttl from venta where idVenta = :new.idVenta;
    update venta set total = ttl + :new.total where idVenta = :new.idVenta;
end;

create or replace trigger trgValorDetalleDevolucion
before insert on detalleDevolucion
for each row
declare
    precio int;
begin
    select precioUnitario into precio from producto where idProducto = :new.idProducto;
    :new.total := :new.cantidad*precio;
end;

create or replace trigger trgactualizarDevolucion
after insert on detalleDevolucion
for each row
declare
    ttl int;
    cant int;
begin
    select total into ttl from devolucion where idDevolucion = :new.idDevolucion;
    select cantidadProductosDevueltos into cant from devolucion where idDevolucion = :new.idDevolucion;
    update devolucion set total = (ttl + :new.total) where idDevolucion = :new.idDevolucion;
    update devolucion set cantidadProductosDevueltos = (cant + :new.cantidad) where idDevolucion = :new.idDevolucion;
end;

/*--- Procedimiento ---*/
create or replace procedure proEliminarInventariosNulos as
begin
    delete from inventario where cantidad=0;
end proEliminarInventariosNulos;

create or replace procedure proActualizarPrecioProducto 
(idpro in int, precioNue in int) as
begin
    Update producto set precioUnitario = precioNue where idProducto = idpro;
end proActualizarPrecioProducto;

create or replace procedure proConsultarTotalVentasPorCliente
(idCli in int)as
begin
    for i in (select sum(total)as totalVentas from venta where idCliente = idCli) loop
        dbms_output.put_line("Total Ventas: " || r.totalVentas);
    end loop;
end proConsultarTtalVentasPorCliente;

/*--- registro de datos ---*/
insert into categoria values (seq_categoria.nextval, 'lácteos');
insert into categoria values (seq_categoria.nextval,'frutas');
insert into categoria values (seq_categoria.nextval,'verduras');
insert into categoria values (seq_categoria.nextval,'higiene personal');
insert into categoria values (seq_categoria.nextval,'carnes y aves');
insert into categoria values (seq_categoria.nextval,'pescados y mariscos');
insert into categoria values (seq_categoria.nextval,'panadería y repostería');
insert into categoria values (seq_categoria.nextval,'bebidas');
insert into categoria values (seq_categoria.nextval,'productos congelados');
insert into categoria values (seq_categoria.nextval,'snacks y golosinas');
insert into categoria values (seq_categoria.nextval,'alimentos enlatados');
insert into categoria values (seq_categoria.nextval,'productos de limpieza');
insert into categoria values (seq_categoria.nextval,'productos para mascotas');
insert into categoria values (seq_categoria.nextval,'productos farmacéuticos');

INSERT INTO cargo VALUES (seq_cargo.nextval, 'gerente de tienda', 2800000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'jefe de departamento', 2100000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'jefe de recursos humanos', 2100000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'jefe de mantenimiento', 2100000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'jefe de seguridad', 2100000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'técnico de mantenimiento', 2000000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'encargado de almacén', 1800000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'supervisor de seguridad', 1750000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'asistente de recursos humanos', 1750000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'cajero', 1500000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'asistente de ventas', 1350000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'guardia de seguridad', 1350000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'reponedor', 1350000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'limpiador', 1200000);
INSERT INTO cargo VALUES (seq_cargo.nextval, 'repartidor', 1200000);

INSERT INTO producto VALUES (seq_producto.nextval, 'Leche', 'Leche descremada en envase de 1 litro', 1, 3500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Manzana', 'Manzanas frescas por unidad', 2, 1500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Lechuga', 'Lechuga fresca por unidad', 3, 2000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Jabón', 'Jabón líquido para manos, 500ml', 4, 5000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Pollo', 'Pechuga de pollo fresca por kilogramo', 5, 12000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Salmón', 'Filete de salmón fresco por kilogramo', 6, 25000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Pan blanco', 'Pan blanco fresco por unidad', 7, 2000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Agua mineral', 'Agua mineral natural en botella de 500ml', 8, 1500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Helado de vainilla', 'Helado de vainilla en envase de 1 litro', 9, 8000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Papas fritas', 'Bolsa de papas fritas, 200g', 10, 3500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Atún en lata', 'Lata de atún en agua, 200g', 11, 4500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Detergente', 'Detergente líquido para ropa, 1 litro', 12, 7500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Comida para gatos', 'Alimento balanceado para gatos, 1kg', 13, 10000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Analgésico', 'Analgésico en tableta, caja de 20 unidades', 14, 12000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Queso Parmesano', 'Queso parmesano rallado, 250g', 1, 10500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Plátano', 'Plátano maduro por unidad', 2, 1200);
INSERT INTO producto VALUES (seq_producto.nextval, 'Zanahoria', 'Zanahoria fresca por kilogramo', 3, 2500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Shampoo', 'Shampoo para cabello normal, 400ml', 4, 9000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Carne Molida', 'Carne molida fresca por kilogramo', 5, 15000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Camarones', 'Camarones frescos por kilogramo', 6, 35000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Pan Integral', 'Pan integral por unidad', 7, 3000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Refresco de Cola', 'Refresco de cola en botella de 2 litros', 8, 3500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Helado de Chocolate', 'Helado de chocolate en envase de 1 litro', 9, 8500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Galletas Saladas', 'Paquete de galletas saladas, 200g', 10, 2800);
INSERT INTO producto VALUES (seq_producto.nextval, 'Sardinas en lata', 'Lata de sardinas en aceite, 120g', 11, 4200);
INSERT INTO producto VALUES (seq_producto.nextval, 'Detergente para Ropa Blanca', 'Detergente para ropa blanca, 1 litro', 12, 8500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Comida para Perros', 'Alimento balanceado para perros, 3kg', 13, 22000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Antibiótico', 'Antibiótico en cápsula, caja de 10 unidades', 14, 18000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Yogur Natural', 'Yogur natural en envase de 500g', 1, 4000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Naranja', 'Naranjas frescas por kilogramo', 2, 1800);
INSERT INTO producto VALUES (seq_producto.nextval, 'Papa', 'Papas frescas por kilogramo', 3, 1500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Jabón Corporal', 'Jabón corporal hidratante, 250ml', 4, 6500);
INSERT INTO producto VALUES (seq_producto.nextval, 'Chuleta de Cerdo', 'Chuleta de cerdo fresca por kilogramo', 5, 16000);
INSERT INTO producto VALUES (seq_producto.nextval, 'Trucha', 'Filete de trucha fresca por kilogramo', 6, 28000);
insert into producto values (seq_producto.nextval, 'Pan Integral con Semillas', 'Pan integral con semillas por unidad', 7, 3500);
insert into producto values (seq_producto.nextval, 'Agua Saborizada', 'Agua saborizada en botella de 500ml', 8, 2000);
insert into producto values (seq_producto.nextval, 'Helado de Fresa', 'Helado de fresa en envase de 1 litro', 9, 8000);
insert into producto values (seq_producto.nextval, 'Palomitas de Maíz', 'Bolsa de palomitas de maíz, 100g', 10, 2500);
insert into producto values (seq_producto.nextval, 'Sopa de Tomate en Lata', 'Lata de sopa de tomate, 400g', 11, 4800);
insert into producto values (seq_producto.nextval, 'Limpiador Multiusos', 'Limpiador multiusos, 500ml', 12, 7800);
insert into producto values (seq_producto.nextval, 'Juguete para Gatos', 'Juguete para gatos con catnip', 13, 6500);
insert into producto values (seq_producto.nextval, 'Analgésico Antiinflamatorio', 'Analgésico antiinflamatorio en tabletas, caja de 30 unidades', 14, 22000);

INSERT INTO inventario VALUES (seq_inventario.nextval, 1, TO_DATE('2024-01-10', 'YYYY-MM-DD'), TO_DATE('2024-02-10', 'YYYY-MM-DD'), 10);
INSERT INTO inventario VALUES (seq_inventario.nextval, 1, TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), 150);
INSERT INTO inventario VALUES (seq_inventario.nextval, 1, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'), 8);
INSERT INTO inventario VALUES (seq_inventario.nextval, 2, TO_DATE('2024-01-12', 'YYYY-MM-DD'), TO_DATE('2024-01-28', 'YYYY-MM-DD'), 150);
INSERT INTO inventario VALUES (seq_inventario.nextval, 2, TO_DATE('2024-02-05', 'YYYY-MM-DD'), TO_DATE('2024-02-20', 'YYYY-MM-DD'), 120);
INSERT INTO inventario VALUES (seq_inventario.nextval, 3, TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2024-01-30', 'YYYY-MM-DD'), 8);
INSERT INTO inventario VALUES (seq_inventario.nextval, 3, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-02-25', 'YYYY-MM-DD'), 100);
INSERT INTO inventario VALUES (seq_inventario.nextval, 4, TO_DATE('2024-01-18', 'YYYY-MM-DD'), TO_DATE('2024-02-18', 'YYYY-MM-DD'), 20);
INSERT INTO inventario VALUES (seq_inventario.nextval, 4, TO_DATE('2024-02-05', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'), 150);
INSERT INTO inventario VALUES (seq_inventario.nextval, 5, TO_DATE('2024-01-20', 'YYYY-MM-DD'), TO_DATE('2024-02-20', 'YYYY-MM-DD'), 12);
INSERT INTO inventario VALUES (seq_inventario.nextval, 5, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 90);
INSERT INTO inventario VALUES (seq_inventario.nextval, 6, TO_DATE('2024-01-25', 'YYYY-MM-DD'), TO_DATE('2024-02-25', 'YYYY-MM-DD'), 10);
INSERT INTO inventario VALUES (seq_inventario.nextval, 6, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 80);
INSERT INTO inventario VALUES (seq_inventario.nextval, 7, TO_DATE('2024-01-28', 'YYYY-MM-DD'), TO_DATE('2024-02-28', 'YYYY-MM-DD'), 1);
INSERT INTO inventario VALUES (seq_inventario.nextval, 7, TO_DATE('2024-02-12', 'YYYY-MM-DD'), TO_DATE('2024-03-12', 'YYYY-MM-DD'), 90);
INSERT INTO inventario VALUES (seq_inventario.nextval, 8, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'), 1);
INSERT INTO inventario VALUES (seq_inventario.nextval, 8, TO_DATE('2024-02-18', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'), 100);
INSERT INTO inventario VALUES (seq_inventario.nextval, 9, TO_DATE('2024-02-05', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'), 7);
INSERT INTO inventario VALUES (seq_inventario.nextval, 9, TO_DATE('2024-02-22', 'YYYY-MM-DD'), TO_DATE('2024-03-22', 'YYYY-MM-DD'), 110);
INSERT INTO inventario VALUES (seq_inventario.nextval, 10, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 12);
INSERT INTO inventario VALUES (seq_inventario.nextval, 10, TO_DATE('2024-02-28', 'YYYY-MM-DD'), TO_DATE('2024-03-28', 'YYYY-MM-DD'), 80);
INSERT INTO inventario VALUES (seq_inventario.nextval, 11, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 9);
INSERT INTO inventario VALUES (seq_inventario.nextval, 11, TO_DATE('2024-03-05', 'YYYY-MM-DD'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 110);
INSERT INTO inventario VALUES (seq_inventario.nextval, 12, TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 14);
INSERT INTO inventario VALUES (seq_inventario.nextval, 12, TO_DATE('2024-03-08', 'YYYY-MM-DD'), TO_DATE('2024-04-08', 'YYYY-MM-DD'), 100);
INSERT INTO inventario VALUES (seq_inventario.nextval, 13, TO_DATE('2024-02-25', 'YYYY-MM-DD'), TO_DATE('2024-03-25', 'YYYY-MM-DD'), 8);
INSERT INTO inventario VALUES (seq_inventario.nextval, 13, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'), 120);
INSERT INTO inventario VALUES (seq_inventario.nextval, 14, TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2025-03-22', 'YYYY-MM-DD'), 39);
INSERT INTO inventario VALUES (seq_inventario.nextval, 15, TO_DATE('2024-01-13', 'YYYY-MM-DD'), TO_DATE('2025-03-04', 'YYYY-MM-DD'), 152);
INSERT INTO inventario VALUES (seq_inventario.nextval, 16, TO_DATE('2024-01-04', 'YYYY-MM-DD'), TO_DATE('2024-07-07', 'YYYY-MM-DD'), 528);
INSERT INTO inventario VALUES (seq_inventario.nextval, 17, TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-09-03', 'YYYY-MM-DD'), 81);
INSERT INTO inventario VALUES (seq_inventario.nextval, 18, TO_DATE('2024-01-07', 'YYYY-MM-DD'), TO_DATE('2024-04-10', 'YYYY-MM-DD'), 270);
INSERT INTO inventario VALUES (seq_inventario.nextval, 19, TO_DATE('2024-04-22', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), 61);
INSERT INTO inventario VALUES (seq_inventario.nextval, 20, TO_DATE('2024-02-03', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'), 15);
INSERT INTO inventario VALUES (seq_inventario.nextval, 21, TO_DATE('2024-01-09', 'YYYY-MM-DD'), TO_DATE('2024-02-23', 'YYYY-MM-DD'), 380);
INSERT INTO inventario VALUES (seq_inventario.nextval, 22, TO_DATE('2024-01-02', 'YYYY-MM-DD'), TO_DATE('2024-03-19', 'YYYY-MM-DD'), 15);
INSERT INTO inventario VALUES (seq_inventario.nextval, 22, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 50);
INSERT INTO inventario VALUES (seq_inventario.nextval, 22, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 120);
INSERT INTO inventario VALUES (seq_inventario.nextval, 23, TO_DATE('2024-02-18', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'), 80);
INSERT INTO inventario VALUES (seq_inventario.nextval, 24, TO_DATE('2024-02-22', 'YYYY-MM-DD'), TO_DATE('2024-03-22', 'YYYY-MM-DD'), 7);
INSERT INTO inventario VALUES (seq_inventario.nextval, 24, TO_DATE('2024-02-25', 'YYYY-MM-DD'), TO_DATE('2024-03-25', 'YYYY-MM-DD'), 80);
INSERT INTO inventario VALUES (seq_inventario.nextval, 25, TO_DATE('2024-02-28', 'YYYY-MM-DD'), TO_DATE('2024-03-28', 'YYYY-MM-DD'), 10);
INSERT INTO inventario VALUES (seq_inventario.nextval, 25, TO_DATE('2024-03-05', 'YYYY-MM-DD'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 120);
INSERT INTO inventario VALUES (seq_inventario.nextval, 26, TO_DATE('2024-01-10', 'YYYY-MM-DD'), TO_DATE('2024-02-10', 'YYYY-MM-DD'), 10);
INSERT INTO inventario VALUES (seq_inventario.nextval, 26, TO_DATE('2024-01-25', 'YYYY-MM-DD'), TO_DATE('2024-02-25', 'YYYY-MM-DD'), 80);
INSERT INTO inventario VALUES (seq_inventario.nextval, 27, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 2);
insert into inventario values (seq_inventario.nextval, 27, TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 30);
insert into inventario values (seq_inventario.nextval, 27, TO_DATE('2024-02-25', 'YYYY-MM-DD'), TO_DATE('2024-03-25', 'YYYY-MM-DD'), 120);
insert into inventario values (seq_inventario.nextval, 28, TO_DATE('2024-02-12', 'YYYY-MM-DD'), TO_DATE('2024-03-12', 'YYYY-MM-DD'), 9);
insert into inventario values (seq_inventario.nextval, 28, TO_DATE('2024-02-18', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'), 24);
insert into inventario values (seq_inventario.nextval, 28, TO_DATE('2024-02-25', 'YYYY-MM-DD'), TO_DATE('2024-03-25', 'YYYY-MM-DD'), 80);
insert into inventario values (seq_inventario.nextval, 29, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'), 150);
insert into inventario values (seq_inventario.nextval, 30, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 12);
insert into inventario values (seq_inventario.nextval, 30, TO_DATE('2024-02-28', 'YYYY-MM-DD'), TO_DATE('2024-03-28', 'YYYY-MM-DD'), 80);
insert into inventario values (seq_inventario.nextval, 31, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 9);
insert into inventario values (seq_inventario.nextval, 31, TO_DATE('2024-03-05', 'YYYY-MM-DD'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 110);
insert into inventario values (seq_inventario.nextval, 32, TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 14);
insert into inventario values (seq_inventario.nextval, 32, TO_DATE('2024-03-08', 'YYYY-MM-DD'), TO_DATE('2024-04-08', 'YYYY-MM-DD'), 100);
insert into inventario values (seq_inventario.nextval, 33, TO_DATE('2024-02-25', 'YYYY-MM-DD'), TO_DATE('2024-03-25', 'YYYY-MM-DD'), 8);
insert into inventario values (seq_inventario.nextval, 33, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'), 120);
insert into inventario values (seq_inventario.nextval, 34, TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2025-03-22', 'YYYY-MM-DD'), 39);
insert into inventario values (seq_inventario.nextval, 35, TO_DATE('2024-01-13', 'YYYY-MM-DD'), TO_DATE('2025-03-04', 'YYYY-MM-DD'), 150);
insert into inventario values (seq_inventario.nextval, 36, TO_DATE('2024-01-04', 'YYYY-MM-DD'), TO_DATE('2024-07-07', 'YYYY-MM-DD'), 520);
insert into inventario values (seq_inventario.nextval, 37, TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-09-03', 'YYYY-MM-DD'), 81);
insert into inventario values (seq_inventario.nextval, 38, TO_DATE('2024-01-07', 'YYYY-MM-DD'), TO_DATE('2024-04-10', 'YYYY-MM-DD'), 270);
insert into inventario values (seq_inventario.nextval, 39, TO_DATE('2024-04-22', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), 61);
insert into inventario values (seq_inventario.nextval, 40, TO_DATE('2024-02-03', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'), 15);
insert into inventario values (seq_inventario.nextval, 41, TO_DATE('2024-01-09', 'YYYY-MM-DD'), TO_DATE('2024-02-23', 'YYYY-MM-DD'), 380);
insert into inventario values (seq_inventario.nextval, 42, TO_DATE('2024-01-02', 'YYYY-MM-DD'), TO_DATE('2024-03-19', 'YYYY-MM-DD'), 15);
insert into inventario values (seq_inventario.nextval, 42, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 50);
insert into inventario values (seq_inventario.nextval, 42, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 120);

insert into empleado values (seq_empleado.nextval, 'Jhony', 'Duque', 'Ciro', '950504946', '3268490309', 'Nelson Mandela', 1, null);
insert into empleado values (seq_empleado.nextval, 'Jillie', 'Charon', 'Clemintoni', '852604393', '3245266378', '1 Hansons Street', 2, 1);
insert into empleado values (seq_empleado.nextval, 'Farlay', 'Lage', 'Damsell', '14547686', '3798852799', '85 Green Ridge Center', 3, 1);
insert into empleado values (seq_empleado.nextval, 'Gay', 'Bertson', 'McKeevers', '205190729', '3253839235', '26 East Place', 4, 1);
insert into empleado values (seq_empleado.nextval, 'Lucho', 'Sewell', 'Crudgington', '450973658', '3738733632', '30795 Maple Wood Center', 5, 1);
insert into empleado values (seq_empleado.nextval, 'Carolynn', 'Hasker', 'Wadly', '78554267', '3309157860', '75015 Cascade Drive', 6, 4);
insert into empleado values (seq_empleado.nextval, 'Klemens', 'MacTrustey', 'Grigorio', '084921367', '3889038450', '6498 Prairie Rose Lane', 6, 4);
insert into empleado values (seq_empleado.nextval, 'Chet', 'Worswick', 'Robion', '354834952', '3139354280', '8 Oakridge Terrace', 7, 2);
insert into empleado values (seq_empleado.nextval, 'Welbie', 'Gunstone', 'Wilcinskis', '797498755', '3792068890', '092 Granby Drive', 7, 2);
insert into empleado values (seq_empleado.nextval, 'Zaria', 'Houndesome', 'Gaydon', '431553186', '3636367751', '6633 8th Place', 8, 5);
insert into empleado values (seq_empleado.nextval, 'Thedrick', 'Serotsky', 'Carradice', '895784893', '3093588047', '429 Gulseth Junction', 8, 5);
insert into empleado values (seq_empleado.nextval, 'Annamarie', 'Puzey', 'Miell', '036148944', '3615316240', '125 West Road', 9, 3);
insert into empleado values (seq_empleado.nextval, 'Erhard', 'Penwarden', 'Ocheltree', '608272456', '3618040358', '078 Eagan Trail', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Baldwin', 'Dewitt', 'Aubery', '850724871', '3299747580', '5334 Sommers Street', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Rubin', 'Radenhurst', 'Starkings', '035666219', '3679715430', '11 Mcbride Court', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Miranda', 'Keith', 'Eliaz', '350265145', '3522238700', '8528 Lakewood Court', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Alyssa', 'Flaunier', 'Bantham', '112457228', '3923239100', '6551 Center Junction', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Maurizio', 'Francioli', 'Plewright', '287955914', '3069600123', '5846 Miller Way', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Berke', 'Jacomb', 'Style', '062174891', '3352500084', '83917 Kensington Place', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Averil', 'Sunner', 'Stratford', '900565361', '3346688367', '2 Corry Park', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Hillard', 'Banbrick', 'Amor', '275978880', '3340822928', '9 Bobwhite Court', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Fraze', 'Powdrill', 'Rigmond', '983499702', '3880288960', '7 Grim Place', 10, 2);
insert into empleado values (seq_empleado.nextval, 'Page', 'Lindblom', 'Beaton', '310622748', '3638167324', '126 Ronald Regan Park', 11, 2);
insert into empleado values (seq_empleado.nextval, 'Stevena', 'Finch', 'Blincoe', '953983493', '3943455134', '61 Lake View Street', 11, 2);
insert into empleado values (seq_empleado.nextval, 'Demetris', 'Erswell', 'Pickance', '656830441', '3655166392', '54 Lotheville Trail', 11, 2);
insert into empleado values (seq_empleado.nextval, 'Wolf', 'Kite', 'Ruggen', '934013670', '3791488829', '283 Fremont Road', 11, 2);
insert into empleado values (seq_empleado.nextval, 'Irita', 'Hanner', 'Deane', '257160134', '3745899185', '92975 2nd Terrace', 11, 2);
insert into empleado values (seq_empleado.nextval, 'Ceciley', 'Jedras', 'Haslewood', '050651597', '3608978160', '918 Columbus Drive', 12, 5);
insert into empleado values (seq_empleado.nextval, 'Darryl', 'Gillingwater', 'O''Lunny', '086381557', '3899333599', '7 Westport Junction', 12, 5);
insert into empleado values (seq_empleado.nextval, 'Malina', 'Garling', 'Crampton', '116663674', '3052922681', '8 Petterle Way', 12, 5);
insert into empleado values (seq_empleado.nextval, 'Teodoor', 'Verrills', 'Queree', '333766068', '3878077551', '7 Union Place', 12, 5);
insert into empleado values (seq_empleado.nextval, 'Mora', 'Tie', 'Jandel', '501455912', '3553388227', '910 Talisman Place', 12, 5);
insert into empleado values (seq_empleado.nextval, 'Jozef', 'Kindle', 'Foxcroft', '361473523', '3702415833', '27 Stoughton Drive', 13, 2);
insert into empleado values (seq_empleado.nextval, 'Orsola', 'McGourty', 'Reichert', '045993312', '3562100317', '45 Dexter Hill', 13, 2);
insert into empleado values (seq_empleado.nextval, 'Sioux', 'Driscoll', 'Warnes', '562832022', '3739413830', '1117 Lindbergh Plaza', 13, 2);
insert into empleado values (seq_empleado.nextval, 'Sherwynd', 'Davers', 'Kleinhaus', '757933433', '3539266976', '6354 1st Center', 13, 2);
insert into empleado values (seq_empleado.nextval, 'Audra', 'Twitty', 'Grimoldby', '389303835', '3889855009', '61 Oxford Court', 13, 2);
insert into empleado values (seq_empleado.nextval, 'Arlana', 'Dacca', 'Ferreri', '543841278', '3431397258', '33 Bowman Road', 14, 2);
insert into empleado values (seq_empleado.nextval, 'Laird', 'Forsbey', 'Edwicker', '946057430', '3490655246', '94 Packers Way', 14, 2);
insert into empleado values (seq_empleado.nextval, 'Leila', 'Hindrich', 'Baynton', '673601492', '3748424354', '781 Milwaukee Trail', 14, 2);
insert into empleado values (seq_empleado.nextval, 'Gabbie', 'Stow', 'Naisbitt', '786823253', '3921105957', '2 Bartillon Alley', 15, 2);

INSERT INTO proveedor VALUES (seq_proveedor.nextval, 1, 'Proveedor A', 123456789, '1234567890', 'Calle 123', 'proveedora@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 2, 'Proveedor B', 234567890, '2345678901', 'Avenida 456', 'proveedorb@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 3, 'Proveedor C', 345678901, '3456789012', 'Carrera 789', 'proveedorc@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 4, 'Proveedor D', 456789012, '4567890123', 'Calle 456', 'proveedord@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 5, 'Proveedor E', 567890123, '5678901234', 'Avenida 789', 'proveedore@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 6, 'Proveedor F', 678901234, '6789012345', 'Carrera 012', 'proveedorf@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 7, 'Proveedor G', 789012345, '7890123456', 'Calle 789', 'proveedorg@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 8, 'Proveedor H', 890123456, '8901234567', 'Avenida 012', 'proveedorh@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 9, 'Proveedor I', 901234567, '9012345678', 'Carrera 345', 'proveedori@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 10, 'Proveedor J', 123456789, '1234567890', 'Calle 678', 'proveedorj@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 11, 'Proveedor K', 234567890, '2345678901', 'Avenida 345', 'proveedork@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 12, 'Proveedor L', 345678901, '3456789012', 'Carrera 678', 'proveedorl@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 13, 'Proveedor M', 456789012, '4567890123', 'Calle 901', 'proveedorm@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 14, 'Proveedor N', 567890123, '5678901234', 'Avenida 678', 'proveedorn@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 1, 'Proveedor O', 678901234, '6789012345', 'Carrera 123', 'proveedoro@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 2, 'Proveedor P', 789012345, '7890123456', 'Calle 012', 'proveedorp@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 3, 'Proveedor Q', 890123456, '8901234567', 'Avenida 789', 'proveedorq@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 4, 'Proveedor R', 901234567, '9012345678', 'Carrera 234', 'proveedorr@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 5, 'Proveedor S', 123456789, '1234567890', 'Calle 345', 'proveedors@example.com');
INSERT INTO proveedor VALUES (seq_proveedor.nextval, 12, 'Proveedor T', 34536801, '3456789012', 'Carrera 678', 'proveedort@example.com');

INSERT INTO pedido VALUES (seq_pedido.nextval, 1, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-03-19', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 2, TO_DATE('2024-01-04', 'YYYY-MM-DD'), TO_DATE('2024-05-03', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Productos en excelente estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 3, TO_DATE('2024-02-18', 'YYYY-MM-DD'), TO_DATE('2024-04-18', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 4, TO_DATE('2024-03-20', 'YYYY-MM-DD'), TO_DATE('2024-04-08', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 5, TO_DATE('2024-02-14', 'YYYY-MM-DD'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 6, TO_DATE('2024-04-12', 'YYYY-MM-DD'), TO_DATE('2024-04-18', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 7, TO_DATE('2024-01-12', 'YYYY-MM-DD'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 8, TO_DATE('2024-01-12', 'YYYY-MM-DD'), TO_DATE('2024-03-07', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 9, TO_DATE('2024-01-04', 'YYYY-MM-DD'), TO_DATE('2024-03-21', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 10, TO_DATE('2024-04-05', 'YYYY-MM-DD'), TO_DATE('2024-04-16', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 11, TO_DATE('2024-04-03', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 12, TO_DATE('2024-04-26', 'YYYY-MM-DD'), TO_DATE('2024-04-24', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 13, TO_DATE('2024-01-10', 'YYYY-MM-DD'), TO_DATE('2024-03-09', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 14, TO_DATE('2024-02-23', 'YYYY-MM-DD'), TO_DATE('2024-04-29', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 15, TO_DATE('2024-04-20', 'YYYY-MM-DD'), TO_DATE('2024-04-19', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 16, TO_DATE('2024-03-30', 'YYYY-MM-DD'), TO_DATE('2024-03-22', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 17, TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-03-16', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 18, TO_DATE('2024-01-28', 'YYYY-MM-DD'), TO_DATE('2024-04-26', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 19, TO_DATE('2024-04-22', 'YYYY-MM-DD'), TO_DATE('2024-05-02', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 20, TO_DATE('2024-01-19', 'YYYY-MM-DD'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 11, TO_DATE('2024-01-09', 'YYYY-MM-DD'), TO_DATE('2024-04-24', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 12, TO_DATE('2024-03-19', 'YYYY-MM-DD'), TO_DATE('2024-04-27', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 13, TO_DATE('2024-04-22', 'YYYY-MM-DD'), TO_DATE('2024-04-13', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 14, TO_DATE('2024-01-23', 'YYYY-MM-DD'), TO_DATE('2024-04-30', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 15, TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-03-04', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 16, TO_DATE('2024-01-23', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 17, TO_DATE('2024-01-14', 'YYYY-MM-DD'), TO_DATE('2024-03-12', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 18, TO_DATE('2024-01-30', 'YYYY-MM-DD'), TO_DATE('2024-03-02', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 19, TO_DATE('2024-01-08', 'YYYY-MM-DD'), TO_DATE('2024-04-26', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 20, TO_DATE('2024-03-27', 'YYYY-MM-DD'), TO_DATE('2024-03-11', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 01, TO_DATE('2024-01-11', 'YYYY-MM-DD'), TO_DATE('2024-04-09', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 02, TO_DATE('2024-03-27', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 03, TO_DATE('2024-02-11', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 04, TO_DATE('2024-01-11', 'YYYY-MM-DD'), TO_DATE('2024-03-28', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 05, TO_DATE('2024-01-02', 'YYYY-MM-DD'), TO_DATE('2024-03-08', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 06, TO_DATE('2024-01-19', 'YYYY-MM-DD'), TO_DATE('2024-03-17', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 07, TO_DATE('2024-01-13', 'YYYY-MM-DD'), TO_DATE('2024-04-13', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 08, TO_DATE('2024-03-13', 'YYYY-MM-DD'), TO_DATE('2024-04-10', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 09, TO_DATE('2024-03-07', 'YYYY-MM-DD'), TO_DATE('2024-04-27', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 10, TO_DATE('2024-04-27', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 11, TO_DATE('2024-04-23', 'YYYY-MM-DD'), TO_DATE('2024-03-30', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 12, TO_DATE('2024-02-17', 'YYYY-MM-DD'), TO_DATE('2024-05-02', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 13, TO_DATE('2024-02-23', 'YYYY-MM-DD'), TO_DATE('2024-04-19', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 14, TO_DATE('2024-03-06', 'YYYY-MM-DD'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 15, TO_DATE('2024-02-11', 'YYYY-MM-DD'), TO_DATE('2024-04-24', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 16, TO_DATE('2024-04-02', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 17, TO_DATE('2024-02-28', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 18, TO_DATE('2024-04-17', 'YYYY-MM-DD'), TO_DATE('2024-04-12', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 19, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-04-21', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Todo en orden', 0);
INSERT INTO pedido VALUES (seq_pedido.nextval, 20, TO_DATE('2024-02-13', 'YYYY-MM-DD'), TO_DATE('2024-03-30', 'YYYY-MM-DD'), 0, 0, 'Recibido', 'Pedidos en buen estado', 0);

INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 1, 1, 67, 7988, 67 * 7988, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 2, 12, 63, 7435, 63 * 7435, TO_DATE('2024-04-28', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 3, 23, 43, 5702, 43 * 5702, TO_DATE('2024-04-17', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 4, 8, 22, 6399, 22 * 6399, TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 5, 32, 40, 4439, 40 * 4439, TO_DATE('2024-04-16', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 6, 14, 157, 7933, 157 * 7933, TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 7, 37, 83, 5036, 83 * 5036, TO_DATE('2024-04-28', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 8, 4, 147, 856, 147 * 856, TO_DATE('2024-05-03', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 9, 18, 62, 7700, 62 * 7700, TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 10, 3, 154, 3642, 154 * 3642, TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 11, 9, 81, 1664, 81 * 1664, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 12, 30, 5, 3341, 5 * 3341, TO_DATE('2024-04-21', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 13, 10, 33, 2409, 33 * 2409, TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 14, 35, 62, 7717, 62 * 7717, TO_DATE('2024-04-20', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 15, 25, 28, 5717, 28 * 5717, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 16, 21, 80, 3062, 80 * 3062, TO_DATE('2024-04-15', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 17, 15, 163, 700, 163 * 700, TO_DATE('2024-04-22', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 18, 39, 105, 877, 105 * 877, TO_DATE('2024-04-30', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 19, 28, 163, 6493, 163 * 6493, TO_DATE('2024-04-06', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 20, 24, 160, 1981, 160 * 1981, TO_DATE('2024-04-29', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 21, 19, 106, 2480, 106 * 2480, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 22, 2, 153, 6478, 153 * 6478, TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 23, 34, 161, 2773, 161 * 2773, TO_DATE('2024-04-15', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 24, 36, 102, 7528, 102 * 7528, TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 25, 11, 122, 1751, 122 * 1751, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 26, 17, 93, 5731, 93 * 5731, TO_DATE('2024-04-27', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 27, 26, 11, 4568, 11 * 4568, TO_DATE('2024-04-29', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 28, 22, 92, 2611, 92 * 2611, TO_DATE('2024-04-19', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 29, 33, 57, 2404, 57 * 2404, TO_DATE('2024-04-07', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 30, 40, 81, 5513, 81 * 5513, TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 31, 20, 121, 7881, 121 * 7881, TO_DATE('2024-04-23', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 32, 38, 47, 6923, 47 * 6923, TO_DATE('2024-04-27', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 33, 5, 132, 1277, 132 * 1277, TO_DATE('2024-04-21', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 34, 6, 172, 5105, 172 * 5105, TO_DATE('2024-04-11', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 35, 16, 128, 7550, 128 * 7550, TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 36, 13, 81, 7727, 81 * 7727, TO_DATE('2024-04-30', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 37, 27, 45, 7982, 45 * 7982, TO_DATE('2024-04-07', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 38, 31, 144, 4849, 144 * 4849, TO_DATE('2024-04-21', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 39, 7, 71, 5615, 71 * 5615, TO_DATE('2024-04-18', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 40, 29, 30, 2378, 30 * 2378, TO_DATE('2024-04-23', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 41, 12, 63, 7435, 63 * 7435, TO_DATE('2024-04-28', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 42, 8, 22, 6399, 22 * 6399, TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 43, 1, 67, 7988, 67 * 7988, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 44, 3, 154, 3642, 154 * 3642, TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 45, 18, 62, 7700, 62 * 7700, TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 46, 32, 40, 4439, 40 * 4439, TO_DATE('2024-04-16', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 47, 4, 147, 856, 147 * 856, TO_DATE('2024-05-03', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 48, 23, 43, 5702, 43 * 5702, TO_DATE('2024-04-17', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 49, 14, 157, 7933, 157 * 7933, TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO detallePedido VALUES (seq_detallePedido.nextval, 50, 37, 83, 5036, 83 * 5036, TO_DATE('2024-04-28', 'YYYY-MM-DD'));

INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 23, 14, 67, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 47, 21, 153, TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 10, 32, 154, TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 31, 2, 147, TO_DATE('2024-05-03', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 1, 9, 132, TO_DATE('2024-04-21', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 14, 27, 172, TO_DATE('2024-04-11', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 35, 37, 71, TO_DATE('2024-04-18', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 45, 42, 22, TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 42, 17, 81, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 6, 5, 33, TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 17, 25, 122, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 40, 30, 63, TO_DATE('2024-04-28', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 19, 41, 81, TO_DATE('2024-04-30', 'YYYY-MM-DD'));
INSERT INTO detalleCambio VALUES (seq_detalleCambio.nextval, 18, 18, 157, TO_DATE('2024-04-10', 'YYYY-MM-DD'));

INSERT INTO cliente VALUES (seq_cliente.nextval, 'Brody', 'Gilliatt', 'Cawdery', 668701292);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Moina', 'Henderson', 'Mazzei', 847724045);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Johannah', 'Winscum', 'Feathers', 214526802);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Gill', 'Bigglestone', 'Horsburgh', 912792646);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Alon', 'Samsin', 'Banghe', 975418432);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Annie', 'Boulsher', 'Jorger', 123540390);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Hayes', 'Rappoport', 'Vasyatkin', 157313628);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Chucho', 'Blaszczak', 'Suffe', 317381157);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Filippa', 'Shipton', 'Arkley', 623080677);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Cynde', 'Mattersey', 'Gartell', 924219606);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Louis', 'Beveredge', 'Fforde', 125422321);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Rand', 'Boog', 'McComish', 93927100);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Starlin', 'Amorts', 'Darker', 873064115);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Rinaldo', 'Jessard', 'Stodart', 677143189);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Ber', 'Biskupiak', 'Dimblebee', 31658271);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Katey', 'Bottom', 'Scatchar', 121733945);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Elsy', 'Allewell', 'Mansbridge', 40882693);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Brittney', 'Brownill', 'Essery', 533447820);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Whitaker', 'Giraudou', 'Storton', 266339185);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Chevalier', 'Caton', 'Bates', 961728749);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Stephanus', 'Mainson', 'Larrad', 191676290);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Darnall', 'Causier', 'Westcarr', 18142622);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Atlante', 'Fairchild', 'Kemshell', 903140541);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Merrily', 'Blagdon', 'Lydford', 274543912);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Stafford', 'Bainbridge', 'Addess', 965036709);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Adham', 'Grelka', 'MacNeely', 504720610);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Lance', 'Ponde', 'Bristow', 841535363);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Alair', 'Whitton', 'Daniel', 290258870);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Brent', 'Erwin', 'Algie', 48841863);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Dolley', 'Grombridge', 'Hoggins', 697691296);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Irena', 'Medlin', 'Crawcour', 492070453);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Fredrick', 'Volk', 'Tolhurst', 580408460);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Bryanty', 'Argabrite', 'Gerholz', 653266203);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Maressa', 'Magor', 'Nys', 75886495);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Bert', 'Olyff', 'Karchowski', 200138514);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Tabby', 'Minards', 'Knyvett', 657279639);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Jarred', 'Minghella', 'Lempertz', 997929807);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Arvin', 'August', 'Clewlow', 526485023);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Dennis', 'Franek', 'McKelloch', 360473752);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Abba', 'Wolpert', 'Garlicke', 627992403);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Brooke', 'Mc Carroll', 'Sidsaff', 530104231);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Ailis', 'Swadlin', 'Cumberbatch', 608491515);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Stormy', 'Bernardin', 'Lunbech', 190404021);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Caddric', 'Tersay', 'Landor', 882647593);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Angelique', 'Benoi', 'Skeel', 627441794);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Veronique', 'Flament', 'Perrins', 895554089);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Eolanda', 'More', 'Jerger', 858234358);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Agace', 'Dollar', 'Sill', 874582245);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Gannie', 'Renak', 'Mosco', 902133432);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Sherilyn', 'Bradick', 'Duffin', 603981095);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Vinnie', 'Caplin', 'Alf', 445359213);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Gilburt', 'Bockin', 'O''Kinedy', 439672550);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Lorin', 'Foottit', 'Barrasse', 165910277);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Lyle', 'Crallan', 'Halworth', 913892965);
INSERT INTO cliente VALUES (seq_cliente.nextval, 'Winona', 'Duferie', 'Kleeborn', 97390445);

INSERT INTO nivelSuscripcion VALUES (seq_nivelSuscripcion.nextval, 'Nivel 1', 'Estacionamiento exclusivo');
INSERT INTO nivelSuscripcion VALUES (seq_nivelSuscripcion.nextval, 'Nivel 2', 'Nivel 1 + caja prioritaria');
INSERT INTO nivelSuscripcion VALUES (seq_nivelSuscripcion.nextval, 'Nivel 3', 'Nivel 2 + 500k Credito para fiados');

INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 1, 1, to_date('2023-01-01','YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 2, 2, TO_DATE('2023-02-15', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 3, 3, TO_DATE('2023-03-10', 'YYYY-MM-DD'), NULL, 500000, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 54, 1, TO_DATE('2023-04-05', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 55, 2, TO_DATE('2023-05-20', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 6, 3, TO_DATE('2023-06-12', 'YYYY-MM-DD'), NULL, 500000, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 46, 1, TO_DATE('2023-07-03', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 8, 2, TO_DATE('2023-08-18', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 9, 3, TO_DATE('2023-09-25', 'YYYY-MM-DD'), NULL, 500000, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 30, 1, TO_DATE('2023-10-14', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 11, 1, TO_DATE('2023-11-10', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 22, 2, TO_DATE('2023-12-05', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 13, 3, TO_DATE('2023-01-01', 'YYYY-MM-DD'), NULL, 500000, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 4, 1, TO_DATE('2023-02-15', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 15, 2, TO_DATE('2023-03-25', 'YYYY-MM-DD'), NULL, NULL, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 49, 3, TO_DATE('2023-04-30', 'YYYY-MM-DD'), NULL, 500000, 'Activa');
INSERT INTO suscripcion VALUES (seq_suscripcion.nextval, 17, 1, TO_DATE('2023-05-12', 'YYYY-MM-DD'), NULL, NULL, 'Activa');

INSERT INTO asociado VALUES (seq_asociado.nextval, 3, 'Blanche', 'Wildt', 'Tompkins', 886108501, 'esposa');
INSERT INTO asociado VALUES (seq_asociado.nextval, 3, 'Denyse', 'Curthoys', 'Scantleberry', 779634090, 'hermana');
INSERT INTO asociado VALUES (seq_asociado.nextval, 3, 'Armand', 'Woodvine', 'Pounds', 36606405, 'madre');
INSERT INTO asociado VALUES (seq_asociado.nextval, 3, 'Nicola', 'Mohammad', 'Pettican', 158281257, 'hijo');
INSERT INTO asociado VALUES (seq_asociado.nextval, 6, 'Reginald', 'Blezard', 'Keywood', 475217276, 'esposo');
INSERT INTO asociado VALUES (seq_asociado.nextval, 6, 'Marice', 'Bonafant', 'Bascombe', 601285148, 'hermano');
INSERT INTO asociado VALUES (seq_asociado.nextval, 6, 'Wallache', 'Bernardeau', 'Jedrzaszkiewicz', 721653767, 'hija');
INSERT INTO asociado VALUES (seq_asociado.nextval, 9, 'Northrop', 'Leverson', 'Anthill', 424629386, 'hermano');
INSERT INTO asociado VALUES (seq_asociado.nextval, 9, 'Briny', 'Gelly', 'Bucham', 302230155, 'padre');
INSERT INTO asociado VALUES (seq_asociado.nextval, 13, 'Ginger', 'Dearden', 'Brownstein', 043513911, 'esposa');
INSERT INTO asociado VALUES (seq_asociado.nextval, 13, 'Nathanil', 'MacGown', 'Yurchenko', 636536529, 'hijo');
INSERT INTO asociado VALUES (seq_asociado.nextval, 16, 'Eliza', 'MacEveley', 'Shyres', 332951072, 'madre');
INSERT INTO asociado VALUES (seq_asociado.nextval, 16, 'Valli', 'Folini', 'Ciric', 169881787, 'hermana');

INSERT INTO fiado VALUES (seq_fiado.nextval, 3, 886108501, 15, TO_DATE('2024-03-11', 'YYYY-MM-DD'), 'Fiado', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 3, 779634090, 22, TO_DATE('2024-03-17', 'YYYY-MM-DD'), 'Pago', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 3, 779634090, 13, TO_DATE('2024-03-26', 'YYYY-MM-DD'), 'Fiado', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 6, 475217276, 14, TO_DATE('2024-03-16', 'YYYY-MM-DD'), 'Pago', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 6, 475217276, 15, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Fiado', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 6, 721653767, 16, TO_DATE('2024-03-28', 'YYYY-MM-DD'), 'Pago', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 16, 169881787, 20, TO_DATE('2024-03-18', 'YYYY-MM-DD'), 'Fiado', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 16, 169881787, 18, TO_DATE('2024-03-08', 'YYYY-MM-DD'), 'Pago', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 13, 636536529, 13, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Fiado', 0);
INSERT INTO fiado VALUES (seq_fiado.nextval, 9, 302230155, 16, TO_DATE('2024-03-28', 'YYYY-MM-DD'), 'Pago', 0);

INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 10, 5, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 23, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 35, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 40, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 2, 15, 10, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 2, 20, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 3, 37, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 4, 1, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 4, 27, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 4, 39, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 5, 13, 5, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 5, 20, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 5, 30, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 6, 16, 7, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 6, 29, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 6, 11, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 7, 7, 9, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 7, 26, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 7, 12, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 8, 18, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 8, 11, 5, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 8, 33, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 9, 19, 6, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 9, 21, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 9, 31, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 10, 17, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 10, 23, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 10, 35, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 10, 5, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 23, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 35, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 1, 40, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 2, 15, 10, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 2, 20, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 2, 37, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 4, 1, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 4, 27, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 4, 39, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 5, 13, 5, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 5, 20, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 5, 30, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 6, 16, 7, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 6, 29, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 6, 11, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 7, 7, 9, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 7, 26, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 7, 12, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 8, 18, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 8, 11, 5, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 8, 33, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 9, 19, 6, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 9, 21, 4, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 9, 31, 1, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 10, 17, 3, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 10, 23, 2, 0);
INSERT INTO detalleFiado VALUES (seq_detalleFiado.nextval, 10, 35, 1, 0);

INSERT INTO perdida VALUES (seq_perdida.nextval, 1, 70, 'Lamentamos la perdida', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 5, 51, 'Error en almacen', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 9, 35, 'Fuga de producto', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 13, 72, 'Perdida leve', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 17, 64, 'Nada encontrado', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 21, 116, 'Mala manipulacion', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 2, 50, 'Fuga de producto', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 6, 9, 'Perdida leve', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 10, 26, 'Nada encontrado', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 14, 167, 'Mala manipulacion', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 18, 100, 'Robo detectado', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 22, 68, 'Lamentamos la perdida', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 3, 74, 'Vencimiento', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 7, 2, 'Mala manipulacion', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 11, 65, 'Robo detectado', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 15, 58, 'Vencimiento', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 19, 153, 'Error en almacen', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 23, 52, 'Fuga de producto', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 4, 82, 'Robo detectado',0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 8, 129, 'Vencimiento', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 12, 38, 'Error en almacen', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 16, 15, 'Fuga de producto', 0);
INSERT INTO perdida VALUES (seq_perdida.nextval, 20, 26, 'Perdida leve', 0);

INSERT INTO venta VALUES (seq_venta.NEXTVAL, 1, 13, TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 2, 14, TO_DATE('2024-04-07', 'YYYY-MM-DD'), 'Transferencia', 'Domicilio', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 3, 15, TO_DATE('2024-04-08', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 4, 16, TO_DATE('2024-04-09', 'YYYY-MM-DD'), 'Transferencia', 'Domicilio', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 5, 17, TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Transferencia', 'Domicilio', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 6, 18, TO_DATE('2024-04-11', 'YYYY-MM-DD'), 'Fisico', 'Domicilio', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 7, 19, TO_DATE('2024-04-12', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 8, 20, TO_DATE('2024-04-13', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 9, 21, TO_DATE('2024-04-14', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 10, 22, TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Fisico', 'Domicilio', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 11, 13, TO_DATE('2024-04-16', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 12, 14, TO_DATE('2024-04-17', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 13, 15, TO_DATE('2024-04-18', 'YYYY-MM-DD'), 'Fisico', 'Domicilio', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 14, 16, TO_DATE('2024-04-19', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 15, 17, TO_DATE('2024-04-20', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 16, 18, TO_DATE('2024-04-21', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 17, 19, TO_DATE('2024-04-22', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 18, 20, TO_DATE('2024-04-23', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 19, 21, TO_DATE('2024-04-24', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 20, 22, TO_DATE('2024-04-25', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 21, 13, TO_DATE('2024-04-26', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 22, 14, TO_DATE('2024-04-27', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 23, 15, TO_DATE('2024-04-28', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 24, 16, TO_DATE('2024-04-29', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 25, 17, TO_DATE('2024-04-30', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 26, 18, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 27, 19, TO_DATE('2024-05-02', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 28, 20, TO_DATE('2024-05-03', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 29, 21, TO_DATE('2024-05-04', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 30, 22, TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 31, 13, TO_DATE('2024-05-06', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 32, 14, TO_DATE('2024-05-07', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 33, 15, TO_DATE('2024-05-08', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 34, 16, TO_DATE('2024-05-09', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 35, 17, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 36, 18, TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 37, 19, TO_DATE('2024-05-12', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 38, 20, TO_DATE('2024-05-13', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 39, 21, TO_DATE('2024-05-14', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 40, 22, TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'Transferencia', 'Domicilio', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 41, 13, TO_DATE('2024-05-16', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 42, 14, TO_DATE('2024-05-17', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 43, 15, TO_DATE('2024-05-18', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 44, 16, TO_DATE('2024-05-19', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 45, 17, TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 46, 18, TO_DATE('2024-05-21', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 47, 19, TO_DATE('2024-05-22', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 48, 20, TO_DATE('2024-05-23', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 49, 21, TO_DATE('2024-07-06', 'YYYY-MM-DD'), 'Fisico', 'Local', 0);
INSERT INTO venta VALUES (seq_venta.NEXTVAL, 50, 22, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 'Transferencia', 'Local', 0);

INSERT INTO domicilio VALUES (seq_domicilio.nextval, 2, '6 Reinke Plaza');
INSERT INTO domicilio VALUES (seq_domicilio.nextval, 4, '9 Mockingbird Point');
INSERT INTO domicilio VALUES (seq_domicilio.nextval, 5, '69417 Lyons Way');
INSERT INTO domicilio VALUES (seq_domicilio.nextval, 6, '5 Linden Center');
INSERT INTO domicilio VALUES (seq_domicilio.nextval, 10, '593 Blackbird Court');
INSERT INTO domicilio VALUES (seq_domicilio.nextval, 13, '3 Riverside Terrace');
INSERT INTO domicilio VALUES (seq_domicilio.nextval, 40, '8 Norway Maple Hill');

INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 1, 1, 18, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 2, 3, 6, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 3, 5, 9, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 4, 7, 15, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 5, 9, 17, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 6, 11, 7, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 7, 13, 8, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 8, 15, 8, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 9, 17, 6, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 10, 19, 8, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 11, 21, 11, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 12, 23, 5, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 13, 25, 15, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 14, 27, 7, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 15, 29, 49, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 16, 31, 14, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 17, 33, 7, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 18, 35, 7, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 19, 37, 17, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 20, 39, 6, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 21, 41, 8, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 22, 23, 6, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 23, 42, 8, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 24, 37, 6, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 25, 33, 9, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 26, 2, 8, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 27, 4, 14, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 28, 6, 17, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 29, 8, 8, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 30, 10, 18, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 31, 12, 2, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 32, 14, 1, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 33, 16, 18, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 34, 18, 17, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 35, 20, 12, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 36, 22, 5, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 37, 24, 15, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 38, 26, 11, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 39, 28, 5, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 40, 30, 10, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 41, 32, 2, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 42, 34, 14, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 43, 36, 13, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 44, 38, 1, 1);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 45, 40, 5, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 46, 42, 10, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 47, 40, 2, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 48, 6, 15, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 49, 8, 15, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 50, 40, 14, 0);
INSERT INTO detalleVenta VALUES (seq_detalleVenta.nextval, 50, 42, 65, 0);

INSERT INTO devolucion VALUES (seq_devolucion.nextval, 1, 15, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 42, 21, TO_DATE('2024-04-29', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 23, 13, TO_DATE('2024-04-25', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 4, 22, TO_DATE('2024-04-26', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 35, 15, TO_DATE('2024-04-22', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 6, 16, TO_DATE('2024-04-24', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 27, 17, TO_DATE('2024-04-30', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 18, 18, TO_DATE('2024-04-20', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 9, 20, TO_DATE('2024-04-11', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 13, 14, TO_DATE('2024-04-04', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 15, 14, TO_DATE('2024-04-27', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 12, 19, TO_DATE('2024-04-19', 'YYYY-MM-DD'), 0, 0);
INSERT INTO devolucion VALUES (seq_devolucion.nextval, 13, 13, TO_DATE('2024-05-03', 'YYYY-MM-DD'), 0, 0);

INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 1, 3, 36, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 1, 6, 3, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 2, 24, 5, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 3, 34, 7, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 3, 24, 9, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 4, 11, 11, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 4, 13, 13, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 5, 6, 15, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 5, 40, 17, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 5, 12, 19, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 6, 15, 21, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 7, 1, 23, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 7, 5, 25, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 8, 7, 27, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 9, 9, 29, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 10, 13, 31, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 11, 34, 33, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 12, 35, 35, 'Defecto', 0);
INSERT INTO detalleDevolucion VALUES (seq_detalledevolucion.nextval, 13, 4, 37, 'Defecto', 0);

INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('08:00', 'HH24:MI'), TO_TIMESTAMP('16:00', 'HH24:MI'), 'Sábado', 'Mañana', TO_TIMESTAMP('10:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('10:00', 'HH24:MI'), TO_TIMESTAMP('18:00', 'HH24:MI'), 'Sábado', 'Tarde', TO_TIMESTAMP('14:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('14:00', 'HH24:MI'), TO_TIMESTAMP('22:00', 'HH24:MI'), 'Sábado', 'Tarde', TO_TIMESTAMP('18:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('16:00', 'HH24:MI'), TO_TIMESTAMP('00:00', 'HH24:MI'), 'Sábado', 'Noche', TO_TIMESTAMP('22:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('08:00', 'HH24:MI'), TO_TIMESTAMP('16:00', 'HH24:MI'), 'Domingo', 'Mañana', TO_TIMESTAMP('10:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('10:00', 'HH24:MI'), TO_TIMESTAMP('18:00', 'HH24:MI'), 'Domingo', 'Tarde', TO_TIMESTAMP('14:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('14:00', 'HH24:MI'), TO_TIMESTAMP('22:00', 'HH24:MI'), 'Domingo', 'Tarde', TO_TIMESTAMP('18:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('16:00', 'HH24:MI'), TO_TIMESTAMP('00:00', 'HH24:MI'), 'Domingo', 'Noche', TO_TIMESTAMP('22:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('08:00', 'HH24:MI'), TO_TIMESTAMP('16:00', 'HH24:MI'), 'Lunes a Viernes', 'Mañana', TO_TIMESTAMP('10:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('10:00', 'HH24:MI'), TO_TIMESTAMP('18:00', 'HH24:MI'), 'Lunes a Viernes', 'Tarde', TO_TIMESTAMP('14:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('14:00', 'HH24:MI'), TO_TIMESTAMP('22:00', 'HH24:MI'), 'Lunes a Viernes', 'Tarde', TO_TIMESTAMP('18:00', 'HH24:MI'));
INSERT INTO horarioLaboral VALUES (seq_horarioLaboral.nextval, TO_TIMESTAMP('16:00', 'HH24:MI'), TO_TIMESTAMP('00:00', 'HH24:MI'), 'Lunes a Viernes', 'Noche', TO_TIMESTAMP('22:00', 'HH24:MI'));


INSERT INTO asignacion VALUES (seq_asignacion.nextval, 1, 1);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 2);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 3);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 4, 4);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 5, 5);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 5);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 12, 6);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 12, 7);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 8);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 9);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 10);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 11, 11);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 1, 12);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 9, 13);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 14);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 15);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 11, 16);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 5, 17);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 18);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 12, 20);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 21);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 23);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 11, 24);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 12, 25);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 6, 26);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 7, 27);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 8, 28);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 9, 29);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 30);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 11, 31);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 12, 32);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 3, 33);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 9, 33);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 3, 33);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 7, 34);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 7, 35);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 11, 36);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 12, 37);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 11, 38);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 9, 39);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 10, 40);
INSERT INTO asignacion VALUES (seq_asignacion.nextval, 11, 41);

/* --- Consultas Simples ---*/

/*1.Mostrar los datos de las suscripciones de nivel 3*/
select idSuscripcion as "Codigo de suscripcion", idCliente as "Codigo de cliente", IDNIVELSUSCRIPCION, CREDITO, estado from suscripcion where IDNIVELSUSCRIPCION=3;

/*2.Mostrar el id y el total de los pedidos que este por arriba de 900000*/
select IDPEDIDO, total from pedido where total>900000;

/*3.Mostrar las perdidas por arriba de 300000*/
select IDPERDIDA, CANTIDAD, MOTIVOPERDIDA, total from perdida where total>500000;

/*4.Mostrar los datos de las ventas que hayan sido Domicilio*/
S
/*5.Muestre los datos de todos los asociados*/
select IDASOCIADO,IDSUSCRIPCION,NOMBRE,APELLIDO1|| ' ' ||APELLIDO2 as "Apellidos", CEDULA,VINCULOCLIENTE from ASOCIADO;



/*1.Mostrar los datos de los empleados que trabajan los domingos por la tarde*/
select a.idEmpleado as "Codigo", 
       a.nombre, 
       a.apellido1 || ' ' || a.apellido2 AS "Apellidos", 
       a.cedula, 
       a.telefono, 
       a.direccion
from empleado a 
join asignacion b on a.idEmpleado = b.idEmpleado 
join horarioLaboral c on b.idHorarioLaboral = c.idHorarioLaboral 
where c.turno = 'Tarde' and c.dias='Domingo';

/*2.Consultar productos junto con su categoría y el nombre del proveedor y que el precio unitario sea menor de 1000*/
SELECT 
    p.idProducto, 
    p.nombre AS nombreProducto, 
    c.nombre AS nombreCategoria, 
    pr.nombre AS nombreProveedor
FROM 
    producto p
JOIN 
    categoria c ON p.idCategoria = c.idCategoria
JOIN 
    proveedor pr ON c.idCategoria = pr.idCategoria
where p.PRECIOUNITARIO>15000;

/*3.Consultar las suscripciones activas de los clientes, incluyendo el nombre del cliente y el nivel de suscripción*/
SELECT 
    c.nombre AS nombreCliente,
    c.apellido1 AS apellidoCliente,
    s.idSuscripcion,
    ns.nombre AS nivelSuscripcion,
    s.fechaIncinio,
    s.fechaFin
FROM 
    suscripcion s
JOIN 
    cliente c ON s.idCliente = c.idCliente
JOIN 
    nivelSuscripcion ns ON s.idNivelSuscripcion = ns.idNivelSuscripcion
WHERE 
    s.estado = 'Activa';

/*4.Obtener las devoluciones realizadas, incluyendo la información del cliente, empleado y productos devueltos*/
SELECT 
    d.idDevolucion,
    c.nombre AS nombreCliente,
    c.apellido1 AS apellidoCliente,
    e.nombre AS nombreEmpleado,
    e.apellido1 AS apellidoEmpleado,
    dv.idProducto,
    p.nombre AS nombreProducto,
    dv.cantidad,
    dv.motivoDevolucion,
    dv.total
FROM 
    devolucion d
JOIN 
    venta v ON d.idVenta = v.idVenta
JOIN 
    cliente c ON v.idCliente = c.idCliente
JOIN 
    empleado e ON d.idEmpleado = e.idEmpleado
JOIN 
    detalleDevolucion dv ON d.idDevolucion = dv.idDevolucion
JOIN 
    producto p ON dv.idProducto = p.idProducto;

/*5.Listar las pérdidas de productos, incluyendo el nombre del producto y el motivo de la pérdida*/
SELECT 
    p.nombre AS nombreProducto, 
    per.cantidad, 
    per.motivoPerdida, 
    per.total
FROM 
    perdida per
JOIN 
    producto p ON per.idProducto = p.idProducto;

/*1.Obtener el total de ventas realizadas por cada empleado*/
SELECT 
    e.idEmpleado,
    e.nombre AS nombreEmpleado,
    e.apellido1 AS apellidoEmpleado,
    COUNT(v.idVenta) AS totalVentas,
    SUM(v.total) AS totalMontoVentas
FROM 
    empleado e
JOIN 
    venta v ON e.idEmpleado = v.idEmpleado
GROUP BY 
    e.idEmpleado, e.nombre, e.apellido1;

/*2.Obtener el total de productos vendidos por categoría*/
SELECT 
    cat.idCategoria, 
    cat.nombre AS nombreCategoria, 
    SUM(dv.cantidad) AS totalProductosVendidos
FROM 
    categoria cat
JOIN 
    producto p ON cat.idCategoria = p.idCategoria
JOIN 
    detalleVenta dv ON p.idProducto = dv.idProducto
GROUP BY 
    cat.idCategoria, cat.nombre;

/*3.Obtener el total de pedidos realizados y el monto total por proveedor*/
SELECT 
    prov.idProveedor, 
    prov.nombre AS nombreProveedor, 
    COUNT(ped.idPedido) AS totalPedidos, 
    SUM(ped.total) AS montoTotalPedidos
FROM 
    proveedor prov
JOIN 
    pedido ped ON prov.idProveedor = ped.idProveedor
GROUP BY 
    prov.idProveedor, prov.nombre;

/*4.Obtener el total de productos en inventario por categoría*/
SELECT 
    cat.idCategoria, 
    cat.nombre AS nombreCategoria, 
    SUM(inv.cantidad) AS totalProductosInventario
FROM 
    categoria cat
JOIN 
    producto p ON cat.idCategoria = p.idCategoria
JOIN 
    inventario inv ON p.idProducto = inv.idProducto
GROUP BY 
    cat.idCategoria, cat.nombre;

/*5.Obtener el total de suscripciones por nivel de suscripción*/
SELECT 
    ns.idNivelSuscripcion, 
    ns.nombre AS nombreNivel, 
    COUNT(s.idSuscripcion) AS totalSuscripciones
FROM 
    nivelSuscripcion ns
JOIN 
    suscripcion s ON ns.idNivelSuscripcion = s.idNivelSuscripcion
GROUP BY 
    ns.idNivelSuscripcion, ns.nombre;
