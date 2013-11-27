clear all;
close all;
clc;

% assuming we are in the example_data/ folder
addpath('../'); % relative location of oncoseq source code
addpath('../external/'); % relative location of external MATLAB files

% call to function
oncoseq( 	'--read_depth_range', '[15:40]', ...
			'--chr_range', '[1:22]', ...
			'--maxploidy', '4.5', ...
			'--minploidy', '1.5', ...
			'--normalcontamination', ...
			'--maxnormalcontamination', '0.5', ...
			'--tumourstatestable', '../config/tumourStates.txt', ...
			'--hgtable', '../config/hgTables_b37.txt', ...
			'--gcdir', '../gc/b37/', ...
			'--seqtype', 'cg', ...
			'--samplename', 'snps-100', ...
			'--infile', 'snps-100.txt.gz', ...
			'--outdir', '.' ...
		);				
