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
pipeline: @data.read_image
group: 1

this reads the first frame. this case has
a 'rolling' mode which means that frames
are read in the 1-2 2-3 3-4... pattern and
processed pairwise."
		graphics
		[
			x	630.7801587301587
			y	70.0
			w	306.0
			h	140.0
			type	"roundrectangle"
			fill	"#FF947F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: frame_1
pipeline: @data.read_image
group: 1

this reads the first frame. this case has
a 'rolling' mode which means that frames
are read in the 1-2 2-3 3-4... pattern and
processed pairwise."
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	1
		label	"label: frame_2
pipeline: @data.read_image
group: 2

loads the second frame."
		graphics
		[
			x	140.8761904761905
			y	70.0
			w	204.0
			h	102.6
			type	"roundrectangle"
			fill	"#7FC9FF"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: frame_2
pipeline: @data.read_image
group: 2

loads the second frame."
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	2
		label	"label: optic_flow
pipeline: @matching.calculate_dense_optic_flow

this calculates the dense optic flow between the two frames"
		graphics
		[
			x	455.7059523809524
			y	418.5728464893058
			w	394.29696000000035
			h	90.5667433380084
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: optic_flow
pipeline: @matching.calculate_dense_optic_flow

this calculates the dense optic flow between the two frames"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	3
		label	"label: denoise_1
pipeline: @preprocessing.anisotropic_diffusion

this denoises the shadowgraph by preserving edges."
		graphics
		[
			x	554.2801587301587
			y	228.5441514726508
			w	332.4038144863391
			h	87.08830294530162
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: denoise_1
pipeline: @preprocessing.anisotropic_diffusion

this denoises the shadowgraph by preserving edges."
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	4
		label	"label: denoise_2
pipeline: @preprocessing.anisotropic_diffusion"
		graphics
		[
			x	191.8761904761905
			y	228.5441514726508
			w	332.4038144863391
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: denoise_2
pipeline: @preprocessing.anisotropic_diffusion"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	5
		label	"label: show_flow
pipeline: @misc.show_displacement

shows calculated optic flow overlay"
		graphics
		[
			x	455.7059523809524
			y	555.4670969441804
			w	251.75616000000036
			h	83.22175757174091
			type	"roundrectangle"
			fill	"#FF99FF"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: show_flow
pipeline: @misc.show_displacement

shows calculated optic flow overlay"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	edge
	[
		source	0
		target	3
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			xSource	-0.5
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	3
		target	2
		label	"1"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.5
			yTarget	-0.9999999999999993
		]
		LabelGraphics
		[
			text	"1"
			fontSize	12
			fontName	"Dialog"
			configuration	"AutoFlippingLabel"
			contentWidth	10.673828125
			contentHeight	18.701171875
			model	"side_slider"
			x	541.6063391466089
			y	297.7758029453016
		]
	]
	edge
	[
		source	1
		target	4
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			xSource	0.5
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	4
		target	2
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	191.8761904761905
					y	228.5441514726508
				]
				point
				[
					x	191.8761904761905
					y	338.2894748203016
				]
				point
				[
					x	357.1317123809523
					y	338.2894748203016
				]
				point
				[
					x	455.7059523809524
					y	418.5728464893058
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5
			yTarget	-0.9999999999999993
		]
	]
	edge
	[
		source	0
		target	5
		label	"1"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	630.7801587301587
					y	70.0
				]
				point
				[
					x	707.2801587301587
					y	155.0
				]
				point
				[
					x	735.4821428571429
					y	155.0
				]
				point
				[
					x	735.4821428571429
					y	478.85621815831
				]
				point
				[
					x	539.6246723809525
					y	478.85621815831
				]
				point
				[
					x	455.7059523809524
					y	555.4670969441804
				]
			]
		]
		edgeAnchor
		[
			xSource	0.5
			ySource	1.0
			xTarget	0.6666666666666662
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	12
			fontName	"Dialog"
			configuration	"AutoFlippingLabel"
			contentWidth	10.673828125
			contentHeight	18.701171875
			model	"side_slider"
			x	722.8083147321429
			y	345.47190392706875
		]
	]
	edge
	[
		source	1
		target	5
		label	"2"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	140.8761904761905
					y	70.0
				]
				point
				[
					x	89.87619047619049
					y	136.3
				]
				point
				[
					x	10.674206349206349
					y	136.3
				]
				point
				[
					x	10.674206349206349
					y	478.85621815831
				]
				point
				[
					x	371.7872323809523
					y	478.85621815831
				]
				point
				[
					x	455.7059523809524
					y	555.4670969441804
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5
			ySource	1.0
			xTarget	-0.6666666666666666
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"2"
			fontSize	12
			fontName	"Dialog"
			configuration	"AutoFlippingLabel"
			contentWidth	10.673828125
			contentHeight	18.701171875
			model	"side_slider"
			x	-1.9996217757936563
			y	316.10835904628334
		]
	]
	edge
	[
		source	2
		target	5
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0
			yTarget	-1.0
		]
	]
]
