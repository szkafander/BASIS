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

this node reads the image"
		graphics
		[
			x	589.3809523809524
			y	50.30691212400433
			w	178.0
			h	69.53466368826696
			type	"roundrectangle"
			fill	"#7FFF7F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: frame_1
pipeline: @data.read_image

this node reads the image"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	1
		label	"label: split_1
pipeline: @techniques.streak.split_stereo_pair

this node splits the single-sensor stereo image pair into
two separate images. this is needed to be consistent with
input arguments of upstream functions."
		graphics
		[
			x	1177.3265873015873
			y	778.0861726450773
			w	335.28138732061046
			h	98.21295587793156
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: split_1
pipeline: @techniques.streak.split_stereo_pair

this node splits the single-sensor stereo image pair into
two separate images. this is needed to be consistent with
input arguments of upstream functions."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	2
		label	"label: resize_1
pipeline: resized <- @imresize

this resizes the image by the factor stored in the &quot;resize&quot;
parameter in the &quot;misc&quot; field. see streak_calibration.m for
details. in brief, we resized images during calibration, so
we must do the same here to stay consistent."
		graphics
		[
			x	676.9027777777778
			y	428.83737194065935
			w	350.08654180968
			h	105.3904547603014
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: resize_1
pipeline: resized <- @imresize

this resizes the image by the factor stored in the &quot;resize&quot;
parameter in the &quot;misc&quot; field. see streak_calibration.m for
details. in brief, we resized images during calibration, so
we must do the same here to stay consistent."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	3
		label	"label: rectify_1
pipeline: @techniques.streak.rectify_stereo_pair

rectification is an affine transformation based on stereo calibration
that aligns images along epipolar lines. after rectification, feature
matching reduces to a search along the epipolar lines. this is more
efficient than searching along lines under a perspective transformation."
		graphics
		[
			x	1281.9468253968255
			y	914.8878678233946
			w	418.48099294415033
			h	105.3904547603014
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: rectify_1
pipeline: @techniques.streak.rectify_stereo_pair

rectification is an affine transformation based on stereo calibration
that aligns images along epipolar lines. after rectification, feature
matching reduces to a search along the epipolar lines. this is more
efficient than searching along lines under a perspective transformation."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	4
		label	"label: green_2
pipeline: @(x)data.select(x, 2)"
		graphics
		[
			x	749.7726190476191
			y	1235.6687773439976
			w	195.07237848035174
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: green_2
pipeline: @(x)data.select(x, 2)"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	5
		label	"label: green_1
pipeline: @(x)data.select(x, 2)

we select the green channel, as it has the best
signal-to-noise and streak-to-background ratios"
		graphics
		[
			x	1835.6777777777777
			y	1235.6687773439976
			w	289.87990237270924
			h	80.67756141399354
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: green_1
pipeline: @(x)data.select(x, 2)

we select the green channel, as it has the best
signal-to-noise and streak-to-background ratios"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	6
		label	"label: detect_1
pipeline: @techniques.streak.detect_streaks

this detects streak candidate objects in a single view.
for details, see function implementation in the pipeline.
the returned output is a binary image."
		graphics
		[
			x	2054.5535714285716
			y	1388.702785431145
			w	335.2813873206105
			h	105.39045476030128
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: detect_1
pipeline: @techniques.streak.detect_streaks

this detects streak candidate objects in a single view.
for details, see function implementation in the pipeline.
the returned output is a binary image."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	7
		label	"label: detect_2
pipeline: @techniques.streak.detect_streaks"
		graphics
		[
			x	1250.3626984126981
			y	1388.702785431145
			w	262.20454559783343
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: detect_2
pipeline: @techniques.streak.detect_streaks"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	8
		label	"label: coherence_1
pipeline: @preprocessing.spatial_filtering.extract_coherence

coherence is an image feature that highlights regions in which
features are oriented along a single gradient direction. streaks
are such features. we use coherence to filter the output of detect_1."
		graphics
		[
			x	1644.4460317460318
			y	1388.702785431145
			w	404.9315623724156
			h	105.39045476030128
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: coherence_1
pipeline: @preprocessing.spatial_filtering.extract_coherence

coherence is an image feature that highlights regions in which
features are oriented along a single gradient direction. streaks
are such features. we use coherence to filter the output of detect_1."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	9
		label	"label: coherence_2
pipeline: @preprocessing.spatial_filtering.extract_coherence"
		graphics
		[
			x	914.8246031746032
			y	1388.702785431145
			w	348.87146128823906
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: coherence_2
pipeline: @preprocessing.spatial_filtering.extract_coherence"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	10
		label	"label: measure_1
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'pixelidxlist', 'centroid', ...
'orientation', 'area', 'image', 'majoraxislength', 'minoraxislength', 'image:bulk_mean', 'coherence:bulk_mean')

this measures underlying image features based on which we filter the streak detections. measurement and calculation
function generally work with table inputs and return table outputs."
		graphics
		[
			x	1889.8190476190475
			y	1670.0932401914465
			w	658.9378157012635
			h	105.39045476030128
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: measure_1
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'pixelidxlist', 'centroid', ...
'orientation', 'area', 'image', 'majoraxislength', 'minoraxislength', 'image:bulk_mean', 'coherence:bulk_mean')

this measures underlying image features based on which we filter the streak detections. measurement and calculation
function generally work with table inputs and return table outputs."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	11
		label	"label: merge_1_a
pipeline: @(image_, coherence)data.merge(image_, coherence, 'mode', 'struct: image, coherence')"
		graphics
		[
			x	1735.6357142857146
			y	1536.8980128112955
			w	545.1075794621026
			h	61.0
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_1_a
pipeline: @(image_, coherence)data.merge(image_, coherence, 'mode', 'struct: image, coherence')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	12
		label	"label: merge_2
pipeline: @(image_, coherence)data.merge(image_, coherence, 'mode', 'struct: image, coherence')"
		graphics
		[
			x	949.7912698412698
			y	1536.8980128112955
			w	545.1075794621026
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_2
pipeline: @(image_, coherence)data.merge(image_, coherence, 'mode', 'struct: image, coherence')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	13
		label	"label: measure_2
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'pixelidxlist', 'centroid', ...
'orientation', 'area', 'image', 'majoraxislength', 'minoraxislength', 'image:bulk_mean', 'coherence:bulk_mean')"
		graphics
		[
			x	1068.827380952381
			y	1670.0932401914463
			w	636.3028797632439
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: measure_2
pipeline: @(image, scalars)measurement.measure_particles(image, scalars, 'pixelidxlist', 'centroid', ...
'orientation', 'area', 'image', 'majoraxislength', 'minoraxislength', 'image:bulk_mean', 'coherence:bulk_mean')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	14
		label	"label: filter_1
pipeline: @(props_)filtering.filter_particles(props_, {'coherence:bulk_mean', 'elongation', ...
'image:bulk_mean', 'majoraxislength', 'area'}, {@(x)x>0.3, @(x)x>2, @(x)x>20, @(x)x>10, @(x)x>100})

we filter all candidate binary objects based on the above properties. this returns binary objects that
are very streak-like."
		graphics
		[
			x	1796.9829365079365
			y	2071.293082038218
			w	589.6381064502621
			h	94.22845918105486
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: filter_1
pipeline: @(props_)filtering.filter_particles(props_, {'coherence:bulk_mean', 'elongation', ...
'image:bulk_mean', 'majoraxislength', 'area'}, {@(x)x>0.3, @(x)x>2, @(x)x>20, @(x)x>10, @(x)x>100})

we filter all candidate binary objects based on the above properties. this returns binary objects that
are very streak-like."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	15
		label	"label: filter_2
pipeline: @(props_)filtering.filter_particles(props_, {'coherence:bulk_mean', 'elongation', ...
'image:bulk_mean', 'majoraxislength', 'area'}, {@(x)x>0.3, @(x)x>2, @(x)x>20, @(x)x>10, @(x)x>100})"
		graphics
		[
			x	990.1515873015873
			y	2071.293082038218
			w	559.1221745492933
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: filter_2
pipeline: @(props_)filtering.filter_particles(props_, {'coherence:bulk_mean', 'elongation', ...
'image:bulk_mean', 'majoraxislength', 'area'}, {@(x)x>0.3, @(x)x>2, @(x)x>20, @(x)x>10, @(x)x>100})"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	16
		label	"label: elongation_1
pipeline: elongation <- @(props_)props_.majoraxislength./props_.minoraxislength

we compute an additional feature, elongation, defined as the ratio of the best fit
ellipse axes. streaks are highly elongated objects, therefore this is a good feature
for filtering."
		graphics
		[
			x	1725.0845238095237
			y	1810.4836250675398
			w	488.00798384325617
			h	105.39045476030128
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: elongation_1
pipeline: elongation <- @(props_)props_.majoraxislength./props_.minoraxislength

we compute an additional feature, elongation, defined as the ratio of the best fit
ellipse axes. streaks are highly elongated objects, therefore this is a good feature
for filtering."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	17
		label	"label: merge_1_b
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:elongation')"
		graphics
		[
			x	1834.9972222222223
			y	1943.6788524476906
			w	439.65134682113705
			h	61.0
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_1_b
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:elongation')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	18
		label	"label: elongation_2
pipeline: elongation <- @(props_)props_.majoraxislength./props_.minoraxislength"
		graphics
		[
			x	909.7515873015873
			y	1810.48362506754
			w	452.7451292021366
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: elongation_2
pipeline: elongation <- @(props_)props_.majoraxislength./props_.minoraxislength"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	19
		label	"label: merge_2_b
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:elongation')"
		graphics
		[
			x	1019.6642857142856
			y	1943.6788524476906
			w	439.65134682113705
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_2_b
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:elongation')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	20
		label	"label: feret_diam_1
pipeline: feret_diams <- @(props_)measurement.calculate_feret_diameters(props_.image)

we compute an additional feature, the maximum Feret diameter of the filtered binary objects.
the Feret diameter will be used as an initial guess of the streak length. this node is placed
after filter_1 because the Feret diameter computation is a little expensive. this way, it only
has to be carried out on a reduced subset of candidate objects."
		graphics
		[
			x	1938.9400793650793
			y	2221.102539008896
			w	548.7327737662392
			h	105.39045476030151
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: feret_diam_1
pipeline: feret_diams <- @(props_)measurement.calculate_feret_diameters(props_.image)

we compute an additional feature, the maximum Feret diameter of the filtered binary objects.
the Feret diameter will be used as an initial guess of the streak length. this node is placed
after filter_1 because the Feret diameter computation is a little expensive. this way, it only
has to be carried out on a reduced subset of candidate objects."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	21
		label	"label: feret_diam_2
pipeline: feret_diams <- @(props_)measurement.calculate_feret_diameters(props_.image)"
		graphics
		[
			x	1126.175
			y	2221.102539008896
			w	521.6075009653783
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: feret_diam_2
pipeline: feret_diams <- @(props_)measurement.calculate_feret_diameters(props_.image)"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	22
		label	"label: merge_1_c
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:feret_diameter')"
		graphics
		[
			x	1767.584126984127
			y	2354.297766389047
			w	472.04306504713156
			h	61.0
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_1_c
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:feret_diameter')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	23
		label	"label: merge_2_c
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:feret_diameter')"
		graphics
		[
			x	1008.1642857142858
			y	2354.297766389047
			w	472.04306504713156
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_2_c
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:feret_diameter')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	24
		label	"label: streak_endpoints_1
pipeline: @techniques.streak.calculate_streak_endpoints

this node calculates 2D streak endpoints from binary object images
and their Feret diameters. these endpoints are preliminary until streaks
are refined after the matching step."
		graphics
		[
			x	1758.6964285714287
			y	2481.9119959795744
			w	418.99181026575013
			h	94.22845918105486
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: streak_endpoints_1
pipeline: @techniques.streak.calculate_streak_endpoints

this node calculates 2D streak endpoints from binary object images
and their Feret diameters. these endpoints are preliminary until streaks
are refined after the matching step."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	25
		label	"label: streak_intensities_1
pipeline: @techniques.streak.calculate_streak_intensities

this computes streak intensity profiles along a line that connects
streak endpoints. this (or a mean of this) is a preliminary feature
used in matching."
		graphics
		[
			x	1997.7166666666667
			y	2656.1404551606292
			w	397.4254313073365
			h	94.22845918105486
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: streak_intensities_1
pipeline: @techniques.streak.calculate_streak_intensities

this computes streak intensity profiles along a line that connects
streak endpoints. this (or a mean of this) is a preliminary feature
used in matching."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	26
		label	"label: streak_endpoints_2
pipeline: @techniques.streak.calculate_streak_endpoints"
		graphics
		[
			x	1008.1642857142858
			y	2481.9119959795744
			w	322.40112852188975
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: streak_endpoints_2
pipeline: @techniques.streak.calculate_streak_endpoints"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	27
		label	"label: streak_intensities_2
pipeline: @techniques.streak.calculate_streak_intensities"
		graphics
		[
			x	1243.647619047619
			y	2656.1404551606292
			w	336.6648202334075
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: streak_intensities_2
pipeline: @techniques.streak.calculate_streak_intensities"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	28
		label	"label: merge_1_d
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:intensity')"
		graphics
		[
			x	1664.323015873016
			y	2976.6749648972846
			w	444.685590954614
			h	61.0
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_1_d
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:intensity')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	29
		label	"label: merge_2_d
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:intensity')"
		graphics
		[
			x	1171.486507936508
			y	2976.6749648972846
			w	444.685590954614
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_2_d
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:columns:intensity')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	30
		label	"label: match_stereo
pipeline: @techniques.streak.match_streaks

this node matches streaks between rectified left and right views and
returns the indices of matched streaks. these indices are used in downstream
computation as an overall filter for detected streaks."
		graphics
		[
			x	1371.3944444444444
			y	3191.0038611844416
			w	444.685590954614
			h	100.07137297029931
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: match_stereo
pipeline: @techniques.streak.match_streaks

this node matches streaks between rectified left and right views and
returns the indices of matched streaks. these indices are used in downstream
computation as an overall filter for detected streaks."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	31
		label	"label: linearization_1
pipeline: @(image_, linearization_data)data.map(image_, linearization_data, 'mode', 'interpolation')

a linearization node is needed due to the raw image format that we are working with here. the .dng files
read by frame_1 are 16-bit data encoded into 12 bits by a nonlinear transformation. this node undoes that
transformation and obtains the linear data. without this reverse mapping, the counts-intensity curve is not
linear. since our calibration was done on linear data, we must linearize the read images here as well."
		graphics
		[
			x	943.4051587301587
			y	626.2844673259608
			w	605.4833249037597
			h	105.3904547603014
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: linearization_1
pipeline: @(image_, linearization_data)data.map(image_, linearization_data, 'mode', 'interpolation')

a linearization node is needed due to the raw image format that we are working with here. the .dng files
read by frame_1 are 16-bit data encoded into 12 bits by a nonlinear transformation. this node undoes that
transformation and obtains the linear data. without this reverse mapping, the counts-intensity curve is not
linear. since our calibration was done on linear data, we must linearize the read images here as well."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	32
		label	"label: params_streak_demo
pipeline: @(~)data.load_parameter([get_basis_path '..\data\other\streak_demo.mat'])

this node reads the constants required for downstream computation. check the file loaded
here to see its contents in Matlab. to understand the contents of the file, please see
the calibration tutorial &quot;streak_calibration.m&quot;"
		graphics
		[
			x	1094.7757936507937
			y	50.30691212400433
			w	508.63720979135996
			h	100.61382424800865
			type	"roundrectangle"
			fill	"#7FFF7F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: params_streak_demo
pipeline: @(~)data.load_parameter([get_basis_path '..\data\other\streak_demo.mat'])

this node reads the constants required for downstream computation. check the file loaded
here to see its contents in Matlab. to understand the contents of the file, please see
the calibration tutorial &quot;streak_calibration.m&quot;"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	33
		label	"pipeline: @(x)data.select(x, 'split')"
		graphics
		[
			x	968.4269841269843
			y	308.14214456050865
			w	222.69695925010535
			h	36.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"pipeline: @(x)data.select(x, 'split')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	34
		label	"pipeline: @(x)data.select(x, 'resize')"
		graphics
		[
			x	715.729761904762
			y	308.14214456050865
			w	222.69695925010535
			h	36.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"pipeline: @(x)data.select(x, 'resize')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	35
		label	"pipeline: @(x)data.select(x, 'misc')
"
		graphics
		[
			x	800.5908730158731
			y	213.61382424800865
			w	222.69695925010535
			h	36.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"pipeline: @(x)data.select(x, 'misc')
"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	36
		label	"pipeline: @(x)data.select(x, 'rectification_data')"
		graphics
		[
			x	1430.448015873016
			y	213.61382424800865
			w	305.67217546455674
			h	36.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"pipeline: @(x)data.select(x, 'rectification_data')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	37
		label	"pipeline: @(x)data.select(x, 'stereo_calibration')"
		graphics
		[
			x	413.0265873015873
			y	213.61382424800865
			w	305.67217546455674
			h	36.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"pipeline: @(x)data.select(x, 'stereo_calibration')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	38
		label	"pipeline: @(x)data.select(x, 'linearization_data')"
		graphics
		[
			x	1094.7757936507937
			y	213.61382424800865
			w	305.67217546455674
			h	36.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"pipeline: @(x)data.select(x, 'linearization_data')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	39
		label	"label: rgb_1
pipeline: @(x)data.select(x, 1)

this selects the first of the outputs of rectify_1
that is, the left-side RGB image. blue and red nodes
perform a set of symmetric operations, thus we only
annotate one side from now."
		graphics
		[
			x	2262.195634920635
			y	1070.278322583696
			w	335.2813873206104
			h	105.39045476030128
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: rgb_1
pipeline: @(x)data.select(x, 1)

this selects the first of the outputs of rectify_1
that is, the left-side RGB image. blue and red nodes
perform a set of symmetric operations, thus we only
annotate one side from now."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	40
		label	"label: rgb_2
pipeline: @(x)data.select(x, 2)

blue nodes are parts of a branch isomorphic with the group formed by red nodes.
for annotation, see the appropriate red node."
		graphics
		[
			x	637.2361111111111
			y	1070.2783225836959
			w	460.1755073583713
			h	85.31594694406897
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: rgb_2
pipeline: @(x)data.select(x, 2)

blue nodes are parts of a branch isomorphic with the group formed by red nodes.
for annotation, see the appropriate red node."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	41
		label	"label: streak_background_1
pipeline: @techniques.streak.estimate_streak_background

this node computes the streak background that is an approximation
of the image of the radiating soot cloud without the streaks. this
is used downstream when fitting streak models."
		graphics
		[
			x	2474.243650793651
			y	1235.6687773439976
			w	394.09571516754227
			h	105.39045476030128
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: streak_background_1
pipeline: @techniques.streak.estimate_streak_background

this node computes the streak background that is an approximation
of the image of the radiating soot cloud without the streaks. this
is used downstream when fitting streak models."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	42
		label	"label: streak_background_2
pipeline: @techniques.streak.estimate_streak_background"
		graphics
		[
			x	461.2138888888889
			y	1235.6687773439976
			w	322.0442092902548
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: streak_background_2
pipeline: @techniques.streak.estimate_streak_background"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	43
		label	"label: green_intensities_1
pipeline: @(x)data.select(x, 'intensity_green')

we select the strongest and most distinctive green
feature for matching"
		graphics
		[
			x	2097.0730158730157
			y	2783.7546847511567
			w	300.2451664313469
			h	84.31078131324011
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: green_intensities_1
pipeline: @(x)data.select(x, 'intensity_green')

we select the strongest and most distinctive green
feature for matching"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	44
		label	"label: green_intensities_2
pipeline: @(x)data.select(x, 'intensity_green')"
		graphics
		[
			x	1276.8575396825397
			y	2783.7546847511567
			w	270.2447806332043
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: green_intensities_2
pipeline: @(x)data.select(x, 'intensity_green')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	45
		label	"label: merge_2_e
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')"
		graphics
		[
			x	861.2761904761904
			y	2783.7546847511567
			w	368.07746364352676
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_2_e
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	46
		label	"label: merge_1_e
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')"
		graphics
		[
			x	1732.9115079365079
			y	2783.7546847511567
			w	368.07746364352676
			h	61.0
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_1_e
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	47
		label	"label: fit_streaks_1
pipeline: @techniques.streak.fit_streaks

this important node fits streak models over streak images. streak models are
defined in the pyrometry paper: in brief, they are convolutions of a 2D Dirac
function and a Gaussian point spread function. this node finds best fitting
parameters including refined endpoints, intensities and the standard deviation
of the point spread function. this is used e.g., for estimating streak energy."
		graphics
		[
			x	2262.195634920635
			y	2976.6749648972846
			w	470.0351155371242
			h	124.47313835401519
			type	"roundrectangle"
			fill	"#FF947F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: fit_streaks_1
pipeline: @techniques.streak.fit_streaks

this important node fits streak models over streak images. streak models are
defined in the pyrometry paper: in brief, they are convolutions of a 2D Dirac
function and a Gaussian point spread function. this node finds best fitting
parameters including refined endpoints, intensities and the standard deviation
of the point spread function. this is used e.g., for estimating streak energy."
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	48
		label	"label: fit_streaks_2
pipeline: @techniques.streak.fit_streaks"
		graphics
		[
			x	637.2361111111111
			y	2976.6749648972846
			w	239.4702967298045
			h	61.0
			type	"roundrectangle"
			fill	"#7FC9FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: fit_streaks_2
pipeline: @techniques.streak.fit_streaks"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	49
		label	"label: streak_props
pipeline: @(fits_1, fits_2, matching)data.merge(fits_1(matching.ind_left,:), fits_2(matching.ind_right,:).endpoint, ...
'mode', 'table:columns:endpoint_right') -> @(table_)data.rename_field(table_, 'endpoint', 'endpoint_left')

this a major merger node to collect close-to-final streak properties"
		graphics
		[
			x	1467.8166666666666
			y	3332.7617940420346
			w	676.9337699175636
			h	83.4444927448867
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: streak_props
pipeline: @(fits_1, fits_2, matching)data.merge(fits_1(matching.ind_left,:), fits_2(matching.ind_right,:).endpoint, ...
'mode', 'table:columns:endpoint_right') -> @(table_)data.rename_field(table_, 'endpoint', 'endpoint_left')

this a major merger node to collect close-to-final streak properties"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	50
		label	"label: triangulate
pipeline: @techniques.streak.triangulate_streaks

this node calculates 3D streak positions based on pixel coordinates
in two views and stereo calibration data"
		graphics
		[
			x	681.0789682539682
			y	3554.7346070994213
			w	402.23874362478807
			h	83.4444927448867
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: triangulate
pipeline: @techniques.streak.triangulate_streaks

this node calculates 3D streak positions based on pixel coordinates
in two views and stereo calibration data"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	51
		label	"label: calculate_velocity
pipeline: @(props_, intensity_calibration)techniques.streak.calculate_velocities(props_, intensity_calibration.integration_time)

this node calculates velocities based on 3D streak coordinates and the integration time"
		graphics
		[
			x	1685.4198412698413
			y	3755.0465737466902
			w	712.5188247285641
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: calculate_velocity
pipeline: @(props_, intensity_calibration)techniques.streak.calculate_velocities(props_, intensity_calibration.integration_time)

this node calculates velocities based on 3D streak coordinates and the integration time"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	52
		label	"pipeline: @(x)data.select(x, 'intensity_calibration')"
		graphics
		[
			x	3000.701587301587
			y	213.61382424800865
			w	305.67217546455674
			h	36.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"pipeline: @(x)data.select(x, 'intensity_calibration')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	53
		label	"label: calculate_viewfactor
pipeline: @(props_)techniques.streak.calculate_streak_viewfactors(props_)"
		graphics
		[
			x	1087.3464285714285
			y	3755.0465737466902
			w	423.62725600093415
			h	61.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: calculate_viewfactor
pipeline: @(props_)techniques.streak.calculate_streak_viewfactors(props_)"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	54
		label	"label: calculate_temperature
pipeline: @techniques.streak.calculate_temperatures

this node calculates streak temperature based on ratio pyrometry"
		graphics
		[
			x	2905.898412698413
			y	3554.734607099421
			w	379.2121894744847
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: calculate_temperature
pipeline: @techniques.streak.calculate_temperatures

this node calculates streak temperature based on ratio pyrometry"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	55
		label	"label: integrate_streaks
pipeline: @(props_)techniques.streak.integrate_streak_fits(props_, 'endpoints', 'endpoint_left')

this node integrates counts of streak models. this is a representation of total incident radiant energy"
		graphics
		[
			x	1799.2452380952382
			y	3554.734607099421
			w	593.4763606845656
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: integrate_streaks
pipeline: @(props_)techniques.streak.integrate_streak_fits(props_, 'endpoints', 'endpoint_left')

this node integrates counts of streak models. this is a representation of total incident radiant energy"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	56
		label	"label: merge_2
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')"
		graphics
		[
			x	1213.7503968253968
			y	3872.079653396516
			w	379.2121894744847
			h	61.0
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_2
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	57
		label	"label: calculate_diameter
pipeline: @(props_, intensity_calibration)techniques.streak.calculate_diameters(props_, intensity_calibration, 'energy', 'energy_red')

this node calculates particle diameter based on the total incident radiant energy and intensity calibration"
		graphics
		[
			x	1402.7031746031746
			y	4046.1693736713414
			w	755.810302848177
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: calculate_diameter
pipeline: @(props_, intensity_calibration)techniques.streak.calculate_diameters(props_, intensity_calibration, 'energy', 'energy_red')

this node calculates particle diameter based on the total incident radiant energy and intensity calibration"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	58
		label	"label: merge_3
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')

the final merger node that merges particle position, temperature, diameter and velocity"
		graphics
		[
			x	1072.3670634920634
			y	4184.235532970993
			w	500.5519142910185
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: merge_3
pipeline: @(varargin)data.merge(varargin, 'mode', 'table:column')

the final merger node that merges particle position, temperature, diameter and velocity"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	59
		label	"label: store
pipeline: @(data_, datalink_)data.store_data(data_, datalink_, 'streak_demo')

this stores data in the in-memory Store called 'store_'"
		graphics
		[
			x	658.7787698412699
			y	4349.358332895644
			w	453.1892375616321
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#7FFF7F"
			outline	"#FF00FF"
			outlineWidth	7
		]
		LabelGraphics
		[
			text	"label: store
pipeline: @(data_, datalink_)data.store_data(data_, datalink_, 'streak_demo')

this stores data in the in-memory Store called 'store_'"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	60
		label	"label: datalink
pipeline: @(~)data.create_datalink('datalink_', 'store_')

a helper node that initializes a DataLink in the workspace if there isn't one"
		graphics
		[
			x	245.1904761904762
			y	50.30691212400433
			w	450.3804171339506
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
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	61
		label	"label: show_detection_left
pipeline: @(image_, props_)techniques.streak.show_streaks(data.cast_image(image_).*10, ...
props_, 'endpoints', 'endpoint_left', 'figure', 1)

this shows the detection result in the left view. we rescale the image a bit for better visibility"
		graphics
		[
			x	2406.1376984126982
			y	3554.7346070994213
			w	560.3081401208832
			h	83.4444927448867
			type	"roundrectangle"
			fill	"#FF99FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: show_detection_left
pipeline: @(image_, props_)techniques.streak.show_streaks(data.cast_image(image_).*10, ...
props_, 'endpoints', 'endpoint_left', 'figure', 1)

this shows the detection result in the left view. we rescale the image a bit for better visibility"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	62
		label	"label: show_coordinates
pipeline: @(props_)techniques.streak.show_streaks_3d(props_, 'figure', 3)

this shows the triangulation result in the left coordinate frame"
		graphics
		[
			x	630.7992063492063
			y	3755.0465737466902
			w	429.4670527644272
			h	73.06615929965119
			type	"roundrectangle"
			fill	"#FF99FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: show_coordinates
pipeline: @(props_)techniques.streak.show_streaks_3d(props_, 'figure', 3)

this shows the triangulation result in the left coordinate frame"
			fontSize	9
			fontStyle	"bold"
			fontName	"Monospaced"
			alignment	"left"
			anchor	"c"
		]
	]
	node
	[
		id	63
		label	"label: show_detection_right
pipeline: @(image_, props_)techniques.streak.show_streaks(data.cast_image(image_).*10, ...
props_, 'endpoints', 'endpoint_right', 'figure', 2)

this shows the detection result in the left view. we rescale the image a bit for better visibility"
		graphics
		[
			x	1192.3527777777779
			y	3554.7346070994213
			w	560.3081401208832
			h	83.4444927448867
			type	"roundrectangle"
			fill	"#FF99FF"
			hasOutline	0
		]
		LabelGraphics
		[
			text	"label: show_detection_right
pipeline: @(image_, props_)techniques.streak.show_streaks(data.cast_image(image_).*10, ...
props_, 'endpoints', 'endpoint_right', 'figure', 2)

this shows the detection result in the left view. we rescale the image a bit for better visibility"
			fontSize	9
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
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5000000000000001
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	577.3800888822533
			y	258.3314825185905
		]
	]
	edge
	[
		source	1
		target	3
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
	]
	edge
	[
		source	5
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
					x	1835.6777777777777
					y	1235.6687773439976
				]
				point
				[
					x	1944.3827411675436
					y	1291.0075580509942
				]
				point
				[
					x	2054.5535714285716
					y	1291.0075580509942
				]
				point
				[
					x	2054.5535714285716
					y	1388.702785431145
				]
			]
		]
		edgeAnchor
		[
			xSource	0.7499999999999996
			ySource	0.9999999999999972
			yTarget	-1.0000000000000022
		]
	]
	edge
	[
		source	4
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
					x	749.7726190476191
					y	1235.6687773439976
				]
				point
				[
					x	822.924760977751
					y	1281.1687773439976
				]
				point
				[
					x	1250.3626984126984
					y	1281.1687773439976
				]
				point
				[
					x	1250.3626984126981
					y	1388.702785431145
				]
			]
		]
		edgeAnchor
		[
			xSource	0.7500000000000006
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	5
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
					x	1835.6777777777777
					y	1235.6687773439976
				]
				point
				[
					x	1799.442789981189
					y	1306.0075580509942
				]
				point
				[
					x	1644.4460317460318
					y	1306.0075580509942
				]
				point
				[
					x	1644.4460317460318
					y	1388.702785431145
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.2500000000000004
			ySource	0.9999999999999972
			yTarget	-1.0000000000000022
		]
	]
	edge
	[
		source	4
		target	9
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	749.7726190476191
					y	1235.6687773439976
				]
				point
				[
					x	774.156666357663
					y	1296.1687773439976
				]
				point
				[
					x	914.8246031746032
					y	1296.1687773439976
				]
				point
				[
					x	914.8246031746032
					y	1388.702785431145
				]
			]
		]
		edgeAnchor
		[
			xSource	0.24999999999999942
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	8
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
					x	1644.4460317460318
					y	1388.702785431145
				]
				point
				[
					x	1644.4460317460318
					y	1471.3980128112955
				]
				point
				[
					x	1599.3588194201889
					y	1471.3980128112955
				]
				point
				[
					x	1735.6357142857146
					y	1536.8980128112955
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0000000000000022
			xTarget	-0.5000000000000002
			yTarget	-1.0
		]
	]
	edge
	[
		source	6
		target	10
		label	"1"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0000000000000022
			xTarget	0.4999999999999999
			yTarget	-1.0000000000000022
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	2042.5525496537725
			y	1538.2063624206708
		]
	]
	edge
	[
		source	11
		target	10
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1735.6357142857146
					y	1536.8980128112955
				]
				point
				[
					x	1735.6357142857146
					y	1582.3980128112955
				]
				point
				[
					x	1725.0845936937317
					y	1582.3980128112955
				]
				point
				[
					x	1889.8190476190475
					y	1670.0932401914465
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
		source	9
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
					x	914.8246031746032
					y	1388.702785431145
				]
				point
				[
					x	914.8246031746032
					y	1471.3980128112955
				]
				point
				[
					x	1086.0681647067954
					y	1471.3980128112955
				]
				point
				[
					x	949.7912698412698
					y	1536.8980128112955
				]
			]
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
		source	7
		target	13
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
					x	1250.3626984126981
					y	1388.702785431145
				]
				point
				[
					x	1250.3627898685515
					y	1582.3980128112955
				]
				point
				[
					x	1227.903100893192
					y	1582.3980128112955
				]
				point
				[
					x	1068.827380952381
					y	1670.0932401914463
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.5000000000000002
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1238.3617842713104
			y	1530.5879754975078
		]
	]
	edge
	[
		source	12
		target	13
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	949.7912698412698
					y	1536.8980128112955
				]
				point
				[
					x	949.7912698412698
					y	1582.3980128112955
				]
				point
				[
					x	909.7516610115699
					y	1582.3980128112955
				]
				point
				[
					x	1068.827380952381
					y	1670.0932401914463
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
		target	11
		label	"1"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			xSource	0.2500000000000004
			ySource	0.9999999999999972
			xTarget	0.5000000000000002
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1859.9117050100178
			y	1382.674465118645
		]
	]
	edge
	[
		source	4
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
					x	749.7726190476191
					y	1235.6687773439976
				]
				point
				[
					x	725.3884920634921
					y	1471.3980128112955
				]
				point
				[
					x	813.5143749757442
					y	1471.3980128112955
				]
				point
				[
					x	949.7912698412698
					y	1536.8980128112955
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.24999999999999942
			ySource	1.0
			xTarget	-0.4999999999999998
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	713.3875433825752
			y	1382.5223342493764
		]
	]
	edge
	[
		source	10
		target	16
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			xSource	-0.5000000000000001
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	10
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
					x	1889.8190476190475
					y	1670.0932401914465
				]
				point
				[
					x	2054.5535015443634
					y	1737.7884675715973
				]
				point
				[
					x	2019.3212301587303
					y	1737.7884675715973
				]
				point
				[
					x	2019.3212301587303
					y	1878.1788524476906
				]
				point
				[
					x	1944.9100589275065
					y	1878.1788524476906
				]
				point
				[
					x	1834.9972222222223
					y	1943.6788524476906
				]
			]
		]
		edgeAnchor
		[
			xSource	0.4999999999999999
			ySource	1.0000000000000022
			xTarget	0.4999999999999999
			yTarget	-1.0
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
		source	17
		target	14
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1834.9972222222223
					y	1943.6788524476906
				]
				point
				[
					x	1834.9972222222223
					y	1989.1788524476906
				]
				point
				[
					x	1796.9829365079365
					y	1989.1788524476906
				]
				point
				[
					x	1796.9829365079365
					y	2071.293082038218
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
		source	18
		target	19
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
	]
	edge
	[
		source	13
		target	18
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
		source	13
		target	19
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1068.827380952381
					y	1670.0932401914463
				]
				point
				[
					x	1227.903100893192
					y	1715.5932401914463
				]
				point
				[
					x	1189.5136904761905
					y	1715.5932401914463
				]
				point
				[
					x	1189.5136904761905
					y	1855.98362506754
				]
				point
				[
					x	1129.5771224195698
					y	1855.98362506754
				]
				point
				[
					x	1019.6642857142856
					y	1943.6788524476906
				]
			]
		]
		edgeAnchor
		[
			xSource	0.5000000000000002
			ySource	1.0
			xTarget	0.4999999999999999
			yTarget	-1.0
		]
	]
	edge
	[
		source	19
		target	15
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1019.6642857142856
					y	1943.6788524476906
				]
				point
				[
					x	1019.6642857142856
					y	1989.1788524476906
				]
				point
				[
					x	990.1515873015873
					y	1989.1788524476906
				]
				point
				[
					x	990.1515873015873
					y	2071.293082038218
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
		source	15
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
					x	990.1515873015873
					y	2071.293082038218
				]
				point
				[
					x	1129.9321309389106
					y	2116.793082038218
				]
				point
				[
					x	1126.175
					y	2116.793082038218
				]
				point
				[
					x	1126.175
					y	2221.102539008896
				]
			]
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
		target	20
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1796.9829365079365
					y	2071.293082038218
				]
				point
				[
					x	1944.392463120502
					y	2133.4073116287454
				]
				point
				[
					x	1938.9400793650793
					y	2133.4073116287454
				]
				point
				[
					x	1938.9400793650793
					y	2221.102539008896
				]
			]
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
		target	22
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
			xTarget	-0.5000000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	20
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
					x	1938.9400793650793
					y	2221.102539008896
				]
				point
				[
					x	1938.9400793650793
					y	2288.797766389047
				]
				point
				[
					x	1885.5948932459098
					y	2288.797766389047
				]
				point
				[
					x	1767.584126984127
					y	2354.297766389047
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.4999999999999999
			yTarget	-1.0
		]
	]
	edge
	[
		source	21
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
			xTarget	0.4999999999999999
			yTarget	-1.0
		]
	]
	edge
	[
		source	15
		target	23
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	990.1515873015873
					y	2071.293082038218
				]
				point
				[
					x	850.3710317460317
					y	2266.602539008896
				]
				point
				[
					x	890.1535194525029
					y	2266.602539008896
				]
				point
				[
					x	1008.1642857142858
					y	2354.297766389047
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5000000000000002
			ySource	1.0
			xTarget	-0.5000000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	22
		target	24
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1767.584126984127
					y	2354.297766389047
				]
				point
				[
					x	1767.584126984127
					y	2399.797766389047
				]
				point
				[
					x	1758.6964285714287
					y	2399.797766389047
				]
				point
				[
					x	1758.6964285714287
					y	2481.9119959795744
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
		source	24
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
			xSource	0.6666666666666665
			ySource	1.0
			xTarget	-0.4999999999999995
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1886.3593544990317
			y	2560.497905257602
		]
	]
	edge
	[
		source	26
		target	27
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
					x	1008.1642857142858
					y	2481.9119959795744
				]
				point
				[
					x	1115.6313285549159
					y	2527.4119959795744
				]
				point
				[
					x	1159.4814406622024
					y	2527.4119959795744
				]
				point
				[
					x	1243.647619047619
					y	2656.1404551606292
				]
			]
		]
		edgeAnchor
		[
			xSource	0.6666666666666674
			ySource	1.0
			xTarget	-0.49999999999999956
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1147.4804496863567
			y	2563.435405257602
		]
	]
	edge
	[
		source	23
		target	26
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
		source	24
		target	28
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1758.6964285714287
					y	2481.9119959795744
				]
				point
				[
					x	1619.0324918161787
					y	2544.026225570102
				]
				point
				[
					x	1533.872619047619
					y	2544.026225570102
				]
				point
				[
					x	1533.872619047619
					y	2864.4383957202767
				]
				point
				[
					x	1553.1516181343625
					y	2864.4383957202767
				]
				point
				[
					x	1664.323015873016
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.6666666666666665
			ySource	1.0
			xTarget	-0.4999999999999999
			yTarget	-1.0
		]
	]
	edge
	[
		source	26
		target	29
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1008.1642857142858
					y	2481.9119959795744
				]
				point
				[
					x	1008.1642857142858
					y	2527.4119959795744
				]
				point
				[
					x	1060.3150793650793
					y	2527.4119959795744
				]
				point
				[
					x	1171.486507936508
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.4999999999999999
			yTarget	-1.0
		]
	]
	edge
	[
		source	28
		target	30
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
					x	1664.323015873016
					y	2976.6749648972846
				]
				point
				[
					x	1664.3231073288691
					y	3090.968174699292
				]
				point
				[
					x	1538.1515410524248
					y	3090.968174699292
				]
				point
				[
					x	1371.3944444444444
					y	3191.0038611844416
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.7500000000000008
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1652.3220958842305
			y	3059.0086417800403
		]
	]
	edge
	[
		source	29
		target	30
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
					x	1171.486507936508
					y	2976.6749648972846
				]
				point
				[
					x	1171.486599392361
					y	3090.968174699292
				]
				point
				[
					x	1315.8087455751177
					y	3090.968174699292
				]
				point
				[
					x	1371.3944444444444
					y	3191.0038611844416
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.24999999999999994
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"2"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1159.4855879477225
			y	3059.0086417800403
		]
	]
	edge
	[
		source	5
		target	30
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
					x	1835.6777777777777
					y	1235.6687773439976
				]
				point
				[
					x	1726.9728143880118
					y	1291.0075580509942
				]
				point
				[
					x	1426.9801587301588
					y	1291.0075580509942
				]
				point
				[
					x	1371.3944444444444
					y	3191.0038611844416
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.7499999999999996
			ySource	0.9999999999999972
			xTarget	0.24999999999999994
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"3"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1414.9791744264164
			y	2202.8970460626433
		]
	]
	edge
	[
		source	4
		target	30
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
					x	749.7726190476191
					y	1235.6687773439976
				]
				point
				[
					x	676.6204771174871
					y	1281.1687773439976
				]
				point
				[
					x	662.2373015873015
					y	1281.1687773439976
				]
				point
				[
					x	662.2373015873015
					y	2877.9667160327767
				]
				point
				[
					x	934.1436507936507
					y	2877.9667160327767
				]
				point
				[
					x	934.1436507936507
					y	3105.968174699292
				]
				point
				[
					x	1204.6373478364642
					y	3105.968174699292
				]
				point
				[
					x	1371.3944444444444
					y	3191.0038611844416
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.7500000000000006
			ySource	1.0
			xTarget	-0.7499999999999998
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"4"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	650.2363250248015
			y	2228.813556182265
		]
	]
	edge
	[
		source	2
		target	31
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
					x	676.9027777777778
					y	428.83737194065935
				]
				point
				[
					x	676.9028692336309
					y	538.58923994581
				]
				point
				[
					x	792.0343275042188
					y	538.58923994581
				]
				point
				[
					x	943.4051587301587
					y	626.2844673259608
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5
			yTarget	-1.000000000000001
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	664.9018405864074
			y	506.09509932081005
		]
	]
	edge
	[
		source	31
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
					x	943.4051587301587
					y	626.2844673259608
				]
				point
				[
					x	943.4051587301587
					y	693.9796947061116
				]
				point
				[
					x	1093.5062404714347
					y	693.9796947061116
				]
				point
				[
					x	1177.3265873015873
					y	778.0861726450773
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
		source	32
		target	35
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1094.7757936507937
					y	50.30691212400433
				]
				point
				[
					x	993.0483516925217
					y	130.61382424800865
				]
				point
				[
					x	800.5908730158731
					y	130.61382424800865
				]
				point
				[
					x	800.5908730158731
					y	213.61382424800865
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.4000000000000002
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	35
		target	34
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	800.5908730158731
					y	213.61382424800865
				]
				point
				[
					x	744.9166332033467
					y	246.61382424800865
				]
				point
				[
					x	715.7297619047619
					y	246.61382424800865
				]
				point
				[
					x	715.729761904762
					y	308.14214456050865
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5000000000000002
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	35
		target	33
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	800.5908730158731
					y	213.61382424800865
				]
				point
				[
					x	856.2651128283994
					y	246.61382424800865
				]
				point
				[
					x	968.4269841269842
					y	246.61382424800865
				]
				point
				[
					x	968.4269841269843
					y	308.14214456050865
				]
			]
		]
		edgeAnchor
		[
			xSource	0.5000000000000002
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	34
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
					x	715.729761904762
					y	308.14214456050865
				]
				point
				[
					x	715.729761904762
					y	341.14214456050865
				]
				point
				[
					x	764.4244132301978
					y	341.14214456050865
				]
				point
				[
					x	676.9027777777778
					y	428.83737194065935
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
		source	33
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
					x	968.4269841269843
					y	308.14214456050865
				]
				point
				[
					x	968.4269841269842
					y	525.06091963331
				]
				point
				[
					x	1261.1468253968253
					y	525.06091963331
				]
				point
				[
					x	1177.3265873015873
					y	778.0861726450773
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
		source	32
		target	36
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1094.7757936507937
					y	50.30691212400433
				]
				point
				[
					x	1196.5032356090658
					y	130.61382424800865
				]
				point
				[
					x	1430.448015873016
					y	130.61382424800865
				]
				point
				[
					x	1430.448015873016
					y	213.61382424800865
				]
			]
		]
		edgeAnchor
		[
			xSource	0.4000000000000002
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	36
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
					x	1430.448015873016
					y	213.61382424800865
				]
				point
				[
					x	1430.448015873016
					y	793.0861726450773
				]
				point
				[
					x	1386.567073632863
					y	793.0861726450773
				]
				point
				[
					x	1281.9468253968255
					y	914.8878678233946
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.49999999999999944
			yTarget	-1.000000000000001
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1418.447039310516
			y	508.38417813404294
		]
	]
	edge
	[
		source	32
		target	37
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1094.7757936507937
					y	50.30691212400433
				]
				point
				[
					x	891.3209097342498
					y	115.61382424800865
				]
				point
				[
					x	604.3809523809524
					y	115.61382424800865
				]
				point
				[
					x	604.3809523809524
					y	160.61382424800865
				]
				point
				[
					x	413.0265873015873
					y	160.61382424800865
				]
				point
				[
					x	413.0265873015873
					y	213.61382424800865
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.7999999999999999
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	32
		target	38
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
		source	38
		target	31
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.5000000000000003
			yTarget	-1.000000000000001
		]
	]
	edge
	[
		source	3
		target	39
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1281.9468253968255
					y	914.8878678233946
				]
				point
				[
					x	1386.567073632863
					y	982.5830952035453
				]
				point
				[
					x	2262.195634920635
					y	982.5830952035453
				]
				point
				[
					x	2262.195634920635
					y	1070.278322583696
				]
			]
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
		source	39
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
					x	2262.195634920635
					y	1070.278322583696
				]
				point
				[
					x	2128.0830799923906
					y	1137.9735499638468
				]
				point
				[
					x	1835.6777777777777
					y	1137.9735499638468
				]
				point
				[
					x	1835.6777777777777
					y	1235.6687773439976
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.8000000000000003
			ySource	1.0000000000000022
			yTarget	-0.9999999999999972
		]
	]
	edge
	[
		source	3
		target	40
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1281.9468253968255
					y	914.8878678233946
				]
				point
				[
					x	1177.326577160788
					y	982.5830952035453
				]
				point
				[
					x	637.2361111111111
					y	982.5830952035453
				]
				point
				[
					x	637.2361111111111
					y	1070.2783225836959
				]
			]
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
		source	40
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
					x	637.2361111111111
					y	1070.2783225836959
				]
				point
				[
					x	729.2712125827853
					y	1127.9362960557305
				]
				point
				[
					x	749.7726190476191
					y	1127.9362960557305
				]
				point
				[
					x	749.7726190476191
					y	1235.6687773439976
				]
			]
		]
		edgeAnchor
		[
			xSource	0.3999999999999999
			ySource	0.9999999999999987
			yTarget	-1.0
		]
	]
	edge
	[
		source	39
		target	41
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2262.195634920635
					y	1070.278322583696
				]
				point
				[
					x	2329.251912384757
					y	1152.9735499638468
				]
				point
				[
					x	2474.243650793651
					y	1152.9735499638468
				]
				point
				[
					x	2474.243650793651
					y	1235.6687773439976
				]
			]
		]
		edgeAnchor
		[
			xSource	0.40000000000000013
			ySource	1.0000000000000022
			yTarget	-1.0000000000000022
		]
	]
	edge
	[
		source	40
		target	42
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	637.2361111111111
					y	1070.2783225836959
				]
				point
				[
					x	545.2010096394367
					y	1142.9362960557305
				]
				point
				[
					x	461.2138888888889
					y	1142.9362960557305
				]
				point
				[
					x	461.2138888888889
					y	1235.6687773439976
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.4000000000000004
			ySource	0.9999999999999987
			yTarget	-1.0
		]
	]
	edge
	[
		source	40
		target	27
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	637.2361111111111
					y	1070.2783225836959
				]
				point
				[
					x	821.3063140544596
					y	1127.9362960557305
				]
				point
				[
					x	1401.9789682539683
					y	1127.9362960557305
				]
				point
				[
					x	1401.9789682539683
					y	2574.026225570102
				]
				point
				[
					x	1327.8138241059708
					y	2574.026225570102
				]
				point
				[
					x	1243.647619047619
					y	2656.1404551606292
				]
			]
		]
		edgeAnchor
		[
			xSource	0.7999999999999998
			ySource	0.9999999999999987
			xTarget	0.49999999999999956
			yTarget	-1.0
		]
	]
	edge
	[
		source	39
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
					x	2262.195634920635
					y	1070.278322583696
				]
				point
				[
					x	2195.1393574565127
					y	1137.9735499638468
				]
				point
				[
					x	2237.1944444444443
					y	1137.9735499638468
				]
				point
				[
					x	2237.1944444444443
					y	2574.026225570102
				]
				point
				[
					x	2097.0730244935007
					y	2574.026225570102
				]
				point
				[
					x	1997.7166666666667
					y	2656.1404551606292
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.40000000000000013
			ySource	1.0000000000000022
			xTarget	0.4999999999999995
			yTarget	-1.0
		]
	]
	edge
	[
		source	25
		target	43
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
		source	43
		target	28
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2097.0730158730157
					y	2783.7546847511567
				]
				point
				[
					x	2097.0730158730157
					y	2864.4383957202767
				]
				point
				[
					x	1775.4944136116694
					y	2864.4383957202767
				]
				point
				[
					x	1664.323015873016
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.4999999999999999
			yTarget	-1.0
		]
	]
	edge
	[
		source	27
		target	44
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1243.647619047619
					y	2656.1404551606292
				]
				point
				[
					x	1327.8138241059708
					y	2701.6404551606292
				]
				point
				[
					x	1276.8575396825397
					y	2701.6404551606292
				]
				point
				[
					x	1276.8575396825397
					y	2783.7546847511567
				]
			]
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
		source	44
		target	29
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1276.8575396825397
					y	2783.7546847511567
				]
				point
				[
					x	1276.8575396825397
					y	2864.4383957202767
				]
				point
				[
					x	1282.6579056751614
					y	2864.4383957202767
				]
				point
				[
					x	1171.486507936508
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.4999999999999999
			yTarget	-1.0
		]
	]
	edge
	[
		source	26
		target	45
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
					x	1008.1642857142858
					y	2481.9119959795744
				]
				point
				[
					x	900.6972428736559
					y	2527.4119959795744
				]
				point
				[
					x	769.256746031746
					y	2527.4119959795744
				]
				point
				[
					x	861.2761904761904
					y	2783.7546847511567
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.6666666666666666
			ySource	1.0
			xTarget	-0.49999999999999994
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	757.2558156395154
			y	2660.1860280772958
		]
	]
	edge
	[
		source	27
		target	45
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1243.647619047619
					y	2656.1404551606292
				]
				point
				[
					x	1159.4814139892671
					y	2701.6404551606292
				]
				point
				[
					x	953.2955563870721
					y	2701.6404551606292
				]
				point
				[
					x	861.2761904761904
					y	2783.7546847511567
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5000000000000001
			ySource	1.0
			xTarget	0.5000000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	24
		target	46
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
					x	1758.6964285714287
					y	2481.9119959795744
				]
				point
				[
					x	1758.6965200272818
					y	2684.6687754731292
				]
				point
				[
					x	1640.892142025626
					y	2684.6687754731292
				]
				point
				[
					x	1732.9115079365079
					y	2783.7546847511567
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.5000000000000006
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1746.6955234926324
			y	2650.679521188376
		]
	]
	edge
	[
		source	25
		target	46
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1997.7166666666667
					y	2656.1404551606292
				]
				point
				[
					x	1898.3603088398327
					y	2718.2546847511567
				]
				point
				[
					x	1824.9308738473896
					y	2718.2546847511567
				]
				point
				[
					x	1732.9115079365079
					y	2783.7546847511567
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.49999999999999994
			ySource	1.0
			xTarget	0.5000000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	46
		target	47
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
					x	1732.9115079365079
					y	2783.7546847511567
				]
				point
				[
					x	1732.911599392361
					y	2879.4383957202767
				]
				point
				[
					x	2105.5172630749266
					y	2879.4383957202767
				]
				point
				[
					x	2262.195634920635
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.6666666666666671
			yTarget	-0.9999999999999963
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1720.9105715376995
			y	2842.880719923217
		]
	]
	edge
	[
		source	39
		target	47
		label	"2"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0000000000000022
			yTarget	-0.9999999999999963
		]
		LabelGraphics
		[
			text	"2"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	2250.194658358135
			y	1922.4697422729905
		]
	]
	edge
	[
		source	41
		target	47
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2474.243650793651
					y	1235.6687773439976
				]
				point
				[
					x	2474.243650793651
					y	2864.4383957202767
				]
				point
				[
					x	2418.874006766343
					y	2864.4383957202767
				]
				point
				[
					x	2262.195634920635
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0000000000000022
			xTarget	0.6666666666666671
			yTarget	-0.9999999999999963
		]
	]
	edge
	[
		source	45
		target	48
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
					x	861.2761904761904
					y	2783.7546847511567
				]
				point
				[
					x	861.2762819320436
					y	2892.9667160327767
				]
				point
				[
					x	717.0595433543792
					y	2892.9667160327767
				]
				point
				[
					x	637.2361111111111
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.6666666666666665
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	849.275255033713
			y	2849.644880079467
		]
	]
	edge
	[
		source	40
		target	48
		label	"2"
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	0.9999999999999987
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"2"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	625.2351345486111
			y	1931.23070875318
		]
	]
	edge
	[
		source	42
		target	48
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	461.2138888888889
					y	1235.6687773439976
				]
				point
				[
					x	461.2138888888889
					y	2864.4383957202767
				]
				point
				[
					x	557.4126788678429
					y	2864.4383957202767
				]
				point
				[
					x	637.2361111111111
					y	2976.6749648972846
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.6666666666666665
			yTarget	-1.0
		]
	]
	edge
	[
		source	47
		target	49
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
					x	2262.195634920635
					y	2976.6749648972846
				]
				point
				[
					x	2262.195726376488
					y	3219.532181496942
				]
				point
				[
					x	1693.461256639188
					y	3219.532181496942
				]
				point
				[
					x	1467.8166666666666
					y	3332.7617940420346
				]
			]
		]
		edgeAnchor
		[
			ySource	0.9999999999999963
			xTarget	0.666666666666667
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	2250.194732952519
			y	3186.231640192177
		]
	]
	edge
	[
		source	48
		target	49
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
					x	637.2361111111111
					y	2976.6749648972846
				]
				point
				[
					x	637.2362025669643
					y	3256.0395476695912
				]
				point
				[
					x	1242.1720766941453
					y	3256.0395476695912
				]
				point
				[
					x	1467.8166666666666
					y	3332.7617940420346
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.666666666666667
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"2"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	625.235201990361
			y	3190.6937051558825
		]
	]
	edge
	[
		source	30
		target	49
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1371.3944444444444
					y	3191.0038611844416
				]
				point
				[
					x	1371.3944444444444
					y	3256.0395476695912
				]
				point
				[
					x	1467.8166666666666
					y	3256.0395476695912
				]
				point
				[
					x	1467.8166666666666
					y	3332.7617940420346
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
		source	49
		target	50
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
					x	1467.8166666666666
					y	3332.7617940420346
				]
				point
				[
					x	1197.0433454241072
					y	3448.012360726978
				]
				point
				[
					x	781.6386541601653
					y	3448.012360726978
				]
				point
				[
					x	681.0789682539682
					y	3554.7346070994213
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.8000000000000004
			ySource	1.0
			xTarget	0.5000000000000001
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1185.0422654282113
			y	3407.282380258228
		]
	]
	edge
	[
		source	37
		target	50
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	413.0265873015873
					y	213.61382424800865
				]
				point
				[
					x	413.0265873015873
					y	246.61382424800865
				]
				point
				[
					x	260.1904761904762
					y	246.61382424800865
				]
				point
				[
					x	260.1904761904762
					y	3478.012360726978
				]
				point
				[
					x	580.5192823477712
					y	3478.012360726978
				]
				point
				[
					x	681.0789682539682
					y	3554.7346070994213
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
		source	50
		target	51
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
					x	681.0789682539682
					y	3554.7346070994213
				]
				point
				[
					x	831.9184971132638
					y	3611.4568534718646
				]
				point
				[
					x	1112.3477105034722
					y	3611.4568534718646
				]
				point
				[
					x	1112.3477105034722
					y	3683.5134940968646
				]
				point
				[
					x	1507.2901350877003
					y	3683.5134940968646
				]
				point
				[
					x	1685.4198412698413
					y	3755.0465737466902
				]
			]
		]
		edgeAnchor
		[
			xSource	0.7500000000000002
			ySource	1.0
			xTarget	-0.5
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1100.3467339409722
			y	3652.2068534718646
		]
	]
	edge
	[
		source	32
		target	52
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1094.7757936507937
					y	50.30691212400433
				]
				point
				[
					x	1298.2306775673378
					y	115.61382424800865
				]
				point
				[
					x	3000.701587301587
					y	115.61382424800865
				]
				point
				[
					x	3000.701587301587
					y	213.61382424800865
				]
			]
		]
		edgeAnchor
		[
			xSource	0.8000000000000004
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	52
		target	51
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	3000.701587301587
					y	213.61382424800865
				]
				point
				[
					x	2898.810862146735
					y	246.61382424800865
				]
				point
				[
					x	2701.2920634920633
					y	246.61382424800865
				]
				point
				[
					x	2701.2920634920633
					y	3669.9851737843646
				]
				point
				[
					x	1863.5495474519823
					y	3669.9851737843646
				]
				point
				[
					x	1685.4198412698413
					y	3755.0465737466902
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.666666666666666
			ySource	1.0
			xTarget	0.5
			yTarget	-1.0
		]
	]
	edge
	[
		source	50
		target	53
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	681.0789682539682
					y	3554.7346070994213
				]
				point
				[
					x	731.3588112070668
					y	3626.4568534718646
				]
				point
				[
					x	1087.3464285714285
					y	3626.4568534718646
				]
				point
				[
					x	1087.3464285714285
					y	3755.0465737466902
				]
			]
		]
		edgeAnchor
		[
			xSource	0.25000000000000006
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	49
		target	54
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
					x	1467.8166666666666
					y	3332.7617940420346
				]
				point
				[
					x	1738.5901708209326
					y	3449.484040414478
				]
				point
				[
					x	2811.0953653297915
					y	3449.484040414478
				]
				point
				[
					x	2905.898412698413
					y	3554.734607099421
				]
			]
		]
		edgeAnchor
		[
			xSource	0.8000000000000004
			ySource	1.0
			xTarget	-0.5000000000000004
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1726.5891954993172
			y	3408.018220101978
		]
	]
	edge
	[
		source	52
		target	54
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.5000000000000004
			yTarget	-1.0
		]
	]
	edge
	[
		source	55
		target	56
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1799.2452380952382
					y	3554.734607099421
				]
				point
				[
					x	1799.2452380952382
					y	3698.5134940968646
				]
				point
				[
					x	1314.1603174603174
					y	3698.5134940968646
				]
				point
				[
					x	1314.1603174603174
					y	3800.5465737466902
				]
				point
				[
					x	1213.7503968253968
					y	3800.5465737466902
				]
				point
				[
					x	1213.7503968253968
					y	3872.079653396516
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
		source	56
		target	57
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
			xTarget	-0.5000000000000002
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1201.7494722861693
			y	3930.142153396516
		]
	]
	edge
	[
		source	49
		target	55
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1467.8166666666666
					y	3332.7617940420346
				]
				point
				[
					x	1467.8166666666666
					y	3404.484040414478
				]
				point
				[
					x	1698.588888888889
					y	3404.484040414478
				]
				point
				[
					x	1698.588888888889
					y	3479.484040414478
				]
				point
				[
					x	1799.2452380952382
					y	3479.484040414478
				]
				point
				[
					x	1799.2452380952382
					y	3554.734607099421
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
		source	52
		target	57
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	3000.701587301587
					y	213.61382424800865
				]
				point
				[
					x	3102.5923124564392
					y	246.61382424800865
				]
				point
				[
					x	3110.504761904762
					y	246.61382424800865
				]
				point
				[
					x	3110.504761904762
					y	3974.636294021516
				]
				point
				[
					x	1591.655750315219
					y	3974.636294021516
				]
				point
				[
					x	1402.7031746031746
					y	4046.1693736713414
				]
			]
		]
		edgeAnchor
		[
			xSource	0.666666666666666
			ySource	1.0
			xTarget	0.5000000000000002
			yTarget	-1.0
		]
	]
	edge
	[
		source	51
		target	58
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1685.4198412698413
					y	3755.0465737466902
				]
				point
				[
					x	1685.4198412698413
					y	3959.636294021516
				]
				point
				[
					x	1009.7980158730159
					y	3959.636294021516
				]
				point
				[
					x	1072.3670634920634
					y	4184.235532970993
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.24999999999999975
			yTarget	-1.0
		]
	]
	edge
	[
		source	53
		target	56
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	-0.6666666666666666
			yTarget	-1.0
		]
	]
	edge
	[
		source	54
		target	56
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2905.898412698413
					y	3554.734607099421
				]
				point
				[
					x	2811.095238095238
					y	3806.579653396516
				]
				point
				[
					x	1340.1544599835584
					y	3806.579653396516
				]
				point
				[
					x	1213.7503968253968
					y	3872.079653396516
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.5000000000000004
			ySource	1.0
			xTarget	0.6666666666666665
			yTarget	-1.0
		]
	]
	edge
	[
		source	54
		target	58
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	2905.898412698413
					y	3554.734607099421
				]
				point
				[
					x	3000.701587301587
					y	3946.107973709016
				]
				point
				[
					x	1795.6083333333333
					y	3946.107973709016
				]
				point
				[
					x	1795.6083333333333
					y	4112.702453321167
				]
				point
				[
					x	1260.0740313511953
					y	4112.702453321167
				]
				point
				[
					x	1072.3670634920634
					y	4184.235532970993
				]
			]
		]
		edgeAnchor
		[
			xSource	0.5000000000000004
			ySource	1.0
			xTarget	0.7500000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	57
		target	58
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1402.7031746031746
					y	4046.1693736713414
				]
				point
				[
					x	1402.7031746031746
					y	4097.702453321167
				]
				point
				[
					x	1134.9360527784406
					y	4097.702453321167
				]
				point
				[
					x	1072.3670634920634
					y	4184.235532970993
				]
			]
		]
		edgeAnchor
		[
			ySource	1.0
			xTarget	0.2500000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	58
		target	59
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
					x	1072.3670634920634
					y	4184.235532970993
				]
				point
				[
					x	1072.3671549479166
					y	4277.825253245818
				]
				point
				[
					x	772.0760792316779
					y	4277.825253245818
				]
				point
				[
					x	658.7787698412699
					y	4349.358332895644
				]
			]
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
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	1060.366126300693
			y	4245.331112620818
		]
	]
	edge
	[
		source	60
		target	59
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	245.1904761904762
					y	50.30691212400433
				]
				point
				[
					x	245.1904761904762
					y	4264.296932933318
				]
				point
				[
					x	545.4814604508618
					y	4264.296932933318
				]
				point
				[
					x	658.7787698412699
					y	4349.358332895644
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
		source	50
		target	58
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	681.0789682539682
					y	3554.7346070994213
				]
				point
				[
					x	530.2394393946728
					y	3611.4568534718646
				]
				point
				[
					x	401.0654761904762
					y	3611.4568534718646
				]
				point
				[
					x	401.0654761904762
					y	4061.1693736713414
				]
				point
				[
					x	884.6600956329314
					y	4061.1693736713414
				]
				point
				[
					x	1072.3670634920634
					y	4184.235532970993
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.7499999999999997
			ySource	1.0
			xTarget	-0.7500000000000001
			yTarget	-1.0
		]
	]
	edge
	[
		source	39
		target	61
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
					x	2262.195634920635
					y	1070.278322583696
				]
				point
				[
					x	2396.308189848879
					y	1137.9735499638468
				]
				point
				[
					x	2686.2916666666665
					y	1137.9735499638468
				]
				point
				[
					x	2686.2916666666665
					y	3434.484040414478
				]
				point
				[
					x	2546.214733442919
					y	3434.484040414478
				]
				point
				[
					x	2406.1376984126982
					y	3554.7346070994213
				]
			]
		]
		edgeAnchor
		[
			xSource	0.8000000000000003
			ySource	1.0000000000000022
			xTarget	0.5000000000000006
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	2674.2906901041665
			y	2391.573167367944
		]
	]
	edge
	[
		source	49
		target	61
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
			Line
			[
				point
				[
					x	1467.8166666666666
					y	3332.7617940420346
				]
				point
				[
					x	1603.2034206501794
					y	3389.484040414478
				]
				point
				[
					x	1713.588888888889
					y	3389.484040414478
				]
				point
				[
					x	1713.588888888889
					y	3464.484040414478
				]
				point
				[
					x	2266.0606633824773
					y	3464.484040414478
				]
				point
				[
					x	2406.1376984126982
					y	3554.7346070994213
				]
			]
		]
		edgeAnchor
		[
			xSource	0.4000000000000002
			ySource	1.0
			xTarget	-0.5000000000000006
			yTarget	-1.0
		]
	]
	edge
	[
		source	50
		target	62
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			xSource	-0.25000000000000006
			ySource	1.0
			yTarget	-1.0
		]
	]
	edge
	[
		source	49
		target	63
		graphics
		[
			smoothBends	1
			fill	"#000000"
			targetArrow	"delta"
		]
		edgeAnchor
		[
			xSource	-0.4000000000000002
			ySource	1.0
			xTarget	0.4999999999999997
			yTarget	-1.0
		]
	]
	edge
	[
		source	40
		target	63
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
					x	637.2361111111111
					y	1070.2783225836959
				]
				point
				[
					x	453.1659081677625
					y	1127.9362960557305
				]
				point
				[
					x	285.19166666666666
					y	1127.9362960557305
				]
				point
				[
					x	285.19166666666666
					y	3463.012360726978
				]
				point
				[
					x	1052.2757427475572
					y	3463.012360726978
				]
				point
				[
					x	1192.3527777777779
					y	3554.7346070994213
				]
			]
		]
		edgeAnchor
		[
			xSource	-0.8000000000000003
			ySource	0.9999999999999987
			xTarget	-0.4999999999999997
			yTarget	-1.0
		]
		LabelGraphics
		[
			text	"1"
			fontSize	10
			fontName	"Monospaced"
			configuration	"AutoFlippingLabel"
			contentWidth	10.0009765625
			contentHeight	17.056640625
			model	"side_slider"
			x	273.19069010416666
			y	2402.7469792811667
		]
	]
]
