error_on_not_interconnectable=false; // [true, false]
$fn = 48;

diagonal_cut=false;

wall_thickness=2;
box_size=99; // [10:0.5:250]
hole_offset=12.5;

grid_n=4;
grid_h=0.5;

prep_hole_d=8;
prep_hole_geo="square"; // [square, circle]

with_grid=false; // [true, false]

if (error_on_not_interconnectable) {
assert(box_size/2 > 2*hole_offset, "Settings yields non interconnectable boxes"); 
}

module rotate_about_pt(z, y, pt) {
    translate(pt)
        rotate([0, y, z])
            translate(-pt)
                children();   
}

module cut_line(diag_cut_len) {
    cut_size=sqrt(pow(wall_thickness,2)+pow(wall_thickness,2));
    translate([diag_cut_len/2,0])
    rotate([45])
    cube([diag_cut_len, cut_size, cut_size], center=true);
}

module side(with_grid=false, diagonal_cut=false){
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
        if (diagonal_cut) {
            translate([0, wall_thickness]) {
                diag_cut_len=box_size+0.01;
                cut_line(diag_cut_len);
                translate([0,0,box_size]) cut_line(diag_cut_len);
                rotate([0,-90]) cut_line(diag_cut_len);
                translate([box_size,0]) rotate([0,-90]) cut_line(diag_cut_len);
            }
        }
        
    }
    if (with_grid) {
        grid_size = box_size-2*hole_offset;
        grid_step = grid_size / (grid_n - 1);
        echo (grid_step, hole_offset, grid_size);
        translate([hole_offset, 0, hole_offset]){
        grid_max_i = grid_n-1;
        for(i=[0:grid_max_i]) {
            for (j=[0:grid_max_i]) {
                if (
                    !(i == 0 && (j == 0 || j == grid_max_i)) && 
                    !(i == grid_max_i && (j == 0 || j == grid_max_i))
                ) {
                translate([j*grid_step, -0.01, i*grid_step]) 
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
    
        translate([0,0.5+0.01,0]) {
            if (prep_hole_geo == "square") {
             cube([prep_hole_d, 1, prep_hole_d], center=true);
            } else {
                rotate([90, 0, 0])
                circle(r=prep_hole_d/2, h=1);
            }
        }
        
        translate([0, wall_thickness+0.1,0])
        rotate([90,0,0])
        cylinder(r=5.45/2, h=5);
}

module box(with_grid=false, diagonal_cut=false) {
center_pt=box_size/2;
translate([0, box_size]) 
rotate_about_pt(180,0,[center_pt,0,center_pt])
    side(with_grid=with_grid, diagonal_cut=diagonal_cut);
side(with_grid=with_grid, diagonal_cut=diagonal_cut);

rotate([0,0,90])
rotate_about_pt(180,0,[center_pt,0,center_pt])
    side(diagonal_cut=diagonal_cut);

translate([box_size, 0])
rotate([0,0,90])
    side(diagonal_cut=diagonal_cut);
}
//    side(diagonal_cut=diagonal_cut);
box(with_grid=with_grid, diagonal_cut=diagonal_cut);