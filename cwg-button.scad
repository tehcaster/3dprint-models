$fa = 1;
$fs = 0.4;

nit = 0.001;

button_d = 10;
button_h = 9;

button_base_z = 3.5;
//button_base_z = 0;

button_pressed = false;

button_skirt_h = 2;

rim_width = 8;
rim_height = rim_width;
rim_gap = 0.1;
skirt_gap = 0.3;

screw_head_d = 3.5;
screw_hole_d = 2;
screw_plate_h = 1;

// button
translate([0, 0, button_h/2 + (button_pressed ? 0 : button_base_z)]) {
    color("grey")
    difference() {
        union() {
            cylinder(d = button_d, h = button_h, center = true);
            translate([0, 0, -button_h/2 + button_skirt_h / 2])
                cylinder(d1 = button_d + button_skirt_h * 2, d2 = button_d, h = button_skirt_h, center = true);
        }
        translate([0, 0, -button_h / 2 + 2.5/2 - nit])
        cube([2 + 0.2, 3 + 0.2, 3 + 0.5], center=true);
    }
    color("blue")
    translate([0, 0, button_h/2-0.6]) {
        difference() {
            resize([9,9,1])
                surface(file="cwg_trezor.png", center=true);
            difference() {
                cylinder(d = button_d + 5, h = 10, center = true);
                cylinder(d = button_d - nit, h = 10 - nit, center=true);
            }
        }
        
    }
}


// rim
rim_r_inner = button_d/2 + rim_gap;
rim_r_outer = rim_r_inner + rim_width;
rim_base_width = rim_width - button_skirt_h + skirt_gap;
translate([0, 0, rim_width/2])
difference() {
    difference() {
        // bulk of the rim
        cylinder(r1 = rim_r_outer, r2 = rim_r_inner, h = rim_height, center = true);
        // space for button cylinder (with clearance)
        cylinder(r = rim_r_inner, h = rim_height + nit, center = true);
        // space for button skirt
        translate([0, 0, -rim_height / 2 + button_base_z])
            cylinder(d1 = button_d + button_skirt_h * 2 + 2*skirt_gap, d2 = button_d, h = button_skirt_h + skirt_gap);
        // space for pressing down the button
        translate([0, 0, - rim_height / 2 + button_base_z / 2])
            cylinder(d = button_d + button_skirt_h * 2 + 2*skirt_gap, h = button_base_z + nit, center = true);
        // space for screw head and hole
        for (rot = [0, 120, 240]) {
            rotate([0,0,rot])
            translate([0, (-rim_r_outer + rim_base_width / 2), 0]) {
                cylinder(d = screw_head_d, h = (rim_width - 2*screw_plate_h), center = true);
                cylinder(d = screw_hole_d, h = rim_width+nit, center=true);
            }
        }
    }
    translate([15,0,0])
        cube([30,30,40], center=true);
    
}
