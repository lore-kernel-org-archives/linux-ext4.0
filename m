From: Adam Huffman <adam.huffman@gmail.com>
Subject: Filesystem corruption on Fedora 17
Date: Tue, 27 Nov 2012 13:31:18 +0000
Message-ID: <CAP5prOgjNXnvXr1HELuez7+Be+TW4N8t9P_AeQw8pBVYDnFHTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60712 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2K0NbU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2012 08:31:20 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so5100633eek.19
        for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2012 05:31:19 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello

On two machines now I've had severe filesystem corruption.  They are
both Fedora 17 machines, and they both have, at some point, run the
kernels that have been mentioned recently as possibly suffering from
ext4 corruption problems.

In the worst case, fsck is unable to fix the problems:

fsck from util-linux 2.20.1
e2fsck 1.42.4 (12-June-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
fsck.ext4: Group descriptors look bad... trying backup blocks...
/dev/mapper/heppc128-lv_home: recovering journal
fsck.ext4: unable to set superblock flags on /dev/mapper/heppc128-lv_home


/dev/mapper/heppc128-lv_home: ***** FILE SYSTEM WAS MODIFIED *****

/dev/mapper/heppc128-lv_home: ********** WARNING: Filesystem still has
errors **********

Here's the output of dumpe2fs:

dumpe2fs 1.42.4 (12-June-2012)
Filesystem volume name:   <none>
Last mounted on:          /home
Filesystem UUID:          b0b53537-bcc0-4006-bc32-5b55e13a4b94
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              3670016
Block count:              14680064
Reserved block count:     670950
Free blocks:              2150657
Free inodes:              2544162
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1020
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Apr  2 10:45:35 2012
Last mount time:          Fri May 11 10:05:54 2012
Last write time:          Tue Nov 27 13:18:35 2012
Mount count:              7
Maximum mount count:      35
Last checked:             Mon Apr  2 10:45:35 2012
Check interval:           15552000 (6 months)
Next check after:         Sat Sep 29 10:45:35 2012
Lifetime writes:          56 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       1574824
Default directory hash:   half_md4
Directory Hash Seed:      32f30e91-a55b-4e69-b95e-3bb3f04f34a9
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x003506be
Journal start:            0

During various other repair attempts, I've seen this message:

e2fsck 1.42.4 (12-June-2012)
/dev/mapper/vg0majh-lv_root contains a file system with errors, check forced.
Resize inode not valid.  Recreate? yes

Pass 1: Checking inodes, blocks, and sizes
Inode 4122234 has illegal block(s).  Clear? yes

Illegal block #256918621 (1313286244) in inode 4122234.  CLEARED.
Error storing directory block information (inode=4122234, block=0,
num=78646612): Memory allocation failed

/dev/mapper/vg0majh-lv_root: ***** FILE SYSTEM WAS MODIFIED *****
e2fsck: aborted

/dev/mapper/vg0majh-lv_root: ***** FILE SYSTEM WAS MODIFIED *****

Both machines are running the most recent Fedora kernel, which is 3.6.7-4.

I just tried mounting the /home LV, which seemed to succeed, but any
file accesses didn't work:

[ 1176.385418] EXT4-fs (dm-8): warning: checktime reached, running
e2fsck is recommended
[ 1176.403296] EXT4-fs warning (device dm-8): ext4_orphan_get:1014:
bad orphan inode 1574824!  e2fsck was run?
[ 1176.403299] ext4_test_bit(bit=1959, block=6291472) = 0
[ 1176.403301] inode=          (null)
[ 1176.403304] EXT4-fs (dm-8): recovery complete
[ 1176.403308] EXT4-fs (dm-8): mounted filesystem with ordered data
mode. Opts: (null)
[ 1250.457438] EXT4-fs error (device dm-8): ext4_lookup:1050: inode
#1572865: comm rsync: deleted inode referenced: 2621441
[ 1250.578786] EXT4-fs error (device dm-8): ext4_lookup:1050: inode
#1671420: comm rsync: deleted inode referenced: 2229739
[ 1250.654595] EXT4-fs error (device dm-8): ext4_lookup:1050: inode
#1572894: comm rsync: deleted inode referenced: 2228725
[ 1250.654703] EXT4-fs error (device dm-8): ext4_lookup:1050: inode
#1572894: comm rsync: deleted inode referenced: 2621702
[ 1250.683319] EXT4-fs error (device dm-8): ext4_lookup:1050: inode
#1576085: comm rsync: deleted inode referenced: 2621449
[ 1250.695378] EXT4-fs error (device dm-8): ext4_lookup:1050: inode
#1576085: comm rsync: deleted inode referenced: 2621450


Any help greatly appreciated...

Best Wishes,
Adam
