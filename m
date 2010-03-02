From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 11/28] ext4: correctly calculate number of blocks for fiemap
Date: Tue,  2 Mar 2010 13:18:28 -0500
Message-ID: <1267553925-6308-12-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Leonard Michlmayr <leonard.michlmayr@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43086 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab0CBSS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:58 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Leonard Michlmayr <leonard.michlmayr@gmail.com>

ext4_fiemap() rounds the length of the requested range down to
blocksize, which is is not the true number of blocks that cover the
requested region.  This problem is especially impressive if the user
requests only the first byte of a file: not a single extent will be
reported.

We fix this by calculating the last block of the region and then
subtract to find the number of blocks in the extents.

Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bd80891..bc9860f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3768,7 +3768,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
 	ext4_lblk_t start_blk;
-	ext4_lblk_t len_blks;
 	int error = 0;
 
 	/* fallback to generic here if not in extents fmt */
@@ -3782,8 +3781,11 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		error = ext4_xattr_fiemap(inode, fieinfo);
 	} else {
+		ext4_lblk_t last_blk, len_blks;
+
 		start_blk = start >> inode->i_sb->s_blocksize_bits;
-		len_blks = len >> inode->i_sb->s_blocksize_bits;
+		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
+		len_blks = last_blk - start_blk + 1;
 
 		/*
 		 * Walk the extent tree gathering extent information.
-- 
1.6.6.1.1.g974db.dirty

