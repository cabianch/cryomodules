#==============================================================
#
#  Abs:  Makefile to build EPICS Database components
#
#  Name: Makefile
#
#  Facility: LCLS-II CryoControls
#
#  Auth: 03-Sep-2006, Diane Fairley  (dfairley)
#  Rev:  dd-mmm-yyyy, First Lastname  (USERNAME)
#--------------------------------------------------------------
#  Mod:
#	 06-Mar-2017, C.Bianchini (carolina)
#	    Add vdb and db files that need to build under /db
#
#        01-Sept-2016, D. Fairley (dfairley):
#           Add Db subdirectories
#
#==============================================================
#
TOP=../..
include $(TOP)/configure/CONFIG
#DIRS += cryoplant 
#DIRS += cds-cms
include $(TOP)/configure/RULES_DIRS
# Install Common databases needed by All IOCs
 # ========================================================
 # Install databases from iocAdmin package
 # These databases support IOC Health and Monitoring
 # ========================================================
 # SoftIOC
 DB_INSTALLS += $(IOCADMIN)/db/iocAdminSoft.db
 DB_INSTALLS += $(IOCADMIN)/db/iocAdminScanMon.db
 DB_INSTALLS += $(IOCADMIN)/db/iocScanMonSum.db
 DB_INSTALLS += $(IOCADMIN)/db/iocScanMon.db
 DB_INSTALLS += $(IOCADMIN)/db/access.db
 IOCRELEASE_DB += iocRelease.db

 # Install Database to support reading the status of the autosave package:
 DB_INSTALLS += $(AUTOSAVE)/db/save_restoreStatus.db
 # PLC
 PLCADMIN_TEMPLATE += $(PLCADMIN)/db/plcAdminControlLogix.template
 ETHER_IP_TEMPLATE += $(ETHER_IP)/db/eip_stat.db

 #----------------------------------------------------
 # Create and install (or just install)
 # databases, templates, substitutions like this
# DB += plc_status.db
# DB += pid.db
# DB += alarms.db
 #
 # substitution files
 #
# DB += wcmp_AIns.db
# DB += cryoControl_plcAdmin.db

 DB += RTDs.db
 DB += valves.db
 DB += pressures.db
 DB += levels.db
 DB += heaters.db


 # =======================================================================

 #----------------------------------------------------
 # If <anyname>.db template is not named <anyname>*.template add
 # <anyname>_TEMPLATE = <templatename>

 include $(TOP)/configure/RULES
 #----------------------------------------
 #  ADD RULES AFTER THIS LINE
 #end of file.


