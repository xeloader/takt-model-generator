use <connector.scad>;
head=true;
head_d=35.5; // 38 measured outside
head_thickness=2;
head_height=23;

arms=true;
total_d_len=116.5;
n_arms = 4;
arm_width = 10;
arm_height = 4;
arm_length=total_d_len/2-head_d/2+arm_width/2;

bottom=true;

$fn = 128;

inner_head_factor = 0.6;
inner_head_height = head_height*inner_head_factor;
inner_head_thickness = head_thickness;

slider_width=2;

magnet_height=2;
magnet_fitting=false;
magnet_opening_width=7;
magnet_angle_offset=10;

mid_arm=false;
mid_arm_length=20;
mid_arm_width=12;


difference() {
    union() {
        if (arms)
        for (i=[0:n_arms]) {
            offset=head_d/2;
            rotate([0,0,(360/n_arms)*i])
            translate([head_d/2-offset,-arm_width/2])
            connector(length=arm_length+offset, width=arm_width, height=arm_height, bottom_head=false);
        }
        
        if (head) {
            translate([0,0,head_height / 2])
            cylinder(h=head_height, r=(head_d+head_thickness)/2, center=true);
        }
        
    }

    z_pos = bottom ? head_height/2+head_thickness : head_height / 2;
    height = bottom ? head_height : head_height * 2;
    if (head)
    translate([0,0,z_pos])
    cylinder(h=height, r=head_d/2, center=true);
}

if (mid_arm) {
    rotate([-45, -90])
    translate([arm_height-0.01,-arm_width/2,-mid_arm_width/2])
    connector(length=mid_arm_length, width=arm_width, height=mid_arm_width, bottom_head=false, sink=false);
}

// inner circle
z_pos = bottom ? inner_head_height/2+head_thickness/2 : inner_head_height/2;
if (head)
translate([0,0,z_pos])
difference() {
    difference() {
        cylinder(h=inner_head_height, r=(head_d)/2, center=true);
        cylinder(h=inner_head_height*2, r=(head_d-inner_head_thickness)/2, center=true);
    }
    for (i=[0:1]) {
        rotate([0, 0, 90*i])
        cube([head_d,slider_width,head_height], center=true);
        
        if (magnet_fitting)
        translate([0,0,-inner_head_height/2+magnet_height/2])
        rotate([0,0, 90*i-magnet_angle_offset])
        cube([head_d+10, magnet_opening_width, magnet_height], center=true);
    }
}