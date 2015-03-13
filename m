From: Adrian Bridgett <adrian@smop.co.uk>
Subject: very slow SSD with fsync
Date: Fri, 13 Mar 2015 14:48:03 +0000
Message-ID: <5502F8A3.4020608@smop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35287 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbbCMOsG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Mar 2015 10:48:06 -0400
Received: by wggy19 with SMTP id y19so23778589wgg.2
        for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2015 07:48:04 -0700 (PDT)
Received: from [192.168.1.12] (188.29.165.45.threembb.co.uk. [188.29.165.45])
        by mx.google.com with ESMTPSA id gi9sm3083269wib.21.2015.03.13.07.48.03
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Mar 2015 07:48:04 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Slow as in sync(1) taking 6 seconds on an idle system, dd-ing from the 
raw disk drops from 600MB/s to less than 1MB/s.   iotop shows jbd2 often 
waiting a long time, but _very_ low throughput (KB/s it that).  I've 
spent a day or so trying everything I can find to identify the cause but 
I'm completely stuck (even with help from a btrfs guru - he eventually 
suggested asking here).

Chrome and dropbox seem to trigger this, I'm just installing a pretty 
new Macbook Pro (didn't get along with OSX, returning to Linux).  The 
system was fine, but now seems to be reaaaaalllly slow.  Maybe it's as 
I've put stuff on, but I think that it's degradation caused by something 
else.

The only thing that makes a difference is mounting with barrier=0 but 
I'd rather not do that of course.  I'm not trying to maximise 
performance here, just eliminate some nasty buglet/incompatibility.

I've tried:
- fstrim
- noncq (just in case)
- disabling power management (tlp daemon, then turning off tweakables in 
powertop)
- latest 3.19.1 ubuntu kernel and also 3.16
- adding discard to mount options, also taking it away again and just fstrim
- disabling SMART (saw one report on a normal hard disk after 30mins - 
note that mine is slow immediately) 
http://unix.stackexchange.com/questions/165464/calls-to-sync-fsync-slow-down-after-30-minutes-uptime
- using the tracing framework (thanks to Ted for a comment elsewhere) I 
traced the slowness to these syncs being very slow (my much older laptop 
takes 0.05s...)

Disk is EcryptFS on LVM (mounted data=ordered) - Ubuntu defaults. I 
tried moving dropbox to non-encryptFS and no joy.  My friend suggested 
that I use LUKS instead but it seems that I'll still have this issue.

I've been using dd|pv for some tests, hdparm shows similar results (this 
set taken with thunderbird, but no chrome, no dropbox running) - and the 
cursor locks up every few seconds whilst I'm typing this!)

[13:50]~# hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
     Model Number:       APPLE SSD SM0512F
     Serial Number:      S1K5NYBF266383
     Firmware Revision:  UXM2JA1Q
     Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II 
Extensions, SATA Rev 2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
     Used: unknown (minor revision code 0x0039)
     Supported: 8 7 6 5
     Likely used: 8
Configuration:
     Logical        max    current
     cylinders    16383    16383
     heads        16    16
     sectors/track    63    63
     --
     CHS current addressable sectors:   16514064
     LBA    user addressable sectors:  268435455
     LBA48  user addressable sectors:  977105060
     Logical  Sector size:                   512 bytes
     Physical Sector size:                  4096 bytes
     Logical Sector-0 offset:                  0 bytes
     device size with M = 1024*1024:      477102 MBytes
     device size with M = 1000*1000:      500277 MBytes (500 GB)
     cache/buffer size  = unknown
     Nominal Media Rotation Rate: Solid State Device
Capabilities:
     LBA, IORDY(can be disabled)
     Queue depth: 32
     Standby timer values: spec'd by Standard, no device specific minimum
     R/W multiple sector transfer: Max = 16    Current = 16
     Recommended acoustic management value: 128, current value: 0
     DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
          Cycle time: min=120ns recommended=120ns
     PIO: pio0 pio1 pio2 pio3 pio4
          Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
     Enabled    Supported:
        *    SMART feature set
             Security Mode feature set
        *    Power Management feature set
        *    Write cache
        *    Look-ahead
        *    Host Protected Area feature set
        *    WRITE_BUFFER command
        *    READ_BUFFER command
        *    NOP cmd
        *    DOWNLOAD_MICROCODE
        *    SET_MAX security extension
             Automatic Acoustic Management feature set
        *    48-bit Address feature set
        *    Device Configuration Overlay feature set
        *    Mandatory FLUSH_CACHE
        *    FLUSH_CACHE_EXT
        *    SMART error logging
        *    SMART self-test
        *    General Purpose Logging feature set
        *    WRITE_{DMA|MULTIPLE}_FUA_EXT
        *    64-bit World wide name
        *    {READ,WRITE}_DMA_EXT_GPL commands
        *    Segmented DOWNLOAD_MICROCODE
        *    Gen1 signaling speed (1.5Gb/s)
        *    Gen2 signaling speed (3.0Gb/s)
        *    Gen3 signaling speed (6.0Gb/s)
        *    Native Command Queueing (NCQ)
        *    Phy event counters
             DMA Setup Auto-Activate optimization
        *    Software settings preservation
        *    SET MAX SETPASSWORD/UNLOCK DMA commands
        *    WRITE BUFFER DMA command
        *    READ BUFFER DMA command
        *    Data Set Management TRIM supported (limit 8 blocks)
Security:
     Master password revision code = 65534
         supported
     not    enabled
     not    locked
         frozen
     not    expired: security count
         supported: enhanced erase
     6min for SECURITY ERASE UNIT. 32min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5002538655584d30
     NAA        : 5
     IEEE OUI    : 002538
     Unique ID    : 655584d30
Integrity word not set (found 0x00bf, expected 0x100a5)

iotop -o -b:
Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   184 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.05 % [kworker/u16:3]
Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:      11.81 K/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   275 be/3 root        0.00 B/s    0.00 B/s  0.00 % 99.99 % [jbd2/dm-0-8]
  4308 be/4 abridget    0.00 B/s    0.00 B/s  0.00 % 99.99 % thunderbird
Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   184 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.07 % [kworker/u16:3]
Total DISK READ :       0.00 B/s | Total DISK WRITE :      31.33 K/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   184 be/4 root        0.00 B/s   31.33 K/s  0.00 %  0.00 % [kworker/u16:3]
Total DISK READ :       0.00 B/s | Total DISK WRITE :       7.70 K/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   275 be/3 root        0.00 B/s    0.00 B/s  0.00 % 99.99 % [jbd2/dm-0-8]
   184 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.04 % [kworker/u16:3]
  3148 be/4 abridget    0.00 B/s    7.70 K/s  0.00 %  0.00 % upstart --user
Total DISK READ :       0.00 B/s | Total DISK WRITE :      15.74 K/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:      70.81 K/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  4308 be/4 abridget    0.00 B/s   15.74 K/s  0.00 %  0.08 % thunderbird
   275 be/3 root        0.00 B/s    0.00 B/s  0.00 %  0.01 % [jbd2/dm-0-8]
Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   184 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.07 % [kworker/u16:3]
Total DISK READ :       0.00 B/s | Total DISK WRITE :      42.50 K/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:      42.50 K/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   275 be/3 root        0.00 B/s   27.04 K/s  0.00 % 99.99 % [jbd2/dm-0-8]
  4308 be/4 abridget    0.00 B/s   15.45 K/s  0.00 %  0.07 % thunderbird
Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:       0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   184 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.06 % [kworker/u16:3]
Total DISK READ :       0.00 B/s | Total DISK WRITE :      30.87 K/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     212.24 K/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   275 be/3 root        0.00 B/s   19.29 K/s  0.00 % 99.99 % [jbd2/dm-0-8]
  4308 be/4 abridget    0.00 B/s   11.58 K/s  0.00 %  0.00 % thunderbird
Total DISK READ :       0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:      23.49 K/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  4308 be/4 abridget    0.00 B/s    0.00 B/s  0.00 % 25.66 % thunderbird
   184 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.05 % [kworker/u16:3]
   275 be/3 root        0.00 B/s    0.00 B/s  0.00 %  0.02 % [jbd2/dm-0-8]

And now (more programs):
[14:30]~$ sudo mount -o remount,barrier=0 /
[14:33]~$ sudo hdparm -tT /dev/sda
/dev/sda:
  Timing cached reads:   6548 MB in  2.00 seconds = 3275.19 MB/sec
  Timing buffered disk reads: 2352 MB in  3.00 seconds = 783.92 MB/sec

[14:34]~$ sudo mount -o remount,barrier=1 /
[14:34]~$ sudo hdparm -tT /dev/sda
/dev/sda:
  Timing cached reads:     2 MB in  2.88 seconds = 710.50 kB/sec
  Timing buffered disk reads:  20 MB in  5.07 seconds =   3.94 MB/sec

[14:34]~$ sudo mount -o remount,barrier=0 /
[14:35]~$ sudo hdparm -tT /dev/sda
/dev/sda:
  Timing cached reads:   17316 MB in  2.00 seconds = 8666.69 MB/sec
  Timing buffered disk reads: 2368 MB in  3.00 seconds = 789.12 MB/sec

