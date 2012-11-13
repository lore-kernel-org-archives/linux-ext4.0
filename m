From: "George Spelvin" <linux@horizon.com>
Subject: Re: e2fsck: eh_magic = 0000 != f30a
Date: 13 Nov 2012 11:42:30 -0500
Message-ID: <20121113164230.26152.qmail@science.horizon.com>
References: <50A264F2.2020001@redhat.com>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:31024 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780Ab2KMQmb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 11:42:31 -0500
In-Reply-To: <50A264F2.2020001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Just for posterity, can you say what parameters you used on mkfs,
> as well as include the "dumpe2fs -h" output for the filesystem so we can
> see features, geometry, etc?  Then it can probably be reproduced
> and analyzed.

Ah, good idea, sorry.

The command was
mke2fs -E stride=32,stripe-width=352,resize=17179869184 -i 1048576 -L data -t ext4 -O metadata_csum,resize_inode,64bit,^huge_file -v /dev/md1

dumpe2fs 1.43-WIP (22-Sep-2012)
Filesystem volume name:   data
Last mounted on:          /data
Filesystem UUID:          c99d1f6f-b973-4378-a391-8e10f15fd24a
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              7630464
Block count:              1953383296
Reserved block count:     97669164
Free blocks:              227072527
Free inodes:              5618110
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         128
Inode blocks per group:   8
RAID stride:              32
RAID stripe width:        352
Flex block group size:    16
Filesystem created:       Sun Nov 11 17:08:46 2012
Last mount time:          Tue Nov 13 08:02:29 2012
Last write time:          Tue Nov 13 08:02:29 2012
Mount count:              2
Maximum mount count:      -1
Last checked:             Tue Nov 13 06:43:04 2012
Check interval:           0 (<none>)
Lifetime writes:          6628 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      305f1eba-74eb-438f-9acf-f41597f73f54
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x8881f484
Journal features:         journal_incompat_revoke journal_64bit
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00005238
Journal start:            0

