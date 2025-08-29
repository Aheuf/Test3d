extends Area3D

@onready var gemstone_view_packedScene: PackedScene = load("res://Props/Items/Gemstones/%s.glb" % str(get_meta("item_name")))
@onready var gemstone_wireframe_packedScene: PackedScene = load("res://Props/Items/Gemstones/wireframe/%sWireframe.glb" % str(get_meta("item_name")))
@onready var shader = load("res://shaders/celshading.gdshader")

var gemstone_outline
var gemstone_view

var gemstone_color_map = {
	"amethyst": Color("#9966cc"),
	"aquamarine": Color("#7fffd4"),
	"diamond": Color("#ddeeed"),
	"emerald": Color("#50c878"),
	"garnet": Color("#5c1419"),
	"heliolite": Color("#df73ff"),
	"opal": Color("#a4c060"),
	"pearl": Color("#eae0c8"),
	"peridot": Color("#7d944c"),
	"ruby": Color("#e0115f"),
	"sapphire": Color("#0f52ba"),
	"topaz": Color("#faea73"),
	"turquoise": Color("#30d5c8")
}

func _ready() -> void:
	position = Vector3(0,1,0)
	#creation de la gemme || TODO : à globaliser pour tous les objets #########################################################################################
	create_model()
	create_collision()


func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	gemstone_outline.visible = true


func _on_mouse_exited() -> void:
	gemstone_outline.visible = false

################################################################################ custom functions

func extract_mesh_from_glb(packedScene: PackedScene) -> Mesh:
	return packedScene.instantiate().get_child(0).mesh


func create_model() -> void:
	gemstone_view = MeshInstance3D.new()
	
	gemstone_view.mesh = extract_mesh_from_glb(gemstone_view_packedScene)
	
	#association du shader de la gemme || TODO : à globaliser pour tous les objets #########################################################################################
	apply_shaders()
	
	#gestion du outline de la gemme || TODO : à globaliser pour tous les objets #########################################################################################
	apply_interactive_outline()
	
	#fonction propre aux gemmes (pour l'instant)
	apply_edge_enhancement()
	
	add_child(gemstone_view)


func apply_shaders() -> void:
	var shader_material = ShaderMaterial.new()
	var shader_color_gradient = GradientTexture1D.new()
	var color_gradient = Gradient.new()
	var shader_fresnel_gradient = GradientTexture1D.new()
	var fresnel_gradient = Gradient.new()
	
	shader_material.shader = shader;
	shader_material.set_shader_parameter("albedo", gemstone_color_map[get_meta("item_name")])
	shader_material.set_shader_parameter("Threshold 1", 0.05)
	shader_material.set_shader_parameter("Threshold 2", 0.5)
	
	color_gradient.offsets = []
	color_gradient.colors = []
	color_gradient.add_point(0.5, Color.BLACK)
	color_gradient.add_point(0.5, Color.WHITE)
	shader_color_gradient.gradient = color_gradient
	
	shader_fresnel_gradient.gradient = fresnel_gradient
	
	gemstone_view.material_override = shader_material


func apply_interactive_outline() -> void:
	var outlined_gemstone_mesh = gemstone_view.mesh.create_outline(0.02);
	var gemstone_outline_material = StandardMaterial3D.new()
	
	gemstone_outline = MeshInstance3D.new()
	gemstone_outline.mesh = outlined_gemstone_mesh
	
	gemstone_outline_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	gemstone_outline_material.albedo_color = Color.WHITE
	
	gemstone_outline.material_override = gemstone_outline_material
	gemstone_outline.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	gemstone_outline.visible = false
	
	gemstone_view.add_child(gemstone_outline)


func apply_edge_enhancement() -> void:
	var gemstone_wireframe = MeshInstance3D.new()
	var standard_material = StandardMaterial3D.new()
	
	gemstone_wireframe.mesh = extract_mesh_from_glb(gemstone_wireframe_packedScene)
	
	standard_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	standard_material.albedo_color = gemstone_color_map[get_meta("item_name")]
	gemstone_wireframe.scale = Vector3(1,1,1)
	gemstone_wireframe.material_override = standard_material
	
	gemstone_view.add_child(gemstone_wireframe)


func create_collision() -> void:
	var collision = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	
	shape.radius = 0.5
	collision.shape = shape
	add_child(collision)
