From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] ext4: drop the EXT4_STATE_DELALLOC_RESERVED flag
Date: Tue,  2 Sep 2014 18:05:49 -0400
Message-ID: <1409695549-18605-4-git-send-email-tytso@mit.edu>
References: <1409695549-18605-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33720 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbaIBWoA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 18:44:00 -0400
In-Reply-To: <1409695549-18605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Having done a full regression test, we can now drop the
DELALLOC_RESERVED state flag.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h    |  1 -
 fs/ext4/inode.c   | 20 ++++----------------
 fs/ext4/mballoc.c | 10 ----------
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 00fd822..4855800 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1400,7 +1400,6 @@ enum {
 	EXT4_STATE_EXT_MIGRATE,		/* Inode is migrating */
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
-	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
 	EXT4_STATE_DIOREAD_LOCK,	/* Disable support for dio read
 					   nolocking */
 	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4a16b0c..d5dd7d4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -596,14 +596,6 @@ found:
 	down_write(&EXT4_I(inode)->i_data_sem);
 
 	/*
-	 * if the caller is from delayed allocation writeout path
-	 * we have already reserved fs blocks for allocation
-	 * let the underlying get_block() function know to
-	 * avoid double accounting
-	 */
-	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
-		ext4_set_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
-	/*
 	 * We need to check for EXT4 here because migrate
 	 * could have changed the inode type in between
 	 */
@@ -631,8 +623,6 @@ found:
 			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
 			ext4_da_update_reserve_space(inode, retval, 1);
 	}
-	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
-		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
 
 	if (retval > 0) {
 		unsigned int status;
@@ -2004,12 +1994,10 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 	 * in data loss.  So use reserved blocks to allocate metadata if
 	 * possible.
 	 *
-	 * We pass in the magic EXT4_GET_BLOCKS_DELALLOC_RESERVE if the blocks
-	 * in question are delalloc blocks.  This affects functions in many
-	 * different parts of the allocation call path.  This flag exists
-	 * primarily because we don't want to change *many* call functions, so
-	 * ext4_map_blocks() will set the EXT4_STATE_DELALLOC_RESERVED flag
-	 * once the inode's allocation semaphore is taken.
+	 * We pass in the magic EXT4_GET_BLOCKS_DELALLOC_RESERVE if
+	 * the blocks in question are delalloc blocks.  This indicates
+	 * that the blocks and quotas has already been checked when
+	 * the data was copied into the page cache.
 	 */
 	get_blocks_flags = EXT4_GET_BLOCKS_CREATE |
 			   EXT4_GET_BLOCKS_METADATA_NOFAIL;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 15dffda..65cca28 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4410,16 +4410,6 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	if (IS_NOQUOTA(ar->inode))
 		ar->flags |= EXT4_MB_USE_ROOT_BLOCKS;
 
-	/*
-	 * For delayed allocation, we could skip the ENOSPC and
-	 * EDQUOT check, as blocks and quotas have been already
-	 * reserved when data being copied into pagecache.
-	 */
-	if (ext4_test_inode_state(ar->inode, EXT4_STATE_DELALLOC_RESERVED)) {
-		WARN_ON((ar->flags & EXT4_MB_DELALLOC_RESERVED) == 0);
-		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
-	}
