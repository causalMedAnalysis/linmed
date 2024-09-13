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
{cmd:linmed} {depvar} {help indepvars:mvars} [{it:{help weight:pweight}}] {cmd:,} 
{opt dvar(varname)}
{opt d(real)} 
{opt dstar(real)}
{opt cvars(varlist))} 
{opt nointer:action} 
{opt cxd} 
{opt cxm} 
{opt detail}
[{it:{help bootstrap##options:bootstrap_options}}]

{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt mvars} - this specifies the mediator(s), which can be a single variable or multivariate.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable.

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt nointer:action} - this option specifies whether treatment-mediator interactions are not to be
included in the outcome model (the default includes the interactions).

{phang}{opt cxd} - this option specifies that all two-way interactions between the treatment and baseline covariates are
included in the mediator and outcome models.

{phang}{opt cxm} - this option specifies that all two-way interactions between the mediator(s) and baseline covariates are
included in the outcome model.

{phang}{opt detail} - this option prints the fitted models used to construct the effect estimates.

{phang}{it:{help bootstrap##options:bootstrap_options}} - all {help bootstrap} options are available. {p_end}

{title:Description}

{pstd}{cmd:linmed} performs causal mediation analysis using linear models for both the mediator(s) and outcome, and it
computes inferential statistics using the nonparametric bootstrap. {p_end}

{pstd}When a single mediator is specified, it estimates total, natural direct, and natural indirect effects using two linear models:
a model for the mediator conditional on treatment and baseline covariates after centering them around their sample means, 
and a model for the outcome conditional on treatment, the mediator, and the baseline covariates after centering them around 
their sample means. {p_end}

{pstd}When multiple mediators are specified, {cmd:linmed} provides estimates for the total effect and then for the multivariate natural 
direct and indirect effects operating through the entire set of mediators considered together. To this end, it fits separate models 
for each mediator conditional on treatment and the baseline covariates after centering them around their sample means, and then a 
model for the outcome conditional on treatment, all the mediators, and the baseline covariates after centering them around their 
sample means. {p_end}

{pstd}If using {help pweights} from a complex sample design that require rescaling to produce valid boostrap estimates, be sure to appropriately 
specify the strata(), cluster(), and size() options from the {help bootstrap} command so that Nc-1 clusters are sampled from each stratum 
with replacement, where Nc denotes the number of clusters per stratum. Failing to properly adjust the bootstrap procedure to account
for a complex sample design and its associated sampling weights could lead to invalid inferential statistics. {p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

{pstd} single mediator, no interaction between treatment and mediator, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) nointer} {p_end}

{pstd} single mediator, treatment-mediator interaction, percentile bootstrap CIs with 1000 replications: {p_end}
 
{phang2}{cmd:. linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)} {p_end}

{pstd} single mediator, all two-way interactions with treatment and the mediator, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) cxd cxm} {p_end}

{pstd} multiple mediators, all treatment-mediator interactions, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. linmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0)} {p_end}

{title:Saved results}

{pstd}{cmd:linmed} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing total, direct, and indirect effect estimates{p_end}

{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke GT and Zhou X. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp regress R}, {manhelp bootstrap R}
{p_end}
