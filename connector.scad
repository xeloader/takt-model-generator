length = 35;
height = 4;
width = 10;

screw_pre_hole_d = 7.95;
screw_hole_floor_h = 1;
screw_hole_d = 5.45;

hinge = true;

$fn = 48;

module screw_hole () {
    pre_hole_h = height-screw_hole_floor_h;
    translate([0,0,screw_hole_floor_h])
    cylinder(r=screw_pre_hole_d/2, h=pre_hole_h+0.01);
    
    translate([0,0,-0.01])
    cylinder(r=screw_hole_d/2, h=height);
}

module hinge () {
    radius=height/2;
    block_width=2.50;
    union() {
        width=3;
        translate([0, 1.5]) {
            translate([-block_width/2, 0])
            rotate([0,0,90])
            cube([width, block_width, height], center=true);
            rotate([90]) cylinder(r=radius, h=width, center=true);
        }
        translate([0,10-1.5]) {
            translate([-block_width/2, 0])
            rotate([0,0,90])
            cube([width, block_width, height], center=true);
            rotate([90]) cylinder(r=radius, h=width, center=true);
        }
        translate([0, 5])
        rotate([90])
        cylinder(r=1.25, h=10, center=true);
    }
    translate([0,5]) {
        width=3.3;
        rotate([0, 180]) {
            difference() {
                union () {
                    translate([-block_width/2, 0])
                    rotate([0,0,90])
                    cube([width, block_width, height], center=true);
                    rotate([90]) cylinder(r=radius, h=width, center=true);
                }
                rotate([90]) cylinder(r=radius-0.5, h=width+0.01, center=true);
            }
        }
    }
}

module connector (with_hinge=false) {
    difference() {
        middle_length = length - width;
        union() {
            cube([middle_length, width, height]);

            end_radius = width/2;
            translate([0, end_radius])
            cylinder(r=end_radius, h=height);

            translate([middle_length, end_radius])
            cylinder(r=end_radius, h=height);
        }
        translate([0, width/2]) screw_hole();
        translate([middle_length, width/2]) screw_hole();
    }
}

hinge();
// connector(with_hinge=hinge);