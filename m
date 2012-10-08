From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: 7 Oct 2012 21:25:34 -0400
Message-ID: <20121008012534.31073.qmail@science.horizon.com>
References: <20121007225403.GA468@thunk.org>
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:22303 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750745Ab2JHBZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Oct 2012 21:25:36 -0400
In-Reply-To: <20121007225403.GA468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

More reproduction (and hopefully useful ideas at the end)

# sleep 10 > /boot/foo & rm /boot/foo ; dumpe2fs -h /dev/md0 ; dd if=/dev/md0 of=/tmp/md0a count=4 ; /tmp/e2fsck -n /dev/md0
[2] 21690
dumpe2fs 1.43-WIP (22-Sep-2012)
dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/md0
Couldn't find valid filesystem superblock.
4+0 records in
4+0 records out
2048 bytes (2.0 kB) copied, 3.0265e-05 s, 67.7 MB/s
e2fsck 1.43-WIP (22-Sep-2012)
Warning!  /dev/md0 is mounted.
Filesystem volume name:   boot
Last mounted on:          /boot
Filesystem UUID:          72aa9b1c-4180-444a-8e15-836ddad4f235
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              49152
Block count:              245600
Reserved block count:     12280
Free blocks:              72229
Free inodes:              26977
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      59
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         6144
Inode blocks per group:   384
Flex block group size:    16
Filesystem created:       Mon May 28 04:06:58 2012
Last mount time:          Mon Oct  8 00:57:42 2012
Last write time:          Mon Oct  8 00:57:42 2012
Mount count:              13
Maximum mount count:      -1
Last checked:             Tue Oct  2 22:53:14 2012
Check interval:           0 (<none>)
Lifetime writes:          34 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       173
Default directory hash:   half_md4
Directory Hash Seed:      f5fe1926-d2da-4864-b41f-a93276ae313f
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0xec7bcce8
Expected checksum was dfd1473e
ext2fs_open2: Superblock checksum does not match superblock
/tmp/e2fsck: Superblock invalid, trying backup blocks...
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
Clear journal? no

boot was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 173 has zero dtime.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (16896, counted=5353).
Fix? no

Free blocks count wrong for group #1 (7259, counted=2217).
Fix? no

Free blocks count wrong for group #2 (12585, counted=3984).
Fix? no

Free blocks count wrong for group #3 (19829, counted=17775).
Fix? no

Free blocks count wrong for group #4 (17162, counted=15224).
Fix? no

Free blocks count wrong for group #5 (18729, counted=10523).
Fix? no

Free blocks count wrong for group #6 (13443, counted=11644).
Fix? no

Free blocks count wrong for group #7 (8424, counted=5509).
Fix? no

Free blocks count wrong (114415, counted=72229).
Fix? no

Inode bitmap differences:  -173
Fix? no

Free inodes count wrong for group #0 (651, counted=439).
Fix? no

Free inodes count wrong for group #1 (128, counted=286).
Fix? no

Free inodes count wrong for group #2 (1137, counted=1158).
Fix? no

Free inodes count wrong for group #3 (792, counted=823).
Fix? no

Free inodes count wrong (26978, counted=26976).
Fix? no

Inode bitmap differences: Group 0 inode bitmap does not match checksum
IGNORED.
Group 1 inode bitmap does not match checksum
IGNORED.
Group 2 inode bitmap does not match checksum
IGNORED.
Group 3 inode bitmap does not match checksum
IGNORED.
Group 5 inode bitmap does not match checksum
IGNORED.
Group 6 inode bitmap does not match checksum
IGNORED.
Group 7 inode bitmap does not match checksum
IGNORED.
Block bitmap differences: Group 0 block bitmap does not match checksum
IGNORED.
Group 1 block bitmap does not match checksum
IGNORED.
Group 2 block bitmap does not match checksum
IGNORED.
Group 3 block bitmap does not match checksum
IGNORED.
Group 4 block bitmap does not match checksum
IGNORED.
Group 5 block bitmap does not match checksum
IGNORED.
Group 6 block bitmap does not match checksum
IGNORED.
Group 7 block bitmap does not match checksum
IGNORED.

boot: ********** WARNING: Filesystem still has errors **********

boot: 22174/49152 files (3.6% non-contiguous), 131185/245600 blocks
# dumpe2fs -h /dev/md0
dumpe2fs 1.43-WIP (22-Sep-2012)
Filesystem volume name:   boot
Last mounted on:          /boot
Filesystem UUID:          72aa9b1c-4180-444a-8e15-836ddad4f235
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              49152
Block count:              245600
Reserved block count:     12280
Free blocks:              72229
Free inodes:              26977
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      59
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         6144
Inode blocks per group:   384
Flex block group size:    16
Filesystem created:       Mon May 28 04:06:58 2012
Last mount time:          Mon Oct  8 00:57:42 2012
Last write time:          Mon Oct  8 00:57:42 2012
Mount count:              13
Maximum mount count:      -1
Last checked:             Tue Oct  2 22:53:14 2012
Check interval:           0 (<none>)
Lifetime writes:          34 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      f5fe1926-d2da-4864-b41f-a93276ae313f
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0xec7bcce8
Journal features:         journal_incompat_revoke
Journal size:             16M
Journal length:           4096
Journal sequence:         0x0000f78d
Journal start:            1

[2]-  Done                    sleep 10 > /boot/foo
# xxd -g4 -a /dev/md0a
[... first 512b snipped ...]
0000200: 00000000 00000000 00000000 00000000  ................
*
00003f0: 00000000 00000000 00000000 03b7302c  ..............0,
0000400: 00c00000 60bf0300 f82f0000 251a0100  ....`..../..%...
0000410: 61690000 00000000 02000000 02000000  ai..............
0000420: 00800000 00800000 00180000 06257250  .............%rP
0000430: 06257250 0d00ffff 53ef0100 01000000  .%rP....S.......
0000440: 5a706b50 00000000 00000000 01000000  ZpkP............
0000450: 00000000 0b000000 00010000 3c000000  ............<...
0000460: 46020000 6b040000 72aa9b1c 4180444a  F...k...r...A.DJ
0000470: 8e15836d dad4f235 626f6f74 00000000  ...m...5boot....
0000480: 00000000 00000000 2f626f6f 74000000  ......../boot...
0000490: 00000000 00000000 00000000 00000000  ................
*
00004c0: 00000000 00000000 00000000 00003b00  ..............;.
00004d0: 00000000 00000000 00000000 00000000  ................
00004e0: 08000000 00000000 ad000000 f5fe1926  ...............&
00004f0: d2da4864 b41fa932 76ae313f 01010000  ..Hd...2v.1?....
0000500: 0c000000 00000000 e2f9c24f 0af30100  ...........O....
0000510: 04000000 00000000 00000000 00100000  ................
0000520: 00000100 00000000 00000000 00000000  ................
0000530: 00000000 00000000 00000000 00000000  ................
0000540: 00000000 00000000 00000000 00000001  ................
0000550: 00000000 00000000 00000000 1c001c00  ................
0000560: 01000000 00000000 00000000 00000000  ................
0000570: 00000000 04010000 bd501802 00000000  .........P......
0000580: 00000000 00000000 00000000 00000000  ................
*
00007f0: 00000000 00000000 00000000 e8cc7bec  ..............{.
#


That's a dumpe2fs, a dumpe2fs, and a (patched) e2fsck on the corruption.
For reference, here's the superblock after the sleep expired (and
dumpe2fs stopped complaining)
# xxd -g4 -a -l2048 /dev/md0
0000200: 00000000 00000000 00000000 00000000  ................
*
00003f0: 00000000 00000000 00000000 03b7302c  ..............0,
0000400: 00c00000 60bf0300 f82f0000 251a0100  ....`..../..%...
0000410: 61690000 00000000 02000000 02000000  ai..............
0000420: 00800000 00800000 00180000 06257250  .............%rP
0000430: 06257250 0d00ffff 53ef0100 01000000  .%rP....S.......
0000440: 5a706b50 00000000 00000000 01000000  ZpkP............
0000450: 00000000 0b000000 00010000 3c000000  ............<...
0000460: 46020000 6b040000 72aa9b1c 4180444a  F...k...r...A.DJ
0000470: 8e15836d dad4f235 626f6f74 00000000  ...m...5boot....
0000480: 00000000 00000000 2f626f6f 74000000  ......../boot...
0000490: 00000000 00000000 00000000 00000000  ................
*
00004c0: 00000000 00000000 00000000 00003b00  ..............;.
00004d0: 00000000 00000000 00000000 00000000  ................
00004e0: 08000000 00000000 00000000 f5fe1926  ...............&
00004f0: d2da4864 b41fa932 76ae313f 01010000  ..Hd...2v.1?....
0000500: 0c000000 00000000 e2f9c24f 0af30100  ...........O....
0000510: 04000000 00000000 00000000 00100000  ................
0000520: 00000100 00000000 00000000 00000000  ................
0000530: 00000000 00000000 00000000 00000000  ................
0000540: 00000000 00000000 00000000 00000001  ................
0000550: 00000000 00000000 00000000 1c001c00  ................
0000560: 01000000 00000000 00000000 00000000  ................
0000570: 00000000 04010000 bd501802 00000000  .........P......
0000580: 00000000 00000000 00000000 00000000  ................
*
00007f0: 00000000 00000000 00000000 e8cc7bec  ..............{.

Notice that the only difference is that the byte at 0x04e8 (offset 0xe8
in the superblock) is cleared, and the checksum is NOT changed, in the
"working" superblock.  Perhaps you're looking for the bug backward:
the checksum *is* getting upated, but the data checksummed is *not*,
leading to the mismatch.

They're also in different halves, so perhaps not writing out
both sectors?
