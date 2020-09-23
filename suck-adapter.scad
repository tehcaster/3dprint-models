
$fa = 1;
$fs = 0.4;

use <MCAD/regular_shapes.scad>

nit = 0.001;

module zavit() {
difference() {
    color("blue")
    rotate([-1.8, 0, 0])
    translate([0, 0, -16/2 + 5-1.5 + 0.8])
        rotate([0,0,-25])   
            rotate_extrude(angle=50) {
                translate([42/2-nit, 0, 0])
                    polygon([[-1, 0], [0, 0], [1.5, 1.5],  [1.5, 4.5], [-1, 4.5]]);
    };
    color("red")
        translate([0, 0, -16/2 + 5+3 + 0.8] )
            cylinder(h=1, d=42+2*1.5+3,center=true);
}
}

// prumer "diagonalne"
hub_r = 20.5;
// max vzdalenost kratsi strany od stredu
hub_dx = 20;
// max vzdalenost delsi strany od stredu
hub_dy = 18;
// polovina delky (jako usecka) kratsi strany
hub_x = 11;
// polovina delky (jako usecka) delsi strany
hub_y = 17.5;
// max vzdalenost kruznice kratsi strany od usecky
hub_ddx = hub_dx - hub_y;
// analogicky
hub_ddy = hub_dy - hub_x;

//echo(sqrt(pow(hub_x,2) + pow(hub_y,2)));

// polomer kruznice kratsi strany
hub_rx = (pow(hub_x, 2) - pow(hub_ddx, 2)) / (2*hub_ddx) + hub_ddx;
// analogicky
hub_ry = (pow(hub_y, 2) - pow(hub_ddy, 2)) / (2*hub_ddy) + hub_ddy;
echo(hub_ry);

// posun stredu kruznice na ose y
hub_shiftx = hub_dx - hub_rx;
hub_shifty = hub_dy - hub_ry;

module hubice(h=10) {
intersection() {
    translate([0, hub_shiftx, 0])
        cylinder(h=h,r=hub_rx,center=true);
    translate([0, - hub_shiftx, 0])
        cylinder(h=h,r=hub_rx,center=true);
    translate([hub_shifty, 0, 0])
        cylinder(h=h,r=hub_ry,center=true);
    translate([-hub_shifty, 0, 0])
        cylinder(h=h,r=hub_ry,center=true);

}
}

// cast co se zasune do vysavace popela
translate([0, 0, 16/2 + 3 - nit]) {
difference() {
    cylinder(h = 16, d = 42, center = true);
    cylinder(h = 16+nit, d = 38, center = true);
}

zavit();
rotate([0,0,180])
    zavit();

// rantl, zevnitr nabeh z hubice
translate([0, 0, -16/2 - 3/2 + nit])
difference() {
    cylinder(d = 54, h=3, center = true);
    intersection() {
        cylinder(d1 = hub_r*2, d2=38, h=3 + nit, center = true);
        //scale([22/20, 22/20,1])
            hubice(h=3+nit);
    }
}
}

// nabeh pod rantl kvuli tisku
nabeh_h = 54/2 - (hub_r+2);
translate([0, 0, -nabeh_h/2+nit])
difference() {
    cylinder(h = nabeh_h + nit, r1 = hub_r+2-nit, r2 = 54/2, center = true);
    hubice(h = nabeh_h+2*nit);
}

n = 2000;
step = 360/n;
amp = 1;
teeth = 20;
points = [ for (t=[0:step:359.999]) [(hub_r+2+amp + amp*sin(teeth*t))*cos(t),
                                     (hub_r+2+amp + amp*sin(teeth*t))*sin(t)]];

// cast do ktery se zasune electrolux hubice
translate([0, 0, -40/2+nit]) {
difference() {
//scale([22/20, 22/20,1])
//  hubice(h=40);
    union() {
        cylinder(h = 40, r = hub_r+2, center=true);
        translate([0, 0, -40/2])
        linear_extrude(height = 40)
            polygon(points);
    }
    scale([1, 1, 1+nit])
        hubice(h=40);
}

// zapadka
color("blue")
translate([0, hub_shiftx, -4/2 + 40/2 - 18])
    rotate([0,0,90-5])
        rotate_extrude(angle=10) {
            translate([hub_rx, 0, 0])
                polygon([[0, 0], [-1, 1],  [-1, 3], [0, 4]]);
        }
 
}

