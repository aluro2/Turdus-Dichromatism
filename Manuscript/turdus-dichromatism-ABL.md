**Ecological conditions favoring species recognition and rapid mate
pairing are associated with greater plumage sexual dichromatism in true
thrushes (genus: *Turdus*)**

Alec B. Luro<sup>1\*</sup> and Mark E. Hauber<sup>1</sup>

<sup>1</sup>Department of Evolution, Ecology and Behavior,

School of Integrative Biology,

University of Illinois at Urbana-Champaign

\*correspondence: <alec.b.luro@gmail.com>

**Abstract**

**Keywords**

**Background**

**Methods**

***Plumage sexual dichromatism***

A total of N=77 *Turdus* thrush species were sampled for plumage
spectral reflectance using from bird skins at the American Museum of
Natural History in New York City and the Field Museum in Chicago.
Reflectance measurements from 300-700nm were taken in triplicate for the
belly, breast, throat, crown and mantle plumage patches \[1\]⁠ of each
individual bird skin. N=3 male and N=3 female individuals were measured
for most species (exceptions: *Turdus lawrencii*, N=2 males and N=2
females; *Turdus swalesi*, N=1 male and N=1 female). Reflectance spectra
were measured using a 400 μm fiber optic reflection probe fitted with a
rubber stopper to maintain a consistent measuring distance of 3 mm and
area of 2 mm<sup>2</sup> at a 90° angle to the surface of the feather
patch. Measurements were taken using a JAZ spectrometer with a
pulsed-xenon light source (Ocean Optics, Dunedin, USA) and all
measurements were made relative to a diffuse reflectance white standard
(Spectralon WS-1-SL, Labsphere, North Sutton NH, USA).

We used a receptor-noise limited visual model \[2\] of the European
Blackbird (*Turdus merula*) visual system \[3\] in the *pavo \[4\]*⁠
package in R v4.0.0 \[5\]⁠ to calculate avian-perceived chromatic and
achromatic visual contrast (in units of “Just-Noticeable Differences”,
or JNDs) of male vs. female plumage patches for all sampled *Turdus*
species. Chromatic and achromatic JNDs were calculated for male-female
pairs within each species (i.e., N=9 JND values calculated per patch for
each species where N=3 males and N=3 females sampled), and then JND
values were averaged for each species’ respective plumage patches. Under
ideal laboratory conditions, a JND value of 1 is generally considered to
be the discriminable threshold past which an observer is predicted to be
able to perceive the two colors as different. However, natural light
environments vary both spatially and temporally \[6\]⁠, bringing into
question the accuracy of a JND=1 threshold for generalizing visual
contrast under natural conditions. Therefore, we calculated the total
number of sexually-dichromatic plumage patches per species (out of N=5
measured patches) as the number of plumage patches with average JND
values \> 1, 2, or 3 to account for uncertainty in visual discrimination
thresholds due to variation in psychophysical and ambient lighting
conditions affecting the strength of between-sex plumage visual contrast
\[7\]⁠.

***Life History Data***

***Breeding Timing Model***

We collected data on migration behavior and breeding season length from
*Thrushes* \[8\]⁠ and the *Handbook of the Birds of the World* \[9\]⁠.
We assigned three different kinds of migratory behavior: 1) *full
migration* when a species description clearly stated that a species
"migrates", 2) *partial migration* when a species was described to have
"altitudinal migration", "latitudinal migration" or "movement during
non-breeding season", or 3) *sedentary* when when a species was
described as "resident" or "sedentary". Breeding season length was
defined as the number of months the species breeds.

***Breeding Sympatry Model***

Species’ breeding ranges were acquired from *BirdLife International*
\[10\]⁠. We calculated congener breeding range overlaps (as percentages)
using the *letsR* package in R \[11\]⁠. We then calculated the number of
sympatric species as the number of congeners with breeding ranges that
overlap \>30% with the focal species’ breeding range \[12\].

***Breeding Spacing Model***

Species’ breeding range sizes (in km<sup>2</sup>) were acquired using
the *BirdLife International* breeding range maps. Species’ island vs.
mainland residence was also determined using breeding ranges from
*BirdLife International*. Mainland residence was assigned if the species
had a breeding range on any continent and Japan. Island residence was
assigned to species having a breeding range limited to a non-continental
landmass entirely surrounded by an oceanic body of water.

***Statistical Modeling***

We used phylogenetically-corrected Bayesian multilevel logistic
regression models using the *brms* v2.13.0 package \[13\]⁠ in R v4.0.0
\[5\]⁠ where responses, the number of sexually-dichromatic patches \>1,
2, and 3 chromatic and achromatic JNDs, were modeled as binomial trials
(N=5 plumage patch “trials”) to test for associations with breeding
timing, breeding sympatry and breeding spacing. For all
phylogenetically-corrected models, we used the *Turdus* phylogeny from
Nylander et al. (2008) \[14\] to create a covariance matrix of species’
phylogenetic relationships. All models used a dataset of N=67 *Turdus*
species for which all data were available.

Our *breeding timing* models included the following predictors: z-scores
of breeding season length (mean centered and divided by one standard
deviation), migratory behavior (full migration as the reference category
versus partial migration or sedentary), and their interaction. *Breeding
sympatry* models included the number of sympatric species with greater
than 30% breeding range overlap as the only predictor of the number of
sexually-dichromatic plumage patches. *Breeding spacing* models included
log<sub>e</sub> transformed breeding range size (km<sup>2</sup>) and
breeding landmass (mainland as the reference category versus island). We
also ran null models (intercept only) for all responses. All models’
intercepts and response standard deviations were assigned a weak prior
(Student T: df = 3, location = 0, scale = 10), and predictor
coefficients were assigned flat priors. We ran each model for 6,000
iterations across 6 chains and assessed Markov Chain Monte Carlo (MCMC)
convergence using the Gelman-Rubin diagnostic (Rhat) \[15\]. We then
performed k-fold cross-validation \[16\] to refit each model *K*=16
times. For each k-fold, the training dataset included a randomly
selected set of\(N - N \cdot \left( \frac{1}{K} \right)\)or N≈63
species, and the testing dataset included \(N \cdot \frac{1}{K}\) or N≈4
species not included in the training dataset. Finally, we compared
differences between the models’ expected log pointwise predictive
densities (ELPD) to assess which model(s) best predicted the number of
sexually-dichromatic plumage patches \[16\]⁠.

**Results**

We obtained N ≥ 4000 effective samples for each model parameter and all
models’ Markov Chains (MCMC) successfully converged (Rhat = 1 for all
models’ parameters).

**Discussion**

**Conclusions**

**Acknowledgments**

**References**

1\. Andersson S, Prager M. 2006 Quantifying Colors. In *Bird coloration,
Volume 1: Mechanisms and Measurements* (eds GE Hill, KJ McGraw), pp.
76–77. Cambridge, MA: Harvard University Press.

2\. Vorobyev M, Osorio D. 1998 Receptor noise as a determinant of colour
thresholds. *Proc. Biol. Sci.* **265**, 351–8.
(doi:10.1098/rspb.1998.0302)

3\. Hart NS, Partridge JC, Cuthill IC, Bennett AT. 2000 Visual pigments,
oil droplets, ocular media and cone photoreceptor distribution in two
species of passerine bird: the blue tit (Parus caeruleus L.) and the
blackbird (Turdus merula L.). *J. Comp. Physiol. A.* **186**, 375–387.
(doi:10.1007/s003590050437)

4\. Maia R, Gruson H, Endler JA, White TE. 2019 pavo 2: New tools for
the spectral and spatial analysis of colour in r. *Methods Ecol. Evol.*
**10**, 1097–1107. (doi:10.1111/2041-210X.13174)

5\. R Core Team. 2020 R: A Language and Environment for Statistical
Computing.

6\. Endler JA, Monographs E, Feb N. 1993 The Color of Light in Forests
and Its Implications. *Ecol. Monogr.* **63**, 1–27.
(doi:10.2307/2937121)

7\. Kemp DJ, Herberstein ME, Fleishman LJ, Endler JA, Bennett ATD, Dyer
AG, Hart NS, Marshall J, Whiting MJ. 2015 An Integrative Framework for
the Appraisal of Coloration in Nature. *Am. Nat.* **185**, 705–724.
(doi:10.1086/681021)

8\. Clement P, Hathway R. 2000 *Thrushes*. London: A\&C Black Publishers
Ltd.

9\. del Hoyo J, Elliott A, Sargatal J, Christie DA, de Juana E. 2017
Handbook of the birds of the world alive. *Handb. Birds World Alive*.

10\. BirdLife International and Handbook of the Birds of the World. 2018
Bird species distribution maps of the world. Version 2018.1. See
http://datazone.birdlife.org/species/requestdis.

11\. Vilela B, Villalobos F. 2015 letsR: a new R package for data
handling and analysis in macroecology. *Methods Ecol. Evol.* **6**,
1229–1234. (doi:https://doi.org/10.1111/2041-210X.12401)

12\. Cooney CR, Tobias JA, Weir JT, Botero CA, Seddon N. 2017 Sexual
selection, speciation and constraints on geographical range overlap in
birds. *Ecol. Lett.* **20**, 863–871. (doi:10.1111/ele.12780)

13\. Bürkner PC. 2017 brms: An R package for Bayesian multilevel models
using Stan. *J. Stat. Softw.* **80**, 1–28. (doi:10.18637/jss.v080.i01)

14\. Nylander JAA, Olsson U, Alström P, Sanmartín I. 2008 Accounting for
phylogenetic uncertainty in biogeography: A bayesian approach to
dispersal-vicariance analysis of the thrushes (Aves: Turdus). *Syst.
Biol.* **57**, 257–268. (doi:10.1080/10635150802044003)

15\. Gelman A, Carlin JB, Stern HS, Dunson DB, Vehtari A, Rubin DB. 2013
*Bayesian data analysis, third edition*. 3rd edn. Boca Raton, FL: CRC
Press. (doi:10.1201/b16018)

16\. Vehtari A, Gelman A, Gabry J. 2017 Practical Bayesian model
evaluation using leave-one-out cross-validation and WAIC. *Stat.
Comput.* **27**, 1413–1432. (doi:10.1007/s11222-016-9696-4)
