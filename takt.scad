wall_thickness=2;
box_size=99;
hole_offset=12.5;

grid_n=4;
grid_h=0.5;

prep_hole_d=8;
prep_hole_geo="square"; // [square, circle]

module side(grid=true){
    max_pt = box_size-hole_offset;
    min_pt = hole_offset;
    difference() {
    difference() {
        cube([box_size, wall_thickness, box_size]);
        union() {
            translate([min_pt, 0, max_pt]) screwHole();
            translate([max_pt, 0, min_pt]) screwHole();
            translate([min_pt, 0, min_pt]) screwHole();
            translate([max_pt, 0, max_pt]) screwHole();
        }
        
    }
    if (grid) {
        grid_size = box_size-2*hole_offset;
        grid_step = grid_size / (grid_n - 1);
        translate([-hole_offset, 0, -hole_offset]){
        for(i=[1:grid_n]) {
            for (j=[1:grid_n]) {
                if (
                    i != 1 && (j != 1 || j != 4) || 
                    i != 4 && (j != 1 || j != 4)
                ) {
                translate([i*grid_step, -0.01, j*grid_step]) 
                rotate([-90, 0, 0])
                    gridHole();
                }
            }
        }
    }
    }
}

}

module gridHole() {
    cylinder(r=2.5, h=grid_h);
}

module screwHole() {
    // 7.95, prephole
    // 5.45 stopper
        translate([0,1,0])
    
        translate([0,1,0]) {
            if (prep_hole_geo == "square") {
             cube([prep_hole_d, 1, prep_hole_d], center=true);
            } else {
                rotate([90, 0, 0])
                circle(r=prep_hole_d/2, h=2);
            }
        }
        
        translate([0, wall_thickness+0.1,0])
        rotate([90,0,0])
        cylinder(r=5.45/2, h=5);
}
side();
