# Rfishpop
Population dynamic tools in support of fisheries managment.

First step is to install devtools package using install.packages("devtools"). 


There are two options for installing our package:

1. Version with vignettes: install_github("IMPRESSPROJECT/Rfishpop", build_vignettes = TRUE). This option needs to install previously the following packages:

install.packages (c("FLAssess", "Flash", "ggplotFL", "FLBRP", "FLCore", repos = http://flr-project.org/R)) # From FLR project

install.packages (c("ggplot2", "tydiverse", "reshape2", "LBSPR")) # From CRAN

PLEASE DON'T STOP THE PROCESS! IT NEEDS TIME TO CREATE ALSO THE VIGNETTES.

2. Version without vignettes: install_github("IMPRESSPROJECT/Rfishpop") this option is faster and don't need the installation of all the previous packages.


Please restart R after install the package.