From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63981] Bad: Buffer I/O errors make disk unusable
Date: Mon, 28 Oct 2013 23:01:07 +0000
Message-ID: <bug-63981-13602-jqIpDHRCQQ@https.bugzilla.kernel.org/>
References: <bug-63981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40802 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525Ab3J1XBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Oct 2013 19:01:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F0D7420360
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 23:01:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8498D2035D
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 23:01:07 +0000 (UTC)
In-Reply-To: <bug-63981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63981

--- Comment #2 from Giuseppe Scalzi <scalg1@bfh.ch> ---
(In reply to Theodore Tso from comment #1)
> From the errors listed in the dmesg, looks like it is a hardware problem
> with the SSD, not an ext4 bug.
> 
> I'd suggest doing a full backup of your disk while you still can, and try
> replacing the SSD....

That's strange because I bought the laptop two weeks ago and for one week I
used windows and all worked fine. I have this problem since the first day after
installing Linux. 

Is it possible to check if there are some hardware errors from smartctl?

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG MZNTD256HAGL-00000
Serial Number:    S15ZNYAD730814
LU WWN Device Id: 5 002538 5000648f8
Firmware Version: DXT2300Q
User Capacity:    256,060,514,304 bytes [256 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4c
Local Time is:    Mon Oct 28 23:47:51 2013 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine
completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (53956) seconds.
Offline data collection
capabilities:                    (0x53) SMART execute Offline immediate.
                                        Auto Offline data collection on/off
support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  40) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always      
-       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always      
-       118
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always      
-       143
177 Wear_Leveling_Count     0x0013   099   099   000    Pre-fail  Always      
-       1
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always      
-       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always      
-       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always      
-       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always      
-       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always      
-       0
190 Airflow_Temperature_Cel 0x0032   061   030   000    Old_age   Always      
-       39
195 Hardware_ECC_Recovered  0x001a   200   200   000    Old_age   Always      
-       0
199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Always      
-       0
235 Unknown_Attribute       0x0012   099   099   000    Old_age   Always      
-       52
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always      
-       851312137

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
  255        0    65535  Read_scanning was never started
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
