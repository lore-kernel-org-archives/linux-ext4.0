From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] ext[34] EA block reference count racing fix
Date: Wed, 21 Feb 2007 15:54:10 -0800
Message-ID: <1172102051.3774.31.camel@dyn9047017103.beaverton.ibm.com>
References: <200702100946.l1A9kM3s009363@shell0.pdx.osdl.net>
	 <20070213075304.GA25313@wotan.suse.de>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@suse.de>,
	Andreas Gruenbacher <agruen@suse.de>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34974 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945908AbXBUXyN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Feb 2007 18:54:13 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1LNsDa1016108
	for <linux-ext4@vger.kernel.org>; Wed, 21 Feb 2007 18:54:13 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1LNsCQI526078
	for <linux-ext4@vger.kernel.org>; Wed, 21 Feb 2007 16:54:12 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1LNsCh2021929
	for <linux-ext4@vger.kernel.org>; Wed, 21 Feb 2007 16:54:12 -0700
In-Reply-To: <20070213075304.GA25313@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

There are race issues around ext[34] xattr block release code.

ext[34]_xattr_release_block() checks the reference count of xattr block
(h_refcount) and frees that xattr block if it is the last one reference
it. Unlike ext2, the check of this counter is unprotected by any lock.
ext[34]_xattr_release_block() will free the mb_cache entry before
freeing that xattr block. There is a small window between the check for
the re h_refcount ==1 and the call to mb_cache_entry_free(). During this
small window another inode might find this xattr block from the mbcache
and reuse it, racing a refcount updates.  The xattr block will later be
freed by the first inode without notice other inode is still use it.
Later if that block is reallocated as a datablock for other file, then
more serious problem might happen.

We need put a lock around places checking the refount as well to avoid
racing issue. Another place need this kind of protection is in
ext3_xattr_block_set(), where it will modify the xattr block content in-
the-fly if the refcount is 1 (means it's the only inode reference it).

This will also fix another issue: the xattr block may not get freed at
all if no lock is to protect the refcount check at the release time. It
is possible that the last two inodes could release the shared xattr
block at the same time. But both of them think they are not the last one
so only decreased the h_refcount without freeing xattr block at all.

We need to call lock_buffer() after ext3_journal_get_write_access() to
avoid deadlock (because the later will call lock_buffer()/unlock_buffer
() as well).


Signed-Off-By: Mingming Cao <cmm@us.ibm.com>
---

 linux-2.6.19-ming/fs/ext3/xattr.c |   42 +++++++++++++++++++++++---------------
 linux-2.6.19-ming/fs/ext4/xattr.c |   41 ++++++++++++++++++++++---------------
 2 files changed, 51 insertions(+), 32 deletions(-)

diff -puN fs/ext3/xattr.c~ext34_xattr_release_block_race_fix fs/ext3/xattr.c
--- linux-2.6.19/fs/ext3/xattr.c~ext34_xattr_release_block_race_fix	2007-02-14 16:40:48.000000000 -0800
+++ linux-2.6.19-ming/fs/ext3/xattr.c	2007-02-21 11:45:10.000000000 -0800
@@ -478,8 +478,15 @@ ext3_xattr_release_block(handle_t *handl
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
@@ -488,21 +495,20 @@ ext3_xattr_release_block(handle_t *handl
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
@@ -678,7 +684,7 @@ ext3_xattr_block_set(handle_t *handle, s
 	struct buffer_head *new_bh = NULL;
 	struct ext3_xattr_search *s = &bs->s;
 	struct mb_cache_entry *ce = NULL;
-	int error;
+	int error = 0;
 
 #define header(x) ((struct ext3_xattr_header *)(x))
 
@@ -687,16 +693,17 @@ ext3_xattr_block_set(handle_t *handle, s
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
@@ -716,6 +723,9 @@ ext3_xattr_block_set(handle_t *handle, s
 		} else {
 			int offset = (char *)s->here - bs->bh->b_data;
 
+			unlock_buffer(bs->bh);
+			journal_release_buffer(handle, bs->bh);
+
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;
diff -puN fs/ext4/xattr.c~ext34_xattr_release_block_race_fix fs/ext4/xattr.c
--- linux-2.6.19/fs/ext4/xattr.c~ext34_xattr_release_block_race_fix	2007-02-14 16:40:48.000000000 -0800
+++ linux-2.6.19-ming/fs/ext4/xattr.c	2007-02-21 15:30:07.465880558 -0800
@@ -478,8 +478,14 @@ ext4_xattr_release_block(handle_t *handl
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
@@ -488,21 +494,21 @@ ext4_xattr_release_block(handle_t *handl
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
@@ -678,7 +684,7 @@ ext4_xattr_block_set(handle_t *handle, s
 	struct buffer_head *new_bh = NULL;
 	struct ext4_xattr_search *s = &bs->s;
 	struct mb_cache_entry *ce = NULL;
-	int error;
+	int error = 0;
 
 #define header(x) ((struct ext4_xattr_header *)(x))
 
@@ -687,16 +693,17 @@ ext4_xattr_block_set(handle_t *handle, s
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
@@ -716,6 +723,8 @@ ext4_xattr_block_set(handle_t *handle, s
 		} else {
 			int offset = (char *)s->here - bs->bh->b_data;
 
+			unlock_buffer(bs->bh);
+			journal_release_buffer(handle, bs->bh);
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;

_
