From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 03/10] ext4: fix unwritten counter leakage
Date: Mon, 24 Sep 2012 15:44:13 +0400
Message-ID: <1348487060-19598-4-git-send-email-dmonakhov@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54781 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2IXLoe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:34 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6549370lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:33 -0700 (PDT)
In-Reply-To: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_set_io_unwritten_flag() will increment i_unwritten counter, so
once we mark end_io with END_IO_UNWRITTEN we have to revert it back
on error path.

 - add missed error checks to prevent counter leakage
 - ext4_end_io_nolock() will clear END_IO_UNWRITTEN flag to signal
   that conversion finished.
 - add BUGON to free_end_io() to prevent similar leackage in future.

Visiable effect of this bug is that unaligned aio_stress may deadlock

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   21 ++++++++++++++-------
 fs/ext4/page-io.c |    6 +++++-
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6eb6b0c..739c21d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3660,6 +3660,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
 		ret = ext4_split_unwritten_extents(handle, inode, map,
 						   path, flags);
+		if (ret <= 0)
+			goto out;
 		/*
 		 * Flag the inode(non aio case) or end_io struct (aio case)
 		 * that this IO needs to conversion to written when IO is
@@ -3905,6 +3907,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = (ext4_io_end_t*) EXT4_CUR_AIO_DIO(inode);
 	ext4_lblk_t cluster_offset;
+	int set_unwritten = 0;
 
 	ext_debug("blocks %u/%u requested for inode %lu\n",
 		  map->m_lblk, map->m_len, inode->i_ino);
@@ -4127,13 +4130,8 @@ got_allocated_blocks:
 		 * For non asycn direct IO case, flag the inode state
 		 * that we need to perform conversion when IO is done.
 		 */
-		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
-			if (io)
-				ext4_set_io_unwritten_flag(inode, io);
-			else
-				ext4_set_inode_state(inode,
-						     EXT4_STATE_DIO_UNWRITTEN);
-		}
+		if ((flags & EXT4_GET_BLOCKS_PRE_IO))
+			set_unwritten = 1;
 		if (ext4_should_dioread_nolock(inode))
 			map->m_flags |= EXT4_MAP_UNINIT;
 	}
@@ -4145,6 +4143,15 @@ got_allocated_blocks:
 	if (!err)
 		err = ext4_ext_insert_extent(handle, inode, path,
 					     &newex, flags);
+
+	if (!err && set_unwritten) {
+		if (io)
+			ext4_set_io_unwritten_flag(inode, io);
+		else
+			ext4_set_inode_state(inode,
+					     EXT4_STATE_DIO_UNWRITTEN);
+	}
+
 	if (err && free_on_err) {
 		int fb_flags = flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
 			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE : 0;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index de77e31..9970022 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -71,6 +71,8 @@ void ext4_free_io_end(ext4_io_end_t *io)
 	int i;
 
 	BUG_ON(!io);
+	BUG_ON(io->flag & EXT4_IO_END_UNWRITTEN);
+
 	if (io->page)
 		put_page(io->page);
 	for (i = 0; i < io->num_io_pages; i++)
@@ -94,6 +96,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 	ssize_t size = io->size;
 	int ret = 0;
 
+	BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
+
 	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
@@ -106,7 +110,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 			 "(inode %lu, offset %llu, size %zd, error %d)",
 			 inode->i_ino, offset, size, ret);
 	}
