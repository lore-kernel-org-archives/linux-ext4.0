From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: 7 Oct 2012 11:09:19 -0400
Message-ID: <20121007150919.17299.qmail@science.horizon.com>
References: <507185F8.3040700@tao.ma>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tm@tao.ma
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:20871 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751225Ab2JGPJU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Oct 2012 11:09:20 -0400
In-Reply-To: <507185F8.3040700@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Interesting. In general, metadata checksum should be updated with the
> same content it checksums. So could you please answer my questions first?

Good point; it *is* only a single (512 byte) sector.  And it's a
512-byte sector drive (pair of drives in RAID-1, actually).

However, it appears that while the FS is mounted, an invalid checksum
*is* written.  That's the bug:

# dumpe2fs /dev/md2                     
dumpe2fs 1.43-WIP (22-Sep-2012)
dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/md2
Couldn't find valid filesystem superblock.
# /tmp/old/sbin/dumpe2fs -f -h /dev/md2
dumpe2fs 1.42.5 (29-Jul-2012)
./dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/md2
Couldn't find valid filesystem superblock.

(Unfortunately, dumpe2fs doesn't have a -n flag like debugfs.)


Here's the first 2K of the partition (superblock at 1K), in case it helps:
# xxd -g4 -l2048 -a /dev/md2
0000000: 00000000 00000000 00000000 00000000  ................
*
00003f0: 00000000 00000000 00000000 1d32be49  .............2.I
0000400: b01d4300 301a3605 82b44200 28242504  ..C.0.6...B.($%.
0000410: faae3900 00000000 02000000 02000000  ..9.............
0000420: 00800000 00800000 70060000 c8007150  ........p.....qP
0000430: c8007150 0200ffff 53ef0100 01000000  ..qP....S.......
0000440: eaf37050 00000000 00000000 01000000  ..pP............
0000450: 00000000 0b000000 00010000 3c000000  ............<...
0000460: 46020000 6b040000 a61d8e82 4c814f84  F...k.......L.O.
0000470: 9011cf24 8d295eeb 726f6f74 00000000  ...$.)^.root....
0000480: 00000000 00000000 2f006e74 00000000  ......../.nt....
0000490: 00000000 00000000 00000000 00000000  ................
*
00004c0: 00000000 00000000 00000000 0000eb03  ................
00004d0: 00000000 00000000 00000000 00000000  ................
00004e0: 08000000 00000000 a1863300 dc2dbaa1  ..........3..-..
00004f0: 7ada4a32 96a5dbe8 c42859c2 01010000  z.J2.....(Y.....
0000500: 0c000000 00000000 b2fbc24f 0af30200  ...........O....
0000510: 04000000 00000000 00000000 ff7f0000  ................
0000520: 00809802 ff7f0000 01000000 ffff9802  ................
0000530: 00000000 00000000 00000000 00000000  ................
0000540: 00000000 00000000 00000000 00000008  ................
0000550: 00000000 00000000 00000000 1c001c00  ................
0000560: 01000000 00000000 00000000 00000000  ................
0000570: 00000000 04010000 e4142809 00000000  ..........(.....
0000580: 00000000 00000000 00000000 00000000  ................
*
00007f0: 00000000 00000000 00000000 38a11164  ............8..d


> 1. your kernel version please?

3.6.0.

> 2. what do you mean a *unclean* shutdown?

AC power failure.  This is actually the second time I've seen the problem,
althought the first was pilot error while trying to rearrange fan power
cables with the power on.

> 3. what do you find in your /var/log/messages except the bad superblock
> checksum error?

I don't understand the question.  There's nothing there *including* no
bad superblock checksum error!

The kernel panicked with "unable to mount root file system", so it
didn't even load init, much less get /var/log writeable or start a
syslog process.

I didn't transcribe the on-screen messages because I assumed the code was
working "as expected" on reboot: it only checks the primary superblock,
and if there's an error there, it bails.

On reboot, there's nothing interesting, since by the time we got there,
e2fsck had run and cleaned up the file system.  It just says

Oct  7 00:11:05 $HOST kernel: EXT4-fs (md2): mounted filesystem with ordered data mode. Opts: (null)
Oct  7 00:11:05 $HOST kernel: VFS: Mounted root (ext4 filesystem) readonly on device 9:2.
... followed by module loaading.


The code causing the mount failure on boot is easy to find.  fs/ext4/super.c line 3311:

        /* Check superblock checksum */
        if (!ext4_superblock_csum_verify(sb, es)) {
                ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
                         "invalid superblock checksum.  Run e2fsck?");
                silent = 1;
                goto cantfind_ext4;
        }
[...]
cantfind_ext4:
        if (!silent)
                ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
        goto failed_mount;


The challenge is to find what's writing the bad superblock checksum.


Here's one clue (/boot also has metadata_csum enabled)

# dumpe2fs -h /dev/md0 | tee /tmp/1
dumpe2fs 1.43-WIP (22-Sep-2012)
Filesystem volume name:   boot
Last mounted on:          /boot
Filesystem UUID:          72aa9b1c-4180-444a-8e15-836ddad4f235
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              49152
Block count:              245600
Reserved block count:     12280
Free blocks:              72345
Free inodes:              26976
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
Last mount time:          Sun Oct  7 14:51:04 2012
Last write time:          Sun Oct  7 14:51:33 2012
Mount count:              6
Maximum mount count:      -1
Last checked:             Tue Oct  2 22:53:14 2012
Check interval:           0 (<none>)
Lifetime writes:          33 GB
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
Checksum:                 0x0063be5b
Journal features:         journal_incompat_revoke
Journal size:             16M
Journal length:           4096
Journal sequence:         0x0000f765
Journal start:            0

# mount /boot
# dumpe2fs -h /dev/md0 | diff -u /tmp/1 -
dumpe2fs 1.43-WIP (22-Sep-2012)
--- /tmp/1      2012-10-07 14:51:39.337345910 +0000
+++ -   2012-10-07 14:51:52.454825889 +0000
@@ -3,7 +3,7 @@
 Filesystem UUID:          72aa9b1c-4180-444a-8e15-836ddad4f235
 Filesystem magic number:  0xEF53
 Filesystem revision #:    1 (dynamic)
-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
+Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
 Filesystem flags:         signed_directory_hash 
 Default mount options:    user_xattr acl
 Filesystem state:         clean
@@ -24,9 +24,9 @@
 Inode blocks per group:   384
 Flex block group size:    16
 Filesystem created:       Mon May 28 04:06:58 2012
-Last mount time:          Sun Oct  7 14:51:04 2012
-Last write time:          Sun Oct  7 14:51:33 2012
-Mount count:              6
+Last mount time:          Sun Oct  7 14:51:42 2012
+Last write time:          Sun Oct  7 14:51:42 2012
+Mount count:              7
 Maximum mount count:      -1
 Last checked:             Tue Oct  2 22:53:14 2012
 Check interval:           0 (<none>)
@@ -42,7 +42,7 @@
 Directory Hash Seed:      f5fe1926-d2da-4864-b41f-a93276ae313f
 Journal backup:           inode blocks
 Checksum type:            crc32c
-Checksum:                 0x0063be5b
+Checksum:                 0x90bee798
 Journal features:         journal_incompat_revoke
 Journal size:             16M
 Journal length:           4096
# ln /boot/sid.bmp /boot/foo  
# dumpe2fs -h /dev/md0 | diff -u /tmp/1 -
dumpe2fs 1.43-WIP (22-Sep-2012)
--- /tmp/1      2012-10-07 14:51:39.337345910 +0000
+++ -   2012-10-07 14:53:43.619910763 +0000
@@ -3,7 +3,7 @@
 Filesystem UUID:          72aa9b1c-4180-444a-8e15-836ddad4f235
 Filesystem magic number:  0xEF53
 Filesystem revision #:    1 (dynamic)
-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
+Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
 Filesystem flags:         signed_directory_hash 
 Default mount options:    user_xattr acl
 Filesystem state:         clean
@@ -24,9 +24,9 @@
 Inode blocks per group:   384
 Flex block group size:    16
 Filesystem created:       Mon May 28 04:06:58 2012
-Last mount time:          Sun Oct  7 14:51:04 2012
-Last write time:          Sun Oct  7 14:51:33 2012
-Mount count:              6
+Last mount time:          Sun Oct  7 14:51:42 2012
+Last write time:          Sun Oct  7 14:51:42 2012
+Mount count:              7
 Maximum mount count:      -1
 Last checked:             Tue Oct  2 22:53:14 2012
 Check interval:           0 (<none>)
@@ -42,10 +42,10 @@
 Directory Hash Seed:      f5fe1926-d2da-4864-b41f-a93276ae313f
 Journal backup:           inode blocks
 Checksum type:            crc32c
-Checksum:                 0x0063be5b
+Checksum:                 0x90bee798
 Journal features:         journal_incompat_revoke
 Journal size:             16M
 Journal length:           4096
-Journal sequence:         0x0000f765
-Journal start:            0
+Journal sequence:         0x0000f766
+Journal start:            1
 
# touch /boot/bar
(Lots more activity, and I can't make the checksum fail.  But...)

# umount /boot
# mount /boot
# touch /boot/baz

Arrgh!  I can't reproduce it!  Earlier, I did "mount /boot", "dumpe2fs -h"
(successfully), "touch /boot/foo", and dumpe2fs died with a checksum error.

So I thought "aha!  Is it the data write or the inode allocation?  I'll
make a hard link to avoid the inode allocation", but it appears it
wasn't (just) either.

But my root file system (/dev/md2) still has a messed up checksum...

# dumpe2fs -h /dev/md2
dumpe2fs 1.43-WIP (22-Sep-2012)
dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/md2
Couldn't find valid filesystem superblock.

