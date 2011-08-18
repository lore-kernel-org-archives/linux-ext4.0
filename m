From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/5] ext3: use fs netlink interface for ENOSPC conditions
Date: Thu, 18 Aug 2011 14:18:23 +0200
Message-ID: <1313669906-14931-3-git-send-email-lczerner@redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab1HRMT2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 08:19:28 -0400
In-Reply-To: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Register fs netlink interface and send proper warning if ENOSPC is
encountered. Note that we differentiate between enospc for metadata and
enospc for data.

Also fix ext3_should_retry_alloc() so we do not check for free blocks
when we are actually allocating metadata

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
CC: Jan Kara <jack@suse.cz>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>
---
 fs/ext3/acl.c           |    5 +++--
 fs/ext3/balloc.c        |   10 ++++++++--
 fs/ext3/inode.c         |    4 ++--
 fs/ext3/namei.c         |   10 +++++-----
 fs/ext3/super.c         |    1 +
 fs/ext3/xattr.c         |    2 +-
 include/linux/ext3_fs.h |    3 ++-
 7 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 3091f62..b900123 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -322,7 +322,7 @@ retry:
 	error = ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
 	ext3_journal_stop(handle);
 	if (error == -ENOSPC &&
-	    ext3_should_retry_alloc(inode->i_sb, &retries))
+	    ext3_should_retry_alloc(inode->i_sb, &retries, 0))
 		goto retry;
 out:
 	posix_acl_release(acl);
@@ -415,7 +415,8 @@ retry:
 		return PTR_ERR(handle);
 	error = ext3_set_acl(handle, inode, type, acl);
 	ext3_journal_stop(handle);
-	if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
+	if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb,
+							&retries, 0))
 		goto retry;
 
 release_and_out:
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 6386d76..5f851ff 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1458,6 +1458,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
  * ext3_should_retry_alloc()
  * @sb:			super block
  * @retries		number of attemps has been made
+ * @data		allocating (data=1 or metadata=0)
  *
  * ext3_should_retry_alloc() is called when ENOSPC is returned, and if
  * it is profitable to retry the operation, this function will wait
@@ -1466,10 +1467,15 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
  *
  * if the total number of retries exceed three times, return FALSE.
  */
-int ext3_should_retry_alloc(struct super_block *sb, int *retries)
+int ext3_should_retry_alloc(struct super_block *sb, int *retries, int data)
 {
-	if (!ext3_has_free_blocks(EXT3_SB(sb)) || (*retries)++ > 3)
+	if ((data && !ext3_has_free_blocks(EXT3_SB(sb))) || ++(*retries) >= 3) {
+		if (data)
+			fs_nl_send_warning(sb->s_dev, FS_NL_ENOSPC_WARN);
+		else
+			fs_nl_send_warning(sb->s_dev, FS_NL_META_ENOSPC_WARN);
 		return 0;
+	}
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 04da6ac..6c5f69d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1305,7 +1305,7 @@ write_begin_failed:
 		if (pos + len > inode->i_size)
 			ext3_truncate_failed_write(inode);
 	}
-	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries, 1))
 		goto retry;
 out:
 	return ret;
@@ -1889,7 +1889,7 @@ retry:
 		if (end > isize)
 			ext3_truncate_failed_direct_write(inode);
 	}
-	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries, 1))
 		goto retry;
 
 	if (orphan) {
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 5571708..9abaebf 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1725,7 +1725,7 @@ retry:
 		err = ext3_add_nondir(handle, dentry, inode);
 	}
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
@@ -1762,7 +1762,7 @@ retry:
 		err = ext3_add_nondir(handle, dentry, inode);
 	}
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
@@ -1849,7 +1849,7 @@ out_clear_inode:
 out_stop:
 	brelse(dir_block);
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
@@ -2287,7 +2287,7 @@ retry:
 	err = ext3_add_nondir(handle, dentry, inode);
 out_stop:
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 err_drop_inode:
@@ -2330,7 +2330,7 @@ retry:
 		iput(inode);
 	}
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7beb69a..d4d6124 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -3077,6 +3077,7 @@ static int __init init_ext3_fs(void)
         err = register_filesystem(&ext3_fs_type);
 	if (err)
 		goto out;
+	init_fs_nl_family();
 	return 0;
 out:
 	destroy_inodecache();
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index d565759..431db28 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -1072,7 +1072,7 @@ retry:
 					      value, value_len, flags);
 		error2 = ext3_journal_stop(handle);
 		if (error == -ENOSPC &&
-		    ext3_should_retry_alloc(inode->i_sb, &retries))
+		    ext3_should_retry_alloc(inode->i_sb, &retries, 0))
 			goto retry;
 		if (error == 0)
 			error = error2;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 67a803a..34daec8 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -861,7 +861,8 @@ extern void ext3_check_blocks_bitmap (struct super_block *);
 extern struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 						    unsigned int block_group,
 						    struct buffer_head ** bh);
-extern int ext3_should_retry_alloc(struct super_block *sb, int *retries);
+extern int ext3_should_retry_alloc(struct super_block *sb, int *retries,
+				   int data);
 extern void ext3_init_block_alloc_info(struct inode *);
 extern void ext3_rsv_window_add(struct super_block *sb, struct ext3_reserve_window_node *rsv);
 extern int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range);
-- 
1.7.4.4

