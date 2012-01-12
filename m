From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] vfs: Protect write paths by sb_start_write - sb_end_write
Date: Thu, 12 Jan 2012 02:20:51 +0100
Message-ID: <1326331253-6497-3-git-send-email-jack@suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

There are three entry points which dirty pages in a filesystem.  mmap (handled
by block_page_mkwrite()), buffered write (handled by
__generic_file_aio_write()), and truncate (it can dirty last partial page -
handled by do_truncate()). Protect these places with sb_start_write() and
sb_end_write().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c  |   18 ++----------------
 fs/open.c    |    6 ++++++
 mm/filemap.c |    3 ++-
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 19d8eb7..8519405 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2371,18 +2371,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
-	/*
-	 * Freezing in progress? We check after the page is marked dirty and
-	 * with page lock held so if the test here fails, we are sure freezing
-	 * code will wait during syncing until the page fault is done - at that
-	 * point page will be dirty and unlocked so freezing code will write it
-	 * and writeprotect it again.
-	 */
 	set_page_dirty(page);
-	if (inode->i_sb->s_frozen != SB_UNFROZEN) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
 	wait_on_page_writeback(page);
 	return 0;
 out_unlock:
@@ -2397,12 +2386,9 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	int ret;
 	struct super_block *sb = vma->vm_file->f_path.dentry->d_inode->i_sb;
 
-	/*
-	 * This check is racy but catches the common case. The check in
-	 * __block_page_mkwrite() is reliable.
-	 */
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	sb_start_write(sb);
 	ret = __block_page_mkwrite(vma, vmf, get_block);
+	sb_end_write(sb);
 	return block_page_mkwrite_return(ret);
 }
 EXPORT_SYMBOL(block_page_mkwrite);
diff --git a/fs/open.c b/fs/open.c
index 22c41b5..ee17c90 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -55,8 +55,14 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	if (ret)
 		newattrs.ia_valid |= ret | ATTR_FORCE;
 
+	/*
+	 * Truncate can dirty last partial page so we need protection against
+	 * filesystem freezing.
+	 */
 	mutex_lock(&dentry->d_inode->i_mutex);
+	sb_start_write(dentry->d_sb);
 	ret = notify_change(dentry, &newattrs);
+	sb_end_write(dentry->d_sb);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return ret;
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index c0018f2..6566c73 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2529,7 +2529,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	count = ocount;
 	pos = *ppos;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb);
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
@@ -2601,6 +2601,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				pos, ppos, count, written);
 	}
 out:
+	sb_end_write(inode->i_sb);
 	current->backing_dev_info = NULL;
 	return written ? written : err;
 }
-- 
1.7.1

