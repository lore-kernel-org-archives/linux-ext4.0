From: amir73il@users.sourceforge.net
Subject: [PATCH 2/4] ext4: rename ext4_indirect_* funcs to ext4_ind_*
Date: Tue, 21 Jun 2011 12:39:26 +0300
Message-ID: <1308649168-12543-3-git-send-email-amir73il@users.sourceforge.net>
References: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32881 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab1FUJjw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 05:39:52 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2252726wyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 02:39:51 -0700 (PDT)
In-Reply-To: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

We are going to move all ext4_ind_* functions to indirect.c.
Before we do that, let's rename 2 functions called ext4_indirect_*
to ext4_ind_*, to keep to the naming convention.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/inode.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2bb7102..79af0cc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1075,8 +1075,7 @@ qsize_t *ext4_get_reserved_space(struct inode *inode)
  * Calculate the number of metadata blocks need to reserve
  * to allocate a new block at @lblocks for non extent file based file
  */
-static int ext4_indirect_calc_metadata_amount(struct inode *inode,
-					      sector_t lblock)
+static int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	sector_t dind_mask = ~((sector_t)EXT4_ADDR_PER_BLOCK(inode->i_sb) - 1);
@@ -1107,7 +1106,7 @@ static int ext4_calc_metadata_amount(struct inode *inode, ext4_lblk_t lblock)
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return ext4_ext_calc_metadata_amount(inode, lblock);
 
-	return ext4_indirect_calc_metadata_amount(inode, lblock);
+	return ext4_ind_calc_metadata_amount(inode, lblock);
 }
 
 /*
@@ -5456,8 +5455,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
-static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
-				      int chunk)
+static int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	int indirects;
 
@@ -5483,7 +5481,7 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return ext4_indirect_trans_blocks(inode, nrblocks, chunk);
+		return ext4_ind_trans_blocks(inode, nrblocks, chunk);
 	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
 }
 
-- 
1.7.4.1

