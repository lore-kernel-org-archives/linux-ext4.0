From: Andreas Dilger <adilger@clusterfs.com>
Subject: group descriptor contents and LAZY_BG
Date: Sat, 24 Mar 2007 15:40:57 -0600
Message-ID: <20070324214056.GL5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@linsyssoft.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54474 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXCXVk7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2007 17:40:59 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,
the LAZY_BG feature was originally written to test large filesystems and
avoid the need to format (or even allocate, if sparse) large parts of the
inode table and bitmaps.  To make the feature COMPAT the bg_free_blocks_count
and bg_free_inodes_count are initialized to zero, and the kernel will skip
these groups entirely without checking the bitmap.

For the GDT_CSUM feature, we are using the LAZY_BG feature to not initialize
the bitmaps and inode table.  However, setting the bg_free_*_count to zero
is troublesome because it means we always need to check the GDT_CSUM feature
flag to know whether a group actually has free blocks/inodes, and e2fsck
is also getting confused about the number of free blocks/inodes in the groups
and filesystem (we have to have a double accounting for "real" free blocks
and "uninitialized" free blocks.

What do you think for the GDT_CSUM feature that we initialize the group
descriptors as if the group had actually been formatted?  I think our
use of the LAZY_BG feature is actually misguided - while they share some
components (e.g. UNINIT flags, mke2fs code, some e2fsck code), since the
GDT_CSUM feature is RO_COMPAT there isn't much reason to even enable
LAZY_BG at format time...

We have to replace all uses of bg_free_*_count with the below macros:

+/* Macro-instructions used to calculate Free inodes and blocks count. */
+#define EXT3_BG_INODES_FREE(sb,gr,gdp) ((EXT3_HAS_RO_COMPAT_FEATURE(sb,       \
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&  \
+					  (gdp)->bg_flags & 		       \
+				          cpu_to_le16(EXT3_BG_INODE_UNINIT)) ? \
+				       EXT3_INODES_PER_GROUP(sb) :	       \
+				       le16_to_cpu((gdp)->bg_itable_unused) +  \
+				       le16_to_cpu((gdp)->bg_free_inodes_count))
+#define EXT3_BG_BLOCKS_FREE(sb,gr,gdp) ((EXT3_HAS_RO_COMPAT_FEATURE(sb,       \
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&  \
+					  (gdp)->bg_flags & 		       \
+				          cpu_to_le16(EXT3_BG_BLOCK_UNINIT)) ? \
+				       ext3_free_blocks_after_init(sb,gr,gdp) :\
+				       le16_to_cpu((gdp)->bg_free_blocks_count))

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
