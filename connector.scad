length = 35;
height = 4;
width = 10;

border_width = 2.05;

screw_pre_hole_d = 7.95;
screw_hole_floor_h = 1;
screw_hole_d = 5.45;

hinge = false;

$fn = 48;

module screw_hole () {
    pre_hole_h = height-screw_hole_floor_h;
    translate([0,0,screw_hole_floor_h])
    cylinder(r=screw_pre_hole_d/2, h=pre_hole_h+0.01);
    
    translate([0,0,-0.01])
    cylinder(r=screw_hole_d/2, h=height);
}

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

