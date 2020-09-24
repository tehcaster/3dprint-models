use <MCAD/boxes.scad>

$fa = 1;
$fs = 0.4;

// sirka zadni steny/vnitrni casti krabicky
orig_sirka = 71;
// vnitrni cast bez podlahy
orig_vyska = 25;
// vnitrni cast bez predni/zadni steny
orig_delka = 92;

thick = 1.4;
slack = 0.3;
nit = 0.01;

module left_pad_square_hole(sirka, vyska, zleva, zdola) {
    translate([(-orig_sirka + sirka + slack) / 2 + zleva, 0, (-vyska_stena + vyska + slack) / 2 + zdola])  
        cube([sirka + slack, thick+nit, vyska + slack], center=true);
}

module right_pad_square_hole(sirka, vyska, zprava, zdola) {
    translate([(orig_sirka - sirka - slack) / 2 - zprava, 0, (-vyska_stena + vyska + slack) / 2 + zdola])  
        cube([sirka + slack, thick+nit, vyska + slack], center=true);
}

module right_pad_round_hole(prumer, zprava, zdola) {
    translate([(orig_sirka - prumer - slack) / 2 - zprava, 0, (-vyska_stena + prumer + slack) / 2 + zdola])
        rotate([90, 0, 0])
        cylinder(d = prumer + slack, h = thick + nit, center=true);
}

sirka = orig_sirka + 2*thick + 10;
delka = orig_delka + 4*thick + slack;
vyska = orig_vyska + 2*thick + 10;



esp_sirka = 25.5;
esp_delka = 51.8;
esp_thick = 1;
esp_prostor_vpredu = 14;
esp_prostor_vpredu_beztl = 8;
esp_prostor_vzadu = 6;
esp_hrebinek_sirka = 4;
esp_vyska_konektor = 4;
esp_hrebinek_delka = esp_delka - esp_prostor_vpredu - esp_prostor_vzadu;
esp_vyska_lcd = 4;

esp_podl_yshift = thick + 1;
esp_podl_sirka = esp_sirka + esp_podl_yshift + thick+slack;
esp_podl_delka = sirka - 2*thick - slack;

esp_total_vyska = esp_vyska_konektor + esp_thick + esp_vyska_lcd;

esp_okraj_vyska = esp_total_vyska;

// spodek plus bocni steny
cube([sirka, delka, thick]);
// leva
difference() {
    cube([thick, delka, vyska]);
    // usb c hole
    color("red")
    translate([thick/2, 2*thick + slack/2 + esp_podl_yshift + esp_sirka/2, vyska + (7+slack)/2 - esp_vyska_lcd])
    rotate([90, 0, 90])
    roundedBox(size = [9 + slack, 7 + slack, thick+nit],
       radius = 1.5, sidesonly = true);
}
// prava
translate([sirka-thick, 0, 0])
    cube([thick, delka, vyska]);


// nosice esp podlozky - levy
translate([thick-nit, esp_podl_sirka/2 + 2*thick + slack,
    vyska - esp_total_vyska - thick - 3 - slack/2])
rotate([90, 0, 0])
linear_extrude(esp_podl_sirka, center=true)
    polygon([[0, 0], [3, 3], [0, 3]]);
// pravy
translate([sirka-thick+nit, esp_podl_sirka/2 + 2*thick + slack,
    vyska - esp_total_vyska - thick - 3 - slack/2])
rotate([90, 0, 180])
linear_extrude(esp_podl_sirka, center=true)
    polygon([[0, 0], [3, 3], [0, 3]]);
// vymezovac esp podlozky na bocni stene - levy
translate([thick-nit, 2*thick + slack + slack/2 + esp_podl_sirka])
    cube([vym, thick, vyska]);
// pravy
translate([sirka - thick - vym + nit, 2*thick + slack + slack/2 + esp_podl_sirka])
    cube([vym, thick, vyska]);

// vymezovace predni/zadni steny
vym = 2;
module vymezovac(y) {
    translate([0, y, 0])
    difference() {
        cube([sirka - nit, thick, vyska]);
        translate([thick + vym, -nit, thick + vym])
        cube([sirka - 2*thick - 2*vym, thick + 2*nit, vyska]);
    }
}
vymezovac(0);
vymezovac(2*thick + slack);
vymezovac(delka -thick);
vymezovac(delka - 3*thick - slack);

d_sl = 7;
// sloupky na horni kryt
module sloupek_kryt() {
    h = vyska;
    translate([0,0,h/2])
    difference() {
        cylinder(d = d_sl, h = h, center = true);
        cylinder(d = 3, h = h + nit, center = true);
    }
}

sloupky_xy = [[d_sl/2, 2*thick+slack+esp_podl_sirka+d_sl/2 + slack/2],
              [sirka-d_sl/2, 2*thick+slack+d_sl/2 + slack/2],
              [d_sl/2, delka-(2*thick+slack+d_sl/2)],
              [sirka-d_sl/2, delka-(2*thick+slack+d_sl/2)]];

for (xy = sloupky_xy) {
    translate([xy[0], xy[1], 0])
        sloupek_kryt();
}

// sloupky na pcb
module sloupek() {
    h = 4.4;
    translate([0,0,h/2])
    difference() {
        cylinder(d = 7, h = h, center = true);
        cylinder(d = 3, h = h + nit, center = true);
    }
}

translate([sirka/2, 2*thick + 21, thick-nit])
sloupek();
translate([sirka/2 - orig_sirka/2 + 9.5, delka - 2*thick - 19, thick-nit])
sloupek();
translate([sirka/2 + orig_sirka/2 - 9.5, delka - 2*thick - 19, thick-nit])
sloupek();

sirka_stena = sirka - 2*thick - slack;
    vyska_stena = vyska - thick - slack;
// predni stena
color("green")
translate([sirka_stena/2 + thick, thick/2 + thick + slack/2, vyska_stena/2 + thick])
difference() {
    cube([sirka_stena, thick, vyska_stena], center=true);
    // dira na SFP
    left_pad_square_hole(15, 10.4, 7, 6);
    // dira na ETH
    right_pad_square_hole(16, 14, 6, 6);
    // diody
    right_pad_round_hole(3, 32.3, 12.4);
    right_pad_round_hole(3, 27.3, 12.4);
    right_pad_round_hole(3, 32.3, 7.4);
    right_pad_round_hole(3, 27.3, 7.4);
}

// zadni stena
color("green")
translate([sirka_stena/2 + thick, -(thick/2 + thick + slack/2)  + delka, vyska_stena/2 + thick])
rotate([0, 0, 180])
difference() {
    cube([sirka_stena, thick, vyska_stena], center=true);
    // dira na POWER konektor
    left_pad_square_hole(9, 11, 9, 6);
    // dira na prepinac
    right_pad_square_hole(5, 2.5, 13, 7.5);

}

color("blue")
translate([thick, 2*thick + slack/2, vyska - thick - esp_total_vyska]) {
    difference() {
        cube([esp_podl_delka, esp_podl_sirka, thick]);
        // vykus rohu na vymezovac
        translate([-nit, -nit, -nit])
            cube([vym + slack + 2*nit, thick + slack + 2*nit, thick + 2*nit]);
        translate([esp_podl_delka+nit - (d_sl-thick + slack + 2*nit), -nit, -nit])
            cube([d_sl + slack + 2*nit, d_sl + 2*slack + 2*nit, thick + 2*nit]);
        // vykusy na hrebinky
        translate([esp_prostor_vpredu, -nit, -nit])
            cube([esp_hrebinek_delka, esp_hrebinek_sirka + esp_podl_yshift, thick + 2*nit]);
        translate([esp_prostor_vpredu, esp_podl_yshift + esp_sirka - esp_hrebinek_sirka, -nit])
            cube([esp_hrebinek_delka, esp_hrebinek_sirka + thick + slack + nit, thick + 2*nit]);
    }
    // zadni podlozeni esp32 desky
    difference() {
        translate([esp_delka - esp_prostor_vzadu, 0, thick-nit])
            cube([esp_prostor_vzadu + thick, esp_podl_sirka, esp_okraj_vyska]);
        translate([0, esp_podl_yshift + slack/2, thick+esp_vyska_konektor])
            cube([esp_delka+slack, esp_sirka + slack, esp_total_vyska]);
    }
    // predni okraje kolem esp32 desky
    translate([0, esp_podl_sirka - thick, thick - nit])
        cube([esp_prostor_vpredu, thick, esp_okraj_vyska]);
    translate([vym+slack+2*nit, 0, thick - nit])
        cube([esp_prostor_vpredu_beztl - (vym+slack+2*nit), esp_podl_yshift, esp_okraj_vyska]);
    // zadni okraj pro zamacknuti vikem
    translate([esp_podl_delka - thick, 2*slack + d_sl, thick - nit])
        cube([thick, esp_podl_sirka - (2* slack) - d_sl, esp_total_vyska]);
}

// horni kryt
// usb c hole
color("grey")
difference() {
    translate([thick/2, 2*thick + slack/2 + esp_podl_yshift + esp_sirka/2, vyska - 3/2 + nit])
        cube([thick, 9, 3], center = true);
    translate([thick/2, 2*thick + slack/2 + esp_podl_yshift + esp_sirka/2, vyska + (3+slack)/2 - esp_vyska_lcd])
        rotate([90, 0, 90])
            roundedBox(size = [9 + slack, 3 + slack, thick+nit],
                radius = 1.5, sidesonly = true);
    
}

color("grey")
union() {
    // kolem predni desky
    translate([thick + vym + slack/2, 0, vyska - vym + nit])
        cube([sirka - 2*thick - 2*vym - slack, thick, vym]);
    translate([thick + esp_prostor_vpredu + slack / 2, 2*thick + slack, vyska - vym + nit])
        cube([esp_hrebinek_delka - slack, thick, vym]);
    translate([thick + esp_delka + thick + slack / 2, 2*thick + slack, vyska - vym + nit])
        cube([sirka - esp_delka - 2*thick - d_sl, thick, vym]);

    // kolem zadni desky
    translate([thick + vym + slack/2, delka - thick, vyska - vym + nit])
        cube([sirka - 2*thick - 2*vym - slack, thick, vym]);
    translate([d_sl, delka - 3*thick - slack, vyska - vym + nit])
        cube([sirka - 2*d_sl, thick, vym]);
    
    // kolem leve steny
    translate([thick + slack/2, 2*thick + esp_podl_sirka + 2*slack + d_sl, vyska - vym + nit])
        cube([thick, delka - 4*thick - 2*d_sl - esp_podl_sirka - 4*slack, vym]);
    // kolem prave steny
    translate([sirka - 2*thick - slack/2, 2*thick + esp_podl_sirka + 2*slack + d_sl, vyska - vym + nit])
        cube([thick, delka - 4*thick - 2*d_sl - esp_podl_sirka - 4*slack, vym]);
    
    // zamacknuti esp32 vzadu
    translate([thick + esp_delka - esp_prostor_vzadu, 2*thick + esp_podl_yshift + 2*slack, vyska - (esp_vyska_lcd - slack/2) + nit])
        cube([esp_prostor_vzadu, vym, esp_vyska_lcd - slack/2]);
    translate([thick + esp_delka - esp_prostor_vzadu, thick + esp_podl_sirka - vym, vyska - (esp_vyska_lcd - slack/2) + nit])
        cube([esp_prostor_vzadu, vym, esp_vyska_lcd - slack/2]);
    
}
