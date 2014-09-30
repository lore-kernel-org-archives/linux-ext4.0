From: Zlatko Calusic <zcalusic@bitsync.net>
Subject: Re: e2fsck not fixing deleted inode referenced errors?
Date: Tue, 30 Sep 2014 20:43:04 +0200
Message-ID: <542AF9B8.2090800@bitsync.net>
References: <542AEED4.5050303@bitsync.net> <20140930183012.GA9942@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bitsync.net ([80.83.126.10]:52551 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaI3SnI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 14:43:08 -0400
In-Reply-To: <20140930183012.GA9942@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 30.09.2014 20:30, Darrick J. Wong wrote:
> On Tue, Sep 30, 2014 at 07:56:36PM +0200, Zlatko Calusic wrote:
>> Hope this is the right list to ask this question.
>>
>> I have an ext4 filesystem that has a few errors like this:
>>
>> Sep 30 19:14:09 atlas kernel: EXT4-fs error (device md2):
>> ext4_lookup:1448: inode #7913865: comm find: deleted inode
>> referenced: 7912058
>> Sep 30 19:14:09 atlas kernel: EXT4-fs error (device md2):
>> ext4_lookup:1448: inode #7913865: comm find: deleted inode
>> referenced: 7912055
>>
>> Yet, when I run e2fsck -fy on it, I have a clean run, no errors are
>> found and/or fixed. Is this the expected behaviour? What am I
>> supposed to do to get rid of errors like the above?
>
> [I should hope not.]
>
>> The filesystem is on a md mirror device, the kernel is 3.17.0-rc7,
>> e2progs 1.42.12-1 (Debian sid). Could md device somehow interfere? I
>> ran md check yesterday, but there were no errors.
>>
>> BTW, this all started when I got ata2.00: failed command: FLUSH
>> CACHE EXT error yesterday morning. I did several runs of e2fsck
>> before the filesystem came up clean, yet errors like the above are
>> popping constantly.
>
> Normally that kernel message only happens if a dir refers to an inode with
> link_count and mode set to 0.
>
> Is the disk attached to ata2.00 one of the RAID1 mirrors?  What was the full
> error message, and does smartctl -a report anything?

Yes, it is part of the mirror:

ata2.00: ATA-8: WDC WD1002FBYS-02A6B0, 03.00C06, max UDMA/133
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133

md2 : active raid1 sdb2[0] sda2[1]
       976229760 blocks [2/2] [UU]
       bitmap: 0/8 pages [0KB], 65536KB chunk

Full error message from the kernel log, together with data check I did 
in the evening:

Sep 29 05:07:51 atlas kernel: ata2.00: exception Emask 0x10 SAct 0x0 
SErr 0x4010000 action 0xe frozen
Sep 29 05:07:51 atlas kernel: ata2.00: irq_stat 0x00400040, connection 
status changed
Sep 29 05:07:51 atlas kernel: ata2: SError: { PHYRdyChg DevExch }
Sep 29 05:07:51 atlas kernel: ata2.00: failed command: FLUSH CACHE EXT
Sep 29 05:07:51 atlas kernel: ata2.00: cmd 
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0\x0a         res 
40/00:f4:e2:7f:14/00:00:3a:00:00/40 Emask 0x10 (ATA bus error)
Sep 29 05:07:51 atlas kernel: ata2.00: status: { DRDY }
Sep 29 05:07:51 atlas kernel: ata2: hard resetting link
Sep 29 05:07:57 atlas kernel: ata2: link is slow to respond, please be 
patient (ready=0)
Sep 29 05:08:00 atlas kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Sep 29 05:08:00 atlas kernel: ata2.00: configured for UDMA/133
Sep 29 05:08:00 atlas kernel: ata2.00: retrying FLUSH 0xea Emask 0x10
Sep 29 05:08:00 atlas kernel: ata2: EH complete
Sep 29 05:37:36 atlas kernel: EXT4-fs error (device md2): 
ext4_mb_generate_buddy:757: group 1783, block bitmap and bg descriptor 
inconsistent: 8218 vs 9292 free clusters
Sep 29 05:37:36 atlas kernel: JBD2: Spotted dirty metadata buffer (dev = 
md2, blocknr = 0). There's a risk of filesystem corruption in case of 
system crash.
Sep 29 16:03:43 atlas kernel: EXT4-fs error (device md2): 
ext4_mb_generate_buddy:757: group 995, block bitmap and bg descriptor 
inconsistent: 15932 vs 15939 free clusters
Sep 29 16:03:43 atlas kernel: EXT4-fs error (device md2): 
ext4_mb_generate_buddy:757: group 1732, block bitmap and bg descriptor 
inconsistent: 5055 vs 5705 free clusters
Sep 29 19:24:01 atlas kernel: md: data-check of RAID array md2
Sep 29 19:24:01 atlas kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Sep 29 19:24:01 atlas kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for data-check.
Sep 29 19:24:01 atlas kernel: md: using 128k window, over a total of 
976229760k.
Sep 29 22:37:53 atlas kernel: md: md2: data-check done.


Later on I did several (at least 3) e2fsck runs until the filesystem 
finally was clean of errors. Only to stumble upon new errors today that 
can't be fixed with e2fsck anymore. :(

>
> It would be interesting to see what "debugfs -R 'stat <7912058>' /dev/md2"
> returns.

Inode: 7912058   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 252726504    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x5428ccf9:667449f0 -- Mon Sep 29 05:07:37 2014
  atime: 0x5428ccf9:65fa3740 -- Mon Sep 29 05:07:37 2014
  mtime: 0x5428ccf9:667449f0 -- Mon Sep 29 05:07:37 2014
crtime: 0x53451666:d35246b0 -- Wed Apr  9 11:44:06 2014
dtime: 0x5428ccf9 -- Mon Sep 29 05:07:37 2014
Size of extra inode fields: 28
EXTENTS:

At this time there seems to be 7 such files. Here's what it looks like:

{atlas} [/ext/backup/atlas/usr/lib/x86_64-linux-gnu/imlib2/filters]# ls -la
ls: cannot access colormod.so: Input/output error
ls: cannot access bumpmap.so: Input/output error
ls: cannot access bumpmap.la: Input/output error
ls: cannot access testfilter.la: Input/output error
ls: cannot access testfilter.so: Input/output error
ls: cannot access colormod.la: Input/output error
total 8
drwxr-xr-x 2 root root 4096 Sep 28 11:10 .
drwxr-xr-x 4 root root 4096 Sep 14  2013 ..
-????????? ? ?    ?       ?            ? bumpmap.la
-????????? ? ?    ?       ?            ? bumpmap.so
-????????? ? ?    ?       ?            ? colormod.la
-????????? ? ?    ?       ?            ? colormod.so
-????????? ? ?    ?       ?            ? testfilter.la
-????????? ? ?    ?       ?            ? testfilter.so
{atlas} [/ext/backup/atlas/usr/lib/x86_64-linux-gnu/imlib2/filters]# cd
{atlas} [~]# umount /ext
tim{atlas} [~]# time e2fsck -fy /dev/md2
e2fsck 1.42.12 (29-Aug-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md2: 3863428/61022208 files (0.7% non-contiguous), 
231256220/244057440 blocks
e2fsck -fy /dev/md2  9.57s user 2.05s system 5% cpu 3:14.40 total


Tried to delete that directory - impossible, i/o errors. I'll try to 
reboot now to see if anything changes...

Thanks for your help.
-- 
Zlatko

