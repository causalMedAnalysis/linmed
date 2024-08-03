{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for linmed}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:linmed} {hline 2}}causal mediation analysis using linear models{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:linmed} {varname} {ifin} [{it:{help weight:pweight}}] {cmd:,} dvar({varname}) mvar({varname}) 
d({it:real}) dstar({it:real}) m({it:real}) [cvars({varlist})) {opt nointer:action} {opt cxd} {opt cxm} 
{reps({it:integer 1000}) strata({varname}) cluster({varname}) level(cilevel) seed({it:passthru})]

{phang}{opt varname} - this specifies the outcome variable.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable.

{phang}{opt mvar(varname)} - this specifies the mediator variable.

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{phang}{opt m(real)} - this specifies the level of the mediator at which the controlled direct effect 
is evaluated. If there is no treatment-mediator interaction, then the controlled direct effect
is the same at all levels of the mediator and thus an arbitary value can be chosen.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt nointer:action} - this option specifies whether a treatment-mediator interaction is not to be
included in the outcome model (the default assumes an interaction is present).

{phang}{opt cxd} - this option specifies that all two-way interactions between the treatment and baseline covariates are
included in the mediator and outcome models.

{phang}{opt cxm} - this option specifies that all two-way interactions between the mediator and baseline covariates are
included in the outcome model.

{phang}{opt reps(integer 200)} - this option specifies the number of replications for bootstrap resampling (the default is 200).

{phang}{opt strata(varname)} - this option specifies a variable that identifies resampling strata. If this option is specified, 
then bootstrap samples are taken independently within each stratum.

{phang}{opt cluster(varname)} - this option specifies a variable that identifies resampling clusters. If this option is specified,
then the sample drawn during each replication is a bootstrap sample of clusters.

{phang}{opt level(cilevel)} - this option specifies the confidence level for constructing bootstrap confidence intervals. If this 
option is omitted, then the default level of 95% is used.

{phang}{opt seed(passthru)} - this option specifies the seed for bootstrap resampling. If this option is omitted, then a random 
seed is used and the results cannot be replicated. {p_end}

{title:Description}

{pstd}{cmd:linmed} performs causal mediation analysis using linear models for both the mediator and outcome. Two models are 
estimated: a model for the mediator conditional on treatment and baseline covariates (if specified) after centering them 
around their sample means, and a model for the outcome conditional on treatment, the mediator, and the baseline covariates 
after centering them around their sample means.

{pstd}{cmd:linmed} provides estimates of the controlled direct effect, the natural direct effect, the natural indirect effect, 
and the total effect.{p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

 
{pstd} no interaction between treatment and mediator, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. linmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) m(0) nointer reps(1000)} {p_end}


{pstd} treatment-mediator interaction, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. linmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) m(0) reps(1000)} {p_end}


{pstd} treatment-mediator interaction, all two-way interactions between baseline covariates and treatment, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. linmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) m(0) cxd reps(1000)} {p_end}


{title:Saved results}

{pstd}{cmd:linmed} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing direct, indirect and total effect estimates{p_end}


{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke GT, Zhou X, and Elwert F. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp regress R}, {manhelp bootstrap R}
{p_end}
