function [x, seg, u, seg_all, v] = segment(chr, arm, pos, k, d, dd, log_pr_gg, loglik_su, loglik_s, params, options)

lambda_1_range = options.lambda_1_range;
lambda_2 = options.lambda_2;
chrRange = options.chrRange;
tumourState = options.tumourState;

n_lev = length(lambda_1_range);
N = length(chr);

U = params.U;
S = params.S;

for lev = 1 : n_lev
	v{lev} = zeros(1, N);
	x{lev} = zeros(1, N);
	u{lev} = zeros(1, N);
end

[arrayind, log_nu, log_transMat] = gentransmat(-lambda_1_range(1), -lambda_1_range(1), options.tumourState, params.u_range);

for chrNo = chrRange

	for armNo = 1 : 2

		chrloc = find( chr == chrNo & arm == armNo );
		n_chr = length(chrloc);

		if n_chr > 0

			vpath = viterbimex(log_nu, loglik_su(:, chrloc), log_transMat); 			
			v{1}(chrloc) = vpath;
			x{1}(chrloc) = arrayind(vpath, 1);
			u{1}(chrloc) = params.u0 + (1-params.u0)*params.u_range(arrayind(vpath, 2));

		end

	end

end

for lev = 2 : n_lev

	lambda_1 = lambda_1_range(lev);

	[arrayind, log_nu, log_transMat] = gentransmat(-lambda_1, -lambda_1, options.tumourState, params.u_range);

	for chrNo = chrRange
		for armNo = 1 : 2
			chrloc = find( chr == chrNo & arm == armNo );
			n_chr = length(chrloc);
			if n_chr > 0
				vpath = multiviterbimex(log_nu, loglik_su(:, chrloc), log_transMat, v{lev-1}(chrloc), options.lambda_2); 
				v{lev}(chrloc) = vpath;
				x{lev}(chrloc) = arrayind(vpath, 1);				
				u{lev}(chrloc) = params.u0 + (1-params.u0)*params.u_range(arrayind(vpath, 2));
			end
		end
	end

end

seg{1} = findsegments(chr, arm, pos, v{1}, x{1}, u{1}, loglik_su, options, params);
for lev = 2 : n_lev

	vd = v{lev} ~= v{lev-1};

	if sum(vd) == 0
		seg{lev} = [];
	else
		seg{lev} = findmultisegments(chr, arm, pos, v{lev}, vd, x{lev}, x{lev-1}, u{lev}, loglik_su, options, params);
	end

end

seg_all = findsegments(chr, arm, pos, v{n_lev}, x{n_lev}, u{n_lev}, loglik_su, options, params);

