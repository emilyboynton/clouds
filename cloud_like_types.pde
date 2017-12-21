import java.util.Map;
import java.util.List;
import java.util.Random;

JSONArray pos_values;

//  TO DO
//  1. create hashmap for the output clouds & count
//      A. also add new var/cond for count
//  2. import json lists of vocab? maybe hash them? also maybe colors?
//  3. rework the pos/neg values
//  4. copy over data.csv and start new one
//  5. THEN reorganize/group function types
//  6. comment up this bitch and remove legacy code/ prints
//  7. rename variables num, sz, feeling, etc more accurately 
//  8. check edge cases, make sure you've seen all colors/cloud names

Table table;
int num = floor(random(1, 15));
float sz = random(1, 5);
String [] positive_words = {};

float x1, y1, x2, y2; // function domain
float step, y; // step = step within domain

//only used in pdj d_pdj functions
float pdj_a = random(1, 3);
float pdj_b = random(-3, 2);
float pdj_c = random(-3, 2);
float pdj_d = random(-1, 1);

//
String feeling, cloud_name;

// COLORS WILL CONTAIN ALPHA VALUES...
// THEY WILL BE IGNORED FOR BACKGROUNDS 
HashMap<String, Integer> colors = new HashMap<String, Integer>();
{
  colors.put("white", color(230, 15));
  colors.put("light_yellow", color(234, 233, 218, 15));
  colors.put("yellow", color(240, 242, 167, 15));
  colors.put("robins_egg", color(143, 182, 193, 15));
  colors.put("bright_blue", color(15, 98, 155, 10));
  colors.put("periwinkle", color(91, 111, 178, 15));
  colors.put("light_periwinkle", color(172, 188, 239, 15));
  colors.put("navy", color(24, 24, 68, 10));
  colors.put("blue_grey", color(40, 80, 107, 10));
  colors.put("grey", color(92, 95, 96, 10));
  colors.put("light_grey", color(198, 15));
  colors.put("orange", color(237, 203, 123, 10));
  colors.put("light_pink", color(232, 220, 218, 15));
  colors.put("pink", color(130, 97, 121, 15));
  colors.put("black", color(5,15));
}

HashMap<String, Integer> used_clouds = new HashMap<String, Integer>();

int st, word;
boolean go = true;

float amount = random(1, 2);
int func_type = floor(random(1, 21));
//int func_type = 16;

HashMap<String, Integer> okList = new HashMap<String, Integer>();
Random r = new Random();
Random rc = new Random();
List<String> keys = new ArrayList<String>(colors.keySet());
String rKey;

String rand_color = keys.get(rc.nextInt(keys.size()));
color bg = colors.get(rand_color);

void setup() {
  loadData();
  size(600, 600);
  smooth(8);
  noFill();
  strokeWeight(0.9);
  println(func_type);
  println(sz + ", " + amount);
  
  
  pos_values = loadJSONArray("new_pos_list.json");
  
  for (int i = 0; i < pos_values.size(); i++) {
      //JSONObject cloudstuff = pos_values.getJSONObject(i);
       positive_words[i] =  pos_values.getString(i);
}
  
  
 
 // switch takes a bg color, then lists cloud color with its 
 // corresponding pos/neg value
 switch(rand_color){
   case "white":
      {
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 1);
        okList.put("navy", 1);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("orange", 1);
        okList.put("pink", 1);
        okList.put("black", 0);
      }
     break;
   case "bright_blue":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("yellow", 1);
        okList.put("robins_egg", 1);
        okList.put("periwinkle", 1);
        okList.put("navy", 0);
        okList.put("light_grey", 1);
        okList.put("orange", 0);
        okList.put("light_pink", 1);
        okList.put("pink", 0);
        okList.put("black", 0);
      }
     break;
   case "grey":   
      {
        okList.put("white", 0);
        okList.put("light_yellow", 0);
        okList.put("yellow", 0);
        okList.put("robins_egg", 1);
        okList.put("periwinkle", 0);
        okList.put("light_periwinkle", 0);
        okList.put("navy", 0);
        okList.put("light_grey", 0);
        okList.put("orange", 0);
        okList.put("light_pink", 0);
        okList.put("pink", 0);
        okList.put("black", 0);
      }
     break;
   case "navy":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("yellow", 1);
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 1);
        okList.put("periwinkle", 1);
        okList.put("light_periwinkle", 1);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("light_grey", 1);
        okList.put("orange", 1);
        okList.put("light_pink", 1);
        okList.put("pink", 0);
        okList.put("black", 0);
      }
     break;
   case "light_yellow":
      {
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 1);
        okList.put("periwinkle", 1);
        okList.put("light_periwinkle", 1);
        okList.put("navy", 0);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("light_grey", 0);
        okList.put("orange", 1);
        okList.put("pink", 1);
        okList.put("black", 0);
      }
       break;
   case "robins_egg":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("yellow", 1);
        okList.put("periwinkle", 1);
        okList.put("light_periwinkle", 1);
        okList.put("navy", 0);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("light_grey", 1);
        okList.put("orange", 1);
        okList.put("pink", 1);
        okList.put("light_pink", 1);
        okList.put("black", 0);
      }
    break;
    case "blue_grey":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("robins_egg", 1);
        okList.put("periwinkle", 0);
        okList.put("light_periwinkle", 1);
        okList.put("navy", 0);
        okList.put("light_grey", 1);
        okList.put("orange", 0);
        okList.put("pink", 0);
        okList.put("light_pink", 1);
        okList.put("black", 0);
      }
      break;
    case "pink":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("yellow", 1);
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 1);
        okList.put("light_periwinkle", 1);
        okList.put("navy", 1);
        okList.put("light_grey", 1);
        okList.put("orange", 1);
        okList.put("light_pink", 1);
        okList.put("black", 0);
      }
      break;
    case "orange":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("yellow", 1);
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 1);
        okList.put("periwinkle", 1);
        okList.put("light_periwinkle", 1);
        okList.put("navy", 0);
        okList.put("grey", 0);
        okList.put("light_grey", 1);
        okList.put("pink", 1);
        okList.put("light_pink", 1);
        okList.put("black", 0);
      }
      break;
    case "yellow":
      {
        okList.put("robins_egg", 0);
        okList.put("bright_blue", 0);
        okList.put("periwinkle", 0);
        okList.put("light_periwinkle", 1);
        okList.put("navy", 0);
        okList.put("grey", 0);
        okList.put("light_grey", 1);
        okList.put("pink", 1);
        okList.put("black", 0);
      }       
      break;   
    case "periwinkle":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("yellow", 1);
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 1);
        okList.put("light_periwinkle", 1);
        okList.put("navy", 1);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("light_grey", 1);
        okList.put("orange", 1);
        okList.put("light_pink", 1);
        okList.put("pink", 0);
        okList.put("black", 0);
      }     
      break;
    case "light_periwinkle":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 1);
        okList.put("yellow", 1);
        okList.put("robins_egg", 0);
        okList.put("bright_blue", 1);
        okList.put("periwinkle", 1);
        okList.put("navy", 0);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("orange", 0);
        okList.put("light_pink", 1);
        okList.put("pink", 0);
        okList.put("black", 0);
      }
      break;   
    case "light_grey":
      {
        okList.put("white", 0);
        okList.put("light_yellow", 0);
        okList.put("yellow", 0);
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 0);
        okList.put("periwinkle", 0);
        okList.put("navy", 0);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("orange", 0);
        okList.put("pink", 0);
        okList.put("black", 0);
      }
      break;
     case "light_pink":
      {
        okList.put("robins_egg", 1);
        okList.put("bright_blue", 0); 
        okList.put("periwinkle", 0); 
        okList.put("light_periwinkle", 1); 
        okList.put("navy", 1); 
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("orange", 1);
        okList.put("pink", 1);
        okList.put("black", 0);
      }
      break;
    case "black":
      {
        okList.put("white", 1);
        okList.put("light_yellow", 0);
        okList.put("yellow", 0);
        okList.put("robins_egg", 0);
        okList.put("bright_blue", 1);
        okList.put("periwinkle", 0);
        okList.put("light_periwinkle", 0);
        okList.put("navy", 0);
        okList.put("blue_grey", 0);
        okList.put("grey", 0);
        okList.put("light_grey", 0);
        okList.put("orange", 0);
        okList.put("light_pink", 0);
        okList.put("pink", 1);
      }
      break;
  } //  END SWITCH
  println(rand_color);
  
  do {
    r = new Random();
    rKey = keys.get(r.nextInt(keys.size()));
    st = colors.get(rKey);
    if (okList.containsKey(rKey)){
      word = okList.get(rKey);
    }
  } while (!okList.containsKey(rKey));

  println(rKey);
  background(bg);
  stroke(st);  
  x1=y1=-sz;
  x2=y2=sz;
  y=y1;
  step=(x2-x1)/(3.321*width);
}

void draw() {
  if (go) {
    for (int i=0; (i<20)&go; i++) { // draw 20 lines at once
      for (float x=x1; x<=x2; x+=step) {
        drawVariation(x, y);
      }
      y+=step;
      if (y>y2) {
        go = false;
        if (word == 1){
          feeling = positive_words[floor(random(0, positive_words.length))];
          cloud_name = feeling + clouds[floor(random(0, clouds.length))] + ".jpg";
          println(cloud_name);
        }
        else {
          feeling = negative_words[floor(random(0, negative_words.length))];
          cloud_name = feeling + clouds[floor(random(0, clouds.length))] + ".jpg";
          println(cloud_name);
        }
        TableRow row = table.addRow();
        row.setString("name", cloud_name);
        row.setInt("func", func_type);
        row.setInt("num", num);
        row.setFloat("sz", sz);
        row.setFloat("amount", amount);
        // maybe only spit these out if a pdj type is used?????????????????
        row.setFloat("a", pdj_a);
        row.setFloat("b", pdj_b);
        row.setFloat("c", pdj_c);
        row.setFloat("d", pdj_d);
        
        saveTable(table, "data.csv");
      }
    }
  }
}
 
void drawVariation(float x, float y) {
  PVector v = new PVector(x,y);
 
  switch(func_type){
    case 1:
      v = addF(sinusoidal(v,amount), pdj(v, amount));
      break;
    case 2:
      v = addF(hyperbolic(v,amount), pdj(v, amount));
      break;
    case 3:
      v = subF(pdj(v, amount), sinusoidal(v, amount));
      break;
    case 4:
      v = addF(julia(julia(v,amount), amount), pdj(pdj(v, amount), amount));
      break;
    case 5:
      v = addF(sinusoidal(v,amount), pdj(v, amount));
      v = addF(sinusoidal(v,amount), julia(pdj(v,amount), amount ));
      break;
    case 6:
      v = addF(julia(v,amount),pdj(v, amount));
      break;
    case 7:
      v = subF(d_pdj(v, amount), pdj(julia(v, amount), amount));
      break;
    case 8:
      v = subF(pdj(pdj(v, amount), amount), julia(v, amount));
      break;
    case 9:
      v = subF(sinusoidal(julia(v, amount), amount), pdj(sinusoidal(v, amount), amount));
      //v = pdj(v, amount);
      break;
    case 10:
      v = sinusoidal(julia(d_pdj(v, amount), amount), amount);
      v = pdj(v, amount);
      break;
    case 11:
      v = julia(d_pdj(pdj(v, amount), amount), amount);
      break;
    case 12:
      v = pdj(julia(pdj(v, amount), amount), amount);
      break;
    case 13:
      v = addF(pdj(v, amount), pdj(julia(v, amount), amount));
      break;
    case 14:
      v = addF(d_pdj(d_pdj(v, amount), amount), julia(v, amount));
      break;
    case 15:
      v = subF(d_pdj(v, amount), julia(v, amount));
      break;
    case 16:
      v = subF(julia(v, amount), d_pdj(v, amount));
      break;
    case 17:
      v = julia(pdj(julia(hyperbolic(pdj(v, amount), amount), amount), amount), amount);
      break;
    case 18:
      v = addF(d_pdj(d_pdj(v, amount), amount), julia(julia(v, amount), amount));
      break;
    case 19:
      v = subF(sinusoidal(hyperbolic(v, amount), amount), hyperbolic(d_pdj(v, amount), amount));
      break;
    case 20:
      v = pdj(pdj(v, amount), amount);
      break;
      
  }
    // this all but ensures some of the function will be onscreen
    // it creates a tiling effect with a to-be determined offest
    v.x = (v.x - x1) % (x2-x1);
    if(v.x<0) v.x += (x2-x1);
    v.y = (v.y - y1) % (y2-y1);
    if(v.y<0) v.y += (y2-y1);
    v.x += x1;
    v.y += y1;
  //v = addF(sinusoidal(v,amount), pdj(v, amount));
  
  float xx = map(v.x+0.003*randomGaussian(), x1, x2, -100, width+100);
  float yy = map(v.y+0.003*randomGaussian(), y1, y2, -100, height+100);
  
  //float xx = map(v.x+0.003*randomGaussian(), x1, x2, 0, width);
  //float yy = map(v.y+0.003*randomGaussian(), y1, y2, 0, height);
  point(xx, yy);
}

void loadData(){
  table = loadTable("data.csv", "header");
}


//maybe have these in a separate file too?????????????????
PVector sinusoidal(PVector v, float amount) {
  return new PVector(amount * sin(v.x), amount * sin(v.y));
}

PVector hyperbolic(PVector v, float amount) {
  float r = v.mag() + 1.0e-10;
  float theta = atan2(v.x, v.y);
  float x = amount * sin(theta) / r;
  float y = amount * cos(theta) * r;
  return new PVector(x, y);
}

PVector pdj(PVector v, float amount) {
  return new PVector( amount * (sin(pdj_a * v.y) - cos(pdj_b * v.x)),
                      amount * (sin(pdj_c * v.x) - cos(pdj_d * v.y)));
}

PVector julia(PVector v, float amount) {
  float r = amount * sqrt(v.mag());
  float theta = 0.5 * atan2(v.x, v.y) + (int)(2.0 * random(0, 1)) * PI;
  float x = r * cos(theta);
  float y = r * sin(theta);
  return new PVector(x, y);
}

PVector d_pdj(PVector v, float amount) {
  float h = 0.1; // step
  float sqrth = sqrt(h);
  PVector v1 = pdj(v, amount);
  PVector v2 = pdj(new PVector(v.x+h, v.y+h), amount);
  return new PVector( (v2.x-v1.x)/sqrth, (v2.y-v1.y)/sqrth );
}

PVector addF(PVector v1, PVector v2) { return new PVector(v1.x+v2.x, v1.y+v2.y); }
PVector subF(PVector v1, PVector v2) { return new PVector(v1.x-v2.x, v1.y-v2.y); }
PVector mulF(PVector v1, PVector v2) { return new PVector(v1.x*v2.x, v1.y*v2.y); }
PVector divF(PVector v1, PVector v2) { return new PVector(v2.x==0?0:v1.x/v2.x, v2.y==0?0:v1.y/v2.y); }

String[] negative_words = {
  "ineffective",
  "unenthused"
};

//String[] positive_words = {
//  "bright-eyed",
//  "hopeful",
//  "liberal"
  
//};

String[] clouds = {
  "_cirrus_fibratus",
  "_cirrus_uncinus",
  "_cirrus_spissatus",
  "_cirrus_castellanus",
  "_cirrus_floccus",
  "_cirrus_fibratus_intortus",
  "_cirrus_fibratus_vertebratus",
  "_cirrus_fibratus_radiatus",
  "_cirrus_uncinus_radiatus",
  "_cirrus_fibratus_duplicatus",
  "_cirrus_funcinus_duplicatus",
  "_cirrus_mammatus",
  "_cirrus_cirrocumulogenitus",
  "_cirrus_altocumulogenitus",
  "_cirrus_cumulonimbogenitus",
  "_cirrus_homogenitus",
  "_cirrus_cirrostratomutatus",
  "_cirrocumulus_stratiformis",
  "_cirrocumulus_lenticularis",
  "_cirrocumulus_castellanus",
  "_cirrocumulus_floccus",
  "_cirrocumulus_stratiformis_undulatus",
  "_cirrocumulus_lenticularis_undulatus",
  "_cirrocumulus_stratiformis_lacunosus",
  "_cirrocumulus_castellanus_lacunosus",
  "_cirrocumulus_floccus_lacunosus",
  "_cirrocumulus_virga",
  "_cirrocumulus_mammatus",
  "_cirrocumulus_homogenitus",
  "_cirrocumulus_cirromutatus",
  "_cirrocumulus_cirrostratomutatus",
  "_cirrocumulus_altocumulomutatus",
  "_cirrostratus_fibratus",
  "_cirrostratus_nebulosus",
  "_cirrostratus_fibratus_duplicatus",
  "_cirrostratus_fibratus_undulatus",
  "_cirrostratus_cirrocumulogenitus",
  "_cirrostratus_cumulonimbogenitus",
  "_cirrostratus_homogenitus",
  "_cirrostratus_cirromutatus",
  "_cirrostratus_cirrocumulomutatus",
  "_cirrostratus_altostratomutatus",
  "_altocumulus_stratiformis",
  "_altocumulus_lenticularis",
  "_altocumulus_volutus",
  "_altocumulus_castellanus",
  "_altocumulus_floccus",
  "_altocumulus_stratiformis_translucidus",
  "_altocumulus_stratiformis_perlucidus",
  "_altocumulus_stratiformis_opacus",
  "_altocumulus_stratiformis_translucidus_radiatus",
  "_altocumulus_stratiformis_perlucidus_radiatus",
  "_altocumulus_stratiformis_opacus_radiatus",
  "_altocumulus_stratiformis_translucidus_duplicatus",
  "_altocumulus_stratiformis_perlucidus_duplicatus",
  "_altocumulus_stratiformis_opacus_duplicatus",
  "_altocumulus_lenticularis_duplicatus",
  "_altocumulus_stratiformis_translucidus_undulatus",
  "_altocumulus_stratiformis_perlucidus_undulatus",
  "_altocumulus_stratiformis_opacus_undulatus",
  "_altocumulus_lenticularis_undulatus",
  "_altocumulus_stratiformis_translucidus_lacunosus",
  "_altocumulus_stratiformis_perlucidus_lacunosus",
  "_altocumulus_stratiformis_opacus_lacunosus",
  "_altocumulus_castellanus_lacunosus",
  "_altocumulus_floccus_lacunosus",
  "_altocumulus_virga",
  "_altocumulus_mammatus",
  "_altocumulus cumulogenitus",
  "_altocumulus_cumulonimbogenitus",
  "_altocumulus_cirrocumulomutatus",
  "_altocumulus_altostratomutatus",
  "_altocumulus_nimbostratomutatus",
  "_altocumulus_stratocumulomutatus",
  "_altostratus_translucidus",
  "_altostratus_opacus",
  "_altostratus_translucidus_radiatus",
  "_altostratus_opacus_radiatus",
  "_altostratus_translucidus_duplicatus",
  "_altostratus_opacus_duplicatus",
  "_altostratus_translucidus_undulatus",
  "_altostratus_opacus_undulatus",
  "_altostratus_virga",
  "_altostratus_praecipitatio",
  "_altostratus_mammatus",
  "_altostratus_pannus",
  "_altostratus_altocumulogenitus",
  "_altostratus_cumulonimbogenitus",
  "_altostratus_cirrostratomutatus",
  "_altostratus_nimbostratomutatus",
  "_cumulonimbus_calvus",
  "_cumulonimbus_capillatus",
  "_cumulonimbus_virga",
  "_cumulonimbus_praecipitatio",
  "_cumulonimbus_incus",
  "_cumulonimbus_mammatus",
  "_cumulonimbus_arcus",
  "_cumulonimbus_tuba",
  "_cumulonimbus_pannus",
  "_cumulonimbus_pileus",
  "_cumulonimbus_velum",
  "_cumulonimbus_altocumulogenitus",
  "_cumulonimbus_altostratogenitus",
  "_cumulonimbus_nimbostratogenitus",
  "_cumulonimbus_stratocumulogenitus",
  "_cumulonimbus_flammagenitus",
  "_cumulonimbus_cumulomutatus",
  "_cumulus_congestus",
  "_cumulus_virga",
  "_cumulus_praecipitatio",
  "_cumulus_mammatus",
  "_cumulus_arcus",
  "_cumulus_tuba",
  "_cumulus_pannus",
  "_cumulus_pileus",
  "_cumulus_velum",
  "_cumulus_congestus_flammagenitus",
  "_nimbostratus_virga",
  "_nimbostratus_praecipitatio",
  "_nimbostratus_pannus",
  "_nimbostratus_cumulogenitus",
  "_nimbostratus_cumulonimbogenitus",
  "_nimbostratus_altostratomutatus",
  "_nimbostratus_altocumulomutatus",
  "_nimbostratus_stratocumulomutatus",
  "_cumulus_mediocris",
  "_cumulus_mediocris_radiatus",
  "_cumulus_virga",
  "_cumulus_praecipitatio",
  "_cumulus_mammatus",
  "_cumulus_pileus",
  "_cumulus_velum",
  "_stratocumulus_stratiformis",
  "_stratocumulus_lenticularis",
  "_stratocumulus_volutus",
  "_stratocumulus_floccus",
  "_stratocumulus_castellanus",
  "_stratocumulus_stratiformis_translucidus",
  "_stratocumulus_stratiformis_perlucidus",
  "_stratocumulus_stratiformis_opacus",
  "_stratocumulus_stratiformis_translucidus_radiatus",
  "_stratocumulus_stratiformis_perlucidus_radiatus",
  "_stratocumulus_stratiformis_opacus_radiatus",
  "_stratocumulus_stratiformis_translucidus_duplicatus",
  "_stratocumulus_stratiformis_perlucidus_duplicatus",
  "_stratocumulus_stratiformis_opacus_duplicatus",
  "_stratocumulus_lenticularis_duplicatus",
  "_stratocumulus_stratiformis_translucidus_undulatus",
  "_stratocumulus_stratiformis_perlucidus_undulatus",
  "_stratocumulus_stratiformis_opacus_undulatus",
  "_stratocumulus_lenticularis_undulatus",
  "_stratocumulus_stratiformis_translucidus_lacunosus",
  "_stratocumulus_stratiformis_perlucidus_lacunosus",
  "_stratocumulus_stratiformis_opacus_lacunosus",
  "_stratocumulus_castellanus_lacunosus",
  "_stratocumulus_virga",
  "_stratocumulus_praecipitatio",
  "_stratocumulus_mammatus",
  "_stratocumulus_cumulogenitus",
  "_stratocumulus_nimbostratogenitus",
  "_stratocumulus_cumulonimbogenitus",
  "_stratocumulus_altostratogenitus",
  "_stratocumulus_nimbostratomutatus",
  "_stratocumulus_altocumulomutatus",
  "_stratocumulus_stratomutatus",
  "_cumulus_fractus",
  "_cumulus_humilis",
  "_cumulus_humilis_radiatus",
  "_cumulus_stratocumulogenitus",
  "_cumulus_homogenitus",
  "_cumulus_stratocumulomutatus",
  "_cumulus_stratomutatus",
  "_stratus_nebulosus",
  "_stratus_fractus",
  "_stratus_nebulosus_translucidus",
  "_stratus_nebulosus_opacus",
  "_stratus_nebulosus_translucidus_undulatus",
  "_stratus_nebulosus_opacus_undulatus",
  "_stratus_praecipitatio",
  "_stratus_nimbostratogenitus",
  "_stratus_cumulogenitus",
  "_stratus_cumulonimbogenitus",
  "_stratus_cataractagenitus",
  "_stratus_silvagenitus",
  "_stratus_stratocumulomutatus",
};

/// NUMBERS THAT ARENT BROKE 
//float pdj_a = 1.82;
//float pdj_b = 2.5;
//float pdj_c = -2.99;
//float pdj_d = 0.9;

//x1=y1=-4.5;
//x2=y2=4.5;
  
//float amount = 2.2;

//THE FOLLOWING MAYBE CONTAIN:
//v = addF(sinusoidal(v,amount), pdj(v, amount));


////// I LIKE THIS
//      v = divF(sinusoidal(v, amount), pdj(v, amount));

/////ALSO THESE
//       v = pdj(julia(v,amount), amount );
 //     v = hyperbolic(sinusoidal(v, amount), amount);
 
//
//       v = addF(sinusoidal(v,amount), pdj(v, amount));
      // v = julia(pdj(v,amount), amount );
      
      
      
      //      v = divF(julia(v, amount), pdj(v, amount)); ///DEAD
      
     //stroke(20, 60, 100, 15);      //OG

      
   //case 5:
   //  background(222);
   //  stroke(115, 150, 220, 15);
   //  break;


//!!!!!!!!!!
//       v = sinusoidal(julia(d_pdj(v, amount), amount), amount);