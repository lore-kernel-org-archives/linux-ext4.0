From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/25] misc: use the checksum predicate function,
 not raw flag tests
Date: Thu, 17 Oct 2013 21:51:16 -0700
Message-ID: <20131018045116.7339.26187.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3JREvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:51:25 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

metadata_csum implies uninit_bg, and in fact forces the bit off for
rocompat with older implementations.  Therefore, to detect the
presence of checksums, we should use the predicate function to decide
if group descriptor checksums are turned on, not open-coded flag
tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2image.c     |    4 +---
 resize/resize2fs.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)


diff --git a/misc/e2image.c b/misc/e2image.c
index 4a5bb22..a466fe8 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -349,9 +349,7 @@ static void mark_table_blocks(ext2_filsys fs)
 		    ext2fs_inode_table_loc(fs, i)) {
 			unsigned int end = (unsigned) fs->inode_blocks_per_group;
 			/* skip unused blocks */
-			if (!output_is_blk &&
-			    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-						       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			if (!output_is_blk && ext2fs_has_group_desc_csum(fs))
 				end -= (ext2fs_bg_itable_unused(fs, i) /
 					EXT2_INODES_PER_BLOCK(fs->super));
 			for (j = 0, b = ext2fs_inode_table_loc(fs, i);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index b351cc6..440c20e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1012,9 +1012,7 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 	 * supports lazy inode initialization, we can skip
 	 * initializing the inode table.
 	 */
-	if (lazy_itable_init &&
-	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (lazy_itable_init && ext2fs_has_group_desc_csum(fs)) {
 		retval = 0;
 		goto errout;
 	}

