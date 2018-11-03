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
pipeline: @data.read_image"
		graphics
		[
			x	1063.3182539682539
			y	30.5
			w	178.0
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: frame_1
group: 1
pipeline: @data.read_image"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	1
		label	"label: preproc1
pipeline: @(image)preprocessing.subtract_background(image, 'background_scale', 20)"
		graphics
		[
			x	524.6384920634921
			y	279.5
			w	485.96736463512565
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: preproc1
pipeline: @(image)preprocessing.subtract_background(image, 'background_scale', 20)"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	2
		label	"label: detect1
pipeline: @(image)detection.single_threshold(image, 'threshold', 90, 'direction', 'object_above_threshold')"
		graphics
		[
			x	524.6384920634921
			y	468.5
			w	568.0989172215922
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: detect1
pipeline: @(image)detection.single_threshold(image, 'threshold', 90, 'direction', 'object_above_threshold')"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	3
		label	"label: store
pipeline: @(data_, datalink_)data.store_data(data_, datalink_, 'shadow_sizing')"
		graphics
		[
			x	290.8420634920635
			y	951.5
			w	441.01234855595965
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: store
pipeline: @(data_, datalink_)data.store_data(data_, datalink_, 'shadow_sizing')"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	4
		label	"label: phase1
pipeline: @preprocessing.spatial_filtering.extract_phase"
		graphics
		[
			x	1173.6126984126984
			y	279.5
			w	321.17707212055984
			h	77.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: phase1
pipeline: @preprocessing.spatial_filtering.extract_phase"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	5
		label	"label: measure1
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'pixelidxlist', 'equivdiameter', 'image:bulk_mean', 'phase:boundary_mean')"
		graphics
		[
			x	728.890873015873
			y	649.5
			w	817.0095263724434
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: measure1
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'pixelidxlist', 'equivdiameter', 'image:bulk_mean', 'phase:boundary_mean')"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	6
		label	"label: merge1
pipeline: @(image,phase)data.merge('mode', 'struct: image, phase', image, phase)"
		graphics
		[
			x	1067.359126984127
			y	468.5
			w	457.34181240714275
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: merge1
pipeline: @(image,phase)data.merge('mode', 'struct: image, phase', image, phase)"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	7
		label	"label: filter1
pipeline: @(props)filtering.filter_particles(props, {'image:bulk_mean', 'phase:boundary_mean'}, {@(x)x<50, @(x)x>0.1})"
		graphics
		[
			x	728.890873015873
			y	770.5
			w	646.3465909090908
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: filter1
pipeline: @(props)filtering.filter_particles(props, {'image:bulk_mean', 'phase:boundary_mean'}, {@(x)x<50, @(x)x>0.1})"
			fontSize	12
			fontName	"Dialog"
			anchor	"c"
		]
	]
	node
	[
		id	8
		label	"label: show
pipeline: @misc.show_detection"
		graphics
		[
			x	1347.4424603174602
			y	951.5
			w	187.03716663992088
			h	61.0
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
			anchor	"c"
		]
	]
	node
	[
		id	9
		label	"label: datalink
pipeline: @(~)data.create_datalink('datalink_', 'store_')"
		graphics
		[
			x	180.5888888888889
			y	30.5
			w	321.17707212055984
			h	61.0
			type	"rectangle"
			fill	"#FFCC00"
			outline	"#000000"
		]
		LabelGraphics
		[
			text	"label: datalink
pipeline: @(~)data.create_datalink('datalink_', 'store_')"
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
					x	1063.3182539682539
					y	30.5
				]
				point
				[
					x	996.5682539682539
					y	121.0
				]
				point
				[
					x	524.6384920634921
					y	121.0
				]
				point
				[
					x	524.6384920634921
					y	279.5
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.75
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
		source	0
		target	4
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	1063.3182539682539
					y	30.5
				]
				point
				[
					x	1085.5682539682539
					y	181.0
				]
				point
				[
					x	1173.6126984126984
					y	181.0
				]
				point
				[
					x	1173.6126984126984
					y	279.5
				]
			]
		]
		edgeAnchor
		[
			xSource	0.25
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	2
		target	5
		label	"1"
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
		]
		edgeAnchor
		[
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
			model	"six_pos"
			position	"tail"
		]
	]
	edge
	[
		source	4
		target	6
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	1173.6126984126984
					y	279.5
				]
				point
				[
					x	1173.6126984126984
					y	378.0
				]
				point
				[
					x	1181.6945800859128
					y	378.0
				]
				point
				[
					x	1067.359126984127
					y	468.5
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.5000000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	0
		target	6
		label	"1"
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	1063.3182539682539
					y	30.5
				]
				point
				[
					x	1041.0682539682539
					y	181.0
				]
				point
				[
					x	953.0238095238095
					y	181.0
				]
				point
				[
					x	1067.359126984127
					y	468.5
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.25
			ySource	1.0
			xTarget	-0.49999999999999994
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
			model	"six_pos"
			position	"tail"
		]
	]
	edge
	[
		source	6
		target	5
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	1067.359126984127
					y	468.5
				]
				point
				[
					x	1067.359126984127
					y	559.0
				]
				point
				[
					x	933.1432546089839
					y	559.0
				]
				point
				[
					x	728.890873015873
					y	649.5
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.5
			yTarget	-1.0
		]
	]
	edge
	[
		source	5
		target	7
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
		source	7
		target	3
		label	"1"
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	728.890873015873
					y	770.5
				]
				point
				[
					x	567.3042252886003
					y	861.0
				]
				point
				[
					x	401.0951506310534
					y	861.0
				]
				point
				[
					x	290.8420634920635
					y	951.5
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5
			ySource	1.0
			xTarget	0.4999999999999999
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
			model	"null"
			position	"null"
		]
	]
	edge
	[
		source	7
		target	8
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	728.890873015873
					y	770.5
				]
				point
				[
					x	890.4775207431458
					y	861.0
				]
				point
				[
					x	1300.68316865748
					y	861.0
				]
				point
				[
					x	1347.4424603174602
					y	951.5
				]
			]
		]
		edgeAnchor
		[
			xSource	0.5
			ySource	1.0
			xTarget	-0.5
			yTarget	-1.0
		]
	]
	edge
	[
		source	0
		target	8
		label	"1"
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
			Line
			[
				point
				[
					x	1063.3182539682539
					y	30.5
				]
				point
				[
					x	1130.0682539682539
					y	121.0
				]
				point
				[
					x	1394.2015873015873
					y	121.0
				]
				point
				[
					x	1347.4424603174602
					y	951.5
				]
			]
		]
		edgeAnchor
		[
			xSource	0.75
			ySource	1.0
			xTarget	0.4999999999999991
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
			model	"six_pos"
			position	"tail"
		]
	]
	edge
	[
		source	9
		target	3
		graphics
		[
			fill	"#000000"
			targetArrow	"standard"
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5
			yTarget	-1.0
		]
	]
]
