From: Amir Goldstein <amir73il@gmail.com>
Subject: recovering from backup superblock with uninit_bg
Date: Tue, 14 Jun 2011 11:15:39 +0300
Message-ID: <BANLkTi=Xy0hKvBe2VvO7L6cPvT94A2g+nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37940 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1FNIPk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 04:15:40 -0400
Received: by wwk4 with SMTP id 4so3294994wwk.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jun 2011 01:15:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi guys,

Can you help me figure this one out.

When I run the test:
# mkfs.ext4 /dev/sda5
# fsck.ext4 -nf -b 32768 /dev/sda5

The results are a total chaos.

Apparently, when opening an fs from a backup superblock,
all _UNINIT flags are cleared:


        /*
         * If recovery is from backup superblock, Clear _UNININT flags &
         * reset bg_itable_unused to zero
         */
        if (superblock > 1 && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
                                        EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
                struct ext2_group_desc *gd;
                dgrp_t group;

                for (group = 0; group < fs->group_desc_count; group++) {
                        ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
                        ext2fs_bg_flags_clear(fs, group,
EXT2_BG_EXCLUDE_UNINIT);
                        ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
                        ext2fs_bg_itable_unused_set(fs, group, 0);
                }
                ext2fs_mark_super_dirty(fs);
        }


First fsck rightfully complains that the group desc checksums are wrong.
Then, is complains about many errors in phantom inodes, because the inode
bitmap and tables are treated as initialized, but they aren't (see snip below)

Any idea what was the purpose of clearing the _UNINIT flags?
Or how and if this should be fixed?

Amir.


Snip:
--------

e2fsck 1.41.14 (22-Dec-2010)
One or more block group descriptor checksums are invalid.  Fix? no

Group descriptor 0 checksum is invalid.  IGNORED.
Group descriptor 1 checksum is invalid.  IGNORED.
Group descriptor 2 checksum is invalid.  IGNORED.
Group descriptor 3 checksum is invalid.  IGNORED.
Group descriptor 4 checksum is invalid.  IGNORED.
Group descriptor 5 checksum is invalid.  IGNORED.
Group descriptor 6 checksum is invalid.  IGNORED.
Group descriptor 7 checksum is invalid.  IGNORED.
Group descriptor 8 checksum is invalid.  IGNORED.
Group descriptor 9 checksum is invalid.  IGNORED.

...


Pass 1: Checking inodes, blocks, and sizes
Inode 130819 is in use, but has dtime set.  Fix? no

Inode 130819 has imagic flag set.  Clear? no

Inode 130819 has a extra size (26988) which is invalid
Fix? no

Inode 130819 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 130819 has an invalid root node.
Clear HTree index? no

Inode 130819 should not have EOFBLOCKS_FL set (size
3275369772944026989, lblk -1)
Clear? no

Inode 130819, i_size is 3275369772944026989, should be 0.  Fix? no

Inode 130819, i_blocks is 115880082960997, should be 0.  Fix? no

Inode 130820 is in use, but has dtime set.  Fix? no

Inode 130820 has imagic flag set.  Clear? no

Inode 130820 has a extra size (31091) which is invalid
Fix? no

Inode 130820 has compression flag set on filesystem without
compression support.  Clear? no

Inode 130820 should not have EOFBLOCKS_FL set (size
7813034463503974420, lblk -1)
Clear? no
...
