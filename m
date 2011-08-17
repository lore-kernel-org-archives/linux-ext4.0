From: Thomas Backlund <tmb@mageia.org>
Subject: Re: INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds
Date: Thu, 18 Aug 2011 00:08:53 +0300
Message-ID: <4E4C2DE5.5020100@mageia.org>
References: <4E4BC296.1040004@mageia.org> <96850198-2253-40F7-B99C-62A6097278FA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <96850198-2253-40F7-B99C-62A6097278FA@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger skrev 17.8.2011 17:35:
> On 2011-08-17, at 7:31 AM, Thomas Backlund<tmb@mageia.org>  wrote:
>>
>> One of our buildnodes, a 8-core Supermicro X7DA8 system,
>> and a WDC WD1002FAEX-0 sata disk hits the "blocked for more than 120 seconds" several times, and ends up resetting the ata bus.
>>
>> The disk does not report any errors with smart, and we have the same model in a 24-core Supermicro X8DTN, and it does not show this problem.
>>
>> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>> ata3.00: failed command: FLUSH CACHE EXT
>> ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>>          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata3.00: status: { DRDY }
>> ata3: soft resetting link
>> ata3.00: configured for UDMA/133
>> ata3.00: retrying FLUSH 0xea Emask 0x4
>> ata3: EH complete
>
> This is a problem with your disk hardware.
>

Are you sure?
I get nothing from smart, even after I had executed the long test...

# smartctl -a /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-mandriva-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD1002FAEX-00Z3A0
Serial Number:    WD-WCATR3168879
Firmware Version: 05.01D05
User Capacity:    1,000,204,886,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Aug 17 23:07:52 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x85) Offline data collection activity
                                         was aborted by an interrupting 
command from host.
                                         Auto Offline Data Collection: 
Enabled.
Self-test execution status:      ( 241) Self-test routine in progress...
                                         10% of test remaining.
Total time to complete Offline
data collection:                 (17400) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 201) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3037) SCT Status supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail 
Always       -       0
   3 Spin_Up_Time            0x0027   186   174   021    Pre-fail 
Always       -       3683
   4 Start_Stop_Count        0x0032   100   100   000    Old_age 
Always       -       15
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail 
Always       -       0
   7 Seek_Error_Rate         0x002e   200   200   000    Old_age 
Always       -       0
   9 Power_On_Hours          0x0032   091   091   000    Old_age 
Always       -       7113
  10 Spin_Retry_Count        0x0032   100   253   000    Old_age 
Always       -       0
  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age 
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age 
Always       -       13
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always 
       -       11
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always 
       -       3
194 Temperature_Celsius     0x0022   115   108   000    Old_age   Always 
       -       32
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always 
       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always 
       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age 
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      7109 
      -
# 2  Extended offline    Completed without error       00%      7003 
      -
# 3  Extended offline    Completed without error       00%      6837 
      -
# 4  Extended offline    Completed without error       00%      6670 
      -
# 5  Extended offline    Completed without error       00%      6504 
      -
# 6  Extended offline    Completed without error       00%      6338 
      -
# 7  Extended offline    Completed without error       00%      6173 
      -
# 8  Extended offline    Completed without error       00%      6006 
      -
# 9  Extended offline    Completed without error       00%      5840 
      -
#10  Extended offline    Completed without error       00%      5674 
      -
#11  Extended offline    Completed without error       00%      5507 
      -
#12  Extended offline    Completed without error       00%      5340 
      -
#13  Extended offline    Completed without error       00%      5173 
      -
#14  Extended offline    Completed without error       00%      5007 
      -
#15  Extended offline    Completed without error       00%      4841 
      -
#16  Extended offline    Completed without error       00%      4675 
      -
#17  Extended offline    Completed without error       00%      4510 
      -
#18  Extended offline    Completed without error       00%      4344 
      -
#19  Extended offline    Completed without error       00%      4179 
      -
#20  Extended offline    Completed without error       00%      4012 
      -
#21  Extended offline    Completed without error       00%      3847 
      -

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

--
Thomas
