clear all;
close all;
clc;

addpath('../');
addpath('../external/');

rand('state', 1);
randn('state', 1);

options.hgtables = '../config/hgTables_b37.txt'; % human genome annotation table
options.gcdir = '/data/cyau/software/gc/b37/'; % directory of local GC content files
options.outdir = '/data/cyau/temp/'; % output directory
options.tumourStateTable = '../config/tumourStates.txt';
batchfile = '/data/cyau/wgs500/bladder.csv';

[samplename, infile, normalfile ] = textread(batchfile, '%s %s %s', 'headerlines', 1);
nfiles = length(samplename);

for fi = 9 % 1 : nfiles

	options.samplename = samplename{fi}; % sample name
	options.infile = [ infile{fi} '.gz' ]; % input data file
	options.normalfile = [ normalfile{fi} '.gz' ]; % input data file

	fi
	disp(samplename{fi});
	
%	continue;

	tic
	oncoseq( 	'--read_depth_range', '[30:50]', ...
				'--chr_range', '[1:22]', ...
				'--n_train', '30000', ...
				'--maxploidy', '4.5', ...
				'--minploidy', '1.5', ...
				'--seqerror', '0.001', ...
				'--readerror', '0.01', ...
				'--lambda3', '0.05', ...
				'--normalcontamination', ...
				'--training', ...
				'--maxnormalcontamination', '0.5', ...
				'--hgtable', options.hgtables, ...
				'--gcdir', options.gcdir, ...
				'--seqtype', 'illumina', ...
				'--samplename', options.samplename, ...
				'--infile', options.infile, ...
				'--normalfile', options.normalfile, ...
				'--outdir', options.outdir ...
			);
	toc

end
