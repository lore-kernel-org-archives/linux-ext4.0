From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 25/30] ext4: snapshot race conditions - concurrent COW operations
Date: Mon,  9 May 2011 19:41:43 +0300
Message-ID: <1304959308-11122-26-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab1EIQo0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:26 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:25 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Wait for pending COW operations to complete.
When concurrent tasks try to COW the same buffer, the task that takes
the active snapshot i_data_sem is elected as the the COWing task.
The COWing task allocates a new snapshot block and creates a buffer
cache entry with ref_count=1 for that new block.  It then locks the
new buffer and marks it with the buffer_new flag.  The rest of the
tasks wait (in msleep(1) loop), until the buffer_new flag is cleared.
The COWing task copies the source buffer into the 'new' buffer,
unlocks it, clears the new_buffer flag and drops its reference count.
On active snapshot readpage, the buffer cache is checked.
If a 'new' buffer entry is found, the reader task waits until the
buffer_new flag is cleared and then copies the 'new' buffer directly
into the snapshot file page.
The sleep loop method was copied from LVM snapshot code, which does
the same thing to deal with these (rare) races without wait queues.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d23743a..794b29f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1049,6 +1049,7 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	int depth;
 	int count = 0;
 	ext4_fsblk_t first_block = 0;
+	struct buffer_head *sbh = NULL;
 
 	J_ASSERT(!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)));
 	J_ASSERT(handle != NULL || (flags & EXT4_GET_BLOCKS_CREATE) == 0);
@@ -1154,6 +1155,25 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	if (err)
 		goto cleanup;
 
+	if (SNAPMAP_ISCOW(flags)) {
+		/*
+		 * COWing block or creating COW bitmap.
+		 * we now have exclusive access to the COW destination block
+		 * and we are about to create the snapshot block mapping
+		 * and make it public.
+		 * grab the buffer cache entry and mark it new
+		 * to indicate a pending COW operation.
+		 * the refcount for the buffer cache will be released
+		 * when the COW operation is either completed or canceled.
+		 */
+		sbh = sb_getblk(inode->i_sb, le32_to_cpu(chain[depth-1].key));
+		if (!sbh) {
+			err = -EIO;
+			goto cleanup;
+		}
+		ext4_snapshot_start_pending_cow(sbh);
+	}
+
 	if (map->m_flags & EXT4_MAP_REMAP) {
 		map->m_len = count;
 		/* move old block to snapshot */
@@ -1197,6 +1217,12 @@ got_it:
 	/* Clean up and exit */
 	partial = chain + depth - 1;	/* the whole chain */
 cleanup:
+	/* cancel pending COW operation on failure to alloc snapshot block */
+	if (SNAPMAP_ISCOW(flags)) {
+		if (err < 0 && sbh)
+			ext4_snapshot_end_pending_cow(sbh);
+		brelse(sbh);
+	}
 	while (partial > chain) {
 		BUFFER_TRACE(partial->bh, "call brelse");
 		brelse(partial->bh);
-- 
1.7.0.4

