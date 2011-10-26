From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 04/17] ext4: Add normal write support for inline data.
Date: Wed, 26 Oct 2011 15:34:15 +0800
Message-ID: <1319614468-11227-4-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

For a normal write case(not journalled write, not delayed allocation),
we write to the inline if the file is small and convert it to an extent
based file when the write is larger than the max inline size.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 208 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2fa8cf4..876cdfd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -741,6 +741,163 @@ static int do_journal_get_write_access(handle_t *handle,
 
 static int ext4_get_block_write(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create);
+static int ext4_read_inline_page(struct inode *inode, struct page *page);
+
+static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
+					      struct inode *inode,
+					      unsigned flags)
+{
+	int ret, needed_blocks;
+	handle_t *handle = NULL;
+	int retries = 0;
+	struct page *page = NULL;
+	unsigned from, to;
+	struct ext4_iloc iloc;
+
+	if (!ext4_has_inline_data(inode)) {
+		/*
+		 * clear the flag so that no new write
+		 * will trap here again.
+		 */
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		return 0;
+	}
+
+	needed_blocks = ext4_writepage_trans_blocks(inode);
+	from = 0;
+	to = ext4_get_max_inline_size(inode);
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+retry:
+	handle = ext4_journal_start(inode, needed_blocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
+
+	page = grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page) {
+		ext4_journal_stop(handle);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!PageUptodate(page)) {
+		ret = ext4_read_inline_page(inode, page);
+		if (ret)
+			goto out;
+	}
+
+	ret = ext4_destroy_inline_data(handle, inode);
+	if (ret)
+		goto out;
+
+	if (ext4_should_dioread_nolock(inode))
+		ret = __block_write_begin(page, from, to, ext4_get_block_write);
+	else
+		ret = __block_write_begin(page, from, to, ext4_get_block);
+
+	if (!ret && ext4_should_journal_data(inode)) {
+		ret = walk_page_buffers(handle, page_buffers(page),
+				from, to, NULL, do_journal_get_write_access);
+	}
+
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+
+	block_commit_write(page, from, to);
+out:
+	if (page) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	if (handle)
+		ext4_journal_stop(handle);
+	brelse(iloc.bh);
+	return ret;
+}
+
+/*
+ * Try to write data in the inode.
+ * If the inode has inline data, check whether the new write can be
+ * in the inode also. If not, create the page the handle, move the data
+ * to the page make it update and let the later codes create extent for it.
+ */
+static int ext4_try_to_write_inline_data(struct address_space *mapping,
+					 struct inode *inode,
+					 loff_t pos, unsigned len,
+					 unsigned flags,
+					 struct page **pagep)
+{
+	int ret;
+	handle_t *handle;
+	struct page *page;
+	struct ext4_iloc iloc;
+
+	if (pos + len > ext4_get_max_inline_size(inode))
+		return ext4_convert_inline_data_to_extent(mapping,
+							  inode, flags);
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+	/*
+	 * The possible write could happen in the inode,
+	 * so try to reserve the space in inode first.
+	 */
+	handle = ext4_journal_start(inode, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		goto out;
+	}
+
+	if (!ext4_has_inline_data(inode)) {
+		ret = ext4_init_inline_data(handle, inode, &iloc);
+		if (ret && ret != -ENOSPC)
+			goto out;
+
+		if (ret == -ENOSPC) {
+			ret = 0;
+			goto out;
+		}
+	}
+
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
+
+	page = grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	*pagep = page;
+
+	if (!PageUptodate(page)) {
+		ret = ext4_read_inline_page(inode, page);
+		if (ret)
+			goto out;
+	}
+
+	ret = 1;
+	handle = NULL;
+out:
+	if (handle)
+		ext4_journal_stop(handle);
+	brelse(iloc.bh);
+	return ret;
+}
+
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
 			    loff_t pos, unsigned len, unsigned flags,
 			    struct page **pagep, void **fsdata)
@@ -763,6 +920,17 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		ret = ext4_try_to_write_inline_data(mapping, inode, pos, len,
+						    flags, pagep);
+		if (ret < 0)
+			goto out;
+		if (ret == 1) {
+			ret = 0;
+			goto out;
+		}
+	}
+
 retry:
 	handle = ext4_journal_start(inode, needed_blocks);
 	if (IS_ERR(handle)) {
@@ -780,6 +948,7 @@ retry:
 		ret = -ENOMEM;
 		goto out;
 	}
+
 	*pagep = page;
 
 	if (ext4_should_dioread_nolock(inode))
@@ -826,6 +995,37 @@ out:
 	return ret;
 }
 
+static int ext4_write_inline_data_end(struct inode *inode,
+				      loff_t pos, unsigned len, unsigned copied,
+				      struct page *page)
+{
+	int ret;
+	void *kaddr;
+	struct ext4_iloc iloc;
+
+	if (unlikely(copied < len)) {
+		if (!PageUptodate(page)) {
+			copied = 0;
+			goto out;
+		}
+	}
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret) {
+		ext4_std_error(inode->i_sb, ret);
+		copied = 0;
+		goto out;
+	}
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	ext4_write_inline_data(inode, &iloc, kaddr, pos, len);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	brelse(iloc.bh);
+out:
+	return copied;
+}
+
 /* For write_end() in data=journal mode */
 static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
@@ -844,7 +1044,12 @@ static int ext4_generic_write_end(struct file *file,
 	struct inode *inode = mapping->host;
 	handle_t *handle = ext4_journal_current_handle();
 
-	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (ext4_has_inline_data(inode))
+		copied = ext4_write_inline_data_end(inode, pos, len,
+						    copied, page);
+	else
+		copied = block_write_end(file, mapping, pos,
+					 len, copied, page, fsdata);
 
 	/*
 	 * No need to use i_size_read() here, the i_size
@@ -3462,7 +3667,8 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
 	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
 		ext4_find_inline_data(inode, iloc);
-	}
+	} else
+		EXT4_I(inode)->i_inline_off = 0;
 }
 
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
-- 
1.7.0.4
