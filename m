From: "George Spelvin" <linux@horizon.com>
Subject: e2fsck crash, and unfixable problems
Date: 18 Nov 2012 08:25:31 -0500
Message-ID: <20121118132531.32049.qmail@science.horizon.com>
References: <20121117123010.17129.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:54513 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751900Ab2KRNZe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Nov 2012 08:25:34 -0500
In-Reply-To: <20121117123010.17129.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Resend with somewhat more abbreviated e2fsck output; blew vger's
length limit with the previous one.)

The sad saga of how I got here is explained in some detail in recent
posts to this mailing list.  Basically, I tried to resize a
file system from 10 TB to 22 TB, and ran into a couple of snags.

In the end, a problem with resizing 64-bit ext4 file systems caused
inodes 129 through 2048 to be overwritten and lost.  I managed to
recover the directories, but a lot of files will have to
be recreated. :-(

Some of the files that were lost, which I didn't worry about,
were some directories and files from BackupPC's cpool directory.

BackupPC is a network backup system which stored compressed files
indexed by hash in a directory tree.  A file with hash 789abcde
will be stored, compressed, in .../backuppc/cpool/7/8/9/789abce.

Then it builds additional trees that mirror backed-up hosts by
hard linking to the compressed files, with names like
/backuppc/pc/localhost/123/f%2f/fusr/fsrc/flinux/fMakefile.
(The leading "f" is a flag character distinguishing backup data
from metadata.)

Anyway, the hosts being backed up were healthy, so I wasn't worried
about losing some backup files; they would just be recreated next
backup cycle.

So after I let e2fsck have its head, I simply used "rm -r" on the
dangling directories that ended up on /lost+found.


However, that initial e2fsck didn't fix everything.  (It said as much
at the time:  "WARNING: Filesystem still has errors".)


I finally got around to re-running e2fsck and got some interesting
results.  Fortuntately, I've wised up and now routinely capture a
typescript when using e2fsck if I expect anything "interesting".


What follows are four runs of e2fsck.  The first was run with -n, and
noticed some problems.  The second was run with -y, fixed a number of
problems, but decided to run pass 3B (optimizing directories) and got
SIGSEGV while doing so.

I switched to a newer e2fsck version and ran it again, which fixed
some more, but *still* left errors.  A fourth pass appears to be a
demonstration of the stable state, finding errors but being unable to
fix them.

(Note: the messge "884: Extent error on inode 7" is a local debug print
added to show where "eh_magic = 0000 != f30a" is coming from.  The first
number is the source __LINE__; the second is the inode number.)



Since all the allocation bitmaps are valid and the rest of the file
system is stable, I'm using the file system R/W at the moment, with
backuppc disabled.

Unless anyone has any better suggestions, I'm just going to clri the
unfoxanle directories.  But I can wait a few days if additional
information sould be useful.



Script started on Fri 16 Nov 2012 11:04:37 PM UTC
/tmp# e2fsck -f -v -C0 -n /dev/md1277
e2fsck 1.43-WIP (22-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
eh_magic = 0000 != f30a
Pass 2: Checking directory structure
Directory inode 1740802, block #0, offset 0: directory fails checksum.
Salvage? no

Directory inode 1740802, block #0, offset 60: directory passes checks but fails checksum
Fix? no

(Same for inode 1740803, offsets 0 & 60)
(Same for inode 1740804, offsets 0 & 60)
(Same for inode 1740805, offsets 0 & 56)
(Same for inode 1740806, offsets 0 & 60)
(Same for inode 1740807, offsets 0 & 56)
(Same for inode 1740808, offsets 0 & 60)
(Same for inode 1740809, offsets 0 & 92)
(Same for inode 1740810, offsets 0 & 40)
(Same for inode 1740812, offsets 0 & 1192)
(Same for inode 1740813, offsets 0 & 132)
(Same for inode 1740814, offsets 0 & 12)
(Same for inode 1740815, offsets 0 & 256)

Problem in HTREE directory inode 1740816: root node fails checksum
Clear HTree index? no

Directory inode 3186690, block #0, offset 0: directory fails checksum
Salvage? no

Directory inode 3186690, block #0, offset 168: directory passes checks but fails checksum
Fix? no

(Same for inode 3186692, offsets 0 & 1332)
(Same for inode 3186693, offsets 0 & 132)
(Same for inode 3186694, offsets 0 & 300)
(Same for inode 3186695, offsets 0 & 200)
(Same for inode 3186696, offsets 0 & 1324)
(Same for inode 3186698, offsets 0 & 80)
(Same for inode 3186699, offsets 0 & 76)
(Same for inode 3186700, offsets 0 & 200)
(Same for inode 3186702, offsets 0 & 1924)
(Same for inode 3186704, offsets 0 & 296)
(Same for inode 3719170, offsets 0 & 40)
(Same for inode 3719171, offsets 0 & 532)
(Same for inode 3719172, offsets 0 & 92)
(Same for inode 3719173, offsets 0 & 104)
(Same for inode 3719174, offsets 0 & 120)
(Same for inode 3719175, offsets 0 & 152)
(Same for inode 3719176, offsets 0 & 136)
(Same for inode 3719177, offsets 0 & 60)
(Same for inode 3719178, offsets 0 & 120)
(Same for inode 3719179, offsets 0 & 96)
(Same for inode 3719180, offsets 0 & 112)
(Same for inode 3719181, offsets 0 & 84)
(Same for inode 3719182, offsets 0 & 1144)
(Same for inode 3719183, offsets 0 & 40)
(Same for inode 3719184, offsets 0 & 44)
(Same for inode 3725315, offsets 0 & 140)
(Same for inode 3727364, offsets 0 & 72)
(Same for inode 3727365, offsets 0 & 92)
(Same for inode 3727366, offsets 0 & 108)
(Same for inode 3727367, offsets 0 & 120)
(Same for inode 3727368, offsets 0 & 232)
(Same for inode 3727369, offsets 0 & 100)
(Same for inode 3727370, offsets 0 & 136)
(Same for inode 3727371, offsets 0 & 104)
(Same for inode 3727372, offsets 0 & 140)
(Same for inode 3727373, offsets 0 & 104)
(Same for inode 3727374, offsets 0 & 40)
(Same for inode 3727375, offsets 0 & 140)
(Same for inode 3727376, offsets 0 & 88)

Entry '#4573591' in . (4573591) is a link to '.'  Clear? no

Entry '#4573591' in . (4573591) is a link to '.'  Clear? no

Entry '#4573591' in . (4573591) is a link to '.'  Clear? no

(Same for inode 4659547)
(Same for inode 5890578)
(Same for inode 5896570)
(Same for inode 5943660)
(Same for inode 5976414)
(Same for inode 5980499)
(Same for inode 5982590)
(Same for inode 5996891)
(Same for inode 5999235)
(Same for inode 5999324)
(Same for inode 6029742)
(Same for inode 6035861)
(Same for inode 6040029)
(Same for inode 6046177)
(Same for inode 6099432)
(Same for inode 6103441)
(Same for inode 6226354)

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences: Group 131072 block bitmap does not match checksum
IGNORED.
Group 131073 block bitmap does not match checksum
IGNORED.
Group 131074 block bitmap does not match checksum
IGNORED.
Group 131075 block bitmap does not match checksum
IGNORED.
	[~55500 lines redacted.  A few *do* have correct checksums.]
Group 163934 block bitmap does not match checksum
IGNORED.

data: ********** WARNING: Filesystem still has errors **********


     2013365 inodes used (9.59%, out of 20983680)
        9557 non-contiguous files (0.5%)
        1375 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 2009531/3813
  1419796195 blocks used (26.43%, out of 5371804064)
           0 bad blocks
         255 large files

     1097083 regular files
      916260 directories
           0 character device files
           0 block device files
           0 fifos
     4340393 links
          12 symbolic links (12 fast symbolic links)
           1 socket
------------
     6353749 files

/tmp# e2fsck -f -v -C0 -y /dev/md127
e2fsck 1.43-WIP (22-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
eh_magic = 0000 != f30a
Pass 2: Checking directory structure
Directory inode 1740802, block #0, offset 0: directory fails checksum
Salvage? yes

(Same for inode 1740803)
(Same for inode 1740804)
(Same for inode 1740805)
(Same for inode 1740806)
(Same for inode 1740807)
(Same for inode 1740808)
(Same for inode 1740809)
(Same for inode 1740810)
(Same for inode 1740812)
(Same for inode 1740813)
(Same for inode 1740814)
(Same for inode 1740815)

Problem in HTREE directory inode 1740816: root node fails checksum
Clear HTree index? yes

Directory inode 3186690, block #0, offset 0: directory fails checksum
Salvage? yes

(Same for inode 3186692)
(Same for inode 3186693)
(Same for inode 3186694)
(Same for inode 3186695)
(Same for inode 3186696)
(Same for inode 3186698)
(Same for inode 3186699)
(Same for inode 3186700)
(Same for inode 3186702)
(Same for inode 3186704)

Directory inode 3719170, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107169 (inode 3719170): Inode checksum does not match inode
Continue? yes

Directory inode 3719171, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107170 (inode 3719171): Inode checksum does not match inode
Continue? yes

Directory inode 3719172, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107171 (inode 3719172): Inode checksum does not match inode
Continue? yes

Directory inode 3719173, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107172 (inode 3719173): Inode checksum does not match inode
Continue? yes

Directory inode 3719174, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107173 (inode 3719174): Inode checksum does not match inode
Continue? yes

Directory inode 3719175, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107174 (inode 3719175): Inode checksum does not match inode
Continue? yes

Directory inode 3719176, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107175 (inode 3719176): Inode checksum does not match inode
Continue? yes

Directory inode 3719177, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107176 (inode 3719177): Inode checksum does not match inode
Continue? yes

Directory inode 3719178, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107177 (inode 3719178): Inode checksum does not match inode
Continue? yes

Directory inode 3719179, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107178 (inode 3719179): Inode checksum does not match inode
Continue? yes

Directory inode 3719180, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107179 (inode 3719180): Inode checksum does not match inode
Continue? yes

Directory inode 3719181, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107180 (inode 3719181): Inode checksum does not match inode
Continue? yes

Directory inode 3719182, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107181 (inode 3719182): Inode checksum does not match inode
Continue? yes

Directory inode 3719183, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107182 (inode 3719183): Inode checksum does not match inode
Continue? yes

Directory inode 3719184, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107183 (inode 3719184): Inode checksum does not match inode
Continue? yes

Directory inode 3725315, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 953680034 (inode 3725315): Inode checksum does not match inode
Continue? yes

Directory inode 3727364, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204323 (inode 3727364): Inode checksum does not match inode
Continue? yes

Directory inode 3727365, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204324 (inode 3727365): Inode checksum does not match inode
Continue? yes

Directory inode 3727366, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204325 (inode 3727366): Inode checksum does not match inode
Continue? yes

Directory inode 3727367, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204326 (inode 3727367): Inode checksum does not match inode
Continue? yes

Directory inode 3727368, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204327 (inode 3727368): Inode checksum does not match inode
Continue? yes

Directory inode 3727369, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204328 (inode 3727369): Inode checksum does not match inode
Continue? yes

Directory inode 3727370, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204329 (inode 3727370): Inode checksum does not match inode
Continue? yes

Directory inode 3727371, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204330 (inode 3727371): Inode checksum does not match inode
Continue? yes

Directory inode 3727372, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204331 (inode 3727372): Inode checksum does not match inode
Continue? yes

Directory inode 3727373, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204332 (inode 3727373): Inode checksum does not match inode
Continue? yes

Directory inode 3727374, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204333 (inode 3727374): Inode checksum does not match inode
Continue? yes

Directory inode 3727375, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204334 (inode 3727375): Inode checksum does not match inode
Continue? yes

Directory inode 3727376, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204335 (inode 3727376): Inode checksum does not match inode
Continue? yes

Directory inode 1740816, block #1, offset 0: directory fails checksum
Salvage? yes

Directory inode 1740816, block #2, offset 0: directory fails checksum
Salvage? yes

Directory inode 1740816, block #3, offset 0: directory fails checksum
Salvage? yes

Entry '#4573591' in . (4573591) is a link to '.'  Clear? yes

(Same for inode 4659547)
(Same for inode 5890578)
(Same for inode 5896570)
(Same for inode 5943660)
(Same for inode 5976414)
(Same for inode 5980499)
(Same for inode 5982590)
(Same for inode 5996891)
(Same for inode 5999235)
(Same for inode 5999324)
(Same for inode 6029742)
(Same for inode 6035861)
(Same for inode 6040029)
(Same for inode 6046177)
(Same for inode 6099432)
(Same for inode 6103441)
(Same for inode 6226354)

Pass 3: Checking directory connectivity
'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb/fatm (1740802) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709).
Fix? yes

Couldn't fix parent of inode 1740802: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb/fhost (1740803) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709).
Fix? yes

Couldn't fix parent of inode 1740803: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb/fchipidea (1740804) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709).
Fix? yes

Couldn't fix parent of inode 1740804: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb/fotg (1740805) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709).
Fix? yes

Couldn't fix parent of inode 1740805: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb/fcore (1740806) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709).
Fix? yes

Couldn't fix parent of inode 1740806: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb/fserial (1740807) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709).
Fix? yes

Couldn't fix parent of inode 1740807: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/frpmsg (1740808) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers (1628165).
Fix? yes

Couldn't fix parent of inode 1740808: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/facpi (1740809) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers (1628165).
Fix? yes

Couldn't fix parent of inode 1740809: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/finclude/fconfig/fcomedi/fpci (1740810) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/finclude/fconfig/fcomedi (1675274).
Fix? yes

Couldn't fix parent of inode 1740810: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/flib/fpython2.7/fdist-packages/fsimplejson/ftests (1740812) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/flib/fpython2.7/fdist-packages/fsimplejson (1738766).
Fix? yes

Couldn't fix parent of inode 1740812: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/flib/fpython2.7/fdist-packages/flanguage_selector-0.1.egg-info (1740813) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/flib/fpython2.7/fdist-packages (1738765).
Fix? yes

Couldn't fix parent of inode 1740813: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/ficons/fhicolor/f36x36/femblems (1740814) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/ficons/fhicolor/f36x36 (1726478).
Fix? yes

Couldn't fix parent of inode 1740814: Ext2 inode is not a directory

'..' in /backuppc/pc/localhost/163/f%2f/fhome/fuser/fDownloads/fr50 (1740815) is / (2), should be /backuppc/pc/localhost/163/f%2f/fhome/fuser/fDownloads (1703953).
Fix? yes

Couldn't fix parent of inode 1740815: Ext2 inode is not a directory

Unconnected directory inode 1742849 (<1740809>/<1742849>)
Connect to /lost+found? yes

Unconnected directory inode 1742850 (<1740809>/<1742850>)
Connect to /lost+found? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fcisco (3186690) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186690: Directory block checksum does not match directory block

Unconnected directory inode 3186692 (???)
Connect to /lost+found? yes

Couldn't fix parent of inode 3186692: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fibm (3186693) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186693: Directory block checksum does not match directory block

Unconnected directory inode 3186694 (???)
Connect to /lost+found? yes

Couldn't fix parent of inode 3186694: Directory block checksum does not match directory block

Unconnected directory inode 3186695 (???)
Connect to /lost+found? yes

Couldn't fix parent of inode 3186695: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/f8390 (3186696) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186696: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fxscale (3186698) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186698: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fnxp (3186699) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186699: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fdec (3186700) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186700: Directory block checksum does not match directory block

Unconnected directory inode 3186702 (???)
Connect to /lost+found? yes

Couldn't fix parent of inode 3186702: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fcalxeda (3186704) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186704: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fxaw3dg/fexamples (3719170) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fxaw3dg (3719169).
Fix? yes

Unconnected directory inode 3719171 (/backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fxaw3dg/fexamples/fapp-defaults)
Connect to /lost+found? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgc1c2 (3719172) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibappindicator1 (3719173) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgnome-menu-3-0 (3719174) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibunistring0 (3719175) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fyelp (3719176) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgpm2 (3719177) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibaudio2 (3719178) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibkrb5support0 (3719179) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fbogofilter-bdb (3719180) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fpython-minimal (3719181) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibquvi-scripts/flua/fwebsite (3719182) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibquvi-scripts/flua (3717134).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging/fpanel (3719183) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging (3649552).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging/fpohmelfs (3719184) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging (3649552).
Fix? yes

Unconnected directory inode 3721230 (/backuppc/pc/localhost/163/f%2f/fusr/fshare/flibquvi-scripts/flua/fwebsite/fquvi)
Connect to /lost+found? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fmime-support (3725315) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibframe6 (3727364) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fuuid-dev (3727365) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgcr-3-1 (3727366) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fpopularity-contest (3727367) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

Unconnected directory inode 3727368 (/backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fpopularity-contest/fexamples)
Connect to /lost+found? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fcompizconfig-backend-gconf (3727369) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibkrb5-3 (3727370) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibao-common (3727371) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flogin (3727372) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibglib-perl (3727373) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibrarian/fTemplates (3727374) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibrarian (3725326).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar/fipmi (3727375) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar (3725328).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar/fpcmcia (3727376) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar (3725328).
Fix? yes

Unconnected directory inode 3729422 (/backuppc/pc/localhost/163/f%2f/fusr/fshare/flibrarian/fTemplates/fC)
Connect to /lost+found? yes

Unconnected directory inode 4573591 (.)
Connect to /lost+found? yes

(Same for inode 4659547)
(Same for inode 5890578)
(Same for inode 5896570)
(Same for inode 5943660)
(Same for inode 5976414)
(Same for inode 5980499)
(Same for inode 5982590)
(Same for inode 5996891)
(Same for inode 5999235)
(Same for inode 5999324)
(Same for inode 6029742)
(Same for inode 6035861)
(Same for inode 6040029)
(Same for inode 6046177)
(Same for inode 6099432)
(Same for inode 6103441)
(Same for inode 6226354)

Pass 3A: Optimizing directories
Signal (11) SIGSEGV si_code=SI_KERNEL fault addr=(nil)
e2fsck[0x428400]
/lib/x86_64-linux-gnu/libc.so.6(+0x364a0)[0x7ff0a18ce4a0]
e2fsck[0x424822]
/lib/x86_64-linux-gnu/libc.so.6(+0x39e92)[0x7ff0a18d1e92]
/lib/x86_64-linux-gnu/libc.so.6(+0x3aa55)[0x7ff0a18d2a55]
e2fsck(e2fsck_rehash_dir+0x281)[0x424d01]
e2fsck(e2fsck_rehash_directories+0x10d)[0x425a2d]
e2fsck(e2fsck_pass3+0x61f)[0x41a3ef]
e2fsck(e2fsck_run+0x57)[0x40e187]
e2fsck(main+0xdfc)[0x40a57c]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xed)[0x7ff0a18b976d]
e2fsck[0x40c111]



/tmp# cd ~/e2fsprogs
~/e2fsprogs# e2fsck/e2fsck -v -C0 -y /dev/md127
e2fsck 1.43-WIP (22-Sep-2012)
data contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
eh_magic = 0000 != f30a
884: Extent error on inode 7
Inode 1740801 checksum does not match inode.  Clear? yes

Pass 2: Checking directory structure
Entry 'frpmsg' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers (1628165) has deleted/unused inode 1740808.  Clear? yes

Entry 'facpi' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers (1628165) has deleted/unused inode 1740809.  Clear? yes

Entry 'fpci' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/finclude/fconfig/fcomedi (1675274) has deleted/unused inode 1740810.  Clear? yes

Entry 'fr50' in /backuppc/pc/localhost/163/f%2f/fhome/fuser/fDownloads (1703953) has deleted/unused inode 1740815.  Clear? yes

Entry 'ftorrents' in /backuppc/pc/localhost/163/f%2f/fhome/fuser/fDownloads (1703953) has deleted/unused inode 1740816.  Clear? yes

Entry 'femblems' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/ficons/fhicolor/f36x36 (1726478) has deleted/unused inode 1740814.  Clear? yes

Entry 'fimage' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709) has deleted/unused inode 1740801.  Clear? yes

Entry 'fatm' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709) has deleted/unused inode 1740802.  Clear? yes

Entry 'fhost' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709) has deleted/unused inode 1740803.  Clear? yes

Entry 'fchipidea' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709) has deleted/unused inode 1740804.  Clear? yes

Entry 'fotg' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709) has deleted/unused inode 1740805.  Clear? yes

Entry 'fcore' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709) has deleted/unused inode 1740806.  Clear? yes

Entry 'fserial' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux-headers-3.6.1/fdrivers/fusb (1736709) has deleted/unused inode 1740807.  Clear? yes

Entry 'ftests' in /backuppc/pc/localhost/163/f%2f/fusr/flib/fpython2.7/fdist-packages/fsimplejson (1738766) has deleted/unused inode 1740812.  Clear? yes

Directory inode 3719170, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107169 (inode 3719170): Inode checksum does not match inode
Continue? yes

Directory inode 3719171, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107170 (inode 3719171): Inode checksum does not match inode
Continue? yes

Directory inode 3719172, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107171 (inode 3719172): Inode checksum does not match inode
Continue? yes

Directory inode 3719173, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107172 (inode 3719173): Inode checksum does not match inode
Continue? yes

Directory inode 3719174, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107173 (inode 3719174): Inode checksum does not match inode
Continue? yes

Directory inode 3719175, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107174 (inode 3719175): Inode checksum does not match inode
Continue? yes

Directory inode 3719176, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107175 (inode 3719176): Inode checksum does not match inode
Continue? yes

Directory inode 3719177, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107176 (inode 3719177): Inode checksum does not match inode
Continue? yes

Directory inode 3719178, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107177 (inode 3719178): Inode checksum does not match inode
Continue? yes

Directory inode 3719179, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107178 (inode 3719179): Inode checksum does not match inode
Continue? yes

Directory inode 3719180, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107179 (inode 3719180): Inode checksum does not match inode
Continue? yes

Directory inode 3719181, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107180 (inode 3719181): Inode checksum does not match inode
Continue? yes

Directory inode 3719182, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107181 (inode 3719182): Inode checksum does not match inode
Continue? yes

Directory inode 3719183, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107182 (inode 3719183): Inode checksum does not match inode
Continue? yes

Directory inode 3719184, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107183 (inode 3719184): Inode checksum does not match inode
Continue? yes

Directory inode 3725315, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 953680034 (inode 3725315): Inode checksum does not match inode
Continue? yes

Directory inode 3727364, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204323 (inode 3727364): Inode checksum does not match inode
Continue? yes

Directory inode 3727365, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204324 (inode 3727365): Inode checksum does not match inode
Continue? yes

Directory inode 3727366, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204325 (inode 3727366): Inode checksum does not match inode
Continue? yes

Directory inode 3727367, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204326 (inode 3727367): Inode checksum does not match inode
Continue? yes

Directory inode 3727368, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204327 (inode 3727368): Inode checksum does not match inode
Continue? yes

Directory inode 3727369, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204328 (inode 3727369): Inode checksum does not match inode
Continue? yes

Directory inode 3727370, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204329 (inode 3727370): Inode checksum does not match inode
Continue? yes

Directory inode 3727371, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204330 (inode 3727371): Inode checksum does not match inode
Continue? yes

Directory inode 3727372, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204331 (inode 3727372): Inode checksum does not match inode
Continue? yes

Directory inode 3727373, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204332 (inode 3727373): Inode checksum does not match inode
Continue? yes

Directory inode 3727374, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204333 (inode 3727374): Inode checksum does not match inode
Continue? yes

Directory inode 3727375, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204334 (inode 3727375): Inode checksum does not match inode
Continue? yes

Directory inode 3727376, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204335 (inode 3727376): Inode checksum does not match inode
Continue? yes

Entry 'flanguage_selector-0.1.egg-info' in /backuppc/pc/localhost/163/f%2f/fusr/flib/fpython2.7/fdist-packages (1738765) has deleted/unused inode 1740813.  Clear? yes

Pass 3: Checking directory connectivity
'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fcisco (3186690) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186690: Directory block checksum does not match directory block

'..' in /lost+found/#3186692 (3186692) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186692: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fibm (3186693) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186693: Directory block checksum does not match directory block

'..' in /lost+found/#3186694 (3186694) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186694: Directory block checksum does not match directory block

'..' in /lost+found/#3186695 (3186695) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186695: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/f8390 (3186696) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186696: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fxscale (3186698) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186698: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fnxp (3186699) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186699: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fdec (3186700) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186700: Directory block checksum does not match directory block

'..' in /lost+found/#3186702 (3186702) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186702: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fcalxeda (3186704) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186704: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fxaw3dg/fexamples (3719170) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fxaw3dg (3719169).
Fix? yes

'..' in /lost+found/#3719171 (3719171) is / (2), should be /lost+found (11).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgc1c2 (3719172) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibappindicator1 (3719173) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgnome-menu-3-0 (3719174) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibunistring0 (3719175) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fyelp (3719176) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgpm2 (3719177) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibaudio2 (3719178) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibkrb5support0 (3719179) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fbogofilter-bdb (3719180) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fpython-minimal (3719181) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibquvi-scripts/flua/fwebsite (3719182) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibquvi-scripts/flua (3717134).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging/fpanel (3719183) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging (3649552).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging/fpohmelfs (3719184) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging (3649552).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fmime-support (3725315) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibframe6 (3727364) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fuuid-dev (3727365) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgcr-3-1 (3727366) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fpopularity-contest (3727367) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /lost+found/#3727368 (3727368) is / (2), should be /lost+found (11).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fcompizconfig-backend-gconf (3727369) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibkrb5-3 (3727370) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibao-common (3727371) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flogin (3727372) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibglib-perl (3727373) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibrarian/fTemplates (3727374) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibrarian (3725326).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar/fipmi (3727375) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar (3725328).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar/fpcmcia (3727376) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar (3725328).
Fix? yes

Unconnected directory inode 6226354 (.)
Connect to /lost+found? yes

Pass 4: Checking reference counts
Inode 2 ref count is 15, should be 55.  Fix? yes

(Inode 11: 8 -> 24)
(Inode 68: 24 -> 23)
(Inode 2211: 11 -> 10)
(Inode 4288: 11 -> 10)
(Inode 6402: 12 -> 11)
(Inode 6641: 12 -> 11)
(Inode 8301: 12 -> 11)
(Inode 8732: 12 -> 11)
(Inode 14701: 12 -> 11)
(Inode 18610: 23 -> 22)
(Inode 18726: 12 -> 11)
(Inode 20529: 12 -> 11)
(Inode 21023: 11 -> 10)
(Inode 22935: 12 -> 11)
(Inode 26638: 12 -> 11)
(Inode 26717: 12 -> 11)
(Inode 27077: 12 -> 11)
(Inode 28812: 12 -> 11)
(Inode 29055: 12 -> 11)
(Inode 29118: 12 -> 11)
(Inode 30745: 12 -> 11)
(Inode 30784: 12 -> 11)
(Inode 30904: 12 -> 11)
(Inode 33170: 12 -> 11)
(Inode 33181: 12 -> 11)
(Inode 34927: 12 -> 11)
(Inode 35221: 12 -> 11)
(Inode 36946: 12 -> 11)
(Inode 36950: 12 -> 11)
(Inode 37239: 12 -> 11)
(Inode 41180: 11 -> 10)
(Inode 43293: 12 -> 11)
(Inode 45374: 12 -> 11)
(Inode 49472: 58 -> 57)
(Inode 49606: 12 -> 11)
(Inode 51495: 12 -> 11)
(Inode 51603: 12 -> 11)
(Inode 53444: 11 -> 10)
(Inode 59747: 12 -> 11)
(Inode 61765: 12 -> 11)
(Inode 62012: 12 -> 11)
(Inode 63851: 12 -> 11)
(Inode 63962: 12 -> 11)
(Inode 65659: 12 -> 11)
(Inode 67910: 58 -> 57)
(Inode 68020: 12 -> 11)
(Inode 70052: 58 -> 57)
(Inode 75868: 12 -> 11)
(Inode 76350: 12 -> 11)
(Inode 82116: 12 -> 11)
(Inode 82169: 12 -> 11)
(Inode 82209: 12 -> 11)
(Inode 82318: 12 -> 11)
(Inode 82340: 12 -> 11)
(Inode 88168: 12 -> 11)
(Inode 88404: 12 -> 11)
(Inode 90115: 12 -> 11)
(Inode 92570: 12 -> 11)
(Inode 96388: 12 -> 11)
(Inode 98339: 12 -> 11)
(Inode 100571: 12 -> 11)
(Inode 100774: 12 -> 11)
(Inode 104899: 12 -> 11)
(Inode 104962: 12 -> 11)
(Inode 108629: 12 -> 11)
(Inode 111132: 12 -> 11)
(Inode 113039: 12 -> 11)
(Inode 113113: 12 -> 11)
(Inode 121138: 12 -> 11)
(Inode 123084: 12 -> 11)
(Inode 124932: 12 -> 11)
(Inode 125020: 11 -> 10)
(Inode 125104: 12 -> 11)
(Inode 125389: 12 -> 11)
(Inode 127089: 58 -> 57)
(Inode 129630: 12 -> 11)
(Inode 131147: 12 -> 11)
(Inode 131393: 12 -> 11)
(Inode 135320: 12 -> 11)
(Inode 135604: 12 -> 11)
(Inode 137269: 58 -> 57)
(Inode 137323: 12 -> 11)
(Inode 137537: 12 -> 11)
(Inode 137720: 12 -> 11)
(Inode 139474: 12 -> 11)
(Inode 139829: 58 -> 57)
(Inode 141850: 58 -> 57)
(Inode 145591: 12 -> 11)
(Inode 145685: 12 -> 11)
(Inode 145794: 12 -> 11)
(Inode 148050: 12 -> 11)
(Inode 149986: 12 -> 11)
(Inode 152035: 12 -> 11)
(Inode 152062: 12 -> 11)
(Inode 154065: 12 -> 11)
(Inode 154108: 12 -> 11)
(Inode 155913: 12 -> 11)
(Inode 156076: 12 -> 11)
(Inode 160253: 12 -> 11)
(Inode 161857: 12 -> 11)
(Inode 164349: 12 -> 11)
(Inode 166235: 12 -> 11)
(Inode 168205: 12 -> 11)
(Inode 180483: 12 -> 11)
(Inode 182441: 12 -> 11)
(Inode 184400: 12 -> 11)
(Inode 184844: 11 -> 10)
(Inode 186414: 12 -> 11)
(Inode 190707: 12 -> 11)
(Inode 190964: 12 -> 11)
(Inode 194564: 56 -> 55)
(Inode 197000: 58 -> 57)
(Inode 197153: 12 -> 11)
(Inode 198973: 12 -> 11)
(Inode 203206: 12 -> 11)
(Inode 206981: 12 -> 11)
(Inode 206985: 12 -> 11)
(Inode 207367: 24 -> 23)
(Inode 208965: 12 -> 11)
(Inode 209287: 11 -> 10)
(Inode 209371: 23 -> 22)
(Inode 209392: 12 -> 11)
(Inode 211344: 12 -> 11)
(Inode 213494: 58 -> 57)
(Inode 215401: 12 -> 11)
(Inode 217364: 12 -> 11)
(Inode 217529: 12 -> 11)
(Inode 219675: 12 -> 11)
(Inode 221285: 12 -> 11)
(Inode 221711: 12 -> 11)
(Inode 225596: 12 -> 11)
(Inode 231669: 12 -> 11)
(Inode 235986: 12 -> 11)
(Inode 237599: 12 -> 11)
(Inode 237727: 12 -> 11)
(Inode 239937: 12 -> 11)
(Inode 241776: 12 -> 11)
(Inode 241844: 12 -> 11)
(Inode 241845: 12 -> 11)
(Inode 244084: 12 -> 11)
(Inode 245829: 12 -> 11)
(Inode 246020: 12 -> 11)
(Inode 250009: 12 -> 11)
(Inode 251937: 12 -> 11)
(Inode 251966: 12 -> 11)
(Inode 252159: 12 -> 11)
(Inode 254292: 12 -> 11)
(Inode 254367: 23 -> 22)
(Inode 256028: 11 -> 10)
(Inode 256375: 12 -> 11)
(Inode 256447: 63 -> 62)
(Inode 256448: 12 -> 11)
(Inode 260599: 45 -> 42)
(Inode 262522: 58 -> 57)
(Inode 264219: 12 -> 11)
(Inode 266415: 12 -> 11)
(Inode 266478: 12 -> 11)
(Inode 268793: 12 -> 11)
(Inode 274445: 12 -> 11)
(Inode 274756: 12 -> 11)
(Inode 274927: 12 -> 11)
(Inode 274964: 12 -> 11)
(Inode 276609: 12 -> 11)
(Inode 277086: 23 -> 22)
(Inode 280624: 12 -> 11)
(Inode 282955: 23 -> 22)
(Inode 283076: 12 -> 11)
(Inode 284782: 12 -> 11)
(Inode 286971: 43 -> 42)
(Inode 288920: 12 -> 11)
(Inode 291333: 12 -> 11)
(Inode 293121: 12 -> 11)
(Inode 293262: 12 -> 11)
(Inode 293283: 12 -> 11)
(Inode 293384: 24 -> 23)
(Inode 294928: 23 -> 22)
(Inode 295460: 58 -> 57)
(Inode 295494: 12 -> 11)
(Inode 301165: 12 -> 11)
(Inode 303593: 12 -> 11)
(Inode 303619: 12 -> 11)
(Inode 303677: 12 -> 11)
(Inode 305465: 12 -> 11)
(Inode 309251: 23 -> 22)
(Inode 311725: 12 -> 11)
(Inode 313848: 34 -> 33)
(Inode 315423: 12 -> 11)
(Inode 317698: 23 -> 22)
(Inode 317900: 12 -> 11)
(Inode 321564: 11 -> 10)
(Inode 321660: 12 -> 11)
(Inode 322020: 12 -> 11)
(Inode 322022: 12 -> 11)
(Inode 323612: 12 -> 11)
(Inode 324104: 12 -> 11)
(Inode 325638: 12 -> 11)
(Inode 325668: 12 -> 11)
(Inode 325979: 12 -> 11)
(Inode 326015: 12 -> 11)
(Inode 326109: 12 -> 11)
(Inode 326166: 12 -> 11)
(Inode 327784: 12 -> 11)
(Inode 327990: 12 -> 11)
(Inode 329953: 56 -> 55)
(Inode 332070: 12 -> 11)
(Inode 332124: 12 -> 11)
(Inode 332187: 56 -> 55)
(Inode 333921: 12 -> 11)
(Inode 334050: 12 -> 11)
(Inode 336214: 12 -> 11)
(Inode 337940: 12 -> 11)
(Inode 342589: 12 -> 11)
(Inode 344299: 23 -> 22)
(Inode 350514: 12 -> 11)
(Inode 350561: 12 -> 11)
(Inode 352584: 12 -> 11)
(Inode 354333: 12 -> 11)
(Inode 356942: 12 -> 11)
(Inode 358638: 12 -> 11)
(Inode 361073: 12 -> 11)
(Inode 366831: 12 -> 11)
(Inode 367028: 12 -> 11)
(Inode 368958: 12 -> 11)
(Inode 371203: 12 -> 11)
(Inode 372967: 12 -> 11)
(Inode 375367: 12 -> 11)
(Inode 377022: 12 -> 11)
(Inode 379262: 12 -> 11)
(Inode 380990: 12 -> 11)
(Inode 381225: 23 -> 22)
(Inode 385412: 58 -> 57)
(Inode 387288: 12 -> 11)
(Inode 389455: 12 -> 11)
(Inode 391191: 45 -> 43)
(Inode 393346: 12 -> 11)
(Inode 393633: 12 -> 11)
(Inode 395311: 58 -> 57)
(Inode 397612: 12 -> 11)
(Inode 405863: 12 -> 11)
(Inode 407632: 12 -> 11)
(Inode 407661: 12 -> 11)
(Inode 415889: 12 -> 11)
(Inode 416007: 12 -> 11)
(Inode 422141: 12 -> 11)
(Inode 422285: 12 -> 11)
(Inode 424424: 23 -> 22)
(Inode 426562: 12 -> 11)
(Inode 430431: 12 -> 11)
(Inode 430592: 12 -> 11)
(Inode 432689: 12 -> 11)
(Inode 434501: 12 -> 11)
(Inode 442468: 12 -> 11)
(Inode 442501: 12 -> 11)
(Inode 442558: 12 -> 11)
(Inode 442858: 12 -> 11)
(Inode 444882: 11 -> 10)
(Inode 446613: 12 -> 11)
(Inode 450613: 12 -> 11)
(Inode 450673: 12 -> 11)
(Inode 456798: 12 -> 11)
(Inode 461248: 12 -> 11)
(Inode 464913: 58 -> 57)
(Inode 469508: 12 -> 11)
(Inode 469517: 12 -> 11)
(Inode 473188: 12 -> 11)
(Inode 479416: 12 -> 11)
(Inode 479622: 12 -> 11)
(Inode 479681: 12 -> 11)
(Inode 483518: 12 -> 11)
(Inode 485638: 58 -> 57)
(Inode 489976: 12 -> 11)
(Inode 495652: 12 -> 11)
(Inode 496201: 56 -> 55)
(Inode 502115: 12 -> 11)
(Inode 502150: 12 -> 11)
(Inode 503838: 12 -> 11)
(Inode 503988: 12 -> 11)
(Inode 504340: 12 -> 11)
(Inode 508408: 12 -> 11)
(Inode 509995: 12 -> 11)
(Inode 510273: 12 -> 11)
(Inode 510472: 12 -> 11)
(Inode 514096: 24 -> 23)
(Inode 514162: 12 -> 11)
(Inode 514196: 12 -> 11)
(Inode 522489: 12 -> 11)
(Inode 524383: 12 -> 11)
(Inode 524537: 12 -> 11)
(Inode 526633: 12 -> 11)
(Inode 526931: 12 -> 11)
(Inode 530646: 58 -> 57)
(Inode 530718: 58 -> 57)
(Inode 534643: 12 -> 11)
(Inode 535042: 12 -> 11)
(Inode 536929: 12 -> 11)
(Inode 538972: 12 -> 11)
(Inode 544949: 12 -> 11)
(Inode 547355: 12 -> 11)
(Inode 548889: 24 -> 23)
(Inode 551503: 12 -> 11)
(Inode 555083: 12 -> 11)
(Inode 555540: 12 -> 11)
(Inode 557305: 12 -> 11)
(Inode 557557: 12 -> 11)
(Inode 559292: 12 -> 11)
(Inode 559539: 12 -> 11)
(Inode 563689: 12 -> 11)
(Inode 563806: 12 -> 11)
(Inode 569585: 12 -> 11)
(Inode 571401: 56 -> 55)
(Inode 573921: 12 -> 11)
(Inode 575765: 12 -> 11)
(Inode 578100: 12 -> 11)
(Inode 582111: 12 -> 11)
(Inode 585789: 23 -> 22)
(Inode 586213: 23 -> 22)
(Inode 588425: 12 -> 11)
(Inode 592201: 12 -> 11)
(Inode 592499: 24 -> 23)
(Inode 594266: 12 -> 11)
(Inode 594524: 12 -> 11)
(Inode 596197: 12 -> 11)
(Inode 596270: 12 -> 11)
(Inode 600149: 12 -> 11)
(Inode 604637: 12 -> 11)
(Inode 606832: 12 -> 11)
(Inode 606839: 12 -> 11)
(Inode 610349: 12 -> 11)
(Inode 612880: 12 -> 11)
(Inode 616816: 12 -> 11)
(Inode 618721: 12 -> 11)
(Inode 620868: 12 -> 11)
(Inode 622674: 12 -> 11)
(Inode 622864: 24 -> 23)
(Inode 623210: 12 -> 11)
(Inode 626938: 12 -> 11)
(Inode 627038: 12 -> 11)
(Inode 627043: 7081 -> 7076)
(Inode 627063: 12 -> 11)
(Inode 635356: 12 -> 11)
(Inode 636954: 12 -> 11)
(Inode 639623: 12 -> 11)
(Inode 641486: 12 -> 11)
(Inode 643218: 12 -> 11)
(Inode 645192: 12 -> 11)
(Inode 645692: 31 -> 30)
(Inode 647530: 12 -> 11)
(Inode 647648: 12 -> 11)
(Inode 649315: 12 -> 11)
(Inode 649328: 12 -> 11)
(Inode 649483: 12 -> 11)
(Inode 651280: 11 -> 10)
(Inode 651300: 12 -> 11)
(Inode 651609: 12 -> 11)
(Inode 651625: 12 -> 11)
(Inode 651678: 12 -> 11)
(Inode 653619: 11 -> 10)
(Inode 661605: 12 -> 11)
(Inode 664042: 12 -> 11)
(Inode 665944: 12 -> 11)
(Inode 668066: 12 -> 11)
(Inode 668130: 12 -> 11)
(Inode 669772: 12 -> 11)
(Inode 670355: 12 -> 11)
(Inode 672031: 5 -> 4)
(Inode 672307: 12 -> 11)
(Inode 673930: 11 -> 10)
(Inode 674028: 12 -> 11)
(Inode 674151: 12 -> 11)
(Inode 674370: 12 -> 11)
(Inode 675913: 12 -> 11)
(Inode 680155: 12 -> 11)
(Inode 682201: 12 -> 11)
(Inode 682457: 12 -> 11)
(Inode 684214: 24 -> 23)
(Inode 684324: 12 -> 11)
(Inode 684674: 12 -> 11)
(Inode 686225: 11 -> 10)
(Inode 686258: 12 -> 11)
(Inode 686310: 12 -> 11)
(Inode 692443: 58 -> 57)
(Inode 694474: 12 -> 11)
(Inode 696391: 12 -> 11)
(Inode 696898: 12 -> 11)
(Inode 696971: 23 -> 22)
(Inode 700489: 12 -> 11)
(Inode 704634: 12 -> 11)
(Inode 704646: 12 -> 11)
(Inode 706838: 23 -> 22)
(Inode 708706: 12 -> 11)
(Inode 710752: 12 -> 11)
(Inode 711164: 12 -> 11)
(Inode 714985: 12 -> 11)
(Inode 719296: 31 -> 30)
(Inode 723207: 12 -> 11)
(Inode 723316: 12 -> 11)
(Inode 725604: 12 -> 11)
(Inode 729390: 12 -> 11)
(Inode 731809: 12 -> 11)
(Inode 735367: 58 -> 57)
(Inode 737386: 12 -> 11)
(Inode 739589: 8 -> 7)
(Inode 745576: 23 -> 22)
(Inode 746001: 12 -> 11)
(Inode 746005: 58 -> 57)
(Inode 748160: 11 -> 10)
(Inode 749865: 12 -> 11)
(Inode 752227: 12 -> 11)
(Inode 753902: 12 -> 11)
(Inode 753992: 12 -> 11)
(Inode 754131: 11 -> 10)
(Inode 756170: 12 -> 11)
(Inode 761895: 12 -> 11)
(Inode 762091: 12 -> 11)
(Inode 762155: 12 -> 11)
(Inode 762258: 12 -> 11)
(Inode 762532: 12 -> 11)
(Inode 764181: 12 -> 11)
(Inode 764515: 12 -> 11)
(Inode 770374: 12 -> 11)
(Inode 770502: 12 -> 11)
(Inode 770552: 12 -> 11)
(Inode 770636: 12 -> 11)
(Inode 772220: 12 -> 11)
(Inode 772698: 12 -> 11)
(Inode 774752: 12 -> 11)
(Inode 778251: 12 -> 11)
(Inode 778347: 58 -> 57)
(Inode 778807: 12 -> 11)
(Inode 780784: 12 -> 11)
(Inode 780794: 12 -> 11)
(Inode 782346: 12 -> 11)
(Inode 782420: 23 -> 22)
(Inode 784582: 12 -> 11)
(Inode 784636: 12 -> 11)
(Inode 786721: 12 -> 11)
(Inode 790739: 12 -> 11)
(Inode 790940: 12 -> 11)
(Inode 792597: 12 -> 11)
(Inode 793000: 297 -> 296)
(Inode 793218: 12 -> 11)
(Inode 795230: 58 -> 57)
(Inode 795241: 12 -> 11)
(Inode 797054: 12 -> 11)
(Inode 797064: 12 -> 11)
(Inode 797155: 12 -> 11)
(Inode 805053: 12 -> 11)
(Inode 809216: 12 -> 11)
(Inode 815598: 12 -> 11)
(Inode 815635: 12 -> 11)
(Inode 815693: 12 -> 11)
(Inode 817179: 12 -> 11)
(Inode 817698: 12 -> 11)
(Inode 817753: 12 -> 11)
(Inode 823818: 12 -> 11)
(Inode 825718: 12 -> 11)
(Inode 825904: 23 -> 21)
(Inode 827849: 12 -> 11)
(Inode 829812: 12 -> 11)
(Inode 831913: 12 -> 11)
(Inode 835631: 12 -> 11)
(Inode 836126: 12 -> 11)
(Inode 836177: 12 -> 11)
(Inode 837646: 12 -> 11)
(Inode 844395: 58 -> 57)
(Inode 846191: 12 -> 11)
(Inode 852369: 12 -> 11)
(Inode 858573: 12 -> 11)
(Inode 860398: 12 -> 11)
(Inode 862363: 12 -> 11)
(Inode 862422: 58 -> 57)
(Inode 864382: 12 -> 11)
(Inode 868572: 23 -> 22)
(Inode 872455: 12 -> 11)
(Inode 872561: 12 -> 11)
(Inode 872966: 12 -> 11)
(Inode 874734: 34 -> 31)
(Inode 876647: 12 -> 11)
(Inode 878671: 12 -> 11)
(Inode 878938: 12 -> 11)
(Inode 882805: 12 -> 11)
(Inode 887285: 12 -> 11)
(Inode 888978: 12 -> 11)
(Inode 893061: 11 -> 10)
(Inode 893388: 12 -> 11)
(Inode 897120: 12 -> 11)
(Inode 897224: 23 -> 22)
(Inode 899561: 58 -> 57)
(Inode 905703: 12 -> 11)
(Inode 907808: 12 -> 11)
(Inode 909989: 56 -> 51)
(Inode 911712: 12 -> 11)
(Inode 915632: 12 -> 11)
(Inode 915633: 12 -> 11)
(Inode 915778: 12 -> 11)
(Inode 918109: 56 -> 55)
(Inode 921875: 54 -> 53)
(Inode 921917: 10 -> 9)
(Inode 923773: 12 -> 11)
(Inode 923840: 12 -> 11)
(Inode 924223: 12 -> 11)
(Inode 926099: 12 -> 11)
(Inode 928068: 12 -> 11)
(Inode 928246: 12 -> 11)
(Inode 928271: 12 -> 11)
(Inode 928338: 12 -> 11)
(Inode 936026: 12 -> 11)
(Inode 938208: 12 -> 11)
(Inode 940176: 12 -> 11)
(Inode 940470: 12 -> 11)
(Inode 942645: 12 -> 11)
(Inode 944337: 11 -> 10)
(Inode 944402: 8 -> 7)
(Inode 946522: 12 -> 11)
(Inode 948594: 12 -> 11)
(Inode 948769: 12 -> 11)
(Inode 950377: 12 -> 11)
(Inode 950505: 12 -> 11)
(Inode 952946: 12 -> 11)
(Inode 954846: 12 -> 11)
(Inode 960977: 12 -> 11)
(Inode 961083: 12 -> 11)
(Inode 962790: 12 -> 11)
(Inode 964740: 12 -> 11)
(Inode 965172: 12 -> 11)
(Inode 966856: 12 -> 11)
(Inode 966988: 12 -> 11)
(Inode 972804: 12 -> 11)
(Inode 973226: 12 -> 11)
(Inode 973346: 12 -> 11)
(Inode 975425: 12 -> 11)
(Inode 977357: 12 -> 11)
(Inode 979259: 12 -> 11)
(Inode 983293: 12 -> 11)
(Inode 983301: 12 -> 11)
(Inode 983510: 12 -> 11)
(Inode 983533: 12 -> 11)
(Inode 985532: 12 -> 11)
(Inode 987664: 12 -> 11)
(Inode 987689: 12 -> 11)
(Inode 987698: 12 -> 11)
(Inode 987816: 12 -> 11)
(Inode 991302: 12 -> 11)
(Inode 991422: 58 -> 57)
(Inode 991507: 12 -> 11)
(Inode 993529: 58 -> 57)
(Inode 993785: 56 -> 55)
(Inode 995806: 12 -> 11)
(Inode 999961: 12 -> 11)
(Inode 999987: 12 -> 11)
(Inode 1001652: 12 -> 11)
(Inode 1001702: 12 -> 11)
(Inode 1002096: 12 -> 11)
(Inode 1004016: 12 -> 11)
(Inode 1004145: 12 -> 11)
(Inode 1005867: 12 -> 11)
(Inode 1005879: 12 -> 11)
(Inode 1007859: 11 -> 10)
(Inode 1009965: 12 -> 11)
(Inode 1010175: 23 -> 21)
(Inode 1011758: 12 -> 11)
(Inode 1011816: 12 -> 11)
(Inode 1012196: 32 -> 31)
(Inode 1014196: 12 -> 11)
(Inode 1020200: 12 -> 11)
(Inode 1022193: 12 -> 11)
(Inode 1024152: 12 -> 11)
(Inode 1024289: 12 -> 11)
(Inode 1026063: 12 -> 11)
(Inode 1028234: 12 -> 11)
(Inode 1028364: 12 -> 11)
(Inode 1028412: 12 -> 11)
(Inode 1028453: 23 -> 22)
(Inode 1030188: 12 -> 11)
(Inode 1030697: 12 -> 11)
(Inode 1040436: 12 -> 11)
(Inode 1046886: 11 -> 10)
(Inode 1048719: 12 -> 11)
(Inode 1049044: 12 -> 11)
(Inode 1051024: 12 -> 11)
(Inode 1051201: 12 -> 11)
(Inode 1059201: 12 -> 11)
(Inode 1062989: 12 -> 11)
(Inode 1063404: 12 -> 11)
(Inode 1067643: 23 -> 22)
(Inode 1069511: 12 -> 11)
(Inode 1073415: 12 -> 11)
(Inode 1075763: 12 -> 11)
(Inode 1077339: 12 -> 11)
(Inode 1077512: 12 -> 11)
(Inode 1077520: 12 -> 11)
(Inode 1079428: 12 -> 11)
(Inode 1079647: 12 -> 11)
(Inode 1081548: 12 -> 11)
(Inode 1081850: 12 -> 11)
(Inode 1083473: 12 -> 11)
(Inode 1083668: 12 -> 11)
(Inode 1083831: 12 -> 11)
(Inode 1089638: 23 -> 22)
(Inode 1091920: 12 -> 11)
(Inode 1093962: 12 -> 11)
(Inode 1095956: 12 -> 11)
(Inode 1096044: 12 -> 11)
(Inode 1097835: 23 -> 22)
(Inode 1101938: 56 -> 55)
(Inode 1101946: 12 -> 11)
(Inode 1102055: 12 -> 11)
(Inode 1102472: 58 -> 57)
(Inode 1104268: 12 -> 11)
(Inode 1108169: 12 -> 11)
(Inode 1108394: 12 -> 11)
(Inode 1110213: 12 -> 11)
(Inode 1112099: 12 -> 11)
(Inode 1114658: 12 -> 11)
(Inode 1120837: 12 -> 11)
(Inode 1122828: 12 -> 11)
(Inode 1124595: 12 -> 11)
(Inode 1124901: 12 -> 11)
(Inode 1128490: 12 -> 11)
(Inode 1128716: 12 -> 11)
(Inode 1128765: 34 -> 33)
(Inode 1130582: 12 -> 11)
(Inode 1131079: 12 -> 11)
(Inode 1131115: 23 -> 22)
(Inode 1135125: 12 -> 11)
(Inode 1138801: 56 -> 55)
(Inode 1141004: 12 -> 11)
(Inode 1143154: 12 -> 11)
(Inode 1144855: 12 -> 11)
(Inode 1147247: 12 -> 11)
(Inode 1149444: 12 -> 11)
(Inode 1153558: 56 -> 55)
(Inode 1153598: 12 -> 11)
(Inode 1155252: 12 -> 11)
(Inode 1155537: 12 -> 11)
(Inode 1157151: 12 -> 11)
(Inode 1157367: 58 -> 57)
(Inode 1157437: 12 -> 11)
(Inode 1157516: 12 -> 11)
(Inode 1159392: 11 -> 10)
(Inode 1159579: 12 -> 11)
(Inode 1161378: 12 -> 11)
(Inode 1165947: 23 -> 22)
(Inode 1169444: 12 -> 11)
(Inode 1173760: 12 -> 11)
(Inode 1174060: 12 -> 11)
(Inode 1177838: 58 -> 57)
(Inode 1179673: 12 -> 11)
(Inode 1181789: 11 -> 10)
(Inode 1183903: 12 -> 11)
(Inode 1185980: 12 -> 11)
(Inode 1192064: 12 -> 11)
(Inode 1194297: 12 -> 11)
(Inode 1198588: 12 -> 11)
(Inode 1200244: 58 -> 57)
(Inode 1206279: 12 -> 11)
(Inode 1206300: 12 -> 11)
(Inode 1210654: 11 -> 10)
(Inode 1212497: 23 -> 22)
(Inode 1214638: 12 -> 11)
(Inode 1214726: 12 -> 11)
(Inode 1214952: 12 -> 11)
(Inode 1216788: 12 -> 11)
(Inode 1218954: 12 -> 11)
(Inode 1219178: 12 -> 11)
(Inode 1220856: 23 -> 22)
(Inode 1225308: 12 -> 11)
(Inode 1226888: 12 -> 11)
(Inode 1227137: 34 -> 33)
(Inode 1227341: 12 -> 11)
(Inode 1232986: 12 -> 11)
(Inode 1239297: 12 -> 11)
(Inode 1239366: 12 -> 11)
(Inode 1241260: 12 -> 11)
(Inode 1245484: 12 -> 11)
(Inode 1247379: 23 -> 21)
(Inode 1249412: 58 -> 57)
(Inode 1249610: 12 -> 11)
(Inode 1628165: 105 -> 103)
(Inode 1675274: 24 -> 23)
(Inode 1703953: 5 -> 3)
(Inode 1726478: 15 -> 14)
(Inode 1736709: 21 -> 14)
(Inode 1738765: 106 -> 105)
(Inode 1738766: 3 -> 2)
(Inode 1742849: 3 -> 2)
(Inode 1742850: 3 -> 2)
(Inode 3180553: 67 -> 60)
(Inode 3186690: 3 -> 2)

Unattached zero-length inode 3186691.  Clear? yes

(Inode 3186692: 3 -> 2)
(Inode 3186693: 4 -> 2)
(Inode 3186694: 3 -> 2)
(Inode 3186695: 3 -> 2)

Unattached zero-length inode 3186697.  Clear? yes

(Inode 3186700: 3 -> 2)

Unattached zero-length inode 3186701.  Clear? yes

(Inode 3186702: 3 -> 2)

Unattached zero-length inode 3186703.  Clear? yes

(Inode 3614721: 1901 -> 1881)
(Inode 3649552: 45 -> 43)
(Inode 3717134: 4 -> 3)
(Inode 3719169: 3 -> 2)
(Inode 3719171: 3 -> 2)
(Inode 3721230: 3 -> 2)
(Inode 3725326: 3 -> 2)
(Inode 3725328: 8 -> 6)
(Inode 3727368: 3 -> 2)
(Inode 3729422: 3 -> 2)
(Inode 4573591: 5 -> 4)
(Inode 4659547: 4 -> 3)
(Inode 5890578: 4 -> 3)
(Inode 5896570: 3 -> 2)
(Inode 5943660: 3 -> 2)
(Inode 5976414: 3 -> 2)
(Inode 5980499: 3 -> 2)
(Inode 5982590: 3 -> 2)
(Inode 5996891: 3 -> 2)
(Inode 5999235: 3 -> 2)
(Inode 5999324: 3 -> 2)
(Inode 6029742: 4 -> 3)
(Inode 6035861: 3 -> 2)
(Inode 6040029: 3 -> 2)
(Inode 6046177: 4 -> 3)
(Inode 6099432: 3 -> 2)
(Inode 6103441: 4 -> 3)
(Inode 6226354: 3 -> 2)
(Inode 7602400: 12 -> 11)
(Inode 7610729: 12 -> 11)
(Inode 7614496: 12 -> 11)
(Inode 7614639: 12 -> 11)
(Inode 7614767: 12 -> 11)
(Inode 7614912: 12 -> 11)
(Inode 7620683: 12 -> 11)
(Inode 7620987: 12 -> 11)
(Inode 7622662: 11 -> 10)
(Inode 7622837: 12 -> 11)
(Inode 7625009: 12 -> 11)
(Inode 7625166: 12 -> 11)
(Inode 7628844: 12 -> 11)
(Inode 7628922: 12 -> 11)
(Inode 7628985: 12 -> 11)

Pass 5: Checking group summary information
Block bitmap differences:  -(445644960--445644976) -445645215
Fix? yes

Free blocks count wrong for group #13600 (32352, counted=32370).
Fix? yes

Free blocks count wrong (3952007869, counted=3952007887).
Fix? yes

Inode bitmap differences:  -(1740801--1740816)
Fix? yes

Free inodes count wrong for group #13600 (0, counted=16).
Fix? yes

Directories count wrong for group #13600 (92, counted=77).
Fix? yes

Free inodes count wrong (18970319, counted=18970335).
Fix? yes


data: ***** FILE SYSTEM WAS MODIFIED *****

data: ********** WARNING: Filesystem still has errors **********


     2013345 inodes used (9.59%, out of 20983680)
        9557 non-contiguous files (0.5%)
        1374 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 2009515/3813
  1419796177 blocks used (26.43%, out of 5371804064)
           0 bad blocks
         255 large files

     1097082 regular files
      916245 directories
           0 character device files
           0 block device files
           0 fifos
     4339684 links
          12 symbolic links (12 fast symbolic links)
           1 socket
------------
     6353020 files




root@Media-PC2:~/e2fsprogs# e2fsck/e2fsck -v -C0 -y /dev/md127
e2fsck 1.43-WIP (22-Sep-2012)
data contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
eh_magic = 0000 != f30a
884: Extent error on inode 7
Pass 2: Checking directory structure
Directory inode 3719170, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107169 (inode 3719170): Inode checksum does not match inode
Continue? yes

Directory inode 3719171, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107170 (inode 3719171): Inode checksum does not match inode
Continue? yes

Directory inode 3719172, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107171 (inode 3719172): Inode checksum does not match inode
Continue? yes

Directory inode 3719173, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107172 (inode 3719173): Inode checksum does not match inode
Continue? yes

Directory inode 3719174, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107173 (inode 3719174): Inode checksum does not match inode
Continue? yes

Directory inode 3719175, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107174 (inode 3719175): Inode checksum does not match inode
Continue? yes

Directory inode 3719176, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107175 (inode 3719176): Inode checksum does not match inode
Continue? yes

Directory inode 3719177, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107176 (inode 3719177): Inode checksum does not match inode
Continue? yes

Directory inode 3719178, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107177 (inode 3719178): Inode checksum does not match inode
Continue? yes

Directory inode 3719179, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107178 (inode 3719179): Inode checksum does not match inode
Continue? yes

Directory inode 3719180, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107179 (inode 3719180): Inode checksum does not match inode
Continue? yes

Directory inode 3719181, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107180 (inode 3719181): Inode checksum does not match inode
Continue? yes

Directory inode 3719182, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107181 (inode 3719182): Inode checksum does not match inode
Continue? yes

Directory inode 3719183, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107182 (inode 3719183): Inode checksum does not match inode
Continue? yes

Directory inode 3719184, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 952107183 (inode 3719184): Inode checksum does not match inode
Continue? yes

Directory inode 3725315, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 953680034 (inode 3725315): Inode checksum does not match inode
Continue? yes

Directory inode 3727364, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204323 (inode 3727364): Inode checksum does not match inode
Continue? yes

Directory inode 3727365, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204324 (inode 3727365): Inode checksum does not match inode
Continue? yes

Directory inode 3727366, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204325 (inode 3727366): Inode checksum does not match inode
Continue? yes

Directory inode 3727367, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204326 (inode 3727367): Inode checksum does not match inode
Continue? yes

Directory inode 3727368, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204327 (inode 3727368): Inode checksum does not match inode
Continue? yes

Directory inode 3727369, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204328 (inode 3727369): Inode checksum does not match inode
Continue? yes

Directory inode 3727370, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204329 (inode 3727370): Inode checksum does not match inode
Continue? yes

Directory inode 3727371, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204330 (inode 3727371): Inode checksum does not match inode
Continue? yes

Directory inode 3727372, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204331 (inode 3727372): Inode checksum does not match inode
Continue? yes

Directory inode 3727373, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204332 (inode 3727373): Inode checksum does not match inode
Continue? yes

Directory inode 3727374, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204333 (inode 3727374): Inode checksum does not match inode
Continue? yes

Directory inode 3727375, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204334 (inode 3727375): Inode checksum does not match inode
Continue? yes

Directory inode 3727376, block #0, offset 0: directory fails checksum
Salvage? yes

Error writing directory block 954204335 (inode 3727376): Inode checksum does not match inode
Continue? yes

Pass 3: Checking directory connectivity
'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fcisco (3186690) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186690: Directory block checksum does not match directory block

'..' in /lost+found/#3186692 (3186692) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186692: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fibm (3186693) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186693: Directory block checksum does not match directory block

'..' in /lost+found/#3186694 (3186694) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186694: Directory block checksum does not match directory block

'..' in /lost+found/#3186695 (3186695) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186695: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/f8390 (3186696) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186696: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fxscale (3186698) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186698: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fnxp (3186699) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186699: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fdec (3186700) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186700: Directory block checksum does not match directory block

'..' in /lost+found/#3186702 (3186702) is / (2), should be /lost+found (11).
Fix? yes

Couldn't fix parent of inode 3186702: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet/fcalxeda (3186704) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fsrc/flinux/fdrivers/fnet/fethernet (3180553).
Fix? yes

Couldn't fix parent of inode 3186704: Directory block checksum does not match directory block

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fxaw3dg/fexamples (3719170) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fxaw3dg (3719169).
Fix? yes

'..' in /lost+found/#3719171 (3719171) is / (2), should be /lost+found (11).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgc1c2 (3719172) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibappindicator1 (3719173) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgnome-menu-3-0 (3719174) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibunistring0 (3719175) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fyelp (3719176) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgpm2 (3719177) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibaudio2 (3719178) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibkrb5support0 (3719179) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fbogofilter-bdb (3719180) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fpython-minimal (3719181) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibquvi-scripts/flua/fwebsite (3719182) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibquvi-scripts/flua (3717134).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging/fpanel (3719183) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging (3649552).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging/fpohmelfs (3719184) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fstaging (3649552).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fmime-support (3725315) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibframe6 (3727364) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fuuid-dev (3727365) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibgcr-3-1 (3727366) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fpopularity-contest (3727367) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /lost+found/#3727368 (3727368) is / (2), should be /lost+found (11).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/fcompizconfig-backend-gconf (3727369) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibkrb5-3 (3727370) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibao-common (3727371) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flogin (3727372) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc/flibglib-perl (3727373) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/fdoc (3614721).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibrarian/fTemplates (3727374) is / (2), should be /backuppc/pc/localhost/163/f%2f/fusr/fshare/flibrarian (3725326).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar/fipmi (3727375) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar (3725328).
Fix? yes

'..' in /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar/fpcmcia (3727376) is / (2), should be /backuppc/pc/localhost/163/f%2f/flib/fmodules/f3.2.0-29-generic/fkernel/fdrivers/fchar (3725328).
Fix? yes

Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences: Group 131072 block bitmap does not match checksum
FIXED.

data: ***** FILE SYSTEM WAS MODIFIED *****

data: ********** WARNING: Filesystem still has errors **********


     2013345 inodes used (9.59%, out of 20983680)
        9557 non-contiguous files (0.5%)
        1374 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 2009511/3813
  1419796177 blocks used (26.43%, out of 5371804064)
           0 bad blocks
         255 large files

     1097078 regular files
      916245 directories
           0 character device files
           0 block device files
           0 fifos
     4339685 links
          12 symbolic links (12 fast symbolic links)
           1 socket
------------
     6353021 files

~/e2fsprogs# exit

Script done on Fri 16 Nov 2012 12:20:25 PM UTC
