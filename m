From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 12/40] ext4: Fix estimate of # of blocks needed to write indirect-mapped files
Date: Tue,  1 Jun 2010 08:02:59 -0400
Message-ID: <1275393807-14369-12-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47473 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab0FAMEF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:04:05 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

commit d330a5befb88875a9b3d2db62f9b74dadf660b13 upstream (as of v2.6.34-rc3)

http://bugzilla.kernel.org/show_bug.cgi?id=15420

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4e8759a..ff04c74 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1018,7 +1018,7 @@ static int ext4_indirect_calc_metadata_amount(struct inode *inode,
 					      sector_t lblock)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	int dind_mask = EXT4_ADDR_PER_BLOCK(inode->i_sb) - 1;
+	sector_t dind_mask = ~((sector_t)EXT4_ADDR_PER_BLOCK(inode->i_sb) - 1);
 	int blk_bits;
 
 	if (lblock < EXT4_NDIR_BLOCKS)
@@ -1033,7 +1033,7 @@ static int ext4_indirect_calc_metadata_amount(struct inode *inode,
 	}
 	ei->i_da_metadata_calc_last_lblock = lblock & dind_mask;
 	ei->i_da_metadata_calc_len = 1;
-	blk_bits = roundup_pow_of_two(lblock + 1);
+	blk_bits = order_base_2(lblock);
 	return (blk_bits / EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb)) + 1;
 }
 
-- 
1.6.6.1.1.g974db.dirty

