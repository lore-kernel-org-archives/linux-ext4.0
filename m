From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Date: Sun, 13 Apr 2014 18:00:16 -0400
Message-ID: <20140413220016.GD8122@thunk.org>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Namjae Jeon <linkinjeon@gmail.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53672 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaDMWAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Apr 2014 18:00:20 -0400
Content-Disposition: inline
In-Reply-To: <1397420518-29218-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 13, 2014 at 04:21:58PM -0400, Theodore Ts'o wrote:
> If a particular fallocate mode is causing test failures, give the
> tester the ability to block a particular fallocate mode so that the
> use of a particular fallocate mode will be reported as not supported.
> 
> For example, if the COLLAPSE_RANGE fallocate mode is causing test
> failures, this allows us to suppress it so we can more easily test the
> rest of the file system code.

Hi Namjae,

One of the reasons this patch set is that after Lukas added
COLLAPSE_RANGE support into fsx, we've started seeing a number of
failures which seem to be directly related to COLLAPSE_RANGE.

For your convenience, I've updated the root_fs.img file for the
kvm-xfststs system in the xfstests-bld system:

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/root_fs.img.i386

This has the latest xfstests (plus some bug fixes not yet in the
xfstests upstream), which means it has the improved fsx.  With this
updated xfstests, the tests which use fsx, such as generic/075 and
generic/091, are failing for the 1k and bigalloc configuration, and if
we apply this patch and then add to the kernel's boot command line:

   ext4.fallocate_mode_block=0x08

this will allow these tests to pass again.

(An easy way to do this using kvm-xfstests is by creating the file
custom.config with the line "EXTRA_ARG="ext4.fallocate_mode_block=0x08")


In addition, although I haven't figured out why what is needed to
create a reliable production, test generic/091 (with COLLAPSE_RANGE
enabled) is sometimes causing a file system corruption which causes
the xfstests run to abort.  (It does seem to reproduce more reliably
if generic/091 is run as part of a "-g auto" run):

e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Inode 20 has out of order extents
	(invalid logical block 3, physical block 492938, len 2)
Clear? yes

Inode 20, i_blocks is 368, should be 352.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(492938--492939)
Fix? yes

Free blocks count wrong for group #15 (32657, counted=32659).
Fix? yes

Free blocks count wrong (1136513, counted=1136515).
Fix? yes


/dev/vdb: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdb: 10137/327680 files (5.4% non-contiguous), 174205/1310720 blocks

(This was found in the standard 4k configuration, but in the test log
below it was showing up in the dioread_nolock configuration).

If you could take a look at some of these test failures, I'd be much
obliged.

Thanks!

						- Ted

An excerpted log file generated using "kvm-xfstests generic/075
generic/091".  The 1k configuration fails reliably.  Some of the other
failures don't always fail, so your mileage may vary.

git versions:
fio		fio-2.1-19-g0b14f0a (Thu, 23 May 2013 21:27:54 +0200)
quota		0d0a674 (Tue, 26 Mar 2013 17:13:33 +0100)
xfsprogs	v3.2.0-alpha2-60-gaa210c4 (Thu, 13 Mar 2014 21:23:50 +1100)
xfstests-bld	66c8bf2 (Sat, 12 Apr 2014 13:32:12 -0400)
xfstests	linux-v3.8-366-g5c0348d (Sat, 12 Apr 2014 19:11:54 -0400)
BEGIN TEST: Ext4 4k block Sun Apr 13 20:53:43 UTC 2014
Device: /dev/vdb
mk2fs options: -q
mount options: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

generic/075 101s ...	[20:54:01] [20:55:44] 103s
generic/091 154s ...	[20:56:00] [20:58:30] 150s
Ran: generic/075 generic/091
Passed all 2 tests

END TEST: Ext4 4k block Sun Apr 13 20:58:45 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdb: 27437/327680 files (8.1% non-contiguous), 591406/1310720 blocks
BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Sun Apr 13 20:59:03 UTC 2014
Device: /dev/vdd
mk2fs options: -q -O ^extents,^flex_bg,^uninit_bg
mount options: -o block_validity,nodelalloc
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q -O ^extents,^flex_bg,^uninit_bg /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc

generic/075 62s ...	[20:59:11] [21:00:12] 61s
generic/091 144s ...	[21:00:15] [21:02:38] 143s
Ran: generic/075 generic/091
Passed all 2 tests

END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Sun Apr 13 21:02:41 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdd: 15/327680 files (6.7% non-contiguous), 55986/1310720 blocks
BEGIN TEST: Ext4 4k block w/ no journal Sun Apr 13 21:02:44 UTC 2014
Device: /dev/vdb
mk2fs options: -q -O ^has_journal
mount options: -o block_validity,noload
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q -O ^has_journal /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,noload /dev/vdc /vdc

generic/075 60s ...	[21:03:00] [21:03:57] 57s
generic/091 137s ...	[21:04:10] [21:06:21] 131s
Ran: generic/075 generic/091
Passed all 2 tests

END TEST: Ext4 4k block w/ no journal Sun Apr 13 21:06:34 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdb: 27437/327680 files (8.1% non-contiguous), 591406/1310720 blocks
BEGIN TEST: Ext4 1k block Sun Apr 13 21:06:49 UTC 2014
Device: /dev/vdd
mk2fs options: -q -b 1024
mount options: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q -b 1024 /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

generic/075		[21:06:53] [21:06:59] [failed, exit status 1] - output mismatch (see /results/results-1k/generic/075.out.bad)
    --- tests/generic/075.out	2014-04-12 23:20:55.000000000 +0000
    +++ /results/results-1k/generic/075.out.bad	2014-04-13 21:06:59.742889855 +0000
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/075.out /results/results-1k/generic/075.out.bad'  to see the entire diff)
generic/091 187s ...	[21:07:00] [21:09:15] [failed, exit status 1] - output mismatch (see /results/results-1k/generic/091.out.bad)
    --- tests/generic/091.out	2014-04-12 23:20:55.000000000 +0000
    +++ /results/results-1k/generic/091.out.bad	2014-04-13 21:09:15.726223187 +0000
    @@ -5,3 +5,816 @@
     fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    +fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    +mapped writes DISABLED
    +skipping zero length zero range
    +fallocating to largest ever: 0x137f5
    ...
    (Run 'diff -u tests/generic/091.out /results/results-1k/generic/091.out.bad'  to see the entire diff)
Ran: generic/075 generic/091
Failures: generic/075 generic/091
Failed 2 of 2 tests

END TEST: Ext4 1k block Sun Apr 13 21:09:17 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdd: 15/327680 files (6.7% non-contiguous), 120162/5242880 blocks
BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Sun Apr 13 21:09:19 UTC 2014
Device: /dev/vdd
mk2fs options: -q -O ^flex_bg
mount options: -o block_validity,nodelalloc
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q -O ^flex_bg /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc

generic/075 63s ...	[21:09:23] [21:10:23] 60s
generic/091 163s ...	[21:10:24] [21:13:07] 163s
Ran: generic/075 generic/091
Passed all 2 tests

END TEST: Ext4 4k block w/nodelalloc and no flex_bg Sun Apr 13 21:13:08 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdd: 15/327680 files (6.7% non-contiguous), 55952/1310720 blocks
BEGIN TEST: Ext4 4k block w/dioread_nolock Sun Apr 13 21:13:09 UTC 2014
Device: /dev/vdb
mk2fs options: -q
mount options: -o block_validity,dioread_nolock
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,dioread_nolock /dev/vdc /vdc

generic/075 99s ...	[21:13:27] [21:15:05] 98s
generic/091		[21:15:19] [21:17:36] [failed, exit status 1] - output mismatch (see /results/results-dioread_nolock/generic/091.out.bad)
    --- tests/generic/091.out	2014-04-12 23:20:55.000000000 +0000
    +++ /results/results-dioread_nolock/generic/091.out.bad	2014-04-13 21:17:36.366223190 +0000
    @@ -5,3 +5,1100 @@
     fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    +fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    +mapped writes DISABLED
    +skipping zero length zero range
    +fallocating to largest ever: 0x137f5
    ...
    (Run 'diff -u tests/generic/091.out /results/results-dioread_nolock/generic/091.out.bad'  to see the entire diff)
_check_generic_filesystem: filesystem on /dev/vdb is inconsistent (see /results/results-dioread_nolock/generic/091.full)
Ran: generic/075 generic/091
Failures: generic/091
Failed 1 of 2 tests
END TEST: Ext4 4k block w/dioread_nolock Sun Apr 13 21:17:50 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Inode 801 has out of order extents
	(invalid logical block 9, physical block 1022972, len 2)
Clear? yes

Inode 801 has out of order extents
	(invalid logical block 18, physical block 1023063, len 1)
Clear? yes

Inode 801 has out of order extents
	(invalid logical block 16, physical block 1022970, len 2)
Clear? yes

Inode 801 has out of order extents
	(invalid logical block 20, physical block 1023056, len 7)
Clear? yes

Inode 801 has out of order extents
	(invalid logical block 19, physical block 1024820, len 2)
Clear? yes

Inode 801, i_blocks is 256, should be 136.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(1019465--1019470) -(1022972--1022973) -1023063 -(1024820--1024821) -(1024836--1024839)
Fix? yes

Free blocks count wrong for group #31 (22489, counted=22504).
Fix? yes

Free blocks count wrong (719201, counted=719216).
Fix? yes


/dev/vdb: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdb: 27437/327680 files (8.1% non-contiguous), 591504/1310720 blocks
BEGIN TEST: Ext4 4k block w/data=journal Sun Apr 13 21:18:03 UTC 2014
Device: /dev/vdb
mk2fs options: -q
mount options: -o block_validity,data=journal
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/vdc /vdc

[ 1488.281589] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
_check_generic_filesystem: filesystem on /dev/vdb is inconsistent (see /results/results-data_journal/check.full)
Passed all 0 tests
END TEST: Ext4 4k block w/data=journal Sun Apr 13 21:18:21 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Inode 801, i_blocks is 136, should be 144.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(1019465--1019470) -(1022970--1022971) -(1023056--1023062) +(1024836--1024839)
Fix? yes

Free blocks count wrong for group #31 (22504, counted=22503).
Fix? yes

Free blocks count wrong (719216, counted=719215).
Fix? yes


/dev/vdb: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdb: 27437/327680 files (8.1% non-contiguous), 591505/1310720 blocks
BEGIN TEST: Ext4 4k block w/bigalloc Sun Apr 13 21:18:38 UTC 2014
Device: /dev/vde
mk2fs options: -q -O bigalloc
mount options: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q -O bigalloc /dev/vdf
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdf /vdf

generic/075		[21:18:42] [21:18:44] [failed, exit status 1] - output mismatch (see /results/results-bigalloc/generic/075.out.bad)
    --- tests/generic/075.out	2014-04-12 23:20:55.000000000 +0000
    +++ /results/results-bigalloc/generic/075.out.bad	2014-04-13 21:18:44.126223139 +0000
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/075.out /results/results-bigalloc/generic/075.out.bad'  to see the entire diff)
generic/091		[21:18:44][ 1526.350948] EXT4-fs error (device vde): ext4_mb_free_metadata:4563: group 1, block 524432:Block already on to-be-freed list
[ 1526.358204] JBD2: Spotted dirty metadata buffer (dev = vde, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
 [21:18:45] [failed, exit status 1] - output mismatch (see /results/results-bigalloc/generic/091.out.bad)
    --- tests/generic/091.out	2014-04-12 23:20:55.000000000 +0000
    +++ /results/results-bigalloc/generic/091.out.bad	2014-04-13 21:18:45.116223190 +0000
    @@ -1,7 +1,158 @@
     QA output created by 091
     fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    ...
    (Run 'diff -u tests/generic/091.out /results/results-bigalloc/generic/091.out.bad'  to see the entire diff)
_check_generic_filesystem: filesystem on /dev/vde is inconsistent (see /results/results-bigalloc/generic/091.full)
Ran: generic/075 generic/091
Failures: generic/075 generic/091
Failed 2 of 2 tests
END TEST: Ext4 4k block w/bigalloc Sun Apr 13 21:18:45 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_blocks is 640, should be 4096.  Fix? yes


Running additional passes to resolve blocks claimed by more than one inode...
Pass 1B: Rescanning for multiply-claimed blocks
Multiply-claimed block(s) in inode 12: 524842 524840 524841 524848 524849 524850 524851 524852 524853 524854 524855 524857 524858 524859 524860 524861 524862 524863 525136 525137 525138 525139 525140 525141 525142 525143 525144 525145 525146 525137 525138 525139 525140 525141 525137 525138 525139 525140 525172 525173 525174 525175 525176 525177 525178 525179 525180 525181 525182 525183 525184 525185 525190 525191 525192
Pass 1C: Scanning directories for inodes with multiply-claimed blocks
Pass 1D: Reconciling multiply-claimed blocks
(There are 1 inodes containing multiply-claimed blocks.)

File /junk (inode #12, mod time Sun Apr 13 21:18:45 2014) 
  has 5 multiply-claimed block(s), shared with 0 file(s):
Clone multiply-claimed blocks? yes

clone_file_block: internal error: can't find dup_blk for 524848

clone_file_block: internal error: can't find dup_blk for 524849

clone_file_block: internal error: can't find dup_blk for 524850

clone_file_block: internal error: can't find dup_blk for 524851

clone_file_block: internal error: can't find dup_blk for 524852

clone_file_block: internal error: can't find dup_blk for 524853

clone_file_block: internal error: can't find dup_blk for 524854

clone_file_block: internal error: can't find dup_blk for 524855

clone_file_block: internal error: can't find dup_blk for 524857

clone_file_block: internal error: can't find dup_blk for 524858

clone_file_block: internal error: can't find dup_blk for 524859

clone_file_block: internal error: can't find dup_blk for 524860

clone_file_block: internal error: can't find dup_blk for 524861

clone_file_block: internal error: can't find dup_blk for 524862

clone_file_block: internal error: can't find dup_blk for 524863

clone_file_block: internal error: can't find dup_blk for 525184

clone_file_block: internal error: can't find dup_blk for 525185

clone_file_block: internal error: can't find dup_blk for 525190

clone_file_block: internal error: can't find dup_blk for 525191

clone_file_block: internal error: can't find dup_blk for 525192

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (31477, counted=31474).
Fix? yes

Free blocks count wrong for group #1 (32752, counted=32751).
Fix? yes

Free blocks count wrong (5188880, counted=5188816).
Fix? yes


/dev/vde: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vde: 15/327680 files (6.7% non-contiguous), 54064/5242880 blocks
BEGIN TEST: Ext4 1k block w/bigalloc Sun Apr 13 21:18:46 UTC 2014
Device: /dev/vdd
mk2fs options: -q -b 1024 -O bigalloc
mount options: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-08699-gc282c15
MKFS_OPTIONS  -- -q -b 1024 -O bigalloc /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

generic/075		[21:18:48][ 1533.195953] EXT4-fs error (device vdd): ext4_mb_free_metadata:4563: group 1, block 131376:Block already on to-be-freed list
[ 1533.210657] JBD2: Spotted dirty metadata buffer (dev = vdd, blocknr = 1). There's a risk of filesystem corruption in case of system crash.
 [21:18:53] [failed, exit status 1] - output mismatch (see /results/results-bigalloc_1k/generic/075.out.bad)
    --- tests/generic/075.out	2014-04-12 23:20:55.000000000 +0000
    +++ /results/results-bigalloc_1k/generic/075.out.bad	2014-04-13 21:18:53.882889857 +0000
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/075.out /results/results-bigalloc_1k/generic/075.out.bad'  to see the entire diff)
_check_generic_filesystem: filesystem on /dev/vdd is inconsistent (see /results/results-bigalloc_1k/generic/075.full)
Ran: generic/075
Failures: generic/075
Failed 1 of 1 tests
END TEST: Ext4 1k block w/bigalloc Sun Apr 13 21:18:54 UTC 2014
e2fsck 1.42.9 (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #1 (8176, counted=8175).
Fix? yes

Free blocks count wrong (5125872, counted=5125856).
Fix? yes


/dev/vdd: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdd: 12/327680 files (0.0% non-contiguous), 117024/5242880 blocks
[....] startpar: service(s) returned failure: rc.local ...[?25l[?1c7[1G[[31mFAIL[39;49m8[?25h[?0c [31mfailed![39;49m

Last login: Sun Apr 13 21:18:54 UTC 2014 on ttyS3
Linux candygram 3.14.0-08699-gc282c15 #1801 SMP Sun Apr 13 16:46:52 EDT 2014 i686

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
root@candygram:~# QEMU: Terminated
