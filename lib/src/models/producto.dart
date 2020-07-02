class Producto {
    Producto({
        this.id,
        this.cant,
        this.nombreProducto,
        this.precioC,
        this.precioV,
    });

    int id;
    int cant;
    String nombreProducto;
    double precioC;
    double precioV;

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        cant: json["cant"],
        nombreProducto: json["nombreProducto"],
        precioC: json["precioC"].toDouble(),
        precioV: json["precioV"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cant": cant,
        "nombreProducto": nombreProducto,
        "precioC": precioC,
        "precioV": precioV,
    };
}
