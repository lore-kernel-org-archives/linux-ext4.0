From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: 7 Oct 2012 21:05:07 -0400
Message-ID: <20121008010507.28502.qmail@science.horizon.com>
References: <20121007225403.GA468@thunk.org>
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:22253 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752970Ab2JHBFI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Oct 2012 21:05:08 -0400
In-Reply-To: <20121007225403.GA468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> If you can replicate this, could you try applying the following patch
> to e2fsck, and install it and then capture the output from e2fsck when
> it repairs the file system?

Well, as I mentioned, the superblock of the currently running root
filesystem has a bad checksum right now, so if you don't mind me NOT
repairing the FS, it's particularly easy.  (What's why I included a
hex-dump of the superblock earlier.)

Let me try fsck -n on the running file system...

# ./e2fsck -n /dev/md2
e2fsck 1.43-WIP (22-Sep-2012)
Warning!  /dev/md2 is mounted.
Filesystem volume name:   root
Last mounted on:          /
Filesystem UUID:          a61d8e82-4c81-4f84-9011-cf248d295eeb
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex
_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              4398512
Block count:              87431728
Reserved block count:     4371586
Free blocks:              69542952
Free inodes:              3780346
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1003
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         1648
Inode blocks per group:   103
Flex block group size:    16
Filesystem created:       Mon May 28 04:14:42 2012
Last mount time:          Sun Oct  7 04:10:48 2012
Last write time:          Sun Oct  7 04:10:48 2012
Mount count:              2
Maximum mount count:      -1
Last checked:             Sun Oct  7 03:15:54 2012
Check interval:           0 (<none>)
Lifetime writes:          147 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       3376801
Default directory hash:   half_md4
Directory Hash Seed:      dc2dbaa1-7ada-4a32-96a5-dbe8c42859c2
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x6411a138
Expected checksum was 242b557a
ext2fs_open2: Superblock checksum does not match superblock
/tmp/e2fsck: Superblock invalid, trying backup blocks...
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
Clear journal? no

root was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inodes that were part of a corrupted orphan linked list found.  Fix? no

Inode 2214932 was part of the orphaned inode list.  IGNORED.
Deleted inode 2640258 has zero dtime.  Fix? no

Inode 3376801 was part of the orphaned inode list.  IGNORED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(5799936--5800165) -8017765 -8017789 -8027658 -8027660 -8958208 -(19016096--19016124) -38855165 -38873550 -52463109 -(58774956--58774992) -67160656 -67160667 -67160687 -67160703 -67160718 -67160729 -67160905 -69785176
Fix? no
[etc.]

Would hard-crashing the machine and running e2fsck on a static file systtem tell you more?

> There is a chance we could get screwed by a race in no journal mode
> where two processes modify superblock at the same time, but we don't
> actually modify the superblock that much.  The primary case where the
> superblock gets modified while the file system is mounted is when we
> add and remove inods from the orphan list, and that is serialized by a
> mutex.  The other times when we modify the superblock is when we add a
> feature in a few rare cases (the large file feature, or the xattr
> compat feature, etc.) and of course during an online resizing.  But
> that's not likely to be happening in your case.  So I really don't
> understand what might be happening on your system, which is why this
> patch will hopefully shed some light as to what is going on.

Thinking about it, it *is* confusing.

Although with help from your clue about the orphan inode list, I just
managed the following.  It appears to be repeatable.  Is this of any help?

# mount /boot
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
Journal sequence:         0x0000f78c
Journal start:            0

# sleep 5 > /boot/foo & rm /boot/foo
[2] 6554
# dumpe2fs -h /dev/md0
dumpe2fs 1.43-WIP (22-Sep-2012)
dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/md0
Couldn't find valid filesystem superblock.
# /tmp/e2fsck -n /dev/md0
e2fsck 1.43-WIP (22-Sep-2012)
Warning!  /dev/md0 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
boot: clean, 22175/49152 files, 173371/245600 blocks
[2]-  Done                    sleep 5 > /boot/foo
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
# sleep 5 > /boot/foo & rm /boot/foo ; dumpe2fs -h /dev/md0 ; dd if=/dev/md0 of=/tmp/md0 count=8 
[2] 6137
dumpe2fs 1.43-WIP (22-Sep-2012)
dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/md0
Couldn't find valid filesystem superblock.
8+0 records in
8+0 records out
4096 bytes (4.1 kB) copied, 3.8679e-05 s, 106 MB/s
[666]# dumpe2fs -h /dev/md0
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

[2]-  Done                    sleep 5 > /boot/foo
# xxd -g4 -a /tmp/md0
0000000: faeb2101 b4014c49 4c4f1702 87f77050  ..!...LILO....pP
0000010: 00000000 02fcc24f 00000000 c2008070  .......O.......p
0000020: e6517a2e b8c0078e d0bc0008 fb525306  .Qz..........RS.
0000030: 56fc8ed8 31ed60b8 0012b336 cd1061b0  V...1.`....6..a.
0000040: 0de86601 b00ae861 01b04ce8 5c01601e  ..f....a..L.\.`.
0000050: 0780fafe 750288f2 bb00028a 761e89d0  ....u.......v...
0000060: 80e48030 e0780a3c 107306f6 461c4075  ...0.x.<.s..F.@u
0000070: 2e88f266 8b761866 09f67423 52b408b2  ...f.v.f..t#R...
0000080: 8053cd13 5b72570f b6caba7f 00426631  .S..[rW......Bf1
0000090: c040e860 00663bb7 b8017403 e2ef5a53  .@.`.f;...t...ZS
00000a0: 8a761fbe 2000e8df 00b49966 817ffc4c  .v.. ......f...L
00000b0: 494c4f75 295e6880 080731db e8c90075  ILOu)^h...1....u
00000c0: fbbe0600 89f7b90a 00b49af3 a6750fb0  .............u..
00000d0: 02ae750a 0655b049 e8cf00cb b440b020  ..u..U.I.....@. 
00000e0: e8c700e8 b400fe4e 007407bc e80761e9  .......N.t....a.
00000f0: 5cfff4eb fd605555 66500653 6a016a10  \....`UUfP.Sj.j.
0000100: 89e653f6 c6607470 f6c62074 14bbaa55  ..S..`tp.. t...U
0000110: b441cd13 720b81fb 55aa7505 f6c10175  .A..r...U.u....u
0000120: 415206b4 08cd1307 72b451c0 e90686e9  AR......r.Q.....
0000130: 89cf59c1 ea089240 4983e13f 41f7e193  ..Y....@I..?A...
0000140: 8b44088b 540a39da 7392f7f3 39f8778c  .D..T.9.s...9.w.
0000150: c0e40686 e092f6f1 08e289d1 415a88c6  ............AZ..
0000160: eb1cb442 5bbd0500 60cd1373 164d74b8  ...B[...`..s.Mt.
0000170: 31c0cd13 614debf0 66505958 88e6b801  1...aM..fPYX....
0000180: 02ebe18d 641061c3 66ad6609 c0740a66  ....d.a.f.f..t.f
0000190: 034610e8 5fff80c7 02c3c1c0 04e80300  .F.._...........
00001a0: c1c00424 0f2704f0 144060bb 0700b40e  ...$.'...@`.....
00001b0: cd1061c3 00000000 00000000 00000000  ..a.............
00001c0: 00000000 00000000 00000000 00000000  ................
*
00001f0: 00000000 00000000 00000000 000055aa  ..............U.
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
0000800: 00000000 00000000 00000000 00000000  ................
*
0000ff0: 00000000 00000000 00000000 00000000  ................
