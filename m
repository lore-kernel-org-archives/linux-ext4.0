From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 corruption on md [7x1TB in RAID5]
Date: Sat, 09 May 2009 12:50:43 -0600
Message-ID: <20090509185043.GM3209@webber.adilger.int>
References: <EB618291F3454E4DA10D152B9045C01701D2836B@exchange-2.sandvine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Don Bowman <don@sandvine.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59100 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZEISu7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 May 2009 14:50:59 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n49IotlY002703
	for <linux-ext4@vger.kernel.org>; Sat, 9 May 2009 11:50:58 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KJE00G0046XYY00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sat,
 09 May 2009 11:50:55 -0700 (PDT)
In-reply-to: <EB618291F3454E4DA10D152B9045C01701D2836B@exchange-2.sandvine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 09, 2009  13:14 -0400, Don Bowman wrote:
> I cleanly shut down my system, and when it came back up, this was
> reported:
> 
> * Checking file systems...
> Sat May  9 13:00:53 2009
> 
> fsck 1.41.4 (27-Jan-2009)
> fsck.ext4: Unable to resolve
> 'UUID=52e18bf7-cbe9-4f58-824c-5c943dd074de'^M
> fsck died with exit status 8
> 
> For some reason it thinks it is ext2:
> 
> root@server:/var/log/fsck# fsck -n /dev/md0 | head -5
> fsck 1.41.4 (27-Jan-2009)
> e2fsck 1.41.4 (27-Jan-2009)
> fsck.ext2: Group descriptors look bad... trying backup blocks...
> Inode table for group 0 is not in group.  (block 3251545658)
> WARNING: SEVERE DATA LOSS POSSIBLE.
> Relocate? No

Looks like the beginning of your disk is corrupted/overwritten.
It is strange that the backup descriptors didn't have something
more sane...  Hmm, it looks like e2fsck isn't so great at trying
the backup group descriptors when there is a problem.  It checks
the superblock, and assumes the group descriptors are OK and/or
need to be fixed.

It would probably be very useful if e2fsck verified the superblock
and group descriptors separately and/or printed a message like:
"group descriptors in group M corrupted, trying backup group N.
 Run 'e2fsck -b {blocksize} -B (N * 32768)' to try a different group".
Ideally it would just try until it finds a group that has no errors.

Alternately, picking some backup group in the middle of the filesystem
is probably the safest place, instead of starting at the beginning of
the disk.

> Upon investigation, i'm not sure what to do. I really don't want to lose
> the data on this disk as it will take ages to rebuild (like weeks!).
> 
> The system has been in operation for about 2-3months. The data on the
> disk is mostly video + some virtual machines.
> 
> Any suggestions for repairing it? I have not done any repairs so far.
> Should i just Run fsck.ext4? Is there something i should try?

If you have the ability, make a backup copy of the full device first
using "dd" to copy everything.  If your data is worth more than maybe
$500 then it justifies going out and buying a duplicate RAID setup.
You can use it for holding proper backups later...

Then, after you've done the backup, run "e2fsck -f -b (32768 * i) -B 4096",
where "i" is one of 1, 3, 5, 7, 9, 25, 27, 49, 81, 125, ... 3^n, 5^n, 7^n
to select a backup group explicitly.  Using a higer numbered backup group
is probably safer than group 1 or 3 (if there was corruption at the start
of your disk).

> root@server:/var/log/fsck# uname -a
> Linux server 2.6.28-12-server #43-Ubuntu SMP Fri May 1 20:22:39 UTC 2009
> x86_64 GNU/Linux
> 
> root@server:/var/log/fsck# fsck.ext4 -n /dev/md0 | head -5
> e2fsck 1.41.4 (27-Jan-2009)
> fsck.ext4: Group descriptors look bad... trying backup blocks...
> Inode table for group 0 is not in group.  (block 3251545658)
> WARNING: SEVERE DATA LOSS POSSIBLE.
> Relocate? No
> 
> root@server:~# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90
>   Creation Time : Sun Mar 15 12:15:20 2009
>      Raid Level : raid5
>      Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
>   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
>    Raid Devices : 7
>   Total Devices : 7
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat May  9 12:42:47 2009
>           State : clean
>  Active Devices : 7
> Working Devices : 7
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : c589dbe9:8dfff933:01f9e43d:ac30fbff (local to host
> server)
>          Events : 0.305524
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        0        0      active sync   /dev/sda
>        1       8       16        1      active sync   /dev/sdb
>        2       8       32        2      active sync   /dev/sdc
>        3       8       64        3      active sync   /dev/sde
>        4       8       80        4      active sync   /dev/sdf
>        5       8       96        5      active sync   /dev/sdg
>        6       8      112        6      active sync   /dev/sdh
> root@server:~#
> 
> 
> root@server:/var/log/fsck# dumpe2fs /dev/md0 |head -60
> dumpe2fs 1.41.4 (27-Jan-2009)
> ext2fs_read_bb_inode: Invalid argument
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem UUID:          52e18bf7-cbe9-4f58-824c-5c943dd074de
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      ext_attr resize_inode dir_index filetype
> extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink
> extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    (none)
> Filesystem state:         not clean with errors
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              366288896
> Block count:              1465143744
> Reserved block count:     73257187
> Free blocks:              1041313557
> Free inodes:              366151494
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      674
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> Flex block group size:    16
> Filesystem created:       Sun Mar 15 12:17:10 2009
> Last mount time:          Wed Apr 22 19:04:50 2009
> Last write time:          Sat May  9 12:31:43 2009
> Mount count:              9
> Maximum mount count:      29
> Last checked:             Sun Mar 15 12:17:10 2009
> Check interval:           15552000 (6 months)
> Next check after:         Fri Sep 11 12:17:10 2009
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Default directory hash:   half_md4
> Directory Hash Seed:      49785c19-388f-444c-977a-886c147a8ae6
> Journal backup:           inode blocks
> 
> Group 0: (Blocks 0-32767)
>   Checksum 0x70e6, unused inodes 34168
>   Primary superblock at 0, Group descriptors at 1-350
>   Reserved GDT blocks at 351-1024
>   Block bitmap at 98318778 (+98318778), Inode bitmap at 837719297
> (+837719297)
>   Inode table at 3251545658-3251546169 (+3251545658)
>   58662 free blocks, 33159 free inodes, 56553 directories, 34168 unused
> inodes
> Group 1: (Blocks 32768-65535) [INODE_UNINIT, ITABLE_ZEROED]
>   Checksum 0x6275, unused inodes 29973
>   Backup superblock at 32768, Group descriptors at 32769-33118
>   Reserved GDT blocks at 33119-33792
>   Block bitmap at 1123273429 (+1123240661), Inode bitmap at 3031071618
> (+3031038850)
>   Inode table at 3149300410-3149300921 (+3149267642)
>   1881 free blocks, 46059 free inodes, 25281 directories, 29973 unused
> inodes
> Group 2: (Blocks 65536-98303) [INODE_UNINIT, ITABLE_ZEROED]
>   Checksum 0x1a0b, unused inodes 51590
>   Block bitmap at 1509085182 (+1509019646), Inode bitmap at 2884607537
> (+2884542001)
>   Inode table at 1940584034-1940584545 (+1940518498)
>   3770 free blocks, 40683 free inodes, 43709 directories, 51590 unused
> inodes
> Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
>   Checksum 0xc3ec, unused inodes 47423
>   Backup superblock at 98304, Group descriptors at 98305-98654
>   Reserved GDT blocks at 98655-99328
>   Block bitmap at 383505502 (+383407198), Inode bitmap at 1784600367
> (+1784502063)
>   Inode table at 798930664-798931175 (+798832360)
>   63118 free blocks, 7143 free inodes, 19773 directories, 47423 unused
> inodes
> 
> 
> 
> root@server:/var/log/fsck# dmesg |egrep -i "sd|md|raid|fsck"
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] RAMDISK: 37778000 - 37fef9b2
> [    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
> [    0.000000] ACPI: RSDT CFEFD038, 004C (r1 INTEL  D975XBX2      AE8
> 1000013)
> [    0.000000] ACPI: DSDT CFEF8000, 3F11 (r1 INTEL  D975XBX2      AE8
> MSFT  1000013)
> [    0.000000] ACPI: SSDT CFEF2000, 01BC (r1 INTEL     CpuPm      AE8
> MSFT  1000013)
> [    0.000000] ACPI: SSDT CFEF1000, 0175 (r1 INTEL   Cpu0Ist      AE8
> MSFT  1000013)
> [    0.000000] ACPI: SSDT CFEF0000, 0175 (r1 INTEL   Cpu1Ist      AE8
> MSFT  1000013)
> [    0.000000] ACPI: SSDT CFEAB000, 0175 (r1 INTEL   Cpu2Ist      AE8
> MSFT  1000013)
> [    0.000000] ACPI: SSDT CFEAA000, 0175 (r1 INTEL   Cpu3Ist      AE8
> MSFT  1000013)
> [    0.000000]   #3 [0037778000 - 0037fef9b2]          RAMDISK ==>
> [0037778000 - 0037fef9b2]
> [    0.000000]  [ffffe20000000000-ffffe200043fffff] PMD ->
> [ffff880028200000-ffff88002c5fffff] on node 0
> [    0.013732] ACPI: Checking initramfs for custom DSDT
> [    0.920745] ACPI: EC: Look up EC in DSDT
> [    1.835081] Fixed MDIO Bus: probed
> [    1.835147] Driver 'sd' needs updating - please use bus_type methods
> [    1.835891] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0
> irq 14
> [    1.835893] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8
> irq 15
> [    2.056689] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma
> 0x40a0 irq 19
> [    2.056691] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma
> 0x40a8 irq 19
> [    2.250605] ata3.00: ATA-8: ST31000340AS, SD1A, max UDMA/133
> [    2.510628] ata4.00: ATA-8: ST31000340AS, SD1A, max UDMA/133
> [    2.591311] scsi 2:0:0:0: Direct-Access     ATA      ST31000340AS
> SD1A PQ: 0 ANSI: 5
> [    2.591402] sd 2:0:0:0: [sda] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    2.591414] sd 2:0:0:0: [sda] Write Protect is off
> [    2.591416] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.591435] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.591478] sd 2:0:0:0: [sda] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    2.591489] sd 2:0:0:0: [sda] Write Protect is off
> [    2.591490] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.591508] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.591511]  sda: unknown partition table
> [    2.600717] sd 2:0:0:0: [sda] Attached SCSI disk
> [    2.600745] sd 2:0:0:0: Attached scsi generic sg1 type 0
> [    2.600855] sd 2:0:1:0: [sdb] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    2.600866] sd 2:0:1:0: [sdb] Write Protect is off
> [    2.600868] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.600886] sd 2:0:1:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.600924] sd 2:0:1:0: [sdb] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    2.600934] sd 2:0:1:0: [sdb] Write Protect is off
> [    2.600936] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.600954] sd 2:0:1:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.600957]  sdb: unknown partition table
> [    3.072070] sd 2:0:1:0: [sdb] Attached SCSI disk
> [    3.072115] sd 2:0:1:0: Attached scsi generic sg2 type 0
> [    3.072178] scsi 3:0:0:0: Direct-Access     ATA      ST31000340AS
> SD1A PQ: 0 ANSI: 5
> [    3.072237] sd 3:0:0:0: [sdc] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    3.072248] sd 3:0:0:0: [sdc] Write Protect is off
> [    3.072249] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    3.072268] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.072303] sd 3:0:0:0: [sdc] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    3.072313] sd 3:0:0:0: [sdc] Write Protect is off
> [    3.072315] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    3.072333] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.072336]  sdc: unknown partition table
> [    3.079128] sd 3:0:0:0: [sdc] Attached SCSI disk
> [    3.079156] sd 3:0:0:0: Attached scsi generic sg3 type 0
> [    3.079257] sd 3:0:1:0: [sdd] 293046768 512-byte hardware sectors:
> (150 GB/139 GiB)
> [    3.079268] sd 3:0:1:0: [sdd] Write Protect is off
> [    3.079269] sd 3:0:1:0: [sdd] Mode Sense: 00 3a 00 00
> [    3.079287] sd 3:0:1:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.079322] sd 3:0:1:0: [sdd] 293046768 512-byte hardware sectors:
> (150 GB/139 GiB)
> [    3.079332] sd 3:0:1:0: [sdd] Write Protect is off
> [    3.079334] sd 3:0:1:0: [sdd] Mode Sense: 00 3a 00 00
> [    3.079352] sd 3:0:1:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.079354]  sdd: sdd1 sdd2 < sdd5 >
> [    3.101054] sd 3:0:1:0: [sdd] Attached SCSI disk
> [    3.101107] sd 3:0:1:0: Attached scsi generic sg4 type 0
> [    3.470676] ata5.00: ATA-8: ST31000340AS, SD1A, max UDMA/133
> [    3.880672] ata6.00: ATA-8: ST31000340AS, SD1A, max UDMA/133
> [    4.290698] ata7.00: ATA-8: ST31000340AS, SD1A, max UDMA/133
> [    4.700696] ata8.00: ATA-8: ST31000340AS, SD1A, max UDMA/133
> [    4.740750] scsi 4:0:0:0: Direct-Access     ATA      ST31000340AS
> SD1A PQ: 0 ANSI: 5
> [    4.740831] sd 4:0:0:0: [sde] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.740842] sd 4:0:0:0: [sde] Write Protect is off
> [    4.740844] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [    4.740862] sd 4:0:0:0: [sde] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.740898] sd 4:0:0:0: [sde] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.740909] sd 4:0:0:0: [sde] Write Protect is off
> [    4.740910] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [    4.740928] sd 4:0:0:0: [sde] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.740930]  sde: unknown partition table
> [    4.749416] sd 4:0:0:0: [sde] Attached SCSI disk
> [    4.749443] sd 4:0:0:0: Attached scsi generic sg5 type 0
> [    4.749488] scsi 5:0:0:0: Direct-Access     ATA      ST31000340AS
> SD1A PQ: 0 ANSI: 5
> [    4.749546] sd 5:0:0:0: [sdf] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.749557] sd 5:0:0:0: [sdf] Write Protect is off
> [    4.749559] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> [    4.749576] sd 5:0:0:0: [sdf] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.749613] sd 5:0:0:0: [sdf] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.749623] sd 5:0:0:0: [sdf] Write Protect is off
> [    4.749624] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> [    4.749642] sd 5:0:0:0: [sdf] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.749645]  sdf: unknown partition table
> [    4.759788] sd 5:0:0:0: [sdf] Attached SCSI disk
> [    4.759815] sd 5:0:0:0: Attached scsi generic sg6 type 0
> [    4.759859] scsi 6:0:0:0: Direct-Access     ATA      ST31000340AS
> SD1A PQ: 0 ANSI: 5
> [    4.759919] sd 6:0:0:0: [sdg] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.759930] sd 6:0:0:0: [sdg] Write Protect is off
> [    4.759932] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
> [    4.759950] sd 6:0:0:0: [sdg] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.759986] sd 6:0:0:0: [sdg] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.759997] sd 6:0:0:0: [sdg] Write Protect is off
> [    4.759998] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
> [    4.760022] sd 6:0:0:0: [sdg] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.760027]  sdg: unknown partition table
> [    4.771408] sd 6:0:0:0: [sdg] Attached SCSI disk
> [    4.771439] sd 6:0:0:0: Attached scsi generic sg7 type 0
> [    4.771483] scsi 7:0:0:0: Direct-Access     ATA      ST31000340AS
> SD1A PQ: 0 ANSI: 5
> [    4.771540] sd 7:0:0:0: [sdh] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.771551] sd 7:0:0:0: [sdh] Write Protect is off
> [    4.771552] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
> [    4.771570] sd 7:0:0:0: [sdh] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.771608] sd 7:0:0:0: [sdh] 1953525168 512-byte hardware sectors:
> (1.00 TB/931 GiB)
> [    4.771618] sd 7:0:0:0: [sdh] Write Protect is off
> [    4.771620] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
> [    4.771637] sd 7:0:0:0: [sdh] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    4.771640]  sdh: unknown partition table
> [    4.781982] sd 7:0:0:0: [sdh] Attached SCSI disk
> [    4.782012] sd 7:0:0:0: Attached scsi generic sg8 type 0
> [    4.942482] block sdd5: hash matches
> [    5.048354] md: linear personality registered for level -1
> [    5.050051] md: multipath personality registered for level -4
> [    5.051538] md: raid0 personality registered for level 0
> [    5.053697] md: raid1 personality registered for level 1
> [    5.271272] raid6: int64x1   1922 MB/s
> [    5.441269] raid6: int64x2   2639 MB/s
> [    5.611280] raid6: int64x4   2025 MB/s
> [    5.781295] raid6: int64x8   1789 MB/s
> [    5.951290] raid6: sse2x1    3078 MB/s
> [    6.121297] raid6: sse2x2    3651 MB/s
> [    6.291275] raid6: sse2x4    7193 MB/s
> [    6.291281] raid6: using algorithm sse2x4 (7193 MB/s)
> [    6.291283] md: raid6 personality registered for level 6
> [    6.291285] md: raid5 personality registered for level 5
> [    6.291286] md: raid4 personality registered for level 4
> [    6.296306] md: raid10 personality registered for level 10
> [    6.494887] md: bind<sde>
> [    6.555824] md: bind<sdf>
> [    6.622315] md: bind<sdh>
> [    6.703948] md: bind<sda>
> [    6.780815] md: bind<sdg>
> [    7.023507] md: bind<sdc>
> [    7.223400] md: bind<sdb>
> [    7.226582] raid5: device sdb operational as raid disk 1
> [    7.226584] raid5: device sdc operational as raid disk 2
> [    7.226586] raid5: device sdg operational as raid disk 5
> [    7.226587] raid5: device sda operational as raid disk 0
> [    7.226588] raid5: device sdh operational as raid disk 6
> [    7.226589] raid5: device sdf operational as raid disk 4
> [    7.226591] raid5: device sde operational as raid disk 3
> [    7.227201] raid5: allocated 7450kB for md0
> [    7.227203] raid5: raid level 5 set md0 active with 7 out of 7
> devices, algorithm 2
> [    7.227205] RAID5 conf printout:
> [    7.227207]  disk 0, o:1, dev:sda
> [    7.227208]  disk 1, o:1, dev:sdb
> [    7.227209]  disk 2, o:1, dev:sdc
> [    7.227210]  disk 3, o:1, dev:sde
> [    7.227212]  disk 4, o:1, dev:sdf
> [    7.227213]  disk 5, o:1, dev:sdg
> [    7.227214]  disk 6, o:1, dev:sdh
> [    7.228333]  md0: unknown partition table
> [   12.709829] Adding 5992204k swap on /dev/sdd5.  Priority:-1 extents:1
> across:5992204k
> [   13.245731] EXT3 FS on sdd1, internal journal
> [  317.618298] type=1505 audit(1241888758.168:7):
> operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2550
> [  318.016442] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [  322.767731] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> recovery directory
> [  322.774119] NFSD: starting 90-second grace period
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

