
function buffer_types(_typeOne = -1, _typeTwo = -1, _typeThree = -1, _typeFour = -1) constructor {
	array[0] = _typeOne;	
	array[1] = _typeTwo;	
	array[2] = _typeThree;	
	array[3] = _typeFour;	
};

function convert_grid_with_struct_to_buffer(_grid, _alignment, _types = -1){
	var width = ds_grid_width(_grid);
	var height = ds_grid_width(_grid);
	
	var	struct_size = variable_struct_names_count(_grid[# 0, 0]);
	var array = variable_struct_get_names(_grid[# 0, 0]);
	
	var minimumSize = ((width*height)*struct_size)*32;
	var buffer = buffer_create(minimumSize, buffer_grow, _alignment);
	
	buffer_seek(buffer, buffer_seek_start, 0);
	
	var i = 0; repeat(struct_size) {	
		for (var yy = 0; yy < width; ++yy) {
		    for (var xx = 0; xx < height; ++xx) {
				var value = variable_struct_get(_grid[# xx, yy], array[i]);	
				//log(string(i) + " : " + string(xx) + ":" + string(yy) + ":  " + string(value));
				buffer_write(buffer, _types.array[i], value);
			}
		}
		
		i++;
	}	

	return(buffer);
}

function convert_grid_to_buffer(_grid, _alignment, _type) {
	
	var width = ds_grid_width(_grid);
	var height = ds_grid_width(_grid);
	var minimumSize = ((width*height))*8;
	var buffer = buffer_create(minimumSize, buffer_grow, _alignment);
	
	buffer_seek(buffer, buffer_seek_start, 0);
	for (var yy = 0; yy < width; ++yy) { 
	    for (var xx = 0; xx < height; ++xx) {
		    buffer_write(buffer, _type, _grid[# xx, yy]);
		}
	}
	
	return(buffer);
}

function convert_buffer_to_grid_with_structs(_buffer, _grid, _types) {
	var width = ds_grid_width(_grid);
	var height = ds_grid_width(_grid);
	
	var	struct_size = variable_struct_names_count(_grid[# 0, 0]);
	var array = variable_struct_get_names(_grid[# 0, 0]);
	
	var type = _types;
	var buffer = _buffer;
	
	buffer_seek(buffer, buffer_seek_start, 0);
	var i = 0; repeat(struct_size) {	
		for (var yy = 0; yy < width; ++yy) {
		    for (var xx = 0; xx < height; ++xx) {
				var value = buffer_read(buffer, type.array[i]);
				//log(string(i) + " : " + string(xx) + ":" + string(yy) + ":  " + string(value));
				variable_struct_set(_grid[# xx, yy], array[i], value);
			}
		}
		
		i++;
	}
		
}
	

function convert_buffer_to_grid(_buffer, _grid, _type) {
	var width = ds_grid_width(_grid);
	var height = ds_grid_width(_grid);
	
	var type = _type;
	var buffer = _buffer;
	
	buffer_seek(buffer, buffer_seek_start, 0);
	
	for (var yy = 0; yy < width; ++yy) {
	    for (var xx = 0; xx < height; ++xx) {
			var value = buffer_read(buffer, type);
			//log(string(xx) + ":" + string(yy) + ":  " + string(value));
			ds_grid_set(_grid, xx, yy, value);
		}
	}		
}
	
