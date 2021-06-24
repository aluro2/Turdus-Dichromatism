---
title: "Rapid species recognition favors greater avian-perceived plumage dichromatism in true thrushes (genus: *Turdus*)"
author: "Alec B. Luro^1^<sup>*</sup>, Mark E. Hauber^1^"
date: "^1^ Department of Evolution, Ecology and Behavior, School of Integrative Biology, University of Illinois at Urbana-Champaign <br> <sup>*</sup>alec.b.luro@mail.com </br>"
csl: Manuscript/proceedings-of-the-royal-society-b.csl
bibliography: Manuscript/Turdus-Dichromatism.bib
header-includes:
  - \usepackage[left]{lineno}
  - \linenumbers
  - \usepackage{graphicx}
  - \usepackage{booktabs}
  - \usepackage{caption}
  - \usepackage{lscape}
link-citations: true
linkcolor: blue
citecolor: blue
mainfont: Lato
linestretch: 1.5
indent: true
papersize: a4
geometry:
 - margin=1in
---

# Abstract

## Keywords

*dichromatism*, *plumage*, *species recognition*

# Introduction

   Species recognition is necessary in sexually reproducing lineages for individuals to find compatible conspecific mates and produce viable offspring [@andersson1994; @groning2008]. Specifically, conspicuous traits signaling species and sex identity reduce the time and effort expended when searching for compatible mates and lessen the likelihood of mating with heterospecifics [@groning2008]. Accordingly, traits which facilitate species and mate recognition should be favored when congeneric species are highly sympatric, when the time to find a mate is limited, and when conspecifics are not encountered often [@andersson1994]. Alternatively, traits used in species and mate recognition may also serve as signals of status to conspecifics and reduce costly conflicts over resources and mates [@west-eberhard1983].
   
   In birds, plumage colouration is a highly conspicuous trait which signals species [@martin2015a; @bitton2016] and (often) sex identity.
   
   Plumage sexual dichromatism, a distinct set of differences in the appearance of male versus female feather colouration, is common in birds and is often attributed to differing selection pressures on males and females [@martin1996; @burns1998; @badyaev2003; @dale2015; @dunn2015]. Fundamentally, plumage sexual dichromatism results in a visible trait useful for recognizing an individual's species, sex, and age (e.g., in species with delayed plumage maturation, see [@hawkins2012]), reducing the time and effort necessary to find a suitable mate. Bird species that migrate to and from their breeding territories and have large geographic ranges tend to have greater plumage sexual dichromatism than species that do not migrate and have limited ranges [@badyaev2003; @friedman2009; @dale2015; @simpson2015a; @matysiokova2017].
   
   Further, plumage sexual dichromatism likely plays a role in hybridization avoidance via character displacement for species and mate recognition [@seddon2013]. For example, in European _Ficedula_ flycatchers, female choice selects for divergent male plumage colouration, leading to character displacement between species and populations and reduced rates of hybridization [@stre1997]. More broadly and across taxa, greater plumage dichromatism is positively correlated with transitions from allopatry to parapatry and an increase in geographic range overlap among a large sample of passerine sister species pairs [@cooney2017]. In addition, plumage sexual dichromatism has been found to be positively associated with species richness among sister species pairs, and dichromatism is increased mainly by changes in male plumage [@seddon2013], suggesting that female choice and male-male competition lead to concurrent changes in male plumage and speciation events. Further, plumage sexual dichromatism is positively associated with greater interspecific plumage colour evolution rate and divergence in _Tyrannida_ suboscines [@cooney2019]. Therefore, plumage sexual dichromatism may be an especially favourable trait to facilitate species and mate recognition when closely-related species have overlapping breeding ranges.

\begin{figure}[h]
\centering
\includegraphics[width=\textwidth,height=\textheight,keepaspectratio]{Figures/hypothesis-figure-mermaid.png}
\caption {Hypotheses and predictions for each model. Arrow colours indicate predicted correlation, positive (\textcolor{blue}{\textbf{blue}}) and negative (\textcolor{red}{\textbf{red}}).\label{fig:01-hypotheses}}
\end{figure}

# Methods

## *Plumage sexual dichromatism*

A total of N=77 *Turdus* thrush species (approximately ~89% of all known true thrush species) were sampled for plumage spectral
reflectance using prepared bird skin specimens at the American Museum of Natural History in
New York City and the Field Museum in Chicago. Reflectance measurements spanning
300-700nm were taken in triplicate from the belly, breast, throat, crown and
mantle plumage patches [@andersson2006] of each individual. N=3 male and N=3 female individuals were measured for most species
(exceptions: *T. lawrencii*, N=2 males and N=2 females; *T. swalesi*,
N=1 male and N=1 female). Reflectance spectra were measured using a 400 μm fiber
optic reflection probe fitted with a rubber stopper to maintain a consistent
measuring distance of 3 mm and area of 2 mm<sup>2</sup> at a 90° angle to the
surface of the feather patch. Measurements were taken using a JAZ spectrometer
with a pulsed-xenon light source (Ocean Optics, Dunedin, USA) and we used a diffuse 99% reflectance white standard
(Spectralon WS-1-SL, Labsphere, North Sutton NH, USA).

We applied a receptor-noise limited visual model
[@vorobyev1998] of the European Blackbird (*T. merula*) visual system [@hart2000] in the *pavo*
[@maia2019, p. 2]⁠ package in R v4.0.0
[@rcoreteam2020]⁠ to calculate avian-perceived
chromatic and achromatic visual contrast (in units of “Just-Noticeable
Differences”,or JNDs) of male vs. female plumage patches for all sampled
*Turdus* species. Chromatic and achromatic JNDs were calculated for male-female
pairs within each species (i.e., N=9 JND values calculated per patch for each
species where N=3 males and N=3 females sampled), and then JND values were
averaged for each species’ respective plumage patches. Under ideal laboratory
conditions, 1 JND is generally considered to be the discriminable
threshold past which an observer is predicted to be able to perceive the two
colors as different. However, natural light environments vary both spatially and
temporally [@endler1993]⁠, bringing into question the accuracy
of a 1 JND threshold for generalizing visual contrast under natural conditions.
Therefore, we calculated the total number of sexually-dichromatic plumage
patches per species (out of N=5 measured patches) as the number of plumage
patches with average JND values > 1, 2, or 3 to account for uncertainty in
visual discrimination thresholds due to variation in psychophysical and ambient
lighting conditions affecting the strength of between-sex plumage visual
contrast [@kemp2015]⁠.

## *Life History Data*

### *Breeding Timing Model*

We collected data on migration behaviour and breeding season length from
*Thrushes* [@clement2000] and the *Handbook of the Birds of the World*
[@delhoyo2017]⁠. We assigned three different kinds of
migratory behaviour: 1) *full migration* when a species description clearly
stated that a species "migrates", 2) *partial migration* when a species was
described to have "altitudinal migration", "latitudinal migration" or "movement
during non-breeding season", or 3) *sedentary* when a species was described
as "resident" or "sedentary". Breeding season length was defined as the number
of months the species breeds each year.

### *Breeding Sympatry Model*

Species’ breeding ranges were acquired from *BirdLife International*
[@birdlifeinternationalandhandbookofthebirdsoftheworld2018]⁠.
We calculated congener breeding range overlaps (as percentages) using the
*letsR* package in R [@vilela2015]⁠. We then calculated the
number of sympatric species as the number of congeners with breeding ranges that
overlap >30% with the focal species’ breeding range
[@cooney2017].

### *Breeding Spacing Model*

Species’ breeding range sizes (in km<sup>2</sup>) were acquired using the
*BirdLife International* breeding range maps. Species’ island vs. mainland
residence was also determined using breeding ranges from *BirdLife
International*. Mainland residence was assigned if the species had a breeding
range on any continent and Japan. Island residence was assigned to species
having a breeding range limited to a non-continental landmass entirely
surrounded by an oceanic body of water.

## *Statistical modeling*

We used phylogenetically-corrected Bayesian multilevel logistic regression
models using the *brms* v2.13.0 package [@burkner2017] in R
v4.0.0 [@rcoreteam2020]⁠ where responses, the
number of sexually-dichromatic patches >1, 2, and 3 chromatic and achromatic
JNDs, were modelled as binomial trials (N=5 plumage patch “trials”) to test for
associations with breeding timing, breeding sympatry and breeding spacing. For
all phylogenetically-corrected models, we used the *Turdus* phylogeny from
Nylander et al. (2008) [@nylander2008] to create
a covariance matrix of species’ phylogenetic relationships. All models used a
dataset of N=67 out of the *Turdus* species for which all the types of data (see above) were available.

Our *breeding timing* models included the following predictors: z-scores of
breeding season length (mean-centered by $\mu$ = 5.4 months, and scaled by one standard deviation $\sigma$ = 2.3 months),
migratory behaviour (no migration as the reference category versus partial
or full migration), and their interaction. *Breeding sympatry* models
included the number of sympatric species with greater than 30% breeding range
overlap as the only predictor of the probability of having a sexually-dichromatic plumage
patch. *Breeding spacing* models included $log_{e}$ transformed breeding
range size (km<sup>2</sup>) and breeding landmass (mainland as the reference
category versus island). We also ran null models (intercept only) for all
responses. All models’ intercepts and response standard deviations were assigned
a weak prior (Student T: df = 3, location = 0, scale = 10), and predictor
coefficients were assigned flat priors. We ran each model for 6,000 iterations
across 6 chains and assessed Markov Chain Monte Carlo (MCMC) convergence using
the Gelman-Rubin diagnostic (Rhat) [@gelman2013]. We then
performed k-fold cross-validation [@vehtari2017] to refit
each model *K*=16 times. For each k-fold, the training dataset included a
randomly selected set of $N- N\frac{1}{K}$ or N≈63 species, and the
testing dataset included $N\frac{1}{K}$ or N≈4 species not included in the
training dataset. Finally, we compared differences between the models’ expected
log pointwise predictive densities (ELPD) to assess which model(s) best
predicted the probability of having a sexually-dichromatic plumage patch.
[@vehtari2017]⁠.

Models' predictor effects were assessed using 90% highest-density intervals of the posterior distributions and probability of direction, the proportion of the posterior distribution that shares the same sign (positive or negative) as the posterior median [@makowski2019], to provide estimates of the probability of that a predictor has an entirely positive or negative effect on the presence of sexually-dimorphic plumage patches. We assume predictor estimates with a probability of direction ≥ 0.90 to be 
indicative of a true existence of a predictor's effect on sexually-dimorphic plumage patches [@makowski2019].

# Results

## *Model comparisons*
We obtained N ≥ 4000 effective posterior samples for each model parameter and all models’
Markov Chains (MCMC) successfully converged (Rhat = 1 for all models’
parameters) (Supplementary Figure). All _breeding sympatry_, _breeding timing_, and _breeding spacing_ models performed similarly well and substantially better than _intercept only_ models in predicting the probability of having a sexually dimorphic plumage patch with achromatic JND values > 1, 2, or 3 (Table 1; all models predicting achromatic plumage patches had ELPD values within 4, following the convention of Burnham and Anderson (2002)[@burnham2002]).  Among models predicting the probability of having a  sexually-dichromatic plumage patch with chromatic JND values >1, 2, or 3, all _breeding sympatry_, _breeding timing_, and _breeding spacing_ models performed much better than _intercept only_ models, and _breeding sympatry_ models had the top predictive performance (Table 1; _breeding sympatry_ models all have ELPD =0, only the _breeding spacing_ models predicting dichromatic plumage patches with had similar predictive performance). 

## *Achromatic plumage sexual dimorphism predictors*

All model predictors' effect estimates are provided as the posterior median odds-ratio (OR) and 90% highest-density interval (HDI) in Table 2. Among predictors of achromatic sexually-dimorphic plumage patches, only predictors included in the _breeding timing_ model have predictors with probability of direction (_pd_) values ≥ 0.90 (Table 2). Specifically, longer breeding season length was associated with lower odds of a species having a sexually-dimorphic plumage patch with achromatic JND > 2 (breeding season length, OR [90% HDI] = 0.10 [0.01, 1.1], 89.5% decrease in odds per 2.3-month increase in breeding season) and JND > 3 (breeding season length, OR [90% HDI] = 0.25 [0.03, 1.5], 75% decrease in odds per 2.3-month increase in breeding season). Additionally, full migratory behaviour, rather than no migratory behaviour, was associated with greater odds of a species having a sexually-dimorphic plumage patch with achromatic JND > 1 (full migration, OR [90% HDI]  = 4.97 [0.95, 24.4]), JND > 2 (full migration, OR [90% HDI]  = 66.5 [3.2, 1802.4]) and JND > 3 (OR [90% HDI]  = 22.3 [1.6, 307.9]). Finally, both full and partial migratory behaviour, rather than no migration behaviour, in conjunction with longer breeding season lengths are associated with greater odds of a species having a sexually-dimorphic plumage patch with achromatic JND > 1 (breeding season length x full migration, OR [90% HDI]  = 4.84 [0.67, 39.6]), JND > 2 (breeding season length x full migration, OR = 66.3 [0.59, 11415.7]; breeding season length x partial migration, OR [90% HDI] = 20.7 [0.9, 589.1]) and JND > 3 (breeding season length x partial migration, OR [90% HDI]  = 8.28 [0.76, 109.1]).

## *Chromatic plumage sexual dimorphism predictors*

Among predictors of _breeding timing_ models predicting chromatic sexually-dimorphic plumage patches, longer breeding season length was associated with lower odds of a species having a plumage patch with chromatic JND > 2 (OR [90% HDI]  = 0.14 [0.01, 1.42], 86% reduction in odds per 2.3 month increase in breeding season), and both full and partial migratory behaviour rather than no migration are associated with greater odds of a species having a plumage patch JND > 1 (partial migration, OR [90% HDI] = 2.2 [0.94, 4.9]), JND > 2 (full migration, OR [90% HDI] = 80.51 [2.8, 3432.9]) and JND > 3 (partial migration, OR [90% HDI] = 71.2 [0.32, 59062.9]; full migration, OR [90% HDI] = 234.7 [ 0.51, 300382.6]). For _breeding spacing models_, island residency rather than mainland residency was associated with lower odds of having a plumage patch > 1 chromatic JND (island, OR [90% HDI] = 0.27 [0.09, 0.89]). Finally, more _Turdus_ species in sympatry was associated with higher odds of a species having a chromatic plumage patch with JND > 1 (number of sympatric species, OR [90% HDI] = 1.4 [1.18, 1.67], 40% increase in odds per each additional sympatic species), JND > 2 (sympatric species, OR [90% HDI] = 1.59 [1.01, 2.52], 59% increase in odds per each additional sympatric species), and JND > 3 (sympatric species, OR [90% HDI] = 2.11 [1.03, 4.46], 111% increase in odds per each additional sympatric species). 



\begin{table}[!h]

\caption{\label{tab:table01}Expected log pointwise predictive densities (ELPD) differences and
kfold information criterion values of models (ELPD Difference ± standard error (kfold IC ± standard error)). Values closest to zero indicate greater model prediction performance.}
\centering
\resizebox{\linewidth}{!}{
\renewcommand{\arraystretch}{1.5}
\begin{tabular}[t]{llllll}
\toprule
\multicolumn{1}{l}{} & \multicolumn{1}{l}{} & \multicolumn{4}{l}{Model} \\
\cmidrule(l{3pt}r{3pt}){3-6}
Plumage Metric & JND Threshold & Breeding Sympatry & Breeding Timing & Breeding Spacing & Intercept Only\\
\midrule
\addlinespace[0.3em]
\multicolumn{6}{l}{\textbf{Achromatic}}\\
\hspace{1em} & 1 JND & 0 ± 0 (-122.17 ± 0.67) & -2.51 ± 2.49 (-124.68 ± 2.38) & -2.59 ± 1.01 (-124.76 ± 1.04) & -21.69 ± 7.36 (-143.87 ± 7.51)\\
\hspace{1em} & 2 JND & 0 ± 0 (-98.94 ± 7.56) & -1.19 ± 3.95 (-100.13 ± 9.22) & -0.7 ± 1.34 (-99.64 ± 7.92) & -52.42 ± 12.67 (-151.36 ± 13.4)\\
\hspace{1em} & 3 JND & -0.04 ± 1.4 (-85.4 ± 8.91) & -1.7 ± 4.41 (-87.07 ± 10.71) & 0 ± 0 (-85.37 ± 8.76) & -28.54 ± 10.02 (-113.91 ± 13.65)\\
\addlinespace[0.3em]
\multicolumn{6}{l}{\textbf{Chromatic}}\\
\hspace{1em} & 1 JND & 0 ± 0 (-115.75 ± 2.95) & -5.67 ± 3.55 (-121.42 ± 2.28) & -2.73 ± 3.4 (-118.49 ± 2.67) & -14.8 ± 7.22 (-130.55 ± 7.05)\\
\hspace{1em} & 2 JND & 0 ± 0 (-88.47 ± 8.77) & -3.8 ± 4.46 (-92.27 ± 10.01) & -3.32 ± 5.29 (-91.79 ± 10.91) & -50.53 ± 14.49 (-139 ± 16.77)\\
\hspace{1em} & 3 JND & 0 ± 0 (-62.77 ± 10.41) & -8 ± 4.32 (-70.77 ± 12.29) & -4.43 ± 3.9 (-67.2 ± 11.72) & -47.63 ± 15.34 (-110.4 ± 20.01)\\
\bottomrule
\end{tabular}}
\end{table}


\newpage
\begin{landscape}
\begin{table}

\caption{\label{tab:table02}Model predictor effect estimates (posterior median odds ratio and 90\% highest-density interval) on the
  presence of a plumage patch with achromatic or chromatic visual contrast values $>$
  1, 2, and 3 JND. Model effects with a probability of direction (pd) value $\geq$ 0.90
  are bolded in \textcolor{red}{\textbf{red}} for a negative effect and \textcolor{blue}{\textbf{blue}} for a positive effect on
  plumage dichromatism. Phylogenetic signal (λ) for each model is provided as the median and 90\% credible interval of the intraclass correlation coefficient among species.}
\centering
\resizebox{\linewidth}{!}{
\renewcommand{\arraystretch}{1.5}
\begin{tabular}[t]{llllllll}
\toprule
Model & Parameter & Achromatic, JND > 1 & Achromatic, JND > 2 & Achromatic, JND > 3 & Chromatic, JND > 1 & Chromatic, JND > 2 & Chromatic, JND > 3\\
\midrule
\addlinespace[0.3em]
\multicolumn{1}{l}{\textbf{Breeding Timing}}\\
 & Intercept & \textcolor{black}{0.31 (0.02, 5.29), pd = 0.76} & \textcolor{red}{\textbf{0 (0, 0.54), pd = 0.98}} & \textcolor{red}{\textbf{0 (0, 0.19), pd = 0.99}} & \textcolor{black}{0.41 (0.05, 2.79), pd = 0.78} & \textcolor{red}{\textbf{0 (0, 1.73), pd = 0.95}} & \textcolor{red}{\textbf{0 (0, 1.37), pd = 0.96}}\\
 & Breeding Season Length & \textcolor{black}{0.94 (0.54, 1.75), pd = 0.57} & \textcolor{red}{\textbf{0.1 (0.01, 1.05), pd = 0.97}} & \textcolor{red}{\textbf{0.25 (0.03, 1.49), pd = 0.91}} & \textcolor{black}{0.89 (0.56, 1.4), pd = 0.66} & \textcolor{red}{\textbf{0.14 (0.01, 1.42), pd = 0.94}} & \textcolor{black}{0.08 (0, 9.14), pd = 0.83}\\
 & Partial Migration vs. No Migration & \textcolor{black}{0.96 (0.31, 2.75), pd = 0.53} & \textcolor{black}{4.11 (0.3, 61.54), pd = 0.83} & \textcolor{black}{3.65 (0.44, 35.64), pd = 0.85} & \textcolor{blue}{\textbf{2.2 (0.94, 4.89), pd = 0.94}} & \textcolor{black}{6.7 (0.42, 134.8), pd = 0.88} & \textcolor{blue}{\textbf{71.16 (0.32, 59062.92), pd = 0.92}}\\
 & Full Migration vs. No Migration & \textcolor{blue}{\textbf{4.97 (0.95, 24.41), pd = 0.96}} & \textcolor{blue}{\textbf{66.52 (3.19, 1802.4), pd = 0.99}} & \textcolor{blue}{\textbf{22.34 (1.59, 307.91), pd = 0.98}} & \textcolor{black}{2.29 (0.69, 7.31), pd = 0.88} & \textcolor{blue}{\textbf{80.51 (2.81, 3432.88), pd = 0.99}} & \textcolor{blue}{\textbf{234.71 (0.51, 300382.62), pd = 0.95}}\\
 & Breeding Season Length x Partial Migration & \textcolor{black}{1.34 (0.48, 3.92), pd = 0.68} & \textcolor{blue}{\textbf{20.71 (0.87, 589.09), pd = 0.96}} & \textcolor{blue}{\textbf{8.28 (0.76, 109.11), pd = 0.94}} & \textcolor{black}{1.39 (0.65, 3.12), pd = 0.76} & \textcolor{blue}{\textbf{9.03 (0.44, 251.36), pd = 0.9}} & \textcolor{black}{34.46 (0.08, 68228.71), pd = 0.85}\\
 & Breeding Season Length x Full Migration & \textcolor{blue}{\textbf{4.84 (0.67, 39.63), pd = 0.9}} & \textcolor{blue}{\textbf{66.3 (0.59, 11415.7), pd = 0.93}} & \textcolor{black}{16.41 (0.27, 824.69), pd = 0.89} & \textcolor{black}{1.68 (0.31, 8.33), pd = 0.7} & \textcolor{blue}{\textbf{160.6 (0.84, 67791.13), pd = 0.95}} & \textcolor{black}{433.67 (0.01, 37194569.46), pd = 0.85}\\
 & Phylogenetic Signal λ, Median (90\% Credible Interval) & \textcolor{black}{0.29 (0.16, 0.43)} & \textcolor{black}{0.72 (0.56, 0.86)} & \textcolor{black}{0.61 (0.42, 0.8)} & \textcolor{black}{0.17 (0.08, 0.28)} & \textcolor{black}{0.74 (0.57, 0.88)} & \textcolor{black}{0.89 (0.77, 0.97)}\\
\addlinespace[0.3em]
\multicolumn{1}{l}{\textbf{Breeding Spacing}}\\
\hspace{1em} & Intercept & \textcolor{black}{0.14 (0, 7.49), pd = 0.8} & \textcolor{red}{\textbf{0 (0, 2.44), pd = 0.95}} & \textcolor{red}{\textbf{0 (0, 0.14), pd = 0.98}} & \textcolor{black}{0.51 (0.03, 9.7), pd = 0.65} & \textcolor{red}{\textbf{0 (0, 7.63), pd = 0.92}} & \textcolor{red}{\textbf{0 (0, 81.95), pd = 0.91}}\\
\hspace{1em} & Island vs. Mainland & \textcolor{black}{1.08 (0.25, 4.79), pd = 0.54} & \textcolor{black}{0.53 (0.01, 17.83), pd = 0.61} & \textcolor{black}{0.92 (0.05, 19.32), pd = 0.52} & \textcolor{red}{\textbf{0.27 (0.09, 0.89), pd = 0.97}} & \textcolor{black}{0.03 (0, 3.99), pd = 0.89} & \textcolor{black}{0.04 (0, 67.59), pd = 0.77}\\
\hspace{1em} & Breeding Range Size & \textcolor{black}{1.08 (0.88, 1.32), pd = 0.75} & \textcolor{black}{1.23 (0.76, 2.01), pd = 0.77} & \textcolor{black}{1.3 (0.87, 1.93), pd = 0.87} & \textcolor{black}{1.02 (0.87, 1.19), pd = 0.58} & \textcolor{black}{1.24 (0.75, 2.05), pd = 0.77} & \textcolor{black}{1.26 (0.54, 2.99), pd = 0.69}\\
\hspace{1em} & Phylogenetic Signal λ, Median (90\% Credible Interval) & \textcolor{black}{0.27 (0.15, 0.41)} & \textcolor{black}{0.71 (0.56, 0.85)} & \textcolor{black}{0.6 (0.42, 0.77)} & \textcolor{black}{0.15 (0.07, 0.25)} & \textcolor{black}{0.72 (0.55, 0.86)} & \textcolor{black}{0.85 (0.71, 0.95)}\\
\addlinespace[0.3em]
\multicolumn{1}{l}{\textbf{Breeding Sympatry}}\\
\hspace{1em} & Intercept & \textcolor{black}{0.41 (0.03, 5.83), pd = 0.72} & \textcolor{red}{\textbf{0 (0, 0.98), pd = 0.95}} & \textcolor{red}{\textbf{0 (0, 0.34), pd = 0.98}} & \textcolor{red}{\textbf{0.25 (0.04, 1.35), pd = 0.91}} & \textcolor{red}{\textbf{0 (0, 1.12), pd = 0.95}} & \textcolor{red}{\textbf{0 (0, 0.29), pd = 0.98}}\\
 & Number of Sympatric Species 
\hspace{1em} (≥ 30\% Breeding Range Overlap) & \textcolor{black}{1.03 (0.84, 1.27), pd = 0.61} & \textcolor{black}{1.15 (0.74, 1.75), pd = 0.71} & \textcolor{black}{1.13 (0.76, 1.63), pd = 0.71} & \textcolor{blue}{\textbf{1.4 (1.18, 1.67), pd = 0.99}} & \textcolor{blue}{\textbf{1.59 (1.01, 2.52), pd = 0.96}} & \textcolor{blue}{\textbf{2.11 (1.03, 4.46), pd = 0.97}}\\
\hspace{1em} & Phylogenetic Signal λ, Median (90\% Credible Interval) & \textcolor{black}{0.26 (0.14, 0.39)} & \textcolor{black}{0.7 (0.54, 0.83)} & \textcolor{black}{0.59 (0.41, 0.77)} & \textcolor{black}{0.13 (0.06, 0.23)} & \textcolor{black}{0.69 (0.52, 0.83)} & \textcolor{black}{0.82 (0.67, 0.94)}\\
\bottomrule
\end{tabular}}
\end{table}
\end{landscape}

# Discussion

# Conclusions

# Acknowledgements

# References
