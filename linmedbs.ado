*!TITLE: LINMED - causal mediation analysis using linear models
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1
*!

program define linmedbs, rclass
	
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
		[cxm]

	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
		local N = r(N)
	}
		
	local yvar `varlist'
	
	if ("`nointeraction'" == "") {
		local interaction true	
		tempvar inter
		qui gen `inter' = `dvar'*`mvar' if `touse'
		}
	else {
		local interaction false
		}

	if ("`cvars'"!="") {
		
		local cvars_r ""
		foreach c in `cvars' {
			tempvar `c'_r001
			qui regress `c' [`weight' `exp'] if `touse'
			qui predict ``c'_r001' if e(sample), resid
			local cvars_r `cvars_r' ``c'_r001'
			}

		if ("`cxd'"!="") {	
			foreach c in `cvars_r' {
				tempvar `c'_xD
				qui gen ``c'_xD' = `dvar' * `c' if `touse'
				local cxd_vars `cxd_vars' ``c'_xD'
				}
			}

		if ("`cxm'"!="") {	
			foreach c in `cvars_r' {
				tempvar `c'_xM
				qui gen ``c'_xM' = `mvar' * `c' if `touse'
				local cxm_vars `cxm_vars' ``c'_xM'
				}
			}
		
		if ("`interaction'"=="false") {
			regress `yvar' `dvar' `mvar' `cvars_r' `cxd_vars' `cxm_vars' [`weight' `exp'] if `touse' 
			matrix beta = e(b)
			
			regress `mvar' `dvar' `cvars_r' `cxd_vars' [`weight' `exp'] if `touse' 
			matrix theta = e(b)
			
			return scalar cde = beta[1,1]*(`d'-`dstar')
			return scalar nde = beta[1,1]*(`d'-`dstar')
			return scalar nie = theta[1,1]*beta[1,2]*(`d'-`dstar')
			return scalar ate = (beta[1,1]*(`d'-`dstar'))+(theta[1,1]*beta[1,2]*(`d'-`dstar'))
			}
		
		if ("`interaction'"=="true") {
			regress `yvar' `dvar' `mvar' `inter' `cvars_r' `cxd_vars' `cxm_vars' [`weight' `exp'] if `touse' 
			matrix beta = e(b)
			
			regress `mvar' `dvar' `cvars_r' `cxd_vars' [`weight' `exp'] if `touse' 
			matrix theta = e(b)
			
			local nc : word count `cvars' `cxd_vars'
			
			return scalar cde = (beta[1,1]+beta[1,3]*`m')*(`d'-`dstar')
			return scalar nde = (beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar')
			return scalar nie = theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar')
			return scalar ate = ((beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar'))+ ///
								 (theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar'))
			}
		}

	if ("`cvars'"=="") {
			
		if ("`interaction'"=="false") {
			regress `yvar' `dvar' `mvar' [`weight' `exp'] if `touse' 
			matrix beta = e(b)
			
			regress `mvar' `dvar' [`weight' `exp'] if `touse' 
			matrix theta = e(b)
			
			return scalar cde = beta[1,1]*(`d'-`dstar')
			return scalar nde = beta[1,1]*(`d'-`dstar')
			return scalar nie = theta[1,1]*beta[1,2]*(`d'-`dstar')
			return scalar ate = (beta[1,1]*(`d'-`dstar'))+(theta[1,1]*beta[1,2]*(`d'-`dstar'))
			}
		
		if ("`interaction'"=="true") {
			regress `yvar' `dvar' `mvar' `inter' [`weight' `exp'] if `touse' 
			matrix beta = e(b)
			
			regress `mvar' `dvar' [`weight' `exp'] if `touse' 
			matrix theta = e(b)
			
			local nc : word count `cvars' `cxd_vars'
			
			return scalar cde = (beta[1,1]+beta[1,3]*`m')*(`d'-`dstar')
			return scalar nde = (beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar')
			return scalar nie = theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar')
			return scalar ate = ((beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar'))+ ///
								 (theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar'))
			}
		}

end linmedbs
