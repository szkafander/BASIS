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
			x	514.4134920634921
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
		label	"label: bg_sub_1
pipeline: @(image)preprocessing.subtract_background(image, 'background_scale', 20)

this subtracts the background and produces an inverted image.
the purpose is the normalization of particle images."
		graphics
		[
			x	1045.0345238095238
			y	352.4610098176719
			w	515.9673684795052
			h	92.91427769985981
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: bg_sub_1
pipeline: @(image)preprocessing.subtract_background(image, 'background_scale', 20)

this subtracts the background and produces an inverted image.
the purpose is the normalization of particle images."
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
		label	"label: detect_1
pipeline: @(image)detection.single_threshold(image, 'threshold', 90, 'direction', 'object_above_threshold')

this carries out binarization (detection) based on a single threshold. the threshold was set up manually, after
inspecting the inverted images. detection should not be very sensitive to this threshold."
		graphics
		[
			x	1045.0345238095238
			y	499.3752875175317
			w	696.3664067026579
			h	100.91427769985978
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: detect_1
pipeline: @(image)detection.single_threshold(image, 'threshold', 90, 'direction', 'object_above_threshold')

this carries out binarization (detection) based on a single threshold. the threshold was set up manually, after
inspecting the inverted images. detection should not be very sensitive to this threshold."
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
		label	"label: phase_1
pipeline: @preprocessing.spatial_filtering.extract_phase

this extracts monogenic image phase. phase is an intensity-independent
edge feature. the higher the phase at an edge, the better defined the edge.
phase is a reliable feature for filtering out out-of-focus particle images."
		graphics
		[
			x	335.0952380952381
			y	352.46100981767194
			w	485.9673646351257
			h	100.91427769985978
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: phase_1
pipeline: @preprocessing.spatial_filtering.extract_phase

this extracts monogenic image phase. phase is an intensity-independent
edge feature. the higher the phase at an edge, the better defined the edge.
phase is a reliable feature for filtering out out-of-focus particle images."
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
		label	"label: measure_1
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'eccentricity', ...
'pixelidxlist', 'equivdiameter', 'image:bulk_mean', 'phase:boundary_mean', 'centroid')

this measures binary object properties."
		graphics
		[
			x	903.0134920634921
			y	689.5777497151124
			w	568.0836357693579
			h	87.08830294530162
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: measure_1
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'eccentricity', ...
'pixelidxlist', 'equivdiameter', 'image:bulk_mean', 'phase:boundary_mean', 'centroid')

this measures binary object properties."
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
		label	"label: merge_1_1
pipeline: @(image,phase)data.merge('mode', 'struct: image, phase', image, phase)

this merges phase data with image intensity for passing into measurement.measure_particles"
		graphics
		[
			x	379.4813492063492
			y	499.3752875175317
			w	574.739175661
			h	92.91427769985978
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_1_1
pipeline: @(image,phase)data.merge('mode', 'struct: image, phase', image, phase)

this merges phase data with image intensity for passing into measurement.measure_particles"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	6
		label	"label: filter_1
pipeline: @(props)filtering.filter_particles(props, {'image:bulk_mean', 'phase:boundary_mean'}, {@(x)x<50, @(x)x>0.1})

this filters binary objects based on scalar criteria for each the mean intensity and mean of phase values over the boundary.
both are filtered based on a single threshold. thresholds were set manually, by inspecting the extracted properties."
		graphics
		[
			x	1078.8400793650794
			y	833.5790400376932
			w	777.8751182583196
			h	100.91427769985978
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: filter_1
pipeline: @(props)filtering.filter_particles(props, {'image:bulk_mean', 'phase:boundary_mean'}, {@(x)x<50, @(x)x>0.1})

this filters binary objects based on scalar criteria for each the mean intensity and mean of phase values over the boundary.
both are filtered based on a single threshold. thresholds were set manually, by inspecting the extracted properties."
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	7
		label	"label: frame_2
group: 2
pipeline: @data.read_image

we read the second frame"
		graphics
		[
			x	1623.0777777777778
			y	54.9577840112202
			w	178.0
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
		id	8
		label	"label: bg_sub_2
pipeline: @(image)preprocessing.subtract_background(image, 'background_scale', 20)"
		graphics
		[
			x	2139.824206349206
			y	352.4610098176719
			w	521.6213786603711
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: bg_sub_2
pipeline: @(image)preprocessing.subtract_background(image, 'background_scale', 20)"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	9
		label	"label: detect_2
pipeline: @(image)detection.single_threshold(image, ...
'threshold', 90, 'direction', 'object_above_threshold')"
		graphics
		[
			x	2139.824206349206
			y	499.3752875175317
			w	362.8709340518867
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: detect_2
pipeline: @(image)detection.single_threshold(image, ...
'threshold', 90, 'direction', 'object_above_threshold')"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	10
		label	"label: phase_2
pipeline: @preprocessing.spatial_filtering.extract_phase"
		graphics
		[
			x	1667.5777777777778
			y	352.4610098176719
			w	362.8709340518867
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: phase_2
pipeline: @preprocessing.spatial_filtering.extract_phase"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	11
		label	"label: measure_2
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, ...
'pixelidxlist', 'equivdiameter', 'image:bulk_mean', 'phase:boundary_mean', 'centroid')"
		graphics
		[
			x	1866.6055555555556
			y	689.5777497151124
			w	543.0823454467771
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: measure_2
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, ...
'pixelidxlist', 'equivdiameter', 'image:bulk_mean', 'phase:boundary_mean', 'centroid')"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	12
		label	"label: merge_2_1
pipeline: @(image,phase)data.merge('mode', 'struct: image, phase', image, phase)"
		graphics
		[
			x	1675.8031746031745
			y	499.3752875175317
			w	505.1703678068621
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_2_1
pipeline: @(image,phase)data.merge('mode', 'struct: image, phase', image, phase)"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	13
		label	"label: filter_2
pipeline: @(props)filtering.filter_particles(props, {'image:bulk_mean', 'phase:boundary_mean'}, {@(x)x<50, @(x)x>0.1})"
		graphics
		[
			x	1866.6055555555556
			y	833.5790400376931
			w	737.6556512176463
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: filter_2
pipeline: @(props)filtering.filter_particles(props, {'image:bulk_mean', 'phase:boundary_mean'}, {@(x)x<50, @(x)x>0.1})"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	14
		label	"label: denoise_1
pipeline: @preprocessing.anisotropic_diffusion

this denoises the shadowgraph by preserving edges."
		graphics
		[
			x	603.7527777777777
			y	213.4597194950912
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
		id	15
		label	"label: denoise_2
pipeline: @preprocessing.anisotropic_diffusion"
		graphics
		[
			x	1667.5777777777776
			y	213.4597194950912
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
		id	16
		label	"label: match
pipeline: @(props_1, props_2)matching.match_particles(props_1, props_2, ...
'descriptors', {'equivdiameter'}, ...
'constrained_descriptors', {'equivdiameter', 'image__bulk_mean'}, ...
'criteria', {@(x,y)data.similarity(x,y)<0.1, @(x,y)data.similarity(x,y)<0.1})

this matches object images between the two frames based on pre-defined criteria.
criteria have been manually set. they basically mean a maximum prescribed 10%
relative difference between the equivalent diameter and mean intensity features."
		graphics
		[
			x	1732.6313492063491
			y	1081.795724825123
			w	535.8969600000003
			h	146.81791999999996
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: match
pipeline: @(props_1, props_2)matching.match_particles(props_1, props_2, ...
'descriptors', {'equivdiameter'}, ...
'constrained_descriptors', {'equivdiameter', 'image__bulk_mean'}, ...
'criteria', {@(x,y)data.similarity(x,y)<0.1, @(x,y)data.similarity(x,y)<0.1})

this matches object images between the two frames based on pre-defined criteria.
criteria have been manually set. they basically mean a maximum prescribed 10%
relative difference between the equivalent diameter and mean intensity features."
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	17
		label	"label: show
pipeline: @techniques.shadow.show_matching

this shows the detection and matching result"
		graphics
		[
			x	177.1861111111111
			y	1270.6618236750528
			w	314.3717582583197
			h	80.18851769985974
			type	"roundrectangle"
			fill	"#FF99FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: show
pipeline: @techniques.shadow.show_matching

this shows the detection and matching result"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	18
		label	"label: store
pipeline: @(data_, datalink_)data.store_data(data_, datalink_, 'shadow_demo')

this stores data in the in-memory Store called 'store_'"
		graphics
		[
			x	2458.9373015873016
			y	1917.3972809578925
			w	501.7910292923473
			h	83.22175757174091
			type	"roundrectangle"
			fill	"#7FFF7F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: store
pipeline: @(data_, datalink_)data.store_data(data_, datalink_, 'shadow_demo')

this stores data in the in-memory Store called 'store_'"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	19
		label	"label: datalink
pipeline: @(~)data.create_datalink('datalink_', 'store_')

a helper node that initializes a DataLink in the workspace if there isn't one"
		graphics
		[
			x	2853.425793650794
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
		id	20
		label	"label: params_shadow_demo
pipeline: @(~)data.load_parameter([get_basis_path '..\data\other\shadow_demo.mat'])

this node reads the constants required for downstream computation. check the file loaded
here to see its contents in Matlab."
		graphics
		[
			x	2285.522290123623
			y	54.9577840112202
			w	580.4517975725662
			h	100.61382424800865
			type	"roundrectangle"
			fill	"#7FFF7F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: params_shadow_demo
pipeline: @(~)data.load_parameter([get_basis_path '..\data\other\shadow_demo.mat'])

this node reads the constants required for downstream computation. check the file loaded
here to see its contents in Matlab."
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	21
		label	"label: velocities
pipeline: @techniques.shadow.calculate_velocities

this calculates particle velocities in physical dimensions"
		graphics
		[
			x	2074.373015873016
			y	1270.6618236750528
			w	384.95275354838736
			h	100.91427769985967
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: velocities
pipeline: @techniques.shadow.calculate_velocities

this calculates particle velocities in physical dimensions"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	22
		label	"label: shapes
pipeline: @(props_, matching)data.select(props_, 'eccentricity')

this selects eccentricity from matched properties"
		graphics
		[
			x	1706.9571428571428
			y	1468.2112300801011
			w	427.82340001351804
			h	100.91427769985967
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: shapes
pipeline: @(props_, matching)data.select(props_, 'eccentricity')

this selects eccentricity from matched properties"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	23
		label	"label: matched_props
pipeline: matched_props <- @(props_, matching)props_(matching.ind_1,:)

this reorders properties from the first frame based on matching"
		graphics
		[
			x	1618.877380952381
			y	1270.6618236750528
			w	455.0162442210917
			h	100.91427769985967
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: matched_props
pipeline: matched_props <- @(props_, matching)props_(matching.ind_1,:)

this reorders properties from the first frame based on matching"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	24
		label	"label: diameters
pipeline: @techniques.shadow.calculate_diameters
this calculates diameters in physical dimension from pixel diameters"
		graphics
		[
			x	2316.881349206349
			y	1468.2112300801011
			w	455.0162442210917
			h	76.782191360237
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: diameters
pipeline: @techniques.shadow.calculate_diameters
this calculates diameters in physical dimension from pixel diameters"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	25
		label	"label: merge_final
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:shape')

the final merger node that merges particle velocity, diameter and shape"
		graphics
		[
			x	2078.747023809524
			y	1745.5521506471964
			w	467.52141369228156
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_final
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:shape')

the final merger node that merges particle velocity, diameter and shape"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	26
		label	"label: merge_velocity_and_diameter
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')

merges diameter and velocity"
		graphics
		[
			x	2195.6271825396825
			y	1593.1354054100452
			w	427.823400013518
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_velocity_and_diameter
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')

merges diameter and velocity"
			fontSize	10
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
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
		target	4
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
			x	1032.3606223463732
			y	588.5824263674616
		]
	]
	edge
	[
		source	3
		target	5
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	335.0952380952381
					y	352.46100981767194
				]
				point
				[
					x	335.0952380952381
					y	417.9181486676018
				]
				point
				[
					x	235.7965552910992
					y	417.9181486676018
				]
				point
				[
					x	379.4813492063492
					y	499.3752875175317
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5
			yTarget	-1.0
		]
	]
	edge
	[
		source	5
		target	4
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	379.4813492063492
					y	499.3752875175317
				]
				point
				[
					x	379.4813492063492
					y	611.0335982424616
				]
				point
				[
					x	760.9925831211526
					y	611.0335982424616
				]
				point
				[
					x	903.0134920634921
					y	689.5777497151124
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5
			yTarget	-1.0
		]
	]
	edge
	[
		source	4
		target	6
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	903.0134920634921
					y	689.5777497151124
				]
				point
				[
					x	903.0134920634921
					y	748.1219011877632
				]
				point
				[
					x	1078.8400793650794
					y	748.1219011877632
				]
				point
				[
					x	1078.8400793650794
					y	833.5790400376932
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	8
		target	9
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
		source	9
		target	11
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
					x	2139.824206349206
					y	499.3752875175317
				]
				point
				[
					x	2139.8242156498018
					y	603.5335982424616
				]
				point
				[
					x	2002.37614191725
					y	603.5335982424616
				]
				point
				[
					x	1866.6055555555556
					y	689.5777497151124
				]
			]
		]
		edgeAnchor
		[
			ySource	0.9999999999999981
			xTarget	0.5000000000000001
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
			x	2127.150382269928
			y	561.9163569424966
		]
	]
	edge
	[
		source	10
		target	12
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1667.5777777777778
					y	352.4610098176719
				]
				point
				[
					x	1667.5777777777778
					y	397.9610098176719
				]
				point
				[
					x	1802.0957665548901
					y	397.9610098176719
				]
				point
				[
					x	1675.8031746031745
					y	499.3752875175317
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
		source	12
		target	11
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1675.8031746031745
					y	499.3752875175317
				]
				point
				[
					x	1675.8031746031745
					y	611.0335982424616
				]
				point
				[
					x	1730.8349691938613
					y	611.0335982424616
				]
				point
				[
					x	1866.6055555555556
					y	689.5777497151124
				]
			]
		]
		edgeAnchor
		[
			ySource	0.9999999999999981
			xTarget	-0.5000000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	11
		target	13
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
		target	14
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
		source	14
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
					x	603.7527777777777
					y	213.4597194950912
				]
				point
				[
					x	603.752787078373
					y	417.9181486676018
				]
				point
				[
					x	523.1661431215991
					y	417.9181486676018
				]
				point
				[
					x	379.4813492063492
					y	499.3752875175317
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0000000000000007
			xTarget	0.4999999999999998
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
			x	591.0789549734176
			y	349.0589371082794
		]
	]
	edge
	[
		source	14
		target	3
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	603.7527777777777
					y	213.4597194950912
				]
				point
				[
					x	492.95150628233137
					y	272.00387096774205
				]
				point
				[
					x	335.0952380952381
					y	272.00387096774205
				]
				point
				[
					x	335.0952380952381
					y	352.46100981767194
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.6666666666666666
			ySource	1.0000000000000007
			yTarget	-1.0
		]
	]
	edge
	[
		source	14
		target	1
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	603.7527777777777
					y	213.4597194950912
				]
				point
				[
					x	714.5540492732241
					y	272.00387096774205
				]
				point
				[
					x	1045.0345238095238
					y	272.00387096774205
				]
				point
				[
					x	1045.0345238095238
					y	352.4610098176719
				]
			]
		]
		edgeAnchor
		[
			xSource	0.6666666666666666
			ySource	1.0000000000000007
			yTarget	-0.9999999999999997
		]
	]
	edge
	[
		source	7
		target	15
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
		source	15
		target	12
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
					x	1667.5777777777776
					y	213.4597194950912
				]
				point
				[
					x	1556.7765062823312
					y	258.95971949509124
				]
				point
				[
					x	1471.1420634920635
					y	258.95971949509124
				]
				point
				[
					x	1471.1420727926588
					y	397.9610098176719
				]
				point
				[
					x	1549.510582651459
					y	397.9610098176719
				]
				point
				[
					x	1675.8031746031745
					y	499.3752875175317
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.6666666666666666
			ySource	1.0
			xTarget	-0.5000000000000004
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
			x	1458.4682407109583
			y	338.8264651268116
		]
	]
	edge
	[
		source	15
		target	10
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
		source	15
		target	8
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1667.5777777777776
					y	213.4597194950912
				]
				point
				[
					x	1778.379049273224
					y	258.95971949509124
				]
				point
				[
					x	2139.824206349206
					y	258.95971949509124
				]
				point
				[
					x	2139.824206349206
					y	352.4610098176719
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
	edge
	[
		source	6
		target	16
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
					x	1078.8400793650794
					y	833.5790400376932
				]
				point
				[
					x	1176.0746124751984
					y	973.386764825123
				]
				point
				[
					x	1598.657109206349
					y	973.386764825123
				]
				point
				[
					x	1732.6313492063491
					y	1081.795724825123
				]
			]
		]
		edgeAnchor
		[
			xSource	0.25000000000000017
			ySource	0.9999999999999989
			xTarget	-0.4999999999999998
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
			x	1163.4006811348152
			y	909.0422824032481
		]
	]
	edge
	[
		source	13
		target	16
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.4999999999999998
			yTarget	-1.0
		]
	]
	edge
	[
		source	0
		target	17
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
					x	514.4134920634921
					y	54.9577840112202
				]
				point
				[
					x	425.07422137625497
					y	124.9155680224404
				]
				point
				[
					x	51.43730158730159
					y	124.9155680224404
				]
				point
				[
					x	177.1861111111111
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5
			ySource	1.0
			xTarget	-0.7999999999999999
			yTarget	-1.0000000000000013
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
			x	38.76351490039923
			y	556.2458979935135
		]
	]
	edge
	[
		source	7
		target	17
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
					x	1623.0777777777778
					y	54.9577840112202
				]
				point
				[
					x	1578.5777777777778
					y	154.9155680224404
				]
				point
				[
					x	77.11150793650793
					y	154.9155680224404
				]
				point
				[
					x	77.11150793650793
					y	1096.795724825123
				]
				point
				[
					x	114.31175945944716
					y	1096.795724825123
				]
				point
				[
					x	177.1861111111111
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5
			ySource	1.0
			xTarget	-0.4
			yTarget	-1.0000000000000013
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
			x	64.4376798115079
			y	616.5050604862816
		]
	]
	edge
	[
		source	6
		target	17
		label	"3"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1078.8400793650794
					y	833.5790400376932
				]
				point
				[
					x	787.1369100182096
					y	899.036178887623
				]
				point
				[
					x	177.1861111111111
					y	899.036178887623
				]
				point
				[
					x	177.1861111111111
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.7499999999999999
			ySource	0.9999999999999989
			yTarget	-1.0000000000000013
		]
		LabelGraphics
		[
			text	"3"
			fontSize	12
			fontName	"Dialog"
			configuration	"AutoFlippingLabel"
			contentWidth	10.673828125
			contentHeight	18.701171875
			model	"side_slider"
			x	164.51228298611113
			y	1013.1756341610603
		]
	]
	edge
	[
		source	13
		target	17
		label	"4"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1866.6055555555556
					y	833.5790400376931
				]
				point
				[
					x	1620.720238095238
					y	943.386764825123
				]
				point
				[
					x	240.0603267609127
					y	943.386764825123
				]
				point
				[
					x	177.1861111111111
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.6666666666666667
			ySource	1.0
			xTarget	0.4
			yTarget	-1.0000000000000013
		]
		LabelGraphics
		[
			text	"4"
			fontSize	12
			fontName	"Dialog"
			configuration	"AutoFlippingLabel"
			contentWidth	10.673828125
			contentHeight	18.701171875
			model	"side_slider"
			x	227.38658616442467
			y	1128.211499200123
		]
	]
	edge
	[
		source	16
		target	17
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1732.6313492063491
					y	1081.795724825123
				]
				point
				[
					x	1553.999029206349
					y	1170.204684825123
				]
				point
				[
					x	302.93481441443896
					y	1170.204684825123
				]
				point
				[
					x	177.1861111111111
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.6666666666666667
			ySource	1.0
			xTarget	0.8
			yTarget	-1.0
		]
	]
	edge
	[
		source	19
		target	18
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2853.425793650794
					y	54.9577840112202
				]
				point
				[
					x	2853.425793650794
					y	1826.435816234522
				]
				point
				[
					x	2584.3850589103886
					y	1826.435816234522
				]
				point
				[
					x	2458.9373015873016
					y	1917.3972809578925
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.5000000000000007
			yTarget	-1.0
		]
	]
	edge
	[
		source	6
		target	21
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
					x	1078.8400793650794
					y	833.5790400376932
				]
				point
				[
					x	1370.543253968254
					y	958.386764825123
				]
				point
				[
					x	2026.2539775545636
					y	958.386764825123
				]
				point
				[
					x	2074.373015873016
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	0.7499999999999999
			ySource	0.9999999999999989
			xTarget	-0.24999999999999956
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
			x	2013.5801328476384
			y	1017.3847018563729
		]
	]
	edge
	[
		source	13
		target	21
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
					x	1866.6055555555556
					y	833.5790400376931
				]
				point
				[
					x	2112.4908823164683
					y	1170.204684825123
				]
				point
				[
					x	2122.4921100665642
					y	1170.204684825123
				]
				point
				[
					x	2074.373015873016
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	0.6666666666666667
			ySource	1.0
			xTarget	0.24999999999999956
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
			x	2099.8170400607887
			y	1130.7678363135208
		]
	]
	edge
	[
		source	20
		target	21
		label	"3"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2285.522290123623
					y	54.9577840112202
				]
				point
				[
					x	2140.4092728290807
					y	120.26469613522453
				]
				point
				[
					x	2415.6349206349205
					y	120.26469613522453
				]
				point
				[
					x	2415.6349206349205
					y	1096.795724825123
				]
				point
				[
					x	2218.730298453661
					y	1096.795724825123
				]
				point
				[
					x	2074.373015873016
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5000000000000004
			ySource	1.0
			xTarget	0.7499999999999987
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"3"
			fontSize	12
			fontName	"Dialog"
			configuration	"AutoFlippingLabel"
			contentWidth	10.673828125
			contentHeight	18.701171875
			model	"side_slider"
			x	2402.9610925099205
			y	599.1796245426738
		]
	]
	edge
	[
		source	6
		target	23
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
					x	1078.8400793650794
					y	833.5790400376932
				]
				point
				[
					x	981.6055648561507
					y	1185.204684825123
				]
				point
				[
					x	1505.123319897108
					y	1185.204684825123
				]
				point
				[
					x	1618.877380952381
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.25000000000000017
			ySource	0.9999999999999989
			xTarget	-0.4999999999999995
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
			x	968.9318013592115
			y	1010.4507506286945
		]
	]
	edge
	[
		source	16
		target	23
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
			yTarget	-1.0
		]
	]
	edge
	[
		source	23
		target	24
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
					x	1618.877380952381
					y	1270.6618236750528
				]
				point
				[
					x	1732.6313585069445
					y	1394.8201343999826
				]
				point
				[
					x	2203.1272881510763
					y	1394.8201343999826
				]
				point
				[
					x	2316.881349206349
					y	1468.2112300801011
				]
			]
		]
		edgeAnchor
		[
			xSource	0.4999999999999995
			ySource	1.0
			xTarget	-0.4999999999999995
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
			x	1719.957556369286
			y	1353.1814625249826
		]
	]
	edge
	[
		source	20
		target	24
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			xSource	0.5000000000000004
			ySource	1.0
			xTarget	0.4999999999999995
			yTarget	-1.0
		]
	]
	edge
	[
		source	22
		target	25
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1706.9571428571428
					y	1468.2112300801011
				]
				point
				[
					x	1706.9571428571428
					y	1674.0190709973708
				]
				point
				[
					x	1961.8666703864535
					y	1674.0190709973708
				]
				point
				[
					x	2078.747023809524
					y	1745.5521506471964
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.49999999999999983
			yTarget	-1.0
		]
	]
	edge
	[
		source	25
		target	18
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
					x	2078.747023809524
					y	1745.5521506471964
				]
				point
				[
					x	2078.747033110119
					y	1840.786402172022
				]
				point
				[
					x	2333.4895442642146
					y	1840.786402172022
				]
				point
				[
					x	2458.9373015873016
					y	1917.3972809578925
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5000000000000007
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
			x	2066.073199576199
			y	1806.647730297022
		]
	]
	edge
	[
		source	23
		target	22
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1618.877380952381
					y	1270.6618236750528
				]
				point
				[
					x	1505.123319897108
					y	1336.1189625249826
				]
				point
				[
					x	1706.9571428571428
					y	1336.1189625249826
				]
				point
				[
					x	1706.9571428571428
					y	1468.2112300801011
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.4999999999999995
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	24
		target	26
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2316.881349206349
					y	1468.2112300801011
				]
				point
				[
					x	2316.881349206349
					y	1521.6023257602196
				]
				point
				[
					x	2302.583032543062
					y	1521.6023257602196
				]
				point
				[
					x	2195.6271825396825
					y	1593.1354054100452
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.49999999999999994
			yTarget	-1.0
		]
	]
	edge
	[
		source	21
		target	26
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2074.373015873016
					y	1270.6618236750528
				]
				point
				[
					x	2074.373015873016
					y	1521.6023257602196
				]
				point
				[
					x	2088.671332536303
					y	1521.6023257602196
				]
				point
				[
					x	2195.6271825396825
					y	1593.1354054100452
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5000000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	26
		target	25
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
			xTarget	0.5000000000000008
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
			x	2182.953428818739
			y	1659.9931920911208
		]
	]
	edge
	[
		source	16
		target	21
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1732.6313492063491
					y	1081.795724825123
				]
				point
				[
					x	1911.2636692063493
					y	1170.204684825123
				]
				point
				[
					x	1930.0157332923707
					y	1170.204684825123
				]
				point
				[
					x	2074.373015873016
					y	1270.6618236750528
				]
			]
		]
		edgeAnchor
		[
			xSource	0.6666666666666667
			ySource	1.0
			xTarget	-0.75
			yTarget	-1.0
		]
	]
]
