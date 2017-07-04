From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v5 27/28] ext4: xattr inode deduplication
Date: Tue, 4 Jul 2017 14:39:19 -0400
Message-ID: <20170704183919.vpk7xuikjdh6s5gu@thunk.org>
References: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
 <20170620090721.12480-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46988 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752141AbdGDSjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Jul 2017 14:39:22 -0400
Content-Disposition: inline
In-Reply-To: <20170620090721.12480-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm going to fold in the following patch to the xattr inode
deduplicate patch to fix up some corner cases which
__ext4_xattr_set_credits() wasn't quite getting right.

				- Ted

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 4befc7369c0d..435a49811218 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -762,10 +762,11 @@ static void ext4_xattr_inode_free_quota(struct inode *inode, size_t len)
 	dquot_free_inode(inode);
 }
 
-static int __ext4_xattr_set_credits(struct super_block *sb,
+static int __ext4_xattr_set_credits(struct inode *inode,
 				    struct buffer_head *block_bh,
 				    size_t value_len)
 {
+	struct super_block *sb = inode->i_sb;
 	int credits;
 	int blocks;
 
@@ -775,12 +776,25 @@ static int __ext4_xattr_set_credits(struct super_block *sb,
 	 * 3) new xattr block
 	 * 4) block bitmap update for new xattr block
 	 * 5) group descriptor for new xattr block
+	 * 6) block bitmap update for old xattr block
+	 * 7) group descriptor for new old block
+	 *
+	 * 6 & 7 can happen if we have two racing threads T_a and T_b
+	 * which are each trying to set an xattr on inodes I_a and I_b
+	 * which were both initially sharing an xattr block.
 	 */
-	credits = 5;
+	credits = 7;
 
 	/* Quota updates. */
 	credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(sb);
 
+	/*
+	 * In case of inline data, we may push out the data to a block,
+	 * so we need to reserve credits for this eventuality
+	 */
+	if (ext4_has_inline_data(inode))
+		credits += ext4_writepage_trans_blocks(inode) + 1;
+
 	/* We are done if ea_inode feature is not enabled. */
 	if (!ext4_has_feature_ea_inode(sb))
 		return credits;
@@ -2120,7 +2134,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 			goto cleanup;
 		}
 
-		credits = __ext4_xattr_set_credits(inode->i_sb, bh, value_len);
+		credits = __ext4_xattr_set_credits(inode, bh, value_len);
 		brelse(bh);
 
 		if (!ext4_handle_has_enough_credits(handle, credits)) {
@@ -2243,7 +2257,7 @@ int ext4_xattr_set_credits(struct inode *inode, size_t value_len, int *credits)
 	if (IS_ERR(bh)) {
 		err = PTR_ERR(bh);
 	} else {
-		*credits = __ext4_xattr_set_credits(inode->i_sb, bh, value_len);
+		*credits = __ext4_xattr_set_credits(inode, bh, value_len);
 		brelse(bh);
 		err = 0;
 	}
