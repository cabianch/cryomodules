TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#========================================

# ================================================
# Build the IOC application
# ================================================
# This will attempt to build an IOC application 
# for every target including the host computer.
PROD_IOC_Linux = cryomodules

# cryomodules.dbd will be created and installed
DBD += crymodules.dbd

# cryomodules.dbd will be made up from these files:
cryomodules_DBD += base.dbd
cryomodules_DBD += devIocStats.dbd
cryomodules_DBD += asSupport.dbd
#cryomodules_DBD += caPutLog.dbd
cryomodules_DBD += ether_ip.dbd
#cryomodules_DBD += drvEtherIP.dbd

# ======================================================================
# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
cryomodules_SRCS += cryomodules_registerRecordDeviceDriver.cpp

ifneq ($(T_A),linuxRT-x86)
 cryomodules_SRCS_DEFAULT += cryomodulesMain.cpp
endif

cryomodules_SRCS_vxWorks += -nil-

#ifeq ($(T_A),linuxRT-x86)
#cryomodules_SRCS_DEFAULT += cryomoduleslinuxRT_Main_.cpp
#cryomodules_SRCS += systemCommand.c
#endif
# ========================================================================
# ========================================================================
# Add locally compiled object code
# For example, subroutines
# ========================================================================
# cryomodules_SRCS += file1.c
# cryomodules_SRCS += file2.c

# The following adds support from base/src/vxWorks
# cryomodules_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# =====================================================
# Link in the code from other libraries
# =====================================================
#
# iocAdmin
cryomodules_LIBS += devIocStats 
# autosave
cryomodules_LIBS += autosave
# caPutLog 
#cryomodules_LIBS += caPutLog
# ether-ip
cryomodules_LIBS += ether_ip
#
# =====================================================

# NOTE: To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

ifneq ($(SNCSEQ),)
    # This builds sncExample as a component of cryomodules
    cryomodules_SNCFLAGS += +r
#    cryomodules_DBD += sncExample.dbd
#    cryomodules_SRCS += sncExample.stt
    cryomodules_LIBS += seq pv

    # The following builds sncProgram as a standalone application
#  ifneq ($(T_A),linuxRT-x86)
#    PROD_HOST += sncProgram
#    sncProgram_SNCFLAGS += +m
#    sncProgram_SRCS += sncProgram.st
#    sncProgram_LIBS += seq pv
#    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
#  endif
endif
# epics base libs
cryomodules_LIBS += $(EPICS_BASE_IOC_LIBS)

# Needed for static builds and stream device
ifeq ($(T_A),linux-x86)
USR_SYS_LIBS += pcre
endif


#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

