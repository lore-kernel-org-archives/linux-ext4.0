From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V3 3/4] ext4: add EXT4_IOC_GET_PA to get inode PA information
Date: Wed, 01 Dec 2010 15:06:50 +0900
Message-ID: <4CF5E5FA.70602@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65268 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0LAGNH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 01:13:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This ioctl gets the information of all inode PAs in the target inode.
The interface of this ioctl is like FS_IOC_FIEMAP. If we call this ioctl, we
get the array of struct ext4_prealloc_info that stores the information of inode
PA.

 INTERFACE
-----------

#define EXT4_IOC_GET_PA		_IOWR('f', 17, struct ext4_prealloc_list)

struct ext4_prealloc_list {
	__u32 pl_count;		/* size of pl_space array (in) */
	__u32 pl_mapped;	/* number of PAs that were mapped (out) */
	__u32 pl_entries;	/* number of PAs the inode has (out) */
	struct ext4_prealloc_info pl_space[0];	/* array of mapped PAs (out) */
};

pl_count specifies the number of elements in the pl_space[] array that can be
used to return inode PAs. If pl_count is zero, no inode PAs will be returned.
Moreover, if pl_count is set the value that is better than the number of
elements in the pl_space array, this ioctl returns EFAULT.

pl_mapped shows the number of getting inode PAs, and pl_entries shows the
number of inode PAs in the target inode. You can confirm that we could get all
inode PAs in the target inode by comparison with pl_mapped and pl_entries.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/ext4.h    |   11 +++++++++++
 fs/ext4/ioctl.c   |   33 +++++++++++++++++++++++++++++++++
 fs/ext4/mballoc.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4094ae7..67901a5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -147,6 +147,14 @@ struct ext4_prealloc_info {
 	__u16 pi_flags;		/* flags for the inode PA setting ioctl (in) */
 };
 
+/* inode PA list */
+struct ext4_prealloc_list {
+	__u32 pl_count;		/* size of pl_space array (in) */
+	__u32 pl_mapped;	/* number of PAs that were mapped (out) */
+	__u32 pl_entries;	/* number of PAs the inode has (out) */
+	struct ext4_prealloc_info pl_space[0];	/* array of mapped PAs (out) */
+};
+
 /*
  * Logical to physical block mapping, used by ext4_map_blocks()
  *
@@ -558,6 +566,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 #define EXT4_IOC_CONTROL_PA		_IOWR('f', 16, struct ext4_prealloc_info)
+#define EXT4_IOC_GET_PA			_IOWR('f', 17, struct ext4_prealloc_list)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -1710,6 +1719,8 @@ extern int ext4_mb_add_groupinfo(struct super_block *sb,
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
 extern int ext4_mb_control_pa(struct inode *inode,
 				struct ext4_prealloc_info *pi);
+extern int ext4_mb_get_pa(struct inode *inode, struct ext4_prealloc_list *pl,
+				struct ext4_prealloc_info *dest);
 
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a207691..79daf56 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -448,6 +448,38 @@ mext_out:
 		return err;
 	}
 
+	case EXT4_IOC_GET_PA:
+	{
+		struct ext4_prealloc_list pl;
+		struct ext4_prealloc_info *dest;
+		int err;
+
+		if (!S_ISREG(inode->i_mode))
+			return -EINVAL;
+		if (!(filp->f_mode & FMODE_READ))
+			return -EBADF;
+
+		if (copy_from_user(&pl,
+			(struct ext4_prealloc_list __user *)arg, sizeof(pl)))
+			return -EFAULT;
+
+		dest = (struct ext4_prealloc_info *)(arg + sizeof(pl));
+		if (!access_ok(VERIFY_WRITE,
+			      (struct ext4_prealloc_info __force __user *)dest,
+			      pl.pl_count * sizeof(struct ext4_prealloc_info)))
+			return -EFAULT;
+
+		err = ext4_mb_get_pa(inode, &pl, dest);
+
+		if (err)
+			return err;
+
+		if (copy_to_user((struct ext4_prealloc_list __user *)arg,
+					&pl, sizeof(pl)))
+			return -EFAULT;
+		return err;
+	}
+
 	default:
 		return -ENOTTY;
 	}
@@ -516,6 +548,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_MOVE_EXT:
 	case EXT4_IOC_DEBUG_DELALLOC:
 	case EXT4_IOC_CONTROL_PA:
+	case EXT4_IOC_GET_PA:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cf501b3..0d727e8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5277,3 +5277,47 @@ out:
 	return err1;
 }
 
+/**
+ * ext4_mb_get_pa - Pass inode PA information to user space
+ *
+ * @inode:	target inode
+ * @pl:		information of the inode PA list (in/out)
+ * @dest:	user space address where PAs' information is written to
+ *
+ * Return 0 if success or error code on failure.
+ */
+int ext4_mb_get_pa(struct inode *inode, struct ext4_prealloc_list *pl,
+		   struct ext4_prealloc_info *dest)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_prealloc_space *pa;
+	struct ext4_prealloc_info pi;
+
+	pl->pl_entries = 0;
+	pl->pl_mapped = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
+		pl->pl_entries++;
+		if (pl->pl_mapped < pl->pl_count) {
+			memset(&pi, 0, sizeof(pi));
+			pi.pi_pstart = pa->pa_pstart;
+			pi.pi_lstart = pa->pa_lstart;
+			pi.pi_len = pa->pa_len;
+			pi.pi_free = pa->pa_free;
+
+			rcu_read_unlock();
+			if (copy_to_user(
+			       (struct ext4_prealloc_info __force __user *)dest,
+							&pi, sizeof(pi))) {
+				return -EFAULT;
+			}
+			dest++;
+			pl->pl_mapped++;
+			rcu_read_lock();
+		}
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
