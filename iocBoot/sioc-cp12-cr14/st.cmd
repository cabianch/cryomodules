#!../../bin/linux-x86_64/cryoControl
#==============================================================
#
#  Abs:  Startup for CryoControl App
#
#  Name: st.cmd
#
#
#  Side: This script is executed from:
#         $EPICS_IOCS/sioc-cp12-cr14/startup.cmd
#
#  Facility: Cryo Controls
#
#  Auth: 05-JUN-2015, Diane Fairley (DFAIRLEY)
#  Rev:  dd-mmm-yyyy, Reviewer's Name (USERNAME)
#--------------------------------------------------------------
#  Mod:
#        dd-mmm-yyyy, First Lastname  (USERNAME):
#          comment
#
#==============================================================
#

< envPaths

# Set environment variables
epicsEnvSet("AREA"      ,"CP12")
#
# name the PLC
#
epicsEnvSet("PLC_NODE"    ,"plc-b34-cr01")
epicsEnvSet("PLC_NAME"    ,"PLC_CP12_CR14")
epicsEnvSet("P_NAME" 	  ,"PLC:CP12:CR14")
#
#name the sioc
#
epicsEnvSet("IOC_NODE"    ,"sioc-b34-cr01")
epicsEnvSet("IOC_NAME"    ,"SIOC:CP12:CR14")
#
# might use this later
#epicsEnvSet("VAC_AFC_FILE ,"vac.acf")
#
# iocAdmin environment variables
epicsEnvSet("ENGINEER"   , "Diane Fairley")
epicsEnvSet("IOC_RESTORE", "${IOC_DATA}/${IOC}/restore")
epicsEnvSet("IOC_BOOT"   , "${TOP}/iocBoot/${IOC}")
epicsEnvSet("STARTUP"    , "${EPICS_IOCS}/${IOC}")
epicsEnvSet("ST_CMD"     , "startup.cmd")
#
# tag log messages with IOC name
# How to escape the "sioc-b34-cr01" as the PERL program
# will try to replace it.
# So, uncomment the following and remove the backslash
epicsEnvSet("EPICS_IOC_LOG_CLIENT_INET","${IOC}")
#
#
cd ${TOP}
#
## Register all support components
dbLoadDatabase "dbd/cryoControl.dbd"
cryoControl_registerRecordDeviceDriver pdbbase
#
# Define EtherIP PLC connections
# Initialize EtherIP driver and define PLC
EIP_buffer_limit(400)
drvEtherIP_init()

#
# drvEtherIP_define_PLC <name>, <ip_addr>, <slot>
drvEtherIP_define_PLC("${PLC_NAME}","${PLC_NODE}", 4)
#
# EtherIP Debug messages
EIP_verbosity(2)
drvEtherIP_default_rate(1)
#
# IOC Health Monitoring
dbLoadRecords("db/iocAdminSoft.db"   ,"IOC=${IOC_NAME}")
dbLoadRecords("db/iocAdminScanMon.db","IOC=${IOC_NAME}")
#
# The following database is a result of a python parser
# which looks at RELEASE_SITE and RELEASE to discover
# versions of software your IOC is referencing
# The python parser is part of iocAdmin
dbLoadRecords("db/iocRelease.db"     ,"IOC=${IOC_NAME}")
#
# Load Channel Access Security configuration file
#asSetFilename("bin/${ARCH}/${VAC_ACF_FILE}")
#
## Load record instances
dbLoadRecords("db/cryoControl_plcAdmin.db","CP=1, C=4, P_NAME=${P_NAME}, PLC_NAME=${PLC_NAME}")
dbLoadRecords("db/pid.db", "CP=1, C=4")
dbLoadRecords("db/wcmp_AIns.db", "PLC_NAME=${PLC_NAME},CP=1,C=4,CMPNUM=4")
dbLoadRecords("db/wcmp_misc.db", "PLC_NAME=${PLC_NAME},CP=1,C=4,CMPNUM=4")
dbLoadRecords("db/wcmp_StartStop.db", "PLC_NAME=${PLC_NAME},CP=1,C=4,LOCA=14,CMPNUM=4")
dbLoadRecords("db/plc_status.db", "PLC_NAME=${PLC_NAME},CP=1,C=4,LOCA=14,CMPNUM=4")
dbLoadRecords("db/alarms.db", "CP=1,C=4") 

#
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
#save_restoreSet_DatedBackupFiles(1)
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
#
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
# change directory to TOP of application
cd("${TOP}")
pwd()
EIP_buffer_limit(495)
#
#
# Turn on caPutLogging:
# Log values only on change to the iocLogServer:
#caPutLogInit("${EPICS_CA_PUT_LOG_ADDR}")
#caPutLogShow(2)
#
## Start any sequence programs
#seq sncExample, "user=dfairleyHost"

