---
title: "Ecological conditions favoring species recognition and rapid mate pairing are associated with greater plumage sexual dichromatism in true thrushes (genus: *Turdus*)"
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
*plumage*, *dichromatism*, *species recognition*

# Background

# Methods

## *Plumage sexual dichromatism*


A total of N=77 *Turdus* thrush species were sampled for plumage spectral
reflectance using from bird skins at the American Museum of Natural History in
New York City and the Field Museum in Chicago. Reflectance measurements from
300-700nm were taken in triplicate for the belly, breast, throat, crown and
mantle plumage patches [@andersson2006] of each individual bird
skin. N=3 male and N=3 female individuals were measured for most species
(exceptions: *Turdus lawrencii*, N=2 males and N=2 females; *Turdus swalesi*,
N=1 male and N=1 female). Reflectance spectra were measured using a 400 μm fiber
optic reflection probe fitted with a rubber stopper to maintain a consistent
measuring distance of 3 mm and area of 2 mm<sup>2</sup> at a 90° angle to the
surface of the feather patch. Measurements were taken using a JAZ spectrometer
with a pulsed-xenon light source (Ocean Optics, Dunedin, USA) and all
measurements were made relative to a diffuse reflectance white standard
(Spectralon WS-1-SL, Labsphere, North Sutton NH, USA).

We used a receptor-noise limited visual model
[@vorobyev1998] of the European Blackbird (*Turdus
merula*) visual system [@hart2000] in the *pavo*
[@maia2019, p. 2]⁠ package in R v4.0.0
[@rcoreteam2020]⁠ to calculate avian-perceived
chromatic and achromatic visual contrast (in units of “Just-Noticeable
Differences”,or JNDs) of male vs. female plumage patches for all sampled
*Turdus* species. Chromatic and achromatic JNDs were calculated for male-female
pairs within each species (i.e., N=9 JND values calculated per patch for each
species where N=3 males and N=3 females sampled), and then JND values were
averaged for each species’ respective plumage patches. Under ideal laboratory
conditions, a JND value of 1 is generally considered to be the discriminable
threshold past which an observer is predicted to be able to perceive the two
colors as different. However, natural light environments vary both spatially and
temporally [@endler1993]⁠, bringing into question the accuracy
of a JND=1 threshold for generalizing visual contrast under natural conditions.
Therefore, we calculated the total number of sexually-dichromatic plumage
patches per species (out of N=5 measured patches) as the number of plumage
patches with average JND values > 1, 2, or 3 to account for uncertainty in
visual discrimination thresholds due to variation in psychophysical and ambient
lighting conditions affecting the strength of between-sex plumage visual
contrast [@kemp2015]⁠.

## *Life History Data*

### *Breeding Timing Model*

We collected data on migration behavior and breeding season length from
*Thrushes* [@clement2000] and the *Handbook of the Birds of the World*
[@delhoyo2017]⁠. We assigned three different kinds of
migratory behavior: 1) *full migration* when a species description clearly
stated that a species "migrates", 2) *partial migration* when a species was
described to have "altitudinal migration", "latitudinal migration" or "movement
during non-breeding season", or 3) *sedentary* when when a species was described
as "resident" or "sedentary". Breeding season length was defined as the number
of months the species breeds.

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

## *Statistical Modeling*

We used phylogenetically-corrected Bayesian multilevel logistic regression
models using the *brms* v2.13.0 package [@burkner2017] in R
v4.0.0 [@rcoreteam2020]⁠ where responses, the
number of sexually-dichromatic patches >1, 2, and 3 chromatic and achromatic
JNDs, were modeled as binomial trials (N=5 plumage patch “trials”) to test for
associations with breeding timing, breeding sympatry and breeding spacing. For
all phylogenetically-corrected models, we used the *Turdus* phylogeny from
Nylander et al. (2008) [@nylander2008]to create
a covariance matrix of species’ phylogenetic relationships. All models used a
dataset of N=67 *Turdus* species for which all data were available.

Our *breeding timing* models included the following predictors: z-scores of
breeding season length (mean centered and divided by one standard deviation),
migratory behavior (full migration as the reference category versus partial
migration or sedentary), and their interaction. *Breeding sympatry* models
included the number of sympatric species with greater than 30% breeding range
overlap as the only predictor of the number of sexually-dichromatic plumage
patches. *Breeding spacing* models included $log_{e}$ transformed breeding
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
predicted the number of sexually-dichromatic plumage patches
[@vehtari2017]⁠.

# Results

We obtained N ≥ 4000 effective samples for each model parameter and all models’
Markov Chains (MCMC) successfully converged (Rhat = 1 for all models’
parameters).


\begin{table}[!h]

\caption{\label{tab:table01}Expected log pointwise predictive densities (ELPD) differences and
kfold information criterion values of models.}
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

\caption{\label{tab:table02}Model predictor effect estimates (posterior median log-odds and 90\% credible interval) on the
  presence of a plumage patch with achromatic or chromatic visual contrast values $>$
  1, 2, and 3 JND. Model effects with a probability of direction (pd) value $\geq$ 0.90
  are bolded in \textcolor{red}{\textbf{red}} for a negative effect and \textcolor{blue}{\textbf{blue}} for a positive effect on
  plumage dichromatism.}
\centering
\resizebox{\linewidth}{!}{
\renewcommand{\arraystretch}{1.5}
\begin{tabular}[t]{llllllll}
\toprule
Model & Parameter & Achromatic, 1 JND & Achromatic, 2 JND & Achromatic, 3 JND & Chromatic, 1 JND & Chromatic, 2 JND & Chromatic, 3 JND\\
\midrule
\addlinespace[0.3em]
\multicolumn{1}{l}{\textbf{Breeding Timing}}\\
 & Intercept & \textcolor{black}{-1.16 (-3.87, 1.67), pd = 0.76} & \textcolor{red}{\textbf{-8.36 (-16.28, -0.62), pd = 0.98}} & \textcolor{red}{\textbf{-7.81 (-14.83, -1.66), pd = 0.99}} & \textcolor{black}{-0.88 (-2.98, 1.03), pd = 0.78} & \textcolor{red}{\textbf{-7.21 (-15.29, 0.55), pd = 0.95}} & \textcolor{red}{\textbf{-12.71 (-28.03, 0.31), pd = 0.96}}\\
 & Breeding Season Length & \textcolor{black}{-0.06 (-0.62, 0.56), pd = 0.57} & \textcolor{red}{\textbf{-2.26 (-4.72, 0.05), pd = 0.97}} & \textcolor{red}{\textbf{-1.39 (-3.56, 0.4), pd = 0.91}} & \textcolor{black}{-0.12 (-0.59, 0.34), pd = 0.66} & \textcolor{red}{\textbf{-1.99 (-4.64, 0.35), pd = 0.94}} & \textcolor{black}{-2.5 (-8.12, 2.21), pd = 0.83}\\
 & Partial Migration vs. No Migration & \textcolor{black}{-0.04 (-1.16, 1.01), pd = 0.53} & \textcolor{black}{1.41 (-1.2, 4.12), pd = 0.83} & \textcolor{black}{1.29 (-0.82, 3.57), pd = 0.85} & \textcolor{blue}{\textbf{0.79 (-0.06, 1.59), pd = 0.94}} & \textcolor{black}{1.9 (-0.87, 4.9), pd = 0.88} & \textcolor{blue}{\textbf{4.26 (-1.13, 10.99), pd = 0.92}}\\
 & Full Migration vs. No Migration & \textcolor{blue}{\textbf{1.6 (-0.05, 3.19), pd = 0.96}} & \textcolor{blue}{\textbf{4.2 (1.16, 7.5), pd = 0.99}} & \textcolor{blue}{\textbf{3.11 (0.46, 5.73), pd = 0.98}} & \textcolor{black}{0.83 (-0.37, 1.99), pd = 0.88} & \textcolor{blue}{\textbf{4.39 (1.03, 8.14), pd = 0.99}} & \textcolor{blue}{\textbf{5.46 (-0.68, 12.61), pd = 0.95}}\\
 & Breeding Season Length x Partial Migration & \textcolor{black}{0.29 (-0.73, 1.37), pd = 0.68} & \textcolor{blue}{\textbf{3.03 (-0.14, 6.38), pd = 0.96}} & \textcolor{blue}{\textbf{2.11 (-0.27, 4.69), pd = 0.94}} & \textcolor{black}{0.33 (-0.43, 1.14), pd = 0.76} & \textcolor{blue}{\textbf{2.2 (-0.82, 5.53), pd = 0.9}} & \textcolor{black}{3.54 (-2.58, 11.13), pd = 0.85}\\
 & Breeding Season Length x Full Migration & \textcolor{blue}{\textbf{1.58 (-0.4, 3.68), pd = 0.9}} & \textcolor{blue}{\textbf{4.19 (-0.53, 9.34), pd = 0.93}} & \textcolor{black}{2.8 (-1.3, 6.72), pd = 0.89} & \textcolor{black}{0.52 (-1.16, 2.12), pd = 0.7} & \textcolor{blue}{\textbf{5.08 (-0.18, 11.12), pd = 0.95}} & \textcolor{black}{6.07 (-4.27, 17.43), pd = 0.85}\\
 & Phylogenetic Signal λ, Median (90\% Credible Interval) & \textcolor{black}{0.29 (0.16, 0.43)} & \textcolor{black}{0.72 (0.56, 0.86)} & \textcolor{black}{0.61 (0.42, 0.8)} & \textcolor{black}{0.17 (0.08, 0.28)} & \textcolor{black}{0.74 (0.57, 0.88)} & \textcolor{black}{0.89 (0.77, 0.97)}\\
\addlinespace[0.3em]
\multicolumn{1}{l}{\textbf{Breeding Spacing}}\\
\hspace{1em} & Intercept & \textcolor{black}{-1.94 (-6.01, 2.01), pd = 0.8} & \textcolor{red}{\textbf{-9.77 (-20.11, 0.89), pd = 0.95}} & \textcolor{red}{\textbf{-10.31 (-19.2, -1.98), pd = 0.98}} & \textcolor{black}{-0.67 (-3.63, 2.27), pd = 0.65} & \textcolor{red}{\textbf{-8.32 (-18.86, 2.03), pd = 0.92}} & \textcolor{red}{\textbf{-12.87 (-30.57, 4.41), pd = 0.91}}\\
\hspace{1em} & Island vs. Mainland & \textcolor{black}{0.08 (-1.38, 1.57), pd = 0.54} & \textcolor{black}{-0.64 (-4.43, 2.88), pd = 0.61} & \textcolor{black}{-0.09 (-3.02, 2.96), pd = 0.52} & \textcolor{red}{\textbf{-1.3 (-2.45, -0.12), pd = 0.97}} & \textcolor{black}{-3.39 (-8.67, 1.38), pd = 0.89} & \textcolor{black}{-3.26 (-12.57, 4.21), pd = 0.77}\\
\hspace{1em} & Breeding Range Size & \textcolor{black}{0.08 (-0.13, 0.28), pd = 0.75} & \textcolor{black}{0.21 (-0.27, 0.7), pd = 0.77} & \textcolor{black}{0.26 (-0.14, 0.66), pd = 0.87} & \textcolor{black}{0.02 (-0.14, 0.18), pd = 0.58} & \textcolor{black}{0.21 (-0.29, 0.72), pd = 0.77} & \textcolor{black}{0.23 (-0.62, 1.1), pd = 0.69}\\
\hspace{1em} & Phylogenetic Signal λ, Median (90\% Credible Interval) & \textcolor{black}{0.27 (0.15, 0.41)} & \textcolor{black}{0.71 (0.56, 0.85)} & \textcolor{black}{0.6 (0.42, 0.77)} & \textcolor{black}{0.15 (0.07, 0.25)} & \textcolor{black}{0.72 (0.55, 0.86)} & \textcolor{black}{0.85 (0.71, 0.95)}\\
\addlinespace[0.3em]
\multicolumn{1}{l}{\textbf{Breeding Sympatry}}\\
\hspace{1em} & Intercept & \textcolor{red}{\textbf{-0.9 (-3.45, 1.76), pd = 0.72}} & \textcolor{red}{\textbf{-6.89 (-14.7, -0.02), pd = 0.95}} & \textcolor{red}{\textbf{-6.74 (-13.39, -1.09), pd = 0.98}} & \textcolor{red}{\textbf{-1.38 (-3.25, 0.3), pd = 0.91}} & \textcolor{red}{\textbf{-6.34 (-13.61, 0.11), pd = 0.95}} & \textcolor{red}{\textbf{-11.29 (-22.79, -1.24), pd = 0.98}}\\
 & Number of Sympatric Species 
\hspace{1em} (≥ 30\% Breeding Range Overlap) & \textcolor{black}{0.03 (-0.18, 0.24), pd = 0.61} & \textcolor{black}{0.14 (-0.31, 0.56), pd = 0.71} & \textcolor{black}{0.12 (-0.27, 0.49), pd = 0.71} & \textcolor{blue}{\textbf{0.34 (0.17, 0.51), pd = 0.99}} & \textcolor{blue}{\textbf{0.46 (0.01, 0.92), pd = 0.96}} & \textcolor{blue}{\textbf{0.75 (0.03, 1.5), pd = 0.97}}\\
\hspace{1em} & Phylogenetic Signal λ, Median (90\% Credible Interval) & \textcolor{black}{0.26 (0.14, 0.39)} & \textcolor{black}{0.7 (0.54, 0.83)} & \textcolor{black}{0.59 (0.41, 0.77)} & \textcolor{black}{0.13 (0.06, 0.23)} & \textcolor{black}{0.69 (0.52, 0.83)} & \textcolor{black}{0.82 (0.67, 0.94)}\\
\bottomrule
\end{tabular}}
\end{table}
\end{landscape}

# Discussion

# Conclusions

# Acknowledgements

# References
