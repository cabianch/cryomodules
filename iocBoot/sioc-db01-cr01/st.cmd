#!../../bin/rhel6-x86_64/cryomodules
#==============================================================
#
#  Abs:  Startup for CryoControl App
#
#  Name: st.cmd
#
#
#  Side: This script is executed from:
#         $EPICS_IOCS/sioc-db01-cr01/startup.cmd
#
#  Facility: Cryomodules controls
#
#  Auth: 22-AUG-2018, Carolina Bianchini (CAROLINA)
#  Rev:  dd-mmm-yyyy, Reviewer's Name (USERNAME)
#--------------------------------------------------------------
#  Mod:
#        dd-mmm-yyyy, First Lastname  (USERNAME):
#          comment
#
#==============================================================
#

< envPaths

#==============================================================
# Set environment variables
#==============================================================
#
# name the PLC
#
epicsEnvSet("PLC_NODE"    ,"129.57.244.23")
epicsEnvSet("PLC_SLOT"    ,"0")
epicsEnvSet("PLC_NAME"    ,"PLC_B15")
epicsEnvSet("P_NAME" 	  ,"PLC:DB01:CR01")
#
#name the sioc
#
epicsEnvSet("IOC_NAME"    ,"SIOC:DB01:CR01")
epicsEnvSet("IOC_NODE"    ,"sioc-db01-cr01")
##
# iocAdmin environment variables
epicsEnvSet("ENGINEER"   , "Carolina Bianchini")
epicsEnvSet("IOC_RESTORE", "${IOC_DATA}/${IOC}/restore")
epicsEnvSet("IOC_BOOT"   , "${TOP}/iocBoot/${IOC}")
epicsEnvSet("STARTUP"    , "${EPICS_IOCS}/${IOC}")
epicsEnvSet("ST_CMD"     , "startup.cmd")
#
# tag log messages with IOC name
epicsEnvSet("EPICS_IOC_LOG_CLIENT_INET","${IOC}")
#
#
#==============================================================
## back to TOP
#==============================================================
cd ${TOP}
#
#
# Register all support components
dbLoadDatabase "dbd/cryomodules.dbd"
cryomodules_registerRecordDeviceDriver pdbbase
#
#==============================================================
# Define EtherIP PLC connections
#==============================================================
# Initialize EtherIP driver and define PLC
EIP_buffer_limit(400)
drvEtherIP_init()
#
# drvEtherIP_define_PLC <name>, <ip_addr>, <slot>
drvEtherIP_define_PLC("${PLC_NAME}","${PLC_NODE}", "${PLC_SLOT}")
#
# EtherIP Debug messages
EIP_verbosity(2)
drvEtherIP_default_rate(1)
#
#==============================================================
# Load IOC Health Monitoring records
#==============================================================
dbLoadRecords("db/iocAdminSoft.db"   ,"IOC=${IOC_NAME}")
dbLoadRecords("db/iocAdminScanMon.db","IOC=${IOC_NAME}")
#
# The following database is a result of a python parser
# which looks at RELEASE_SITE and RELEASE to discover
# versions of software your IOC is referencing
# The python parser is part of iocAdmin
dbLoadRecords("db/iocRelease.db"     ,"IOC=${IOC_NAME}")
#
#==============================================================
## Load SIOC specific record instances
#==============================================================
#
#dbLoadRecords("db/cryoplant_plcAdmin.db","CP=1, C=4, P_NAME=${P_NAME}, PLC_NAME=${PLC_NAME}")
#
#dbLoadRecords("db/wcmp_AIs.db", "PLC_NAME=${PLC_NAME},CP=1,C=4")
#dbLoadRecords("db/wcmp_components.db", "PLC_NAME=${PLC_NAME},CP=1,C=4")
#dbLoadRecords("db/wcmp_plc_status.db", "PLC_NAME=${PLC_NAME},CP=1,C=4")
#dbLoadRecords("db/wcmp_alarms.db", "PLC_NAME=${PLC_NAME},CP=1,C=4") 
dbLoadRecords("db/heaters.db", "PLC_NAME=${PLC_NAME}")

#==============================================================
# Load Channel Access Security configuration file
#==============================================================
#this file contains the CRYO group
asSetFilename("${ACF_FILE}")
#
#
#==============================================================
# Initialize Autosave Save/Restore
#==============================================================
# Initialize Autosave Save/Restore
save_restoreSet_Debug(0)
#
# Specify where request and save_restore files can be found
set_requestfile_path("${IOC_DATA}/${IOC}/autosave-req")
set_savefile_path("${IOC_DATA}/${IOC}/autosave")
#
# Status-PV prefix, so save_restore can find its status PVs.
save_restoreSet_status_prefix("${IOC_NAME}:")
#
# Load bumpless reboot status database
dbLoadRecords("db/save_restoreStatus.db","P=${IOC_NAME}:")
#
# Ok to restore a save set that had missing values (no CA connection to PV)?
# Ok to save a file if some CA connections are bad?
save_restoreSet_IncompleteSetsOk(1)
#
# In the restore operation, a copy of the save file will be written.  The
# file name can look like "auto_settings.sav.bu", and be overwritten every
# reboot, or it can look like "auto_settings.sav_020306-083522" (this is what
# is meant by a dated backup file) and every reboot will write a new copy.
save_restoreSet_DatedBackupFiles(0)
#
# Specify what save files should be restored and when.
# Note: up to eight files can be specified for each pass.
set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")
#
# Number of sequenced backup files (e.g., 'info_settings.sav0') to write
save_restoreSet_NumSeqFiles(3)
#
# Time interval between sequenced backups
save_restoreSet_SeqPeriodInSeconds(600)
#
# Time between failed .sav-file write and the retry.
save_restoreSet_RetrySeconds(60)
#
#==============================================================
#  Initialize the IOC
#==============================================================
## Run this to trace the stages of iocInit
#traceIocInit
#
cd ${TOP}/iocBoot/${IOC}
iocInit
#
# Wait before building autosave files
epicsThreadSleep(1)
#
# Generate the autosave PV list
# Note we need change directory to
# where we are saving the restore
# request file.
cd("${IOC_DATA}/${IOC}/autosave-req")
makeAutosaveFiles()
#
# Start the save_restore task
# save changes on change, but no faster
# than every 60 seconds.
# Note: the last arg cannot be set to 0
create_monitor_set("info_positions.req", 60 )
create_monitor_set("info_settings.req" , 60 )
#
#==============================================================
# change directory to TOP of application
#==============================================================
cd("${TOP}")
pwd()
#
#==============================================================
# Turn on logging:
#==============================================================
iocLogInit
#
#==============================================================
# set message logging facility=CRYO and process=IOC_NODE for this sioc
#==============================================================
iocLogPrefix("fac=CRYO proc={IOC_NODE} ")
#
#==============================================================
# Turn on caPutLogging:
#==============================================================
# Log values only on change to the iocLogServer:
caPutLogInit("${EPICS_CA_PUT_LOG_ADDR}")
caPutLogShow(2)
#
## Start any sequence programs
#seq sncExample, "user=carolinaHost"

