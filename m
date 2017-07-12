From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] ext4: make xattr inode reads faster
Date: Wed, 12 Jul 2017 01:29:32 -0700
Message-ID: <20170712082932.31844-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33171 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933243AbdGLI3h (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jul 2017 04:29:37 -0400
Received: by mail-pf0-f173.google.com with SMTP id e7so9439340pfk.0
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jul 2017 01:29:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_xattr_inode_read() currently reads each block sequentially while
waiting for io operation to complete before moving on to the next
block. This prevents request merging in block layer.

Fix this by starting reads for all blocks then wait for completions.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/ext4.h  |  2 ++
 fs/ext4/inode.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.c | 50 +++++++++++++++++++++++++++++++-------------------
 3 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9ebde0cd632e..12f0a16ad500 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2462,6 +2462,8 @@ extern void ext4_process_freed_data(struct super_block *sb, tid_t commit_tid);
 int ext4_inode_is_fast_symlink(struct inode *inode);
 struct buffer_head *ext4_getblk(handle_t *, struct inode *, ext4_lblk_t, int);
 struct buffer_head *ext4_bread(handle_t *, struct inode *, ext4_lblk_t, int);
+int ext4_bread_batch(struct inode *inode, ext4_lblk_t block, int bh_count,
+		     struct buffer_head **bhs);
 int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 			     struct buffer_head *bh_result, int create);
 int ext4_get_block(struct inode *inode, sector_t iblock,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c600f02673f..5b8ae1b66f09 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1015,6 +1015,42 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 	return ERR_PTR(-EIO);
 }
 
+/* Read a contiguous batch of blocks. */
+int ext4_bread_batch(struct inode *inode, ext4_lblk_t block, int bh_count,
+		     struct buffer_head **bhs)
+{
+	int i, err;
+
+	for (i = 0; i < bh_count; i++) {
+		bhs[i] = ext4_getblk(NULL, inode, block + i, 0 /* map_flags */);
+		if (IS_ERR(bhs[i])) {
+			err = PTR_ERR(bhs[i]);
+			while (i--)
+				brelse(bhs[i]);
+			return err;
+		}
+	}
+
+	for (i = 0; i < bh_count; i++)
+		/* Note that NULL bhs[i] is valid because of holes. */
+		if (bhs[i] && !buffer_uptodate(bhs[i]))
+			ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1,
+				    &bhs[i]);
+
+	for (i = 0; i < bh_count; i++)
+		if (bhs[i])
+			wait_on_buffer(bhs[i]);
+
+	for (i = 0; i < bh_count; i++) {
+		if (bhs[i] && !buffer_uptodate(bhs[i])) {
+			for (i = 0; i < bh_count; i++)
+				brelse(bhs[i]);
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
 int ext4_walk_page_buffers(handle_t *handle,
 			   struct buffer_head *head,
 			   unsigned from,
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index cff4f41ced61..f7364a842ff4 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -317,28 +317,40 @@ static void ext4_xattr_inode_set_hash(struct inode *ea_inode, u32 hash)
  */
 static int ext4_xattr_inode_read(struct inode *ea_inode, void *buf, size_t size)
 {
-	unsigned long block = 0;
-	struct buffer_head *bh;
-	int blocksize = ea_inode->i_sb->s_blocksize;
-	size_t csize, copied = 0;
-	void *copy_pos = buf;
-
-	while (copied < size) {
-		csize = (size - copied) > blocksize ? blocksize : size - copied;
-		bh = ext4_bread(NULL, ea_inode, block, 0);
-		if (IS_ERR(bh))
-			return PTR_ERR(bh);
-		if (!bh)
-			return -EFSCORRUPTED;
+	int blocksize = 1 << ea_inode->i_blkbits;
+	int bh_count = (size + blocksize - 1) >> ea_inode->i_blkbits;
+	int tail_size = (size % blocksize) ?: blocksize;
+	struct buffer_head *bhs_inline[8];
+	struct buffer_head **bhs = bhs_inline;
+	int i, ret;
+
+	if (bh_count > ARRAY_SIZE(bhs_inline)) {
+		bhs = kmalloc_array(bh_count, sizeof(*bhs), GFP_NOFS);
+		if (!bhs)
+			return -ENOMEM;
+	}
 
-		memcpy(copy_pos, bh->b_data, csize);
-		brelse(bh);
+	ret = ext4_bread_batch(ea_inode, 0 /* block */, bh_count, bhs);
+	if (ret)
+		goto free_bhs;
 
-		copy_pos += csize;
-		block += 1;
-		copied += csize;
+	for (i = 0; i < bh_count; i++) {
+		/* There shouldn't be any holes in ea_inode. */
+		if (!bhs[i]) {
+			ret = -EFSCORRUPTED;
+			goto put_bhs;
+		}
+		memcpy((char *)buf + blocksize * i, bhs[i]->b_data,
+		       i < bh_count - 1 ? blocksize : tail_size);
 	}
-	return 0;
+	ret = 0;
+put_bhs:
+	for (i = 0; i < bh_count; i++)
+		brelse(bhs[i]);
+free_bhs:
+	if (bhs != bhs_inline)
+		kfree(bhs);
+	return ret;
 }
 
 static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
-- 
2.13.2.932.g7449e964c-goog
