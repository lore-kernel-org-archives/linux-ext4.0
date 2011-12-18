From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 20/21] ext4: Evict inline data out if we needs to strore xattr in inode.
Date: Sun, 18 Dec 2011 22:24:37 +0800
Message-ID: <1324218278-2460-20-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Now we stores data in the inode, but in case we need to store some
xattrs and inode doesn't have enough space, Andreas suggested that
we should keep the xattr(metadata) in and data should be pushed out.
So this patch does the work.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.c  |   25 ++++++++++++++-
 fs/ext4/xattr.h  |    3 ++
 3 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 4203aa4..f6f27e1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1554,3 +1554,89 @@ out:
 	up_read(&EXT4_I(inode)->xattr_sem);
 	return (error < 0 ? error : 0);
 }
+
+/*
+ * Called during xattr set, and if we can sparse space 'needed',
+ * just create the extent tree evict the data to the outer block.
+ *
+ * We use jbd2 instead of page cache to move data to the 1st block
+ * so that the whole transaction can be committed as a whole and
+ * the data isn't lost because of the delayed page cache write.
+ */
+int ext4_try_to_evict_inline_data(handle_t *handle,
+				  struct inode *inode,
+				  int needed)
+{
+	int error;
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_ibody_header *header;
+	struct ext4_inode *raw_inode;
+	struct ext4_iloc iloc;
+	void *buf = NULL;
+	struct buffer_head *data_bh = NULL;
+	struct ext4_map_blocks map;
+
+	error = ext4_get_inode_loc(inode, &iloc);
+	if (error)
+		return error;
+
+	raw_inode = ext4_raw_inode(&iloc);
+	header = IHDR(inode, raw_inode);
+	entry = (struct ext4_xattr_entry *)((void *)raw_inode +
+					    EXT4_I(inode)->i_inline_off);
+	if (EXT4_XATTR_LEN(entry->e_name_len) +
+	    EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size)) < needed) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+	buf = kmalloc(ext4_get_inline_size(inode), GFP_NOFS);
+	if (!buf) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	error = ext4_read_inline_data(inode, buf,
+				      ext4_get_inline_size(inode), &iloc);
+	if (error < 0)
+		goto out;
+
+	error = ext4_destroy_inline_data_nolock(handle, inode);
+	if (error)
+		goto out;
+
+	map.m_lblk = 0;
+	map.m_len = 1;
+	map.m_flags = 0;
+	error = ext4_map_blocks(handle, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	if (error < 0)
+		goto out;
+	if (!(map.m_flags & EXT4_MAP_MAPPED)) {
+		error = -EIO;
+		goto out;
+	}
+
+	data_bh = sb_getblk(inode->i_sb, map.m_pblk);
+	if (!data_bh) {
+		error = -EIO;
+		goto out;
+	}
+
+	lock_buffer(data_bh);
+	error = ext4_journal_get_create_access(handle, data_bh);
+	if (error) {
+		unlock_buffer(data_bh);
+		error = -EIO;
+		goto out;
+	}
+	memcpy(data_bh->b_data, buf, data_bh->b_size);
+	set_buffer_uptodate(data_bh);
+	unlock_buffer(data_bh);
+	error = ext4_handle_dirty_metadata(handle,
+					   inode, data_bh);
+out:
+	brelse(data_bh);
+	kfree(buf);
+	brelse(iloc.bh);
+	return error;
+}
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 71ef45e..6785250 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -910,8 +910,21 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 	if (EXT4_I(inode)->i_extra_isize == 0)
 		return -ENOSPC;
 	error = ext4_xattr_set_entry(i, s);
-	if (error)
+	if (error && error != -ENOSPC)
 		return error;
+	if (error && ext4_has_inline_data(inode)) {
+		error = ext4_try_to_evict_inline_data(handle, inode,
+				EXT4_XATTR_LEN(strlen(i->name) +
+				EXT4_XATTR_SIZE(i->value_len)));
+		if (error)
+			return error;
+		error = ext4_xattr_ibody_find(inode, i, is);
+		if (error)
+			return error;
+		error = ext4_xattr_set_entry(i, s);
+		if (error)
+			return error;
+	}
 	header = IHDR(inode, ext4_raw_inode(&is->iloc));
 	if (!IS_LAST_ENTRY(s->first)) {
 		header->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
@@ -1057,9 +1070,17 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 {
 	handle_t *handle;
 	int error, retries = 0;
+	int credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
 
 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	/*
+	 * In case of inline data, we may push out the data to a block,
+	 * So reserve the journal space first.
+	 */
+	if (ext4_has_inline_data(inode))
+		credits += ext4_writepage_trans_blocks(inode) + 1;
+
+	handle = ext4_journal_start(inode, credits);
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 6bfdf9c..feb06ec 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -184,6 +184,9 @@ extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
 extern int ext4_inline_data_fiemap(struct inode *inode,
 				   struct fiemap_extent_info *fieinfo,
 				   int *has_inline);
+extern int ext4_try_to_evict_inline_data(handle_t *handle,
+					 struct inode *inode,
+					 int needed);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
-- 
1.7.0.4
