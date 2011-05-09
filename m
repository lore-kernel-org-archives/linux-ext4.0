From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: remove unneeded ext4_journal_get_undo_access
Date: Mon,  9 May 2011 10:59:30 -0400
Message-ID: <1304953170-32637-2-git-send-email-tytso@mit.edu>
References: <20110509145453.GB19811@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51931 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1EIO7d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:59:33 -0400
In-Reply-To: <20110509145453.GB19811@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block allocation code used to use jbd2_journal_get_undo_access as
a way to make changes that wouldn't show up until the commit took
place.  The new multi-block allocation code has a its own way of
preventing newly freed blocks from getting reused until the commit
takes place (it avoids updating the buddy bitmaps until the commit is
done), so we don't need to use jbd2_journal_get_undo_access(), which
has extra overhead compared to jbd2_journal_get_write_access().

There was one last vestigal use of ext4_journal_get_undo_access() in
ext4_add_groupblocks(); change it to use ext4_journal_get_write_access()
and then remove the ext4_journal_get_undo_access() support.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4_jbd2.c |   14 --------------
 fs/ext4/ext4_jbd2.h |    5 -----
 fs/ext4/mballoc.c   |   12 ++++--------
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 6e272ef..f5240aa 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -6,20 +6,6 @@
 
 #include <trace/events/ext4.h>
 
-int __ext4_journal_get_undo_access(const char *where, unsigned int line,
-				   handle_t *handle, struct buffer_head *bh)
-{
-	int err = 0;
-
-	if (ext4_handle_valid(handle)) {
-		err = jbd2_journal_get_undo_access(handle, bh);
-		if (err)
-			ext4_journal_abort_handle(where, line, __func__, bh,
-						  handle, err);
-	}
-	return err;
-}
-
 int __ext4_journal_get_write_access(const char *where, unsigned int line,
 				    handle_t *handle, struct buffer_head *bh)
 {
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d0f5353..bb85757 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -126,9 +126,6 @@ void ext4_journal_abort_handle(const char *caller, unsigned int line,
 			       const char *err_fn,
 		struct buffer_head *bh, handle_t *handle, int err);
 
-int __ext4_journal_get_undo_access(const char *where, unsigned int line,
-				   handle_t *handle, struct buffer_head *bh);
-
 int __ext4_journal_get_write_access(const char *where, unsigned int line,
 				    handle_t *handle, struct buffer_head *bh);
 
@@ -146,8 +143,6 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 int __ext4_handle_dirty_super(const char *where, unsigned int line,
 			      handle_t *handle, struct super_block *sb);
 
-#define ext4_journal_get_undo_access(handle, bh) \
-	__ext4_journal_get_undo_access(__func__, __LINE__, (handle), (bh))
 #define ext4_journal_get_write_access(handle, bh) \
 	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
 #define ext4_forget(handle, is_metadata, inode, bh, block_nr) \
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 92aa05d..307d447 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4732,9 +4732,9 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	 * Check to see if we are freeing blocks across a group
 	 * boundary.
 	 */
-	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
+	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb))
 		goto error_return;
-	}
+
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (!bitmap_bh)
 		goto error_return;
@@ -4753,12 +4753,8 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 		goto error_return;
 	}
 
-	/*
-	 * We are about to add blocks to the bitmap,
-	 * so we need undo access.
-	 */
-	BUFFER_TRACE(bitmap_bh, "getting undo access");
-	err = ext4_journal_get_undo_access(handle, bitmap_bh);
+	BUFFER_TRACE(bitmap_bh, "getting write access");
+	err = ext4_journal_get_write_access(handle, bitmap_bh);
 	if (err)
 		goto error_return;
 
-- 
1.7.3.1

