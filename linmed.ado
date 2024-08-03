*!TITLE: LINMED - causal mediation analysis using linear models
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1
*!

program define linmed, eclass

	version 15	

	syntax varname(numeric) [if][in] [pweight], ///
		dvar(varname numeric) ///
		mvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		m(real) ///
		[cvars(varlist numeric)] ///
		[NOINTERaction] ///
		[cxd] ///
		[cxm] ///
		[reps(integer 200)] ///
		[strata(varname numeric)] ///
		[cluster(varname numeric)] ///
		[level(cilevel)] ///
		[seed(passthru)] ///
		[saving(string)] ///
		[detail]

	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}

	if ("`detail'" != "") {
		linmedbs `varlist' if `touse' [`weight' `exp'], ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') `nointeraction' `cxd' `cxm'
		}
	
	if ("`saving'" != "") {
		bootstrap ATE=r(ate) NDE=r(nde) NIE=r(nie) CDE=r(cde), force ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			saving(`saving', replace) noheader notable: ///
			linmedbs `varlist' if `touse' [`weight' `exp'], ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') `nointeraction' `cxd' `cxm'
			}

	if ("`saving'" == "") {
		bootstrap ATE=r(ate) NDE=r(nde) NIE=r(nie) CDE=r(cde), force ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			noheader notable: ///
			linmedbs `varlist' if `touse' [`weight' `exp'], ///
			dvar(`dvar') mvar(`mvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') `nointeraction' `cxd' `cxm'
			}
			
	estat bootstrap, p noheader

end linmed
