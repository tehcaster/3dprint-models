use <MCAD/boxes.scad>

$fa = 1;
$fs = 0.4;

thick = 2;
nit = 0.001;

chg_radius = 31;
// including surface below charger, for simplicity
chg_height = 11 + thick;

nex_width = 114+2;
nex_length = 200+2;
nex_height = 9;
nex_corner_radius = 5;
nex_diag = sqrt(nex_width*nex_width + nex_length*nex_length);
nex_diag_rot = atan2(nex_length/2-nex_corner_radius,
                     nex_width/2-nex_corner_radius);

ear_size = 30;

module nexus(extraxy=0, extraz=0, height=chg_height) {
    roundedBox(size = [nex_width + 2*extraxy, nex_length + 2*extraxy,height+extraz],
        radius = nex_corner_radius + extraxy, sidesonly = true);
}

module charger(extraxy=0, extraz=0) {
    cylinder(h = chg_height+extraz, r = chg_radius+extraxy,
             center = true);
}

// outer outline
difference() {
    nexus(extraxy = 2);
    nexus(extraz = nit);
    // hole for cable
    translate([0,(nex_length+thick)/2,thick+chg_height/2-5/2])
        cube([5, 5, chg_height], center=true);
    // hole to see LED
    translate([0,-nex_length/2,chg_height/2])
        rotate([90,0,0])
            cylinder(h=10, r=5, center=true);
}

// inner outline
difference() {
    charger(extraxy = 2);
    charger(extraz = nit);
    // hole for charger usb connector
    translate([0,chg_radius,thick])
        cube([15, 15, chg_height], center=true);
    // hole for LED
    color("red")
        translate([0,-chg_radius,thick/2])
            cube([5, 15, chg_height-thick-3], center=true);
}

// surface below charger
color("blue")
translate([0,0,-(chg_height-thick)/2])
    cylinder(h = thick, r = chg_radius+nit, center=true);


// diagonal support
module diag_sup(rotation) {
    rotate(a=[0,0,rotation]) 
        cube([nex_diag, thick, chg_height], center=true);
}

// supports
intersection() {
    difference() {
        union() {
            // horizontal support
            cube([nex_width+nit, thick, chg_height], center=true);
            diag_sup(nex_diag_rot);
            diag_sup(-nex_diag_rot);
        }
        charger(extraxy = nit, extraz = nit);
    }
    nexus(extraz=nit, extraxy=nit);
}

// upper corners
translate([0,0,chg_height/2+nex_height/2-nit]){
    difference() {
        nexus(extraxy = 2, height=nex_height);
        nexus(extraz = nit, height=nex_height);
        cube([nex_width - ear_size*2,
              nex_length+2*thick+nit,
              nex_height+nit], center=true);
        cube([nex_width+2*thick+nit,
              nex_length - ear_size*2,
              nex_height+nit], center=true);
    }
}




