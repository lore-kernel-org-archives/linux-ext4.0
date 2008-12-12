From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH V2 2/2]QUOTA cleanup:Move EXPORT_SYMBOL immediatlely next
	to the functions/varibles
Date: Fri, 12 Dec 2008 12:48:26 -0800
Message-ID: <1229114906.7646.30.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:60586 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYLLUsi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 15:48:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

quota: Move EXPORT_SYMBOL immediatlely next to the functions/varibles
From: Mingming Cao <cmm@us.ibm.com>

According to checkpatch: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Updated with KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> compile fix.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/dquot.c |   69 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

Index: linux-2.6.28-rc2/fs/dquot.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/dquot.c	2008-12-12 12:21:49.000000000 -0800
+++ linux-2.6.28-rc2/fs/dquot.c	2008-12-12 12:35:36.000000000 -0800
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
 
 static void dqput(struct dquot *dquot);
 
@@ -306,6 +310,7 @@ int dquot_mark_dquot_dirty(struct dquot 
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 
 /* This function needs dq_list_lock */
 static inline int clear_dquot_dirty(struct dquot *dquot)
@@ -357,6 +362,7 @@ out_iolock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_acquire);
 
 /*
  *	Write dquot to disk
@@ -386,6 +392,7 @@ out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit);
 
 /*
  *	Release dquot
@@ -414,6 +421,7 @@ out_dqlock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_release);
 
 static void destroy_dquot(struct dquot *dquot)
 {
@@ -522,6 +530,7 @@ int vfs_quota_sync(struct super_block *s
 
 	return 0;
 }
+EXPORT_SYMBOL(vfs_quota_sync);
 
 /* Free unused dquots from cache */
 static void prune_dqcache(int count)
@@ -1200,6 +1209,7 @@ out_err:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_initialize);
 
 /*
  * 	Release all quotas referenced by inode
@@ -1219,6 +1229,7 @@ int dquot_drop(struct inode *inode)
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop);
 
 /* Wrapper to remove references to quota structures from inode */
 void vfs_dq_drop(struct inode *inode)
@@ -1241,6 +1252,7 @@ void vfs_dq_drop(struct inode *inode)
 			inode->i_sb->dq_op->drop(inode);
 	}
 }
+EXPORT_SYMBOL(vfs_dq_drop);
 
 /*
  * Following four functions update i_blocks+i_bytes fields and
@@ -1317,6 +1329,7 @@ out_unlock:
 out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_space);
 
 int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
 {
@@ -1335,6 +1348,7 @@ out_unlock:
 out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_reserve_space);
 
 int dquot_claim_space(struct inode *inode, qsize_t number)
 {
@@ -1371,6 +1385,7 @@ int dquot_claim_space(struct inode *inod
 out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_claim_space);
 
 /*
  * Release reserved quota space
@@ -1402,6 +1417,7 @@ out_unlock:
 out:
 	return;
 }
+EXPORT_SYMBOL(dquot_release_reserved_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1447,6 +1463,7 @@ warn_put_all:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_inode);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1487,6 +1504,7 @@ out_sub:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1523,6 +1541,7 @@ int dquot_free_inode(const struct inode 
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_inode);
 
 /*
  * Transfer the number of inode and blocks from one diskquota to an other.
@@ -1640,6 +1659,7 @@ warn_put_all:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_transfer);
 
 /* Wrapper for transferring ownership of an inode */
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
@@ -1651,7 +1671,7 @@ int vfs_dq_transfer(struct inode *inode,
 	}
 	return 0;
 }
-
+EXPORT_SYMBOL(vfs_dq_transfer);
 
 /*
  * Write info of quota file to disk
@@ -1666,6 +1686,7 @@ int dquot_commit_info(struct super_block
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit_info);
 
 /*
  * Definitions of diskquota operations.
@@ -1811,12 +1832,14 @@ put_inodes:
 		}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_quota_disable);
 
 int vfs_quota_off(struct super_block *sb, int type, int remount)
 {
 	return vfs_quota_disable(sb, type, remount ? DQUOT_SUSPENDED :
 				 (DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED));
 }
+EXPORT_SYMBOL(vfs_quota_off);
 
 /*
  *	Turn quotas on on a device
@@ -1954,6 +1977,7 @@ static int vfs_quota_on_remount(struct s
 
 	return ret;
 }
+EXPORT_SYMBOL(vfs_quota_on_remount);
 
 int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
 		      struct path *path)
@@ -1970,6 +1994,7 @@ int vfs_quota_on_path(struct super_block
 					     DQUOT_LIMITS_ENABLED);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_path);
 
 int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 		 int remount)
@@ -1987,6 +2012,7 @@ int vfs_quota_on(struct super_block *sb,
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on);
 
 /*
  * More powerful function for turning on quotas allowing setting
@@ -2031,6 +2057,7 @@ out_lock:
 load_quota:
 	return vfs_load_quota_inode(inode, type, format_id, flags);
 }
+EXPORT_SYMBOL(vfs_quota_enable);
 
 /*
  * This function is used when filesystem needs to initialize quotas
@@ -2060,6 +2087,7 @@ out:
 	dput(dentry);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_mount);
 
 /* Wrapper to turn on quotas when remounting rw */
 int vfs_dq_quota_on_remount(struct super_block *sb)
@@ -2076,6 +2104,7 @@ int vfs_dq_quota_on_remount(struct super
 	}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_dq_quota_on_remount);
 
 static inline qsize_t qbtos(qsize_t blocks)
 {
@@ -2119,6 +2148,7 @@ int vfs_get_dqblk(struct super_block *sb
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqblk);
 
 /* Generic routine for setting common part of quota structure */
 static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
@@ -2202,6 +2232,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return rc;
 }
+EXPORT_SYMBOL(vfs_set_dqblk);
 
 /* Generic routine for getting common part of quota file information */
 int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2223,6 +2254,7 @@ int vfs_get_dqinfo(struct super_block *s
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqinfo);
 
 /* Generic routine for setting common part of quota file information */
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2251,6 +2283,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
+EXPORT_SYMBOL(vfs_set_dqinfo);
 
 struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,
@@ -2406,37 +2439,3 @@ static int __init dquot_init(void)
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
-EXPORT_SYMBOL(vfs_dq_drop);
-EXPORT_SYMBOL(dquot_alloc_space);
-EXPORT_SYMBOL(dquot_alloc_inode);
-EXPORT_SYMBOL(dquot_free_space);
-EXPORT_SYMBOL(dquot_free_inode);
-EXPORT_SYMBOL(dquot_reserve_space);
-EXPORT_SYMBOL(dquot_claim_space);
-EXPORT_SYMBOL(dquot_release_reserved_space);
-EXPORT_SYMBOL(dquot_transfer);
-EXPORT_SYMBOL(vfs_dq_transfer);
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);


