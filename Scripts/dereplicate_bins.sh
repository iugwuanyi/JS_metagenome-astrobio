#!/bin/bash

#######################################################################################################################
#
# MAGs were dereplicated  using dRep v3.4.2. Instructions on how to install and run dRep can be found at 
# https://github.com/MrOlm/drep
#######################################################################################################################

#dereplicate bins
dRep dereplicate MAGs_drep -g All_MAGs/*.fa -p 12