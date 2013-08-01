From: Christian Nilsson <nikize@gmail.com>
Subject: Re: resize2fs ext4 shrink corruption?
Date: Thu, 1 Aug 2013 23:59:26 +0200
Message-ID: <CAHhAHvhvvcgyfXFwUPEwmMtRSrnmbQJk9KQetEgAOEGvweX07w@mail.gmail.com>
References: <CAHhAHvhth46yz==nnZ8WeVgYDPB2gTpmFdV2eAoL5-6xLPOnbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:61641 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3HAV71 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 17:59:27 -0400
Received: by mail-ve0-f179.google.com with SMTP id c13so2976471vea.24
        for <linux-ext4@vger.kernel.org>; Thu, 01 Aug 2013 14:59:26 -0700 (PDT)
In-Reply-To: <CAHhAHvhth46yz==nnZ8WeVgYDPB2gTpmFdV2eAoL5-6xLPOnbw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 1, 2013 at 10:46 PM, Christian Nilsson <nikize@gmail.com> wrote:
> Hi,
> This is half a support request and half a possible issue. - sorry about that.
> Got some fs problems after resize.
> Shrink of ext4 fs from ~6.8TB to ~5.5TB
> now getting fs errors, is this expected or can someone see a reason
> for it going wrong? (anyone seen this before? Could not find similar
> issues reported, except for other features enabled.)
> And are there anything better to do to recover then a fsck?
> Test run of fsck -y is in progress and not yet complete.
>
> Some commands and output below
> (underlaying md3 as of this posting not yet shrunk)
>
> # resize2fs -d 31 -p /dev/md3 5545605120K > md3shrink.log
> (log is 16GB uncompressed bz2 is 1.7G)
> estimated runtime maybe ~24h(?) (i started of by reading source code
> and canceling on block move because of no output or status messages at
> all, and on that not i sugest using xx% compleate instead of those XXX
> if possible since any other output will change the layout of them.)
>
> # dumpe2fs /dev/md3 > md3_dumpe2fs.full
> let me know if any of these log files are of interest. and I will make
> them available.
>
> # dumpe2fs -h /dev/md3
> Filesystem volume name:   data
> Last mounted on:          /data
> Filesystem UUID:          70131c5d-de06-4349-954e-6f0d9ef3538c
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index
> filetype extent sparse_super large_file uninit_bg
> Filesystem flags:         signed_directory_hash
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              346603520
> Block count:              1386401280
> Reserved block count:     69303139
> Free blocks:              31526436
> Free inodes:              346589276
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      693
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> RAID stride:              16
> RAID stripe width:        112
> Filesystem created:       Tue Apr 22 23:51:00 2008
> Last mount time:          Sun Feb  3 15:52:25 2013
> Last write time:          Thu Aug  1 10:21:05 2013
> Mount count:              0
> Maximum mount count:      35
> Last checked:             Tue Jul 30 13:03:01 2013
> Check interval:           15552000 (6 months)
> Next check after:         Sun Jan 26 12:03:01 2014
> Lifetime writes:          1738 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Journal inode:            8
> Default directory hash:   tea
> Directory Hash Seed:      cd66ced7-b600-43c2-82ef-b0971239f822
> Journal backup:           inode blocks
> Journal features:         journal_incompat_revoke
> Journal size:             128M
> Journal length:           32768
> Journal sequence:         0x00dcfa88
> Journal start:            0
>
>
> # fsck.ext4 -C0 -n /dev/md3 > md3fsck_errs.log
> estimated runtime ~5h
> Here is part of the output the "Illegal block number" is not in the
> logfile. (actually from separate run)
> e2fsck 1.42.7 (21-Jan-2013)
> ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
> e2fsck: Group descriptors look bad... trying backup blocks...
> Block bitmap for group 42309 is not in group.  (block 1386413648)
> Relocate? no
>
> Inode bitmap for group 42309 is not in group.  (block 1386413649)
> Relocate? no
>
> data contains a file system with errors, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Illegal block number passed to ext2fs_test_block_bitmap #1386413648
> for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #1386413648
> for in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #1386413649
> for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #1386413649
> for in-use block map
> Interior extent node level 1 of inode 357:
> Logical start 36672 does not match logical start 36863 at next level.  Fix? no
>
> Interior extent node level 1 of inode 357:
> Logical start 46464 does not match logical start 46591 at next level.  Fix? no
>
> Interior extent node level 1 of inode 357:
> Logical start 140096 does not match logical start 140159 at next level.  Fix? no
>
> Interior extent node level 1 of inode 363:
> Logical start 46656 does not match logical start 46783 at next level.  Fix? no
>
> [...snip...]
>
> Interior extent node level 0 of inode 267124739:
> Logical start 38784 does not match logical start 39039 at next level.  Fix? no
>
> Interior extent node level 1 of inode 315826185:
> Logical start 25728 does not match logical start 25855 at next level.  Fix? no
>
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
>
> data: ********** WARNING: Filesystem still has errors **********
>
> data: 14244/346603520 files (31.6% non-contiguous), 1354874844/1386401280 blocks
>
>
> Before i do a fsck on the device, let's see if any of the files are available...
> # mount /dev/md3 /mnt/floppy -r
> mount: wrong fs type ...
>
> Nope, Ok lets create a cow image we can use to test the result of fsck
> # qemu-img create -f qcow2 -o backing_file=/dev/md3 md3.qcow2
> Formatting 'md3.qcow2', fmt=qcow2 size=7571599523840
> backing_file='/dev/md3' encryption=off cluster_size=65536
> # qemu-nbd -c /dev/nbd1 md3.qcow2
>
> # e2fsck -C0 /dev/nbd1
> e2fsck 1.42.7 (21-Jan-2013)
> ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
> e2fsck: Group descriptors look bad... trying backup blocks...
> Block bitmap for group 42309 is not in group.  (block 1386413648)
> Relocate<y>? yes
> Inode bitmap for group 42309 is not in group.  (block 1386413649)
> Relocate<y>? yes
> One or more block group descriptor checksums are invalid.  Fix<y>? yes
> Group descriptor 42309 checksum is 0x561b, should be 0xf661.  FIXED.
> data contains a file system with errors, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Interior extent node level 1 of inode 357:
> Logical start 36672 does not match logical start 36863 at next level.
> Fix<y>? yes
> Interior extent node level 1 of inode 357:
> Logical start 46464 does not match logical start 46591 at next level.
> Fix<y>? yes
>
> ... and waiting on 33%, qcow image at 5.8MB
And finaly done

Interior extent node level 0 of inode 267124739:
Logical start 38784 does not match logical start 39039 at next level.  Fix? yes

Interior extent node level 1 of inode 315826185:
Logical start 25728 does not match logical start 25855 at next level.  Fix? yes

Error allocating 1 contiguous block(s) in block group 42309 for block
bitmap: Could not allocate block in ext2 filesystem
Error allocating 1 contiguous block(s) in block group 42309 for inode
bitmap: Could not allocate block in ext2 filesystem
e2fsck: aborted

data: ***** FILE SYSTEM WAS MODIFIED *****

data: ********** WARNING: Filesystem still has errors **********

# ls -lh md3.qcow2
-rw-r--r-- 1 root root 6.4M Aug  1 23:10 md3.qcow2
# mount /dev/nbd1 /mnt/floppy/ -r
mount: wrong fs type, bad option, bad superblock on /dev/nbd1
# dmesg | tail
[15489853.841518] EXT4-fs (nbd1): ext4_check_descriptors: Block bitmap
for group 42309 not in group (block 0)!
[15489853.841521] EXT4-fs (nbd1): group descriptors corrupted!

Just double checked that mdadm -Z was not used yet, it wasn't but i
did change the size as a test
[15490200.496547] md3: detected capacity change from 7571599523840 to
5678699642880
[15490200.505263]  md3: unknown partition table

And now doing a rerun of fsck -y the start is identical to above.

>
> Any pointers at all would be greatly appreciated.
>
> /Christian
