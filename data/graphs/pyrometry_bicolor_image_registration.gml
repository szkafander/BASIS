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

this reads the first frame, which in this
case is the first color channel. imaging was
done on a single sensor using a beam
splitter. one half of the sensor recorded one
color, the other half a second color."
		graphics
		[
			x	173.0
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

this reads the first frame, which in this
case is the first color channel. imaging was
done on a single sensor using a beam
splitter. one half of the sensor recorded one
color, the other half a second color."
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

the second frame representing the 
second color."
		graphics
		[
			x	472.0
			y	70.0
			w	232.0
			h	101.0
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

the second frame representing the 
second color."
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
		label	"label: register
pipeline: @(image, transformation_matrix)preprocessing.transform_image(image, transformation_matrix)

this registers the two color channels. registration in this case means that the pixels of the two channels are
overlaid and cast into a color image. this way indexing into the first two dimensions of the color image can
access both color channels. this is necessary to carry out pixelwise operations on color images, such as
pyrometry."
		graphics
		[
			x	645.75
			y	271.3505859375
			w	695.0
			h	114.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: register
pipeline: @(image, transformation_matrix)preprocessing.transform_image(image, transformation_matrix)

this registers the two color channels. registration in this case means that the pixels of the two channels are
overlaid and cast into a color image. this way indexing into the first two dimensions of the color image can
access both color channels. this is necessary to carry out pixelwise operations on color images, such as
pyrometry."
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
		label	"label: show
pipeline: @(image_1, image_2)imshowpair(image_1, image_2, 'scaling', 'independent', 'colorchannels', [2 1 1])

plots the registered color image. hues of red show the intensity of the first channel and hues of cyan show the
intensity of the second channel. notice that the root of the flame has more intensity in the second channel as the rest.
this is because low-wavelength radiation is more intense there due to higher temperature and flame radicals."
		graphics
		[
			x	426.9166666666667
			y	432.8505859375
			w	752.3333333333333
			h	109.0
			type	"roundrectangle"
			fill	"#FF99FF"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: show
pipeline: @(image_1, image_2)imshowpair(image_1, image_2, 'scaling', 'independent', 'colorchannels', [2 1 1])

plots the registered color image. hues of red show the intensity of the first channel and hues of cyan show the
intensity of the second channel. notice that the root of the flame has more intensity in the second channel as the rest.
this is because low-wavelength radiation is more intense there due to higher temperature and flame radicals."
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
		label	"label: transformation_matrix
pipeline: @(~)data.load_parameter([get_basis_path '..\data\other\transformation_matrix.mat'])

this loads data required for registration. the loaded data contains the transformation
matrix that is used to transform the image. this matrix has been obtained using Matlab's
image registration routine."
		graphics
		[
			x	913.1666666666666
			y	70.0
			w	590.3333333333333
			h	114.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: transformation_matrix
pipeline: @(~)data.load_parameter([get_basis_path '..\data\other\transformation_matrix.mat'])

this loads data required for registration. the loaded data contains the transformation
matrix that is used to transform the image. this matrix has been obtained using Matlab's
image registration routine."
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
			x	459.326171875
			y	158.07470703125
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
					x	913.1666666666666
					y	70.0
				]
				point
				[
					x	913.1666666666666
					y	179.3505859375
				]
				point
				[
					x	819.5
					y	179.3505859375
				]
				point
				[
					x	645.75
					y	271.3505859375
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
		source	2
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
					x	645.75
					y	271.3505859375
				]
				point
				[
					x	645.75
					y	343.3505859375
				]
				point
				[
					x	615.0
					y	343.3505859375
				]
				point
				[
					x	426.9166666666667
					y	432.8505859375
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
		target	3
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
					x	173.0
					y	70.0
				]
				point
				[
					x	173.00000930059522
					y	300.701171875
				]
				point
				[
					x	238.83333333333337
					y	300.701171875
				]
				point
				[
					x	426.9166666666667
					y	432.8505859375
				]
			]
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
			model	"side_slider"
			x	160.32617908858774
			y	264.640625
		]
	]
]
