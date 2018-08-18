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
PROD_IOC_Linux = cryoControl

# cryoControl.dbd will be created and installed
DBD += cryoControl.dbd

# cryoControl.dbd will be made up from these files:
cryoControl_DBD += base.dbd
cryoControl_DBD += devIocStats.dbd
cryoControl_DBD += asSupport.dbd
#cryoControl_DBD += caPutLog.dbd
cryoControl_DBD += ether_ip.dbd
#cryoControl_DBD += drvEtherIP.dbd

# ======================================================================
# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
cryoControl_SRCS += cryoControl_registerRecordDeviceDriver.cpp

ifneq ($(T_A),linuxRT-x86)
 cryoControl_SRCS_DEFAULT += cryoControlMain.cpp
endif

cryoControl_SRCS_vxWorks += -nil-

#ifeq ($(T_A),linuxRT-x86)
#cryoControl_SRCS_DEFAULT += cryoControllinuxRT_Main_.cpp
#cryoControl_SRCS += systemCommand.c
#endif
# ========================================================================
# ========================================================================
# Add locally compiled object code
# For example, subroutines
# ========================================================================
# cryoControl_SRCS += file1.c
# cryoControl_SRCS += file2.c

# The following adds support from base/src/vxWorks
# cryoControl_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# =====================================================
# Link in the code from other libraries
# =====================================================
#
# iocAdmin
cryoControl_LIBS += devIocStats 
# autosave
cryoControl_LIBS += autosave
# caPutLog 
#cryoControl_LIBS += caPutLog
# ether-ip
cryoControl_LIBS += ether_ip
#
# =====================================================

# NOTE: To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

ifneq ($(SNCSEQ),)
    # This builds sncExample as a component of cryoControl
    cryoControl_SNCFLAGS += +r
#    cryoControl_DBD += sncExample.dbd
#    cryoControl_SRCS += sncExample.stt
    cryoControl_LIBS += seq pv

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
cryoControl_LIBS += $(EPICS_BASE_IOC_LIBS)

# Needed for static builds and stream device
ifeq ($(T_A),linux-x86)
USR_SYS_LIBS += pcre
endif


#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

