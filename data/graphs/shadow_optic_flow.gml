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
group: 1
pipeline: @data.read_image

we read the first frame. note: pipelines for the two
frames are symmetric. only one side will be annotated."
		graphics
		[
			x	198.67857142857142
			y	54.9577840112202
			w	357.3570827489484
			h	109.9155680224404
			type	"roundrectangle"
			fill	"#FF947F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: frame_1
group: 1
pipeline: @data.read_image

we read the first frame. note: pipelines for the two
frames are symmetric. only one side will be annotated."
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
group: 2
pipeline: @data.read_image

we read the second frame"
		graphics
		[
			x	505.15714285714284
			y	54.9577840112202
			w	195.5999999999999
			h	90.5667433380084
			type	"roundrectangle"
			fill	"#7FC9FF"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: frame_2
group: 2
pipeline: @data.read_image

we read the second frame"
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
			x	515.1670634920634
			y	263.9001115664446
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
		label	"label: datalink
pipeline: @(~)data.create_datalink('datalink_', 'store_')

a helper node that initializes a DataLink in the workspace if there isn't one"
		graphics
		[
			x	880.6349206349207
			y	54.9577840112202
			w	495.35520948177634
			h	75.13422657804966
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: datalink
pipeline: @(~)data.create_datalink('datalink_', 'store_')

a helper node that initializes a DataLink in the workspace if there isn't one"
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
		label	"label: store
pipeline: @(data_, datalink_)data.aggregate_data(data_, datalink_, 'of_demo')

this aggregates data in the in-memory Store called 'store_'"
		graphics
		[
			x	756.7960317460318
			y	444.4955338963192
			w	495.35520948177634
			h	83.22175757174091
			type	"roundrectangle"
			fill	"#7FFF7F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: store
pipeline: @(data_, datalink_)data.aggregate_data(data_, datalink_, 'of_demo')

this aggregates data in the in-memory Store called 'store_'"
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
		label	"label: counter
pipeline: out_ <- @(x,y)x+y
type: accumulating_1"
		graphics
		[
			x	1274.679365079365
			y	263.9001115664446
			w	207.39999999999998
			h	64.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: counter
pipeline: out_ <- @(x,y)x+y
type: accumulating_1"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			anchor	"c"
		]
	]
	node
	[
		id	6
		label	"label: counter_token
pipeline: out_ <- @(~)identity(1)"
		graphics
		[
			x	1274.679365079365
			y	54.9577840112202
			w	232.73333333333332
			h	64.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: counter_token
pipeline: out_ <- @(~)identity(1)"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			anchor	"c"
		]
	]
	node
	[
		id	7
		label	"label: show_flow
pipeline: @misc.show_displacement

shows calculated optic flow overlay"
		graphics
		[
			x	303.018253968254
			y	444.4955338963192
			w	251.75616000000036
			h	83.22175757174091
			type	"roundrectangle"
			fill	"#FF99FF"
			hasOutline	0
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
		target	2
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
					x	198.67857142857142
					y	54.9577840112202
				]
				point
				[
					x	288.01786644345236
					y	183.6167398974404
				]
				point
				[
					x	416.59282349206336
					y	183.6167398974404
				]
				point
				[
					x	515.1670634920634
					y	263.9001115664446
				]
			]
		]
		edgeAnchor
		[
			xSource	0.5000000000000001
			ySource	1.0
			xTarget	-0.5
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
			x	275.3440245741556
			y	141.9780680224404
		]
	]
	edge
	[
		source	1
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
					x	505.15714285714284
					y	54.9577840112202
				]
				point
				[
					x	554.0571428571428
					y	115.2411556802244
				]
				point
				[
					x	583.8992063492063
					y	115.2411556802244
				]
				point
				[
					x	583.8992063492063
					y	169.2661539599404
				]
				point
				[
					x	613.7413034920635
					y	169.2661539599404
				]
				point
				[
					x	515.1670634920634
					y	263.9001115664446
				]
			]
		]
		edgeAnchor
		[
			xSource	0.5
			ySource	1.0
			xTarget	0.4999999999999997
			yTarget	-1.0
		]
	]
	edge
	[
		source	2
		target	4
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
					x	515.1670634920634
					y	263.9001115664446
				]
				point
				[
					x	613.7412791418651
					y	367.88465511044876
				]
				point
				[
					x	632.9572293755876
					y	367.88465511044876
				]
				point
				[
					x	756.7960317460318
					y	444.4955338963192
				]
			]
		]
		edgeAnchor
		[
			xSource	0.4999999999999997
			ySource	0.9999999999999993
			xTarget	-0.5000000000000001
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
			x	601.0674574205906
			y	333.74598323544876
		]
	]
	edge
	[
		source	3
		target	4
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.49999999999999967
			yTarget	-1.0
		]
	]
	edge
	[
		source	6
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
	edge
	[
		source	0
		target	7
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
					x	198.67857142857142
					y	54.9577840112202
				]
				point
				[
					x	109.33928571428571
					y	353.53406917294876
				]
				point
				[
					x	219.09953396825387
					y	353.53406917294876
				]
				point
				[
					x	303.018253968254
					y	444.4955338963192
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
			text	"1"
			fontSize	12
			fontName	"Dialog"
			configuration	"AutoFlippingLabel"
			contentWidth	10.673828125
			contentHeight	18.701171875
			model	"side_slider"
			x	96.66546424461322
			y	226.9367326601946
		]
	]
	edge
	[
		source	1
		target	7
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
					x	505.15714285714284
					y	54.9577840112202
				]
				point
				[
					x	456.25714285714287
					y	124.9155680224404
				]
				point
				[
					x	303.018253968254
					y	124.9155680224404
				]
				point
				[
					x	303.018253968254
					y	444.4955338963192
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5
			ySource	1.0
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
			x	290.344425843254
			y	285.43601351651716
		]
	]
	edge
	[
		source	2
		target	7
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	515.1670634920634
					y	263.9001115664446
				]
				point
				[
					x	416.59285714285716
					y	353.53406917294876
				]
				point
				[
					x	386.9369739682541
					y	353.53406917294876
				]
				point
				[
					x	303.018253968254
					y	444.4955338963192
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5
			ySource	0.9999999999999993
			xTarget	0.6666666666666666
			yTarget	-1.0
		]
	]
]
