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
		label	"label: generate some data
pipeline: out_ <- @(~)identity(linspace(0,3.14,100))"
		graphics
		[
			x	324.2007936507936
			y	30.819999999999993
			w	297.144
			h	61.639999999999986
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: generate some data
pipeline: out_ <- @(~)identity(linspace(0,3.14,100))"
			fontSize	12
			fontName	"Dialog"
			model	"null"
		]
	]
	node
	[
		id	1
		label	"label: a named function
pipeline: @sin"
		graphics
		[
			x	111.40039682539683
			y	142.45999999999998
			w	182.80000000000007
			h	61.639999999999986
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: a named function
pipeline: @sin"
			fontSize	12
			fontName	"Dialog"
			model	"null"
		]
	]
	node
	[
		id	2
		label	"label: an anonymous function
pipeline: out_ <- @(x)x.^2"
		graphics
		[
			x	324.2007936507936
			y	142.45999999999998
			w	182.80000000000007
			h	61.639999999999986
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: an anonymous function
pipeline: out_ <- @(x)x.^2"
			fontSize	12
			fontName	"Dialog"
			model	"null"
		]
	]
	node
	[
		id	3
		label	"label: function chaining
pipeline: out_ <- @(x)x.^3 -> @sqrt"
		graphics
		[
			x	551.4011904761904
			y	142.45999999999998
			w	211.60000000000002
			h	61.639999999999986
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: function chaining
pipeline: out_ <- @(x)x.^3 -> @sqrt"
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
			Line
			[
				point
				[
					x	324.2007936507936
					y	30.819999999999993
				]
				point
				[
					x	225.15279365079363
					y	76.63999999999999
				]
				point
				[
					x	111.40039682539683
					y	76.63999999999999
				]
				point
				[
					x	111.40039682539683
					y	142.45999999999998
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.6666666666666666
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	0
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
		source	0
		target	3
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	324.2007936507936
					y	30.819999999999993
				]
				point
				[
					x	423.24879365079363
					y	76.63999999999999
				]
				point
				[
					x	551.4011904761904
					y	76.63999999999999
				]
				point
				[
					x	551.4011904761904
					y	142.45999999999998
				]
			]
		]
		edgeAnchor
		[
			xSource	0.6666666666666666
			ySource	1.0
			yTarget	-1.0
		]
	]
]
