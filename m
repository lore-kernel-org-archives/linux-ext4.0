From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
Subject: Re: 3.10.9: EXT4-fs (sdb1): delayed block allocation failed for inode
 163315715 at logical offset 1 with max blocks 2 with error -5
Date: Fri, 30 Aug 2013 17:37:21 +0200
Message-ID: <5220BC31.9020904@gmail.com>
References: <521DE3C1.8030304@gmail.com> <20130830151855.GC30385@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130830151855.GC30385@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o wrote:
> Your SATA disk had enough errors that the ATA link was completely
> reset, and the device was detached and then reattached.  As far as
> kernel is concerned, it's a new device.

Later on I rebooted and ran smarctl:

# smartctl --test=long /dev/sdb 

As of now after two days I have:

# smartctl -a /dev/sdb 
smartctl 6.0 2012-10-10 r3643 [x86_64-linux-3.10.9-default-pciehp] (local build)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate SV35
Device Model:     ST3000VX000-1CU166
Serial Number:    Z1F1YB3K
LU WWN Device Id: 5 000c50 04f5930de
Firmware Version: CV22
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Aug 30 17:32:13 2013 MEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (   89) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
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
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 326) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x10b9) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   108   099   006    Pre-fail  Always       -       19762904
  3 Spin_Up_Time            0x0003   092   091   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       57
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   066   060   030    Pre-fail  Always       -       4287008
  9 Power_On_Hours          0x0032   096   096   000    Old_age   Always       -       3770
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       49
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   099   000    Old_age   Always       -       8590065666
189 High_Fly_Writes         0x003a   001   001   000    Old_age   Always       -       464
190 Airflow_Temperature_Cel 0x0022   056   052   045    Old_age   Always       -       44 (Min/Max 25/45)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       41
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       57
194 Temperature_Celsius     0x0022   044   048   000    Old_age   Always       -       44 (0 16 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      3728         -

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

#


> 
> The problem is that the ext4 mount was for the old device, not the
> newly attached device.  So attempts to read from the device is
> returning errors from the block device layer.

Aha, that was wrong. I thought it happened that kernel ran out of some buffers because
I used shell redirect to write into a file and the buffer just kept growing once the disk
was not accessible. But sure, teh first question is why it was not accessible.

> 
>> but later on, suddenly, without any other related message in between as far as I can see:
>>
>> Aug 28 11:47:39 vostro kernel: [25874.121506] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
>> Aug 28 11:47:39 vostro kernel: [25874.121510] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
> 
> This was just the first timat the system had tried accessing the file
> system, and when it tried reading from the device, it got an I/O
> failure from the device pretty much immediately.  
> 
>> So kernel was trying for 10 minutes before it gave up?
> 
> I'm guessing your file system is configured with errors=continued?

How can I check? I just did mount without any arguments.

> 
>> Any clues what I should look at? Few days ago memtest86+ went fine through all 16GB of RAM (Dell Vostro 3550). I do not know if the PCI/ACPI change is related or not. 
> 
> The error is happening at the block device layer.  So I don't know
> whether it's caused by the table getting bumped, or something getting
> confused when the device tried to enter some kind of power saving
> mode, etc.

I don't think it was going to sleep. I was reading data from it. I suspect that
it was the ACPI which messed in due to that battery/ac power change. No, there
was no power outage.

Martin
