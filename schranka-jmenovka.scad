
$fa = 1;
$fs = 0.4;

nit = 0.001;
width = 68;
height = 17;
thick = 1.8;
text_thick = 0.6;

linear_extrude(height = thick, scale=[(width - 2*thick)/width, 1]) {
    square([width, height], center=true);
}

color("black")
translate([0,0,thick])
    linear_extrude(height = text_thick)
        text("BABKOVI", halign="center", valign="center", font="Nimbus Sans");