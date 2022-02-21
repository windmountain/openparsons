// 1000 = 1 inch
// Port and starboard are from the perspective of sitting up in bed

// Queen bed
MATTRESS_HEIGHT = 10 * 1000;
MATTRESS_WIDTH = 60 * 1000;
MATTRESS_LENGTH = 80 * 1000;



/*//////////////////////////////////////////////////////
//                                                    //
//                      PRIMITIVES                    //
//                                                    //
//////////////////////////////////////////////////////*/


module BoxProfile(width, height, thickness) {
    difference() {
        square([width, height]);
    translate([thickness/2, thickness/2])
        square([width - thickness, height - thickness]);
    }
}

module BoxSection(length, width, height, thickness) {
    linear_extrude(length) {
        BoxProfile(width, height, thickness);
    }
}

module LProfile(width, height, thickness) {
    square([thickness, height]);
    square([width, thickness]);
}

module LSection(length, width, height, thickness) {
    linear_extrude(length) {
        LProfile(width, height, thickness);
    }
}

module Fin() {
    linear_extrude(125)
        polygon([
            [0, 0],
            [500, 0],
            [1000, 2000],
            [0, 2000]
        ]);
}

module FinSlot() {
    translate([0, 0, 125])
        linear_extrude(125)
            polygon([
                [0, 0],
                [500, 0],
                [1000, 2000],
                [0, 2000]
            ]);
    translate([0, 0, -125])
        linear_extrude(125)
            polygon([
                [0, 0],
                [500, 0],
                [1000, 2000],
                [0, 2000]
            ]);
    translate([125, 0, -125])
        linear_extrude(375)
            polygon([
                [500 - 125, 0],
                [500, 0],
                [1000, 2000],
                [1000 - 125, 2000]
            ]);
}



/*//////////////////////////////////////////////////////
//                                                    //
//                      COMPONENTS                    //
//                                                    //
//////////////////////////////////////////////////////*/


module LegAssembly(height) {
    rotate([-90, 0, 0])
        translate([0, -2000, 0])
            BoxSection(height, 2000, 2000, 250);
    rotate([0, 90, 0])
        translate([0, MATTRESS_HEIGHT, 125])
            FinSlot();
}

module Footboard() {
    HEIGHT = 22 * 1000;

    // port leg
    mirror([0,0,1])
        translate([0, 0, -2000])
                LegAssembly(HEIGHT);

    // starboard leg
    translate([MATTRESS_WIDTH, 0, 2000])
        rotate([0,180,0])
                LegAssembly(HEIGHT);

    // top pieces are not longer and are not translated,
    // as a miter joint
    translate([0, HEIGHT - 2000, 2000])
        rotate([0, 90, 0])
            BoxSection(MATTRESS_WIDTH, 2000, 2000, 250);

    // non-top pieces are shorter and translated, as a
    // butt joint
    translate([2000, MATTRESS_HEIGHT, 2000])
        rotate([0, 90, 0])
            BoxSection(MATTRESS_WIDTH - 4000, 2000, 2000, 250);

}

module Headboard() {
    HEIGHT = MATTRESS_HEIGHT * 4 + 2000;

    // port
    LegAssembly(HEIGHT);

    // startboard
    translate([MATTRESS_WIDTH, 0, 0])
        mirror([1,0,0])
            LegAssembly(HEIGHT);

    // top pieces are not longer and are not translated,
    // as a miter joint
    translate([0, MATTRESS_HEIGHT * 4, 2000])
        rotate([0, 90, 0])
            BoxSection(MATTRESS_WIDTH, 2000, 2000, 250);

    // non-top pieces are shorter and translated, as a
    // butt joint
    translate([2000, MATTRESS_HEIGHT * 3, 2000])
        rotate([0, 90, 0])
            BoxSection(MATTRESS_WIDTH - 4000, 2000, 2000, 250);

    translate([2000, MATTRESS_HEIGHT * 2, 2000])
        rotate([0, 90, 0])
            BoxSection(MATTRESS_WIDTH - 4000, 2000, 2000, 250);

    translate([2000, MATTRESS_HEIGHT, 2000])
        rotate([0, 90, 0])
            BoxSection(MATTRESS_WIDTH - 4000, 2000, 2000, 250);

}

module SideRail() {
    // side rail
    translate([0, MATTRESS_HEIGHT + 2000, 2000])
        LSection(MATTRESS_LENGTH, 2000, 2000, 125);

    // footboard fin
    rotate([0,270,0])
        translate([2000, MATTRESS_HEIGHT, -250])
            Fin();

    // headboard fin
    rotate([0,90,0])
        translate([-MATTRESS_LENGTH - 2000, MATTRESS_HEIGHT, 125])
            Fin();
}

module Mattress(width, height, thickness) {
    translate([125, 125, 125])
    cube([width - 250, thickness - 250, height - 250]);



/*//////////////////////////////////////////////////////
//                                                    //
//                       ASSEMBLY                     //
//                                                    //
//////////////////////////////////////////////////////*/


translate([0, 2000 + MATTRESS_HEIGHT, 2000])
    color("gray", 0.5)
        Mattress(MATTRESS_WIDTH, MATTRESS_LENGTH, 10 * 1000);

Footboard();

translate([0, 0, MATTRESS_LENGTH + 2000])
    Headboard();

// port
SideRail();

// starboard
translate([MATTRESS_WIDTH, 0, 0])
    mirror([1,0,0])
        SideRail();
