From: Villa <villa@vansid.org>
Subject: Filesystem corruption on Synology iSCSI LUN
Date: Fri, 28 Nov 2014 21:32:21 +0000
Message-ID: <CAOE-YndzkhbAPjc=bBqioQkjbdbE2dKaq8AnrZBcLxDuupfg-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61285 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaK1VcW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Nov 2014 16:32:22 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so6374497ieb.7
        for <linux-ext4@vger.kernel.org>; Fri, 28 Nov 2014 13:32:21 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

I've got an interesting ext4 corruption problem that I can
successfully reproduce and I'm trying to determine where the fault is
coming from.  Let me start out by saying that I am not a kernel
developer, nor am I much of a programmer.  My understanding of
filesystems is rudimentary (by computer science standards), but after
20 years in the IT field, I certainly know more than your average
person.  Having said that, I can't offer deep technical insight into
filesystem issues - but I hope you can.

The problem is occurring with an iSCSI LUN presented to an Ubuntu
12.04 x64 Linux system via a Synology DS1513 using DSM version 5.1.
This filesystem has been running flawlessly for quite some time.  It
is on UPS and no power outages or unscheduled shutdowns have taken
place lately.  I very recently upgraded from DSM 5.0 to 5.1, and
roughly after this I started noticing the filesystem corruption
problem.  However, it is far too simplistic to immediately assume that
DSM 5.1 is the culprit, and instead I am trying to find out what else
may be causing the issue.

The LUN is approximately 4TB and from the time that DSM 5.1 was
installed to the point that I began noticing problems was only a few
days (again, this doesn't prove the Synology DSM is involved).  In
those few days, almost no new files were added to the filesystem.
However, I noticed the next day after I added a directory and some new
files (thanks to a Logwatch report) that several errors were recorded
by the kernel.  I unmounted the LUN and ran "fsck.ext4 -f" on the
device, which detected several errors and fixed them.  The recovered
files were in the "lost+found" directory and I was able to move them
into the correct place.  However, on a hunch, I tried the same thing
again - and got the same errors.  This situation seems to be
completely repeatable on my system.  I just subscribed to this list
today and I am not familiar with your established standards or
expectations, so I am including as much relevant information as I can.
If anyone has any insight or clues, or needs more information, please
let me know.


"uname -a" output:
Linux cj148869-a 3.2.0-72-generic #107-Ubuntu SMP Thu Nov 6 14:24:01
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
--------------------------------------------------------------------------------

Mounted iSCSI device/partition:
/dev/sdd1
--------------------------------------------------------------------------------

"fdisk" p:
Disk /dev/sdd: 4402.3 GB, 4402341478400 bytes
255 heads, 63 sectors/track, 535220 cylinders, total 8598323200 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 8192 bytes / 8192 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1  4294967295  2147483647+  ee  GPT
Partition 1 does not start on physical sector boundary
--------------------------------------------------------------------------------

"iscsiadm -m node" output:
172.16.8.10:3260,0 iqn.2000-01.com.synology:regusersfs.cjserver-lun1-target
--------------------------------------------------------------------------------

"lspci | grep -i ethernet" output:
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
--------------------------------------------------------------------------------

NIC kernel module:
r8168 (version 8.037.00)
--------------------------------------------------------------------------------

Command to mount LUN:
mount -t ext4 -o acl,user_xattr /dev/sdd1 /storage/iscsi-lun1
--------------------------------------------------------------------------------

Commands to trigger fault/corruption:
mkdir /storage/iscsi-lun1/mymedia/pub/software/linux/mobile
vi /storage/iscsi-lun1/mymedia/pub/software/linux/mobile/text.txt
     (an attempt to write a simple text file)
--------------------------------------------------------------------------------

output of "dmesg" (beginning with the mounting of the device):
[125975.883678] EXT4-fs (sdd1): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[126085.888075] sd 9:0:0:0: [sdd]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[126085.888081] sd 9:0:0:0: [sdd]  Sense Key : Illegal Request [current]
[126085.888086] sd 9:0:0:0: [sdd]  <<vendor>> ASC=0x80 ASCQ=0x0ASC=0x80 ASCQ=0x0
[126085.888093] sd 9:0:0:0: [sdd] CDB: Write(16): 8a 00 00 00 00 01 e1
c0 95 c0 00 00 00 08 00 00
[126085.888105] end_request: I/O error, dev sdd, sector 8082462144
[126085.890808] Buffer I/O error on device sdd1, logical block 1010307512
[126085.893509] lost page write due to I/O error on sdd1
[126105.933792] EXT4-fs error (device sdd1): add_dirent_to_buf:1273:
inode #126289726: block 1010307512: comm vi: bad entry in directory:
rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0,
name_len=0
[126105.935569] EXT4-fs error (device sdd1): add_dirent_to_buf:1273:
inode #126289726: block 1010307512: comm vi: bad entry in directory:
rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0,
name_len=0
[126111.933747] EXT4-fs error (device sdd1): add_dirent_to_buf:1273:
inode #126289726: block 1010307512: comm vi: bad entry in directory:
rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0,
name_len=0
--------------------------------------------------------------------------------

After umounting, output of "fsck.ext4 -f /dev/sdd1":
e2fsck 1.42 (29-Nov-2011)
/dev/sdd1: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Directory inode 126289726, block #0, offset 0: directory corrupted
Salvage<y>? yes

Missing '.' in directory inode 126289726.
Fix<y>? yes

Setting filetype for entry '.' in ??? (126289726) to 2.
Missing '..' in directory inode 126289726.
Fix<y>? yes

Setting filetype for entry '..' in ??? (126289726) to 2.
Pass 3: Checking directory connectivity
'..' in /mymedia/pub/software/linux/mobile (126289726) is <The NULL
inode> (0), should be /mymedia/pub/software/linux (126091366).
Fix<y>? yes

Pass 4: Checking reference counts
Inode 2 ref count is 4, should be 5.  Fix<y>? yes

Inode 126091366 ref count is 19, should be 18.  Fix<y>? yes

Pass 5: Checking group summary information

/dev/sdd1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdd1: 147160/134348800 files (0.8% non-contiguous),
478740596/1074789888 blocks
--------------------------------------------------------------------------------

After running this clean up and either moving around files from
lost+found (or just deleting them), the filesystem seems to behave --
until I try to write files.

Other relevant "dmesg" warnings from other recent failures/problems
(happened immediately after mounting and trying to write
files/folders):
[28315.611845] EXT4-fs (sdd1): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[28360.135947] EXT4-fs error (device sdd1):
htree_dirblock_to_tree:587: inode #126289726: block 1010307512: comm
rm: bad entry in directory: rec_len is smaller than minimal -
offset=0(0), inode=0, rec_len=0, name_len=0
[28360.138737] EXT4-fs warning (device sdd1): empty_dir:1926: bad
directory (dir #126289726) - no `.' or `..'
[28580.746047] EXT4-fs (sdd1): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[28597.680443] sd 9:0:0:0: [sdd]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[28597.680449] sd 9:0:0:0: [sdd]  Sense Key : Illegal Request [current]
[28597.680454] sd 9:0:0:0: [sdd]  <<vendor>> ASC=0x80 ASCQ=0x0ASC=0x80 ASCQ=0x0
[28597.680466] sd 9:0:0:0: [sdd] CDB: Write(16): 8a 00 00 00 00 01 e1
c0 95 c0 00 00 00 08 00 00
[28597.680472] end_request: I/O error, dev sdd, sector 8082462144
[28597.681706] Buffer I/O error on device sdd1, logical block 1010307512
[28597.682936] lost page write due to I/O error on sdd1
[28617.421379] Aborting journal on device sdd1-8.
[28617.425268] EXT4-fs error (device sdd1): ext4_put_super:819:
Couldn't clean up the journal
[28617.427950] EXT4-fs (sdd1): Remounting filesystem read-only
[28621.076820] sd 9:0:0:0: [sdd]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[28621.076824] sd 9:0:0:0: [sdd]  Sense Key : Illegal Request [current]
[28621.076828] sd 9:0:0:0: [sdd]  <<vendor>> ASC=0x80 ASCQ=0x0ASC=0x80 ASCQ=0x0
[28621.076834] sd 9:0:0:0: [sdd] CDB: Write(16): 8a 00 00 00 00 01 e1
c0 95 c0 00 00 00 08 00 00
[28621.076844] end_request: I/O error, dev sdd, sector 8082462144
[28621.078991] Buffer I/O error on device sdd1, logical block 1010307512
[28621.081116] lost page write due to I/O error on sdd1
[28670.043409] sd 9:0:0:0: [sdd]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[28670.043413] sd 9:0:0:0: [sdd]  Sense Key : Illegal Request [current]
[28670.043417] sd 9:0:0:0: [sdd]  <<vendor>> ASC=0x80 ASCQ=0x0ASC=0x80 ASCQ=0x0
[28670.043421] sd 9:0:0:0: [sdd] CDB: Write(16): 8a 00 00 00 00 01 e1
c0 95 c0 00 00 00 08 00 00
[28670.043429] end_request: I/O error, dev sdd, sector 8082462144
[28670.045163] Buffer I/O error on device sdd1, logical block 1010307512
[28670.046886] lost page write due to I/O error on sdd1
[28700.734181] EXT4-fs (sdd1): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[28721.134899] EXT4-fs error (device sdd1):
htree_dirblock_to_tree:587: inode #126289726: block 1010307512: comm
rm: bad entry in directory: rec_len is smaller than minimal -
offset=0(0), inode=0, rec_len=0, name_len=0
[28721.137720] EXT4-fs warning (device sdd1): empty_dir:1926: bad
directory (dir #126289726) - no `.' or `..'
--------------------------------------------------------------------------------


I know this list doesn't exist to fix my personal problems and I
understand that this is a lot (especially for the first post in the
thread), but I'd like to know if any of you think this filesystem is
salvageable and if it can be permanently fixed.  Luckily this is a
backup LUN and all of the data is safely elsewhere, so I can
"experiment" if necessary.  I wonder if this is some sort of
kernel/module problem.  If anyone can help, I'd greatly appreciate it.
Let me know if you need more info.

Thanks,

Villa
