From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Why do we initialize block bitmaps in ext4_new_inode()
Date: Mon, 14 Mar 2011 13:44:35 -0400
Message-ID: <E1PzBop-0007a0-BN@tytso-glaptop>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45610 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1CNRoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2011 13:44:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Is there some subtle reason why ext4_new_inode() checked for
uninitialized block bitmaps and initialized the block bitmaps in
ext4_new_inode().  It's not immediately needed in that function, and I
don't see any reason why initializing the inode table or inode
allocation bitmap requires initializing the block bitmap.

Am I missing something?

					- Ted


>From ff15031626d5f10ba1256c0c7a3818ca12205b55 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 14 Mar 2011 13:37:36 -0400
Subject: [PATCH] ext4: Remove block bitmap initialization in ext4_new_inode()

We are initializing the block bitmap in ext4_new_inode(), and as far
as I can tell, there's no reason to do it.  So remove it to simplify
things.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |   36 ------------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2fd3b0e..f79432a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -936,42 +936,6 @@ repeat_in_this_group:
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
