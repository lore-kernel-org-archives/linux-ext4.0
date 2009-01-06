From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH V5 5/5]QUOTA cleanup:Move EXPORT_SYMBOL immediatlely next
	to the functions/varibles
Date: Mon, 05 Jan 2009 20:41:34 -0800
Message-ID: <1231216894.9267.31.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

quota: Move EXPORT_SYMBOL immediatlely next to the functions/varibles

From: Mingming Cao <cmm@us.ibm.com>

According to checkpatch: EXPORT_SYMBOL(foo); should immediately follow its
 function/variable

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/dquot.c |   74 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

Index: linux-2.6.28-git7/fs/dquot.c
===================================================================
--- linux-2.6.28-git7.orig/fs/dquot.c	2009-01-05 17:26:48.000000000 -0800
+++ linux-2.6.28-git7/fs/dquot.c	2009-01-05 17:36:38.000000000 -0800
@@ -127,6 +127,7 @@
 
 static DEFINE_SPINLOCK(dq_list_lock);
 DEFINE_SPINLOCK(dq_data_lock);
+EXPORT_SYMBOL(dq_data_lock);
 
 static char *quotatypes[] = INITQFNAMES;
 static struct quota_format_type *quota_formats;	/* List of registered formats */
@@ -143,6 +144,7 @@ int register_quota_format(struct quota_f
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(register_quota_format);
 
 void unregister_quota_format(struct quota_format_type *fmt)
 {
@@ -154,6 +156,7 @@ void unregister_quota_format(struct quot
 		*actqf = (*actqf)->qf_next;
 	spin_unlock(&dq_list_lock);
 }
+EXPORT_SYMBOL(unregister_quota_format);
 
 static struct quota_format_type *find_quota_format(int id)
 {
@@ -210,6 +213,7 @@ static unsigned int dq_hash_bits, dq_has
 static struct hlist_head *dquot_hash;
 
 struct dqstats dqstats;
+EXPORT_SYMBOL(dqstats);
 
 static inline unsigned int
 hashfn(const struct super_block *sb, unsigned int id, int type)
@@ -304,6 +308,7 @@ int dquot_mark_dquot_dirty(struct dquot 
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 
 /* This function needs dq_list_lock */
 static inline int clear_dquot_dirty(struct dquot *dquot)
@@ -355,6 +360,7 @@ out_iolock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_acquire);
 
 /*
  *	Write dquot to disk
@@ -384,6 +390,7 @@ out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit);
 
 /*
  *	Release dquot
@@ -412,6 +419,7 @@ out_dqlock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_release);
 
 void dquot_destroy(struct dquot *dquot)
 {
@@ -511,6 +519,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_scan_active);
 
 int vfs_quota_sync(struct super_block *sb, int type)
 {
@@ -558,6 +567,7 @@ int vfs_quota_sync(struct super_block *s
 
 	return 0;
 }
+EXPORT_SYMBOL(vfs_quota_sync);
 
 /* Free unused dquots from cache */
 static void prune_dqcache(int count)
@@ -668,6 +678,7 @@ we_slept:
 	put_dquot_last(dquot);
 	spin_unlock(&dq_list_lock);
 }
+EXPORT_SYMBOL(dqput);
 
 struct dquot *dquot_alloc(struct super_block *sb, int type)
 {
@@ -713,6 +724,7 @@ int dquot_is_cached(struct super_block *
 	spin_unlock(&dq_list_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_is_cached);
 
 /*
  * Get reference to dquot
@@ -766,6 +778,7 @@ we_slept:
 
 	return dquot;
 }
+EXPORT_SYMBOL(dqget);
 
 static int dqinit_needed(struct inode *inode, int type)
 {
@@ -1261,6 +1274,7 @@ out_err:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_initialize);
 
 /*
  * 	Release all quotas referenced by inode
@@ -1278,6 +1292,7 @@ int dquot_drop_locked(struct inode *inod
 	}
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop_locked);
 
 int dquot_drop(struct inode *inode)
 {
@@ -1286,6 +1301,7 @@ int dquot_drop(struct inode *inode)
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop);
 
 /* Wrapper to remove references to quota structures from inode */
 void vfs_dq_drop(struct inode *inode)
@@ -1308,6 +1324,7 @@ void vfs_dq_drop(struct inode *inode)
 			inode->i_sb->dq_op->drop(inode);
 	}
 }
+EXPORT_SYMBOL(vfs_dq_drop);
 
 /*
  * Following four functions update i_blocks+i_bytes fields and
@@ -1384,6 +1401,7 @@ out_unlock:
 out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_space);
 
 int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
 {
@@ -1448,6 +1466,7 @@ warn_put_all:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_inode);
 
 int dquot_claim_space(struct inode *inode, qsize_t number)
 {
@@ -1557,6 +1576,7 @@ out_sub:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1593,6 +1613,8 @@ int dquot_free_inode(const struct inode 
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_inode);
+
 /*
  * call back function, get reserved quota space from underlying fs
  */
@@ -1722,6 +1744,7 @@ warn_put_all:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_transfer);
 
 /* Wrapper for transferring ownership of an inode */
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
@@ -1733,7 +1756,7 @@ int vfs_dq_transfer(struct inode *inode,
 	}
 	return 0;
 }
-
+EXPORT_SYMBOL(vfs_dq_transfer);
 
 /*
  * Write info of quota file to disk
@@ -1748,6 +1771,7 @@ int dquot_commit_info(struct super_block
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit_info);
 
 /*
  * Definitions of diskquota operations.
@@ -1895,13 +1919,14 @@ put_inodes:
 		}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_quota_disable);
 
 int vfs_quota_off(struct super_block *sb, int type, int remount)
 {
 	return vfs_quota_disable(sb, type, remount ? DQUOT_SUSPENDED :
 				 (DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED));
 }
-
+EXPORT_SYMBOL(vfs_quota_off);
 /*
  *	Turn quotas on on a device
  */
@@ -2054,6 +2079,7 @@ int vfs_quota_on_path(struct super_block
 					     DQUOT_LIMITS_ENABLED);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_path);
 
 int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 		 int remount)
@@ -2071,6 +2097,7 @@ int vfs_quota_on(struct super_block *sb,
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on);
 
 /*
  * More powerful function for turning on quotas allowing setting
@@ -2115,6 +2142,7 @@ out_lock:
 load_quota:
 	return vfs_load_quota_inode(inode, type, format_id, flags);
 }
+EXPORT_SYMBOL(vfs_quota_enable);
 
 /*
  * This function is used when filesystem needs to initialize quotas
@@ -2144,6 +2172,7 @@ out:
 	dput(dentry);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_mount);
 
 /* Wrapper to turn on quotas when remounting rw */
 int vfs_dq_quota_on_remount(struct super_block *sb)
@@ -2160,6 +2189,7 @@ int vfs_dq_quota_on_remount(struct super
 	}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_dq_quota_on_remount);
 
 static inline qsize_t qbtos(qsize_t blocks)
 {
@@ -2203,6 +2233,7 @@ int vfs_get_dqblk(struct super_block *sb
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqblk);
 
 /* Generic routine for setting common part of quota structure */
 static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
@@ -2296,6 +2327,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return rc;
 }
+EXPORT_SYMBOL(vfs_set_dqblk);
 
 /* Generic routine for getting common part of quota file information */
 int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2317,6 +2349,7 @@ int vfs_get_dqinfo(struct super_block *s
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqinfo);
 
 /* Generic routine for setting common part of quota file information */
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2345,6 +2378,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
+EXPORT_SYMBOL(vfs_set_dqinfo);
 
 struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,
@@ -2500,39 +2534,3 @@ static int __init dquot_init(void)
 	return 0;
 }
 module_init(dquot_init);
-
-EXPORT_SYMBOL(register_quota_format);
-EXPORT_SYMBOL(unregister_quota_format);
-EXPORT_SYMBOL(dqstats);
-EXPORT_SYMBOL(dq_data_lock);
-EXPORT_SYMBOL(vfs_quota_enable);
-EXPORT_SYMBOL(vfs_quota_on);
-EXPORT_SYMBOL(vfs_quota_on_path);
-EXPORT_SYMBOL(vfs_quota_on_mount);
-EXPORT_SYMBOL(vfs_quota_disable);
-EXPORT_SYMBOL(vfs_quota_off);
-EXPORT_SYMBOL(dquot_scan_active);
-EXPORT_SYMBOL(vfs_quota_sync);
-EXPORT_SYMBOL(vfs_get_dqinfo);
-EXPORT_SYMBOL(vfs_set_dqinfo);
-EXPORT_SYMBOL(vfs_get_dqblk);
-EXPORT_SYMBOL(vfs_set_dqblk);
-EXPORT_SYMBOL(dquot_commit);
-EXPORT_SYMBOL(dquot_commit_info);
-EXPORT_SYMBOL(dquot_acquire);
-EXPORT_SYMBOL(dquot_release);
-EXPORT_SYMBOL(dquot_mark_dquot_dirty);
-EXPORT_SYMBOL(dquot_initialize);
-EXPORT_SYMBOL(dquot_drop);
-EXPORT_SYMBOL(dquot_drop_locked);
-EXPORT_SYMBOL(vfs_dq_drop);
-EXPORT_SYMBOL(dqget);
-EXPORT_SYMBOL(dqput);
-EXPORT_SYMBOL(dquot_is_cached);
-EXPORT_SYMBOL(dquot_alloc_space);
-EXPORT_SYMBOL(dquot_alloc_inode);
-EXPORT_SYMBOL(dquot_free_space);
-EXPORT_SYMBOL(dquot_free_inode);
-EXPORT_SYMBOL(dquot_transfer);
-EXPORT_SYMBOL(vfs_dq_transfer);
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);


