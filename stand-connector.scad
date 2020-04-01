use <connector.scad>;
head=true;
head_d=38;
head_thickness=2;
head_height=23;

arms=true;
total_d_len=115;
n_arms = 4;
arm_length=total_d_len/2-head_d/2;

$fn = 128;
difference() {
    union() {
        if (arms)
        for (i=[0:n_arms]) {
            offset=2;
            rotate([0,0,(360/n_arms)*i])
            translate([head_d/2-offset,-5])
            connector(length=arm_length+offset, width=10, bottom_head=false);;
        }
        if (head)
        translate([0,0,head_height/2])
        cylinder(h=head_height, r=head_d/2, center=true);
    }

    if (head)
    translate([0,0,head_height/2+head_thickness])
    cylinder(h=head_height, r=(head_d-head_thickness)/2, center=true);
}