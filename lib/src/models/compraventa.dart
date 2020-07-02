class CompraVenta {
    CompraVenta({
        this.id,
        this.fecha,
        this.cantidad,
        this.iDproducto,
        this.compra,
    });

    int id;
    String fecha;
    int cantidad;
    int iDproducto;
    bool compra;

    factory CompraVenta.fromJson(Map<String, dynamic> json) => CompraVenta(
        id: json["id"],
        fecha: json["fecha"],
        cantidad: json["cantidad"],
        iDproducto: json["IDproducto"],
        compra: json["Compra"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "cantidad": cantidad,
        "IDproducto": iDproducto,
        "Compra": compra,
    };
}
