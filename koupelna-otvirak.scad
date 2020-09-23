$fa = 1;
$fs = 0.4;

nit = 0.001;

prumer_cudl = 19;
drazka = 1.5;
// vybouleni od 0.3 do 1.7
vyb_dr = 1.4;
zapusteni = 2;

h = 30;

// polomer vybouleni
vyb_r = (pow(prumer_cudl/2, 2) - pow(vyb_dr, 2)) / (2*vyb_dr) + vyb_dr + 0.3;

echo(vyb_r);

difference() {
    cylinder(d=30, h=h - vyb_dr + 1.9 + zapusteni, $fn = 6);
    cylinder(d=prumer_cudl, h=h - vyb_dr + 1.9 + nit + zapusteni);
}

difference() {
cylinder(d=prumer_cudl, h=h);
translate([0, 0, h + vyb_r - vyb_dr])
    sphere(vyb_r);
}
translate([-prumer_cudl/2, -drazka/2, h - vyb_dr])
cube([prumer_cudl, drazka, 1.9]);

