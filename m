From: akpm@linux-foundation.org
Subject: + ext-ea-block-reference-count-racing-fix.patch added to -mm tree
Date: Wed, 21 Feb 2007 19:41:17 -0800
Message-ID: <200702220341.l1M3fHNr003499@shell0.pdx.osdl.net>
Cc: cmm@us.ibm.com, agruen@suse.de, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35723 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXBVDlY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Feb 2007 22:41:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext[34]" EA block reference count racing fix
has been added to the -mm tree.  Its filename is
     ext-ea-block-reference-count-racing-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext[34]" EA block reference count racing fix
From: Mingming Cao <cmm@us.ibm.com>

There are race issues around ext[34] xattr block release code.

ext[34]_xattr_release_block() checks the reference count of xattr block
(h_refcount) and frees that xattr block if it is the last one reference it.
 Unlike ext2, the check of this counter is unprotected by any lock. 
ext[34]_xattr_release_block() will free the mb_cache entry before freeing
that xattr block.  There is a small window between the check for the re
h_refcount ==1 and the call to mb_cache_entry_free().  During this small
window another inode might find this xattr block from the mbcache and reuse
it, racing a refcount updates.  The xattr block will later be freed by the
first inode without notice other inode is still use it.  Later if that
block is reallocated as a datablock for other file, then more serious
problem might happen.

We need put a lock around places checking the refount as well to avoid
racing issue.  Another place need this kind of protection is in
ext3_xattr_block_set(), where it will modify the xattr block content in-
the-fly if the refcount is 1 (means it's the only inode reference it).

This will also fix another issue: the xattr block may not get freed at all
if no lock is to protect the refcount check at the release time.  It is
possible that the last two inodes could release the shared xattr block at
the same time.  But both of them think they are not the last one so only
decreased the h_refcount without freeing xattr block at all.

We need to call lock_buffer() after ext3_journal_get_write_access() to
avoid deadlock (because the later will call lock_buffer()/unlock_buffer
() as well).

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/xattr.c |   42 ++++++++++++++++++++++++++----------------
 fs/ext4/xattr.c |   41 +++++++++++++++++++++++++----------------
 2 files changed, 51 insertions(+), 32 deletions(-)

diff -puN fs/ext3/xattr.c~ext-ea-block-reference-count-racing-fix fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext-ea-block-reference-count-racing-fix
+++ a/fs/ext3/xattr.c
@@ -475,8 +475,15 @@ ext3_xattr_release_block(handle_t *handl
 			 struct buffer_head *bh)
 {
 	struct mb_cache_entry *ce = NULL;
+	int error = 0;
 
 	ce = mb_cache_entry_get(ext3_xattr_cache, bh->b_bdev, bh->b_blocknr);
+	error = ext3_journal_get_write_access(handle, bh);
+	if (error)
+		 goto out;
+
+	lock_buffer(bh);
+
 	if (BHDR(bh)->h_refcount == cpu_to_le32(1)) {
 		ea_bdebug(bh, "refcount now=0; freeing");
 		if (ce)
@@ -485,21 +492,20 @@ ext3_xattr_release_block(handle_t *handl
 		get_bh(bh);
 		ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
-		if (ext3_journal_get_write_access(handle, bh) == 0) {
-			lock_buffer(bh);
-			BHDR(bh)->h_refcount = cpu_to_le32(
+		BHDR(bh)->h_refcount = cpu_to_le32(
 				le32_to_cpu(BHDR(bh)->h_refcount) - 1);
-			ext3_journal_dirty_metadata(handle, bh);
-			if (IS_SYNC(inode))
-				handle->h_sync = 1;
-			DQUOT_FREE_BLOCK(inode, 1);
-			unlock_buffer(bh);
-			ea_bdebug(bh, "refcount now=%d; releasing",
-				  le32_to_cpu(BHDR(bh)->h_refcount));
-		}
+		error = ext3_journal_dirty_metadata(handle, bh);
+		handle->h_sync = 1;
+		DQUOT_FREE_BLOCK(inode, 1);
+		ea_bdebug(bh, "refcount now=%d; releasing",
+			  le32_to_cpu(BHDR(bh)->h_refcount));
 		if (ce)
 			mb_cache_entry_release(ce);
 	}
+	unlock_buffer(bh);
+out:
+	ext3_std_error(inode->i_sb, error);
+	return;
 }
 
 struct ext3_xattr_info {
@@ -675,7 +681,7 @@ ext3_xattr_block_set(handle_t *handle, s
 	struct buffer_head *new_bh = NULL;
 	struct ext3_xattr_search *s = &bs->s;
 	struct mb_cache_entry *ce = NULL;
-	int error;
+	int error = 0;
 
 #define header(x) ((struct ext3_xattr_header *)(x))
 
@@ -684,16 +690,17 @@ ext3_xattr_block_set(handle_t *handle, s
 	if (s->base) {
 		ce = mb_cache_entry_get(ext3_xattr_cache, bs->bh->b_bdev,
 					bs->bh->b_blocknr);
+		error = ext3_journal_get_write_access(handle, bs->bh);
+		if (error)
+			goto cleanup;
+		lock_buffer(bs->bh);
+
 		if (header(s->base)->h_refcount == cpu_to_le32(1)) {
 			if (ce) {
 				mb_cache_entry_free(ce);
 				ce = NULL;
 			}
 			ea_bdebug(bs->bh, "modifying in-place");
-			error = ext3_journal_get_write_access(handle, bs->bh);
-			if (error)
-				goto cleanup;
-			lock_buffer(bs->bh);
 			error = ext3_xattr_set_entry(i, s);
 			if (!error) {
 				if (!IS_LAST_ENTRY(s->first))
@@ -713,6 +720,9 @@ ext3_xattr_block_set(handle_t *handle, s
 		} else {
 			int offset = (char *)s->here - bs->bh->b_data;
 
+			unlock_buffer(bs->bh);
+			journal_release_buffer(handle, bs->bh);
+
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;
diff -puN fs/ext4/xattr.c~ext-ea-block-reference-count-racing-fix fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~ext-ea-block-reference-count-racing-fix
+++ a/fs/ext4/xattr.c
@@ -475,8 +475,14 @@ ext4_xattr_release_block(handle_t *handl
 			 struct buffer_head *bh)
 {
 	struct mb_cache_entry *ce = NULL;
+	int error = 0;
 
 	ce = mb_cache_entry_get(ext4_xattr_cache, bh->b_bdev, bh->b_blocknr);
+	error = ext4_journal_get_write_access(handle, bh);
+	if (error)
+		goto out;
+
+	lock_buffer(bh);
 	if (BHDR(bh)->h_refcount == cpu_to_le32(1)) {
 		ea_bdebug(bh, "refcount now=0; freeing");
 		if (ce)
@@ -485,21 +491,21 @@ ext4_xattr_release_block(handle_t *handl
 		get_bh(bh);
 		ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
-		if (ext4_journal_get_write_access(handle, bh) == 0) {
-			lock_buffer(bh);
-			BHDR(bh)->h_refcount = cpu_to_le32(
+		BHDR(bh)->h_refcount = cpu_to_le32(
 				le32_to_cpu(BHDR(bh)->h_refcount) - 1);
-			ext4_journal_dirty_metadata(handle, bh);
-			if (IS_SYNC(inode))
-				handle->h_sync = 1;
-			DQUOT_FREE_BLOCK(inode, 1);
-			unlock_buffer(bh);
-			ea_bdebug(bh, "refcount now=%d; releasing",
-				  le32_to_cpu(BHDR(bh)->h_refcount));
-		}
+		error = ext4_journal_dirty_metadata(handle, bh);
+		if (IS_SYNC(inode))
+			handle->h_sync = 1;
+		DQUOT_FREE_BLOCK(inode, 1);
+		ea_bdebug(bh, "refcount now=%d; releasing",
+			  le32_to_cpu(BHDR(bh)->h_refcount));
 		if (ce)
 			mb_cache_entry_release(ce);
 	}
+	unlock_buffer(bh);
+out:
+	ext4_std_error(inode->i_sb, error);
+	return;
 }
 
 struct ext4_xattr_info {
@@ -675,7 +681,7 @@ ext4_xattr_block_set(handle_t *handle, s
 	struct buffer_head *new_bh = NULL;
 	struct ext4_xattr_search *s = &bs->s;
 	struct mb_cache_entry *ce = NULL;
-	int error;
+	int error = 0;
 
 #define header(x) ((struct ext4_xattr_header *)(x))
 
@@ -684,16 +690,17 @@ ext4_xattr_block_set(handle_t *handle, s
 	if (s->base) {
 		ce = mb_cache_entry_get(ext4_xattr_cache, bs->bh->b_bdev,
 					bs->bh->b_blocknr);
+		error = ext4_journal_get_write_access(handle, bs->bh);
+		if (error)
+			goto cleanup;
+		lock_buffer(bs->bh);
+
 		if (header(s->base)->h_refcount == cpu_to_le32(1)) {
 			if (ce) {
 				mb_cache_entry_free(ce);
 				ce = NULL;
 			}
 			ea_bdebug(bs->bh, "modifying in-place");
-			error = ext4_journal_get_write_access(handle, bs->bh);
-			if (error)
-				goto cleanup;
-			lock_buffer(bs->bh);
 			error = ext4_xattr_set_entry(i, s);
 			if (!error) {
 				if (!IS_LAST_ENTRY(s->first))
@@ -713,6 +720,8 @@ ext4_xattr_block_set(handle_t *handle, s
 		} else {
 			int offset = (char *)s->here - bs->bh->b_data;
 
+			unlock_buffer(bs->bh);
+			journal_release_buffer(handle, bs->bh);
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;
_

Patches currently in -mm which might be from cmm@us.ibm.com are

ext-ea-block-reference-count-racing-fix.patch
ext2-reservations.patch
ext2-fix-reservation-extension.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
