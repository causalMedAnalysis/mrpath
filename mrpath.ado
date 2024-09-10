*!TITLE: MRPATH - path-specific effects using parametric multiply robust methods
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!


program define mrpath, eclass

	version 15	

	syntax varlist(min=2 numeric) [if][in], ///
		dvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		[ cvars(varlist numeric) ///
		NOINTERaction ///
		cxd ///
		cxm ///
		censor ///
		reps(integer 200) ///
		strata(varname numeric) ///
		cluster(varname numeric) ///
		level(cilevel) ///
		seed(passthru) * ] 

		
	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}
	
	gettoken yvar mvars : varlist
	
	local num_mvars = wordcount("`mvars'")

	if (`num_mvars' > 5) {
		display as error "mrpath only supports a maximum of 5 mvars"
		error 198
	}
	
	local i = 1
	foreach v of local mvars {
		local mvar`i' `v'
		local ++i
	}
	
	confirm variable `dvar'
	qui levelsof `dvar', local(levels)
	if "`levels'" != "0 1" & "`levels'" != "1 0" {
		display as error "The variable `dvar' is not binary and coded 0/1"
		error 198
		}
	
	if (`num_mvars' == 1) {
		bootstrap ///
			ATE=r(ate) ///
			NDE=r(nde) ///
			NIE=r(nie), ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' `options' ///
				noheader notable: ///
					mrpathbs `yvar' `mvars' if `touse', ///
						dvar(`dvar') d(`d') dstar(`dstar') cvars(`cvars') ///
						`cxd' `cxm' `nointeraction' `censor'
	}
			
	if (`num_mvars' == 2) {
		bootstrap ///
			ATE=r(ate) ///
			PSE_DY=r(pse_DY) ///
			PSE_DM2Y=r(pse_DM2Y) ///
			PSE_DM1Y=r(pse_DM1Y), ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' `options' ///
				noheader notable: ///
					mrpathbs `yvar' `mvars' if `touse', ///
						dvar(`dvar') d(`d') dstar(`dstar') cvars(`cvars') ///
						`cxd' `cxm' `nointeraction' `censor'

	}

	if (`num_mvars' == 3) {
		bootstrap ///
			ATE=r(ate) ///
			PSE_DY=r(pse_DY) ///
			PSE_DM3Y=r(pse_DM3Y) ///				
			PSE_DM2Y=r(pse_DM2Y) ///
			PSE_DM1Y=r(pse_DM1Y), ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' `options' ///
				noheader notable: ///
					mrpathbs `yvar' `mvars' if `touse', ///
						dvar(`dvar') d(`d') dstar(`dstar') cvars(`cvars') ///
						`cxd' `cxm' `nointeraction' `censor'
	}

	if (`num_mvars' == 4) {
		bootstrap ///
			ATE=r(ate) ///
			PSE_DY=r(pse_DY) ///
			PSE_DM4Y=r(pse_DM4Y) ///				
			PSE_DM3Y=r(pse_DM3Y) ///
			PSE_DM2Y=r(pse_DM2Y) ///
			PSE_DM1Y=r(pse_DM1Y), ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' `options' ///
				noheader notable: ///
					mrpathbs `yvar' `mvars' if `touse', ///
						dvar(`dvar') d(`d') dstar(`dstar') cvars(`cvars') ///
						`cxd' `cxm' `nointeraction' `censor'
	}

	if (`num_mvars' == 5) {
		bootstrap ///
			ATE=r(ate) ///
			PSE_DY=r(pse_DY) ///
			PSE_DM5Y=r(pse_DM5Y) ///				
			PSE_DM4Y=r(pse_DM4Y) ///				
			PSE_DM3Y=r(pse_DM3Y) ///
			PSE_DM2Y=r(pse_DM2Y) ///
			PSE_DM1Y=r(pse_DM1Y), ///
				reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' `options' ///
				noheader notable: ///
					mrpathbs `yvar' `mvars' if `touse', ///
						dvar(`dvar') d(`d') dstar(`dstar') cvars(`cvars') ///
						`cxd' `cxm' `nointeraction' `censor'
	}
	
	estat bootstrap, p noheader
	
end mrpath
