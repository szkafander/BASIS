# Batch AnalysiS of Image Sets --- BASIS

Batch Analysis of Image Sets (BASIS) is a Matlab framework for automating, archiving and running image analysis, image processing and machine vision workflows.

BASIS is a fully OO, functional, dataflow framework. In brief, it lets you run a DAG stored as e.g., a .gml file. The graph nodes must be annotated by using BASIS' simple scripting language that is an extension of Matlab's anonymous function syntax. Coupled with a .gml editor, you can draw workflows, annotate them, then run them.

BASIS makes your lab easier to maintain because your workflows are:

- Visual: explore graphs visually instead of spending two days to read through a script that nobody remembers how to use
- Archivable: save your .gml and case template instead of saving a Matlab script and remembering how to use it
- Portable: you can give a case template and a .gml to your co-worker instead of giving him a complicated Matlab script and a lecture on how to use it

Nodes can run simple named or anonymous functions, or chains (Pipelines) of these. The Graph class, the heart of BASIS, takes care of input-output routing and managing internal node data.

Running a complex workflow that analyzes a folder of images is as simple as

`Driver(my_case, my_graph).run()`

where my_case and my_graph are a Case and Graph object, respectively.

A bunch of functions for loading, storing, reshaping and manipulating data are provided that were written in the mentality of BASIS: generic node functions are heavily overloaded and flexible. They follow the simple form

`output = function(input, optional_input, name_value_pairs)`

where input is a single or multiple mandatory input arguments, optional_input is a single or multiple optional arguments and name_value_pairs is a single or multiple optional name-value arguments. So far this might not be surprising; however, in BASIS, name-value arguments should only be constants that can be comfortably expressed by manual typing. More complicated data should be passed as inputs from other nodes.

BASIS was developed for the University of Utah, Department of Chemical Engineering, for the group of Prof. Terry A. Ring. The intended use was the streamlined analysis of image data acquired in laser diagnostics/fluid mechanics experiments (e.g., PIV). The original code contained an extensive library of technique-specific functions. These have been removed from this public repository. This repository is here so that others can have access to the dataflow framework itself. Technique-specific functionality is available for high-mag shadowgraph, emission imaging and long-exposure streak imaging of luminous flows. If you are interested in the specific functionality, please contact the U of U.

Since the original repository has been gutted, it is likely that BASIS will not function properly after a simple pull and install. With a basic knowledge of Matlab, it should be easy to figure out why. The thirdparty library does not have all required packages, particularly due to missing license information. You can hunt down the missing libraries easily from FEX or from other places.

## TL/DR:

BASIS can run a machine vision workflow expressed as a graph like [this](data/graphs/shadow_simple_processing.png) on an entire folder of images in one line.

See [BASIS.pdf](BASIS.pdf) for more.
