// 35 normal, 41 hinge. (middle length), 39 hinge (new screw offset).
length = 39;
height = 4;
width = 10;

screw_pre_hole_d = 7.95;
screw_hole_floor_h = 1;
screw_hole_d = 5.45;

hinge = true;
hinge_spacing = 0.0; // was 0.1
hinge_width_fac = 0.29;

sink=true;

$fn = 48;

module screw_hole (sink=true, height=height) {
    pre_hole_h = height-screw_hole_floor_h;
    if (sink) translate([0,0,screw_hole_floor_h])
    cylinder(r=screw_pre_hole_d/2, h=pre_hole_h+0.01);
    
    translate([0,0,-height/2])
    cylinder(r=screw_hole_d/2, h=height*2+0.02);
}

module hinge () {
    radius=height/2;
    block_width=2.50;
    union() {
        hinge_width=width*hinge_width_fac;
        translate([0, hinge_width/2]) {
            translate([-block_width/2, 0])
            rotate([0,0,90])
            cube([hinge_width, block_width, height], center=true);
            rotate([90]) cylinder(r=radius, h=hinge_width, center=true);
        }
        translate([0,width-hinge_width/2]) {
            translate([-block_width/2, 0])
            rotate([0,0,90])
            cube([hinge_width, block_width, height], center=true);
            rotate([90]) cylinder(r=radius, h=hinge_width, center=true);
        }
        translate([0, width/2])
        rotate([90])
        cylinder(r=1.25, h=width, center=true);
    }
    translate([0,width/2]) {
        hinge_width=width * 1/3;
        rotate([0, 180]) {
            difference() {
                union () {
                    translate([-block_width/2, 0])
                    rotate([0,0,90])
                    cube([hinge_width, block_width, height], center=true);
                    rotate([90]) cylinder(r=radius, h=hinge_width, center=true);
                }
                rotate([90]) cylinder(r=radius-0.5, h=hinge_width+0.01, center=true);
            }
        }
    }
}

module connector (with_hinge=false, length=length, width=width, height=height, top_head=true, bottom_head=true, sink=true) {
    middle_length = length - width;
    difference() {
        union() {
            cube([middle_length, width, height]);

            end_radius = width/2;
            if (bottom_head) {
                translate([0, end_radius])
                cylinder(r=end_radius, h=height);
            }

            if (top_head) {
                translate([middle_length, end_radius])
                cylinder(r=end_radius, h=height);
            }
        }
        if (bottom_head) translate([0, width/2]) screw_hole(sink=sink, height=height);
        if (top_head) translate([middle_length, width/2]) screw_hole(sink=sink, height=height);
        if (with_hinge) {
            translate([middle_length/2, width/2, height/2])
            cube([5-hinge_spacing, width+0.1, height+0.1], center=true);
        }
    }
    if (with_hinge) {
        translate([middle_length/2, 0, height/2])
        hinge();
    }
}

connector(with_hinge=hinge, sink=sink);