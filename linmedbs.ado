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
	local cvar `cvars'
	
	if ("`nointeraction'" == "") {
		local interaction true	
		local inter_var_names "_`dvar'_X_`mvar' _`mvar'_X_`dvar' _`dvar_X_`mvar'_001 _`dvar'_X_`mvar'_010 _`dvar'_X_`mvar'_100 _`mvar'_X_`dvar'_001 _`mvar'_X_`dvar'_010 _`mvar'_X_`dvar'_100"
		foreach name of local inter_var_names {
			capture confirm new variable `name'
			if !_rc {
				local inter `name'
				continue, break
				}
			}
		if _rc {
			display as error "{p 0 0 5 0}The command needs to create an interaction variable "
			display as error "with one of the following names: `inter_var_names', "
			display as error "but these variables have already been defined.{p_end}"
			error 110
			}
		gen `inter' = `dvar'*`mvar' if `touse'
		}
	else {
		local interaction false
		}

	if ("`cvar'"!="") {
		
		foreach c in `cvar' {
			capture confirm new variable `c'_r001
			if _rc {
				display as error "{p 0 0 5 0}The command needs to create a residualized variable "
				display as error "with the following name: `c'_r001, "
				display as error "but this variable has already been defined.{p_end}"
				error 110
				}
			}
			
		local cvar_r ""
		foreach c in `cvar' {
			qui regress `c' [`weight' `exp'] if `touse'
			predict `c'_r001 if e(sample), resid
			local cvar_r `cvar_r' `c'_r001
			}

		if ("`cxd'"!="") {	
			foreach c in `cvar_r' {
				tempvar `c'_xD
				gen ``c'_xD' = `dvar' * `c' if `touse'
				local cxd_vars `cxd_vars'  ``c'_xD'
				}
			}

		if ("`cxm'"!="") {	
			foreach c in `cvar_r' {
				tempvar `c'_xM
				gen ``c'_xM' = `mvar' * `c' if `touse'
				local cxm_vars `cxm_vars'  ``c'_xM'
				}
			}
		
		if ("`interaction'"=="false") {
			regress `yvar' `dvar' `mvar' `cvar_r' `cxd_vars' `cxm_vars' [`weight' `exp'] if `touse' 
			matrix beta = e(b)
			regress `mvar' `dvar' `cvar_r' `cxd_vars' [`weight' `exp'] if `touse' 
			matrix theta = e(b)
			return scalar cde = beta[1,1]*(`d'-`dstar')
			return scalar nde = beta[1,1]*(`d'-`dstar')
			return scalar nie = theta[1,1]*beta[1,2]*(`d'-`dstar')
			return scalar ate = (beta[1,1]*(`d'-`dstar'))+(theta[1,1]*beta[1,2]*(`d'-`dstar'))
			}
		
		if ("`interaction'"=="true") {
			regress `yvar' `dvar' `mvar' `inter' `cvar_r' `cxd_vars' `cxm_vars' [`weight' `exp'] if `touse' 
			matrix beta = e(b)
			regress `mvar' `dvar' `cvar_r' `cxd_vars' [`weight' `exp'] if `touse' 
			matrix theta = e(b)
			
			local nc : word count `cvar' `cxd_vars'
			
			return scalar cde = (beta[1,1]+beta[1,3]*`m')*(`d'-`dstar')
			return scalar nde = (beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar')
			return scalar nie = theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar')
			return scalar ate = ((beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar'))+ ///
								 (theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar'))
			}
		}

	if ("`cvar'"=="") {
			
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
			
			local nc : word count `cvar' `cxd_vars'
			
			return scalar cde = (beta[1,1]+beta[1,3]*`m')*(`d'-`dstar')
			return scalar nde = (beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar')
			return scalar nie = theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar')
			return scalar ate = ((beta[1,1]+beta[1,3]*(theta[1,`nc'+2]+theta[1,1]*`dstar'))*(`d'-`dstar'))+ ///
								 (theta[1,1]*(beta[1,2]+beta[1,3]*`d')*(`d'-`dstar'))
			}
		}

	if ("`interaction'"=="true") {
		drop `inter'
		}
	
	if ("`cvar'"!="") {
		drop `cvar_r'
		}
		
end linmedbs
