Creator	"yFiles"
Version	"2.12"
graph
[
	hierarchic	1
	label	""
	directed	1
	node
	[
		id	0
		label	"label: frame_1
pipeline: @data.read_image"
		graphics
		[
			x	209.5
			y	30.0
			w	161.0
			h	60.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: frame_1
pipeline: @data.read_image"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	1
		label	"label: min
pipeline: @(x,y)arithmetic.blend_images(@max,x,y)
type: accumulating_1"
		graphics
		[
			x	209.5
			y	150.0
			w	293.0
			h	60.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: min
pipeline: @(x,y)arithmetic.blend_images(@max,x,y)
type: accumulating_1"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	2
		label	"label: rolling_mean
type: memory_100
pipeline: a<-@identity"
		graphics
		[
			x	209.5
			y	275.25
			w	161.0
			h	70.5
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: rolling_mean
type: memory_100
pipeline: a<-@identity"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	3
		label	"label: merge
pipeline: @(x)data.merge(x, 'mode', '3darray') -> a<-@(x)mean(x, 3)"
		graphics
		[
			x	209.5
			y	395.25
			w	379.0
			h	70.5
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: merge
pipeline: @(x)data.merge(x, 'mode', '3darray') -> a<-@(x)mean(x, 3)"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	4
		label	"label: show
pipeline: @misc.show_detection"
		graphics
		[
			x	209.5
			y	520.5
			w	201.0
			h	60.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: show
pipeline: @misc.show_detection"
			fontSize	12
			fontName	"Dialog"
			model	"null"
		]
	]
	edge
	[
		source	0
		target	1
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
		]
		edgeAnchor
		[
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	1
		target	2
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
		]
		edgeAnchor
		[
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	2
		target	3
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
		]
		edgeAnchor
		[
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	3
		target	4
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
		]
		edgeAnchor
		[
			ySource	1.0
			yTarget	-1.0
		]
	]
]
