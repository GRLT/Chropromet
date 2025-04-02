shader_type canvas_item;



void vertex(){
    if (UV.y < 0.5){
        VERTEX.y += sin(TIME*40.0 + VERTEX.x) * 10.0;
    }
    if (UV.y > 0.5) VERTEX.x += sin(TIME*10.0 + VERTEX.x) * 10.0;
}

void fragment(){
    //float value = texture(mask,UV).g;
    //float green = value*(TIME+20.0);
	//COLOR = vec4(COLOR.r, green, COLOR.ba);

}