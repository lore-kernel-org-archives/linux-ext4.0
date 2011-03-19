From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 04/12] ext4: Remove block bitmap initialization in ext4_new_inode()
Date: Sat, 19 Mar 2011 17:28:29 -0400
Message-ID: <1300570117-24048-5-git-send-email-tytso@mit.edu>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52246 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603Ab1CSVhY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Mar 2011 17:37:24 -0400
In-Reply-To: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are initializing the block bitmap in ext4_new_inode(), and as far
as I can tell, there's no reason to do it.  So remove it to simplify
things.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a679a48..88ad0e3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -815,7 +815,6 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
 	int ret2, err = 0;
 	struct inode *ret;
 	ext4_group_t i;
-	int free = 0;
 	static int once = 1;
 	ext4_group_t flex_group;
 
@@ -936,42 +935,6 @@ repeat_in_this_group:
 	goto out;
 
 got:
-	/* We may have to initialize the block bitmap if it isn't already */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
-	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		struct buffer_head *block_bitmap_bh;
-
-		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
-		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
-		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
-		if (err) {
-			brelse(block_bitmap_bh);
-			goto fail;
-		}
-
-		free = 0;
-		ext4_lock_group(sb, group);
-		/* recheck and clear flag under lock if we still need to */
-		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-			free = ext4_free_blocks_after_init(sb, group, gdp);
-			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
-			ext4_free_blks_set(sb, gdp, free);
-			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
-								gdp);
-		}
-		ext4_unlock_group(sb, group);
-
-		/* Don't need to dirty bitmap block if we didn't change it */
-		if (free) {
-			BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
-			err = ext4_handle_dirty_metadata(handle,
-							NULL, block_bitmap_bh);
-		}
