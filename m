From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/5] ext4: use fs netlink interface for ENOSPC conditions
Date: Thu, 18 Aug 2011 14:18:24 +0200
Message-ID: <1313669906-14931-4-git-send-email-lczerner@redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab1HRMTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 08:19:22 -0400
In-Reply-To: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Register fs netlink interface and send proper warning if ENOSPC is
encountered. Note that we differentiate between enospc for metadata and
enospc for data.

Also fix ext4_should_retry_alloc() so we do not check for free blocks
when we are actually allocating metadata.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>
---
 fs/ext4/acl.c      |    5 +++--
 fs/ext4/balloc.c   |   15 +++++++++++----
 fs/ext4/ext4.h     |    3 ++-
 fs/ext4/extents.c  |    2 +-
 fs/ext4/indirect.c |    2 +-
 fs/ext4/inode.c    |   10 +++++-----
 fs/ext4/namei.c    |   10 +++++-----
 fs/ext4/super.c    |    1 +
 fs/ext4/xattr.c    |    2 +-
 9 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index a5c29bb..cc3e72c 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -321,7 +321,7 @@ retry:
 	error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
 	ext4_journal_stop(handle);
 	if (error == -ENOSPC &&
-	    ext4_should_retry_alloc(inode->i_sb, &retries))
+	    ext4_should_retry_alloc(inode->i_sb, &retries, 0))
 		goto retry;
 out:
 	posix_acl_release(acl);
@@ -414,7 +414,8 @@ retry:
 		return PTR_ERR(handle);
 	error = ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
-	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb,
+							&retries, 0))
 		goto retry;
 
 release_and_out:
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f8224ad..42daae7 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -426,12 +426,19 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
  *
  * if the total number of retries exceed three times, return FALSE.
  */
-int ext4_should_retry_alloc(struct super_block *sb, int *retries)
+int ext4_should_retry_alloc(struct super_block *sb, int *retries, int data)
 {
-	if (!ext4_has_free_blocks(EXT4_SB(sb), 1, 0) ||
-	    (*retries)++ > 3 ||
-	    !EXT4_SB(sb)->s_journal)
+	if ((data && !ext4_has_free_blocks(EXT4_SB(sb), 1, 0)) ||
+	    ++(*retries) >= 3 ||
+	    !EXT4_SB(sb)->s_journal) {
+		if (data)
+			fs_nl_send_warning(sb->s_dev, FS_NL_ENOSPC_WARN);
+		else
+			fs_nl_send_warning(sb->s_dev, FS_NL_META_ENOSPC_WARN);
 		return 0;
+	}
+
+
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..45cb981 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1741,7 +1741,8 @@ extern void ext4_check_blocks_bitmap(struct super_block *);
 extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 						    ext4_group_t block_group,
 						    struct buffer_head ** bh);
-extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
+extern int ext4_should_retry_alloc(struct super_block *sb, int *retries,
+				   int data);
 struct buffer_head *ext4_read_block_bitmap(struct super_block *sb,
 				      ext4_group_t block_group);
 extern unsigned ext4_init_block_bitmap(struct super_block *sb,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..1c8cb04 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3834,7 +3834,7 @@ retry:
 			break;
 	}
 	if (ret == -ENOSPC &&
-			ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			ext4_should_retry_alloc(inode->i_sb, &retries, 1)) {
 		ret = 0;
 		goto retry;
 	}
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index b8602cd..40153bc 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -817,7 +817,7 @@ retry:
 				ext4_truncate_failed_write(inode);
 		}
 	}
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries, 1))
 		goto retry;
 
 	if (orphan) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d47264c..d0596f3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -814,7 +814,7 @@ retry:
 		}
 	}
 
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries, 1))
 		goto retry;
 out:
 	return ret;
@@ -1067,7 +1067,7 @@ repeat:
 	 */
 	if (ext4_claim_free_blocks(sbi, md_needed + 1, 0)) {
 		dquot_release_reservation_block(inode, 1);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+		if (ext4_should_retry_alloc(inode->i_sb, &retries, 1)) {
 			yield();
 			goto repeat;
 		}
@@ -2291,7 +2291,7 @@ retry:
 			ext4_truncate_failed_write(inode);
 	}
 
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries, 1))
 		goto retry;
 out:
 	return ret;
@@ -4349,7 +4349,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 			ret = __block_page_mkwrite(vma, vmf,
 						   ext4_da_get_block_prep);
 		} while (ret == -ENOSPC &&
-		       ext4_should_retry_alloc(inode->i_sb, &retries));
+		       ext4_should_retry_alloc(inode->i_sb, &retries, 1));
 		goto out_ret;
 	}
 
@@ -4402,7 +4402,7 @@ retry_alloc:
 		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 	}
 	ext4_journal_stop(handle);
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries, 1))
 		goto retry_alloc;
 out_ret:
 	ret = block_page_mkwrite_return(ret);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f8068c7..5a2fe5e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1764,7 +1764,7 @@ retry:
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
@@ -1801,7 +1801,7 @@ retry:
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
@@ -1886,7 +1886,7 @@ out_clear_inode:
 out_stop:
 	brelse(dir_block);
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
@@ -2333,7 +2333,7 @@ retry:
 	err = ext4_add_nondir(handle, dentry, inode);
 out_stop:
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 err_drop_inode:
@@ -2376,7 +2376,7 @@ retry:
 		iput(inode);
 	}
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries, 0))
 		goto retry;
 	return err;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4687fea..83b7ccd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5011,6 +5011,7 @@ static int __init ext4_init_fs(void)
 
 	ext4_li_info = NULL;
 	mutex_init(&ext4_li_mtx);
+	init_fs_nl_family();
 	return 0;
 out:
 	unregister_as_ext2();
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..a3e381b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1094,7 +1094,7 @@ retry:
 					      value, value_len, flags);
 		error2 = ext4_journal_stop(handle);
 		if (error == -ENOSPC &&
-		    ext4_should_retry_alloc(inode->i_sb, &retries))
+		    ext4_should_retry_alloc(inode->i_sb, &retries, 0))
 			goto retry;
 		if (error == 0)
 			error = error2;
-- 
1.7.4.4

