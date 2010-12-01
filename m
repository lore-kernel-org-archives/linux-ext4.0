From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V3 1/4] ext4: add EXT4_IOC_CONTROL_PA to create/discard
 inode PA
Date: Wed, 01 Dec 2010 15:06:42 +0900
Message-ID: <4CF5E5F2.9080007@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43469 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0LAGMc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 01:12:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_IOC_CONTROL_PA allows to create new inode PA based on the specified range,
or to discard all inode PAs in the target inode.

 INTERFACE
-----------

#define EXT4_IOC_CONTROL_PA	_IOWR('f', 16, struct ext4_prealloc_info)

struct ext4_prealloc_info {
	__u64 pi_pstart; /* physical offset for the start of the PA from
			  * the beginning of the file (in/out) */
	__u32 pi_lstart; /* logical offset for the start of the PA from
			  * the beginning of the disk (in/out) */
	__u32 pi_len;	 /* length for this PA (in/out) */
	__u32 pi_free;	 /* the number of free blocks in this PA (out) */
	__u16 pi_flags;	 /* flags for the inode PA setting ioctl (in) */
};

This ioctl has three modes by setting the following flags to pi_flags:

- EXT4_MB_MANDATORY
  Create the specified inode PA to the target inode. If the block allocation
  cannot allocate the specified range, this ioctl returns -ENOSPC.

- EXT4_MB_ADVISORY
  Create the specified inode PA to the target inode. If the block allocation
  cannot allocate the specified range, this ioctl creates an inode PA allocated
  in the different range.

- EXT4_MB_DISCARD_PA
  Discard all inode PAs in the target inode.

This ioctl returns struct ext4_prealloc_info. pi_pstart shows where to create
the inode PA, and pi_len shows how many blocks it allocates. If we call this
ioctl with EXT4_MB_MANDATORY flag and the specified range cannot be allocated,
this ioctl returns struct ext4_prealloc_info to give free space information
near the specified range.

 NOTE
------

This ioctl is limited to create up to 1024 inode PAs.
Because I'm afraid to increase memory usage if there is no limit.

#define EXT4_MAX_PREALLOC	1024

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/ext4.h         |   21 ++
 fs/ext4/ext4_extents.h |    4 
 fs/ext4/extents.c      |    2 
 fs/ext4/inode.c        |    2 
 fs/ext4/ioctl.c        |   29 ++++
 fs/ext4/mballoc.c      |  345 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/mballoc.h      |    8 +
 7 files changed, 392 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3069a1b..4094ae7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -108,6 +108,8 @@ typedef unsigned int ext4_group_t;
 #define EXT4_MB_DELALLOC_RESERVED	0x0400
 /* We are doing stream allocation */
 #define EXT4_MB_STREAM_ALLOC		0x0800
+/* create an inode PA that has only free blocks */
+#define EXT4_MB_HINT_PA_ONLY		0x1000
 
 
 struct ext4_allocation_request {
@@ -131,6 +133,20 @@ struct ext4_allocation_request {
 	unsigned int flags;
 };
 
+/* The maximum number of inode PAs that EXT4_IOC_CONTROL_PA can create */
+#define EXT4_MAX_PREALLOC	1024
+
+/* inode PA information */
+struct ext4_prealloc_info {
+	__u64 pi_pstart;	/* physical offset for the start of the PA from
+				 * the beginning of the file (in/out) */
+	__u32 pi_lstart;	/* logical offset for the start of the PA from
+				 * the beginning of the disk (in/out) */
+	__u32 pi_len;		/* length for this PA (in/out) */
+	__u32 pi_free;		/* the number of free blocks in this PA (out) */
+	__u16 pi_flags;		/* flags for the inode PA setting ioctl (in) */
+};
+
 /*
  * Logical to physical block mapping, used by ext4_map_blocks()
  *
@@ -541,6 +557,7 @@ struct ext4_new_group_data {
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
+#define EXT4_IOC_CONTROL_PA		_IOWR('f', 16, struct ext4_prealloc_info)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -1691,6 +1708,8 @@ extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
+extern int ext4_mb_control_pa(struct inode *inode,
+				struct ext4_prealloc_info *pi);
 
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
@@ -1726,6 +1745,8 @@ extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
+extern int ext4_ind_map_blocks(handle_t *, struct inode *,
+					struct ext4_map_blocks *, int);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 28ce70f..6d0ea53 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -291,5 +291,9 @@ extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
 							struct ext4_ext_path *);
 extern void ext4_ext_drop_refs(struct ext4_ext_path *);
 extern int ext4_ext_check_inode(struct inode *inode);
+extern unsigned int ext4_ext_check_overlap(struct inode *,
+						struct ext4_extent *,
+						struct ext4_ext_path *);
+
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..28f847e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1584,7 +1584,7 @@ static int ext4_ext_try_to_merge(struct inode *inode,
  * such that there will be no overlap, and then returns 1.
  * If there is no overlap found, it returns 0.
  */
-static unsigned int ext4_ext_check_overlap(struct inode *inode,
+unsigned int ext4_ext_check_overlap(struct inode *inode,
 					   struct ext4_extent *newext,
 					   struct ext4_ext_path *path)
 {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b4236d4..f78e7cb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -940,7 +940,7 @@ err_out:
  * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system
  * blocks.
  */
-static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
+int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map,
 			       int flags)
 {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1aae42d..a207691 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -419,6 +419,34 @@ mext_out:
 		return 0;
 	}
 
+	case EXT4_IOC_CONTROL_PA:
+	{
+		struct ext4_prealloc_info pi;
+		int err;
+
+		if (!S_ISREG(inode->i_mode))
+			return -EINVAL;
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+
+		if (copy_from_user(&pi,
+			(struct ext4_prealloc_info __user *)arg, sizeof(pi)))
+			return -EFAULT;
+
+		err = ext4_mb_control_pa(inode, &pi);
+
+		/*
+		 * If ext4_mb_control_pa() returns ENOSPC, we need the
+		 * free space information of buddy bitmap to retry.
+		 */
+		if (err && err != -ENOSPC)
+			return err;
+
+		if (copy_to_user((struct ext4_prealloc_info __user *)arg,
+					&pi, sizeof(pi)))
+			return -EFAULT;
+		return err;
+	}
 
 	default:
 		return -ENOTTY;
@@ -487,6 +515,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 	case EXT4_IOC_MOVE_EXT:
 	case EXT4_IOC_DEBUG_DELALLOC:
+	case EXT4_IOC_CONTROL_PA:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5b4d4e3..e8effb6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -22,6 +22,7 @@
  */
 
 #include "mballoc.h"
+#include "ext4_extents.h"
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <trace/events/ext4.h>
@@ -3426,8 +3427,13 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	struct ext4_group_info *grp;
 	struct ext4_inode_info *ei;
 
-	/* preallocate only when found space is larger then requested */
-	BUG_ON(ac->ac_o_ex.fe_len >= ac->ac_b_ex.fe_len);
+	if (ac->ac_flags & EXT4_MB_HINT_PA_ONLY) {
+		/* EXT4_MB_HINT_PA_ONLY makes all found space preallocated */
+		BUG_ON(ac->ac_b_ex.fe_len <= 0);
+	} else {
+		/* preallocate only when found space is larger then requested */
+		BUG_ON(ac->ac_o_ex.fe_len >= ac->ac_b_ex.fe_len);
+	}
 	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
 	BUG_ON(!S_ISREG(ac->ac_inode->i_mode));
 
@@ -3435,7 +3441,8 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	if (pa == NULL)
 		return -ENOMEM;
 
-	if (ac->ac_b_ex.fe_len < ac->ac_g_ex.fe_len) {
+	if (!(ac->ac_flags & EXT4_MB_HINT_PA_ONLY) &&
+	    ac->ac_b_ex.fe_len < ac->ac_g_ex.fe_len) {
 		int winl;
 		int wins;
 		int win;
@@ -3475,7 +3482,12 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	pa->pa_pstart = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
 	pa->pa_len = ac->ac_b_ex.fe_len;
 	pa->pa_free = pa->pa_len;
-	atomic_set(&pa->pa_count, 1);
+	if (!(ac->ac_flags & EXT4_MB_HINT_PA_ONLY)) {
+		atomic_set(&pa->pa_count, 1);
+	} else {
+		/* EXT4_MB_HINT_PA_ONLY doesn't allocate blocks */
+		atomic_set(&pa->pa_count, 0);
+	}
 	spin_lock_init(&pa->pa_lock);
 	INIT_LIST_HEAD(&pa->pa_inode_list);
 	INIT_LIST_HEAD(&pa->pa_group_list);
@@ -3486,7 +3498,8 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 	trace_ext4_mb_new_inode_pa(ac, pa);
 
-	ext4_mb_use_inode_pa(ac, pa);
+	if (!(ac->ac_flags & EXT4_MB_HINT_PA_ONLY))
+		ext4_mb_use_inode_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
 
 	ei = EXT4_I(ac->ac_inode);
@@ -4265,7 +4278,7 @@ static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
 ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 				struct ext4_allocation_request *ar, int *errp)
 {
-	int freed;
+	int freed, length_check;
 	struct ext4_allocation_context *ac = NULL;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
@@ -4291,6 +4304,15 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		 * and verify allocation doesn't exceed the quota limits.
 		 */
 		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
+			/*
+			 * In this case, we want a PA that is equal to ar->len.
+			 * So don't adjust ar->len
+			 */
+			if ((ar->flags & EXT4_MB_HINT_PA_ONLY) &&
+					(ar->flags & EXT4_MB_HINT_GOAL_ONLY)) {
+				ar->len = 0;
+				break;
+			}
 			/* let others to free the space */
 			yield();
 			ar->len = ar->len >> 1;
@@ -4301,6 +4323,15 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		}
 		reserv_blks = ar->len;
 		while (ar->len && dquot_alloc_block(ar->inode, ar->len)) {
+			/*
+			 * In this case, we want a PA that is equal to ar->len.
+			 * So don't adjust ar->len
+			 */
+			if ((ar->flags & EXT4_MB_HINT_PA_ONLY) &&
+					(ar->flags & EXT4_MB_HINT_GOAL_ONLY)) {
+				ar->len = 0;
+				break;
+			}
 			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
 			ar->len--;
 		}
@@ -4334,15 +4365,26 @@ repeat:
 		if (*errp)
 			goto errout;
 
-		/* as we've just preallocated more space than
-		 * user requested orinally, we store allocated
-		 * space in a special descriptor */
-		if (ac->ac_status == AC_STATUS_FOUND &&
-				ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len)
+		if (ac->ac_flags & EXT4_MB_HINT_PA_ONLY) {
+			/*
+			 * In EXT4_MB_HINT_PA_ONLY case, all of the found
+			 * blocks are new PA space.
+			 */
+			length_check = (ac->ac_b_ex.fe_len > 0);
+		} else {
+			/* as we've just preallocated more space than
+			 * user requested orinally, we store allocated
+			 * space in a special descriptor */
+			length_check =
+				(ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len);
+		}
+		if (ac->ac_status == AC_STATUS_FOUND && length_check)
 			ext4_mb_new_preallocation(ac);
 	}
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
-		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_blks);
+		if (!(ac->ac_flags & EXT4_MB_HINT_PA_ONLY))
+			*errp = ext4_mb_mark_diskspace_used(ac, handle,
+								reserv_blks);
 		if (*errp == -EAGAIN) {
 			/*
 			 * drop the reference that we took
@@ -4362,9 +4404,12 @@ repeat:
 			ar->len = ac->ac_b_ex.fe_len;
 		}
 	} else {
-		freed  = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
-		if (freed)
-			goto repeat;
+		if (!(ac->ac_flags & EXT4_MB_HINT_PA_ONLY)) {
+			freed  = ext4_mb_discard_preallocations(sb,
+							ac->ac_o_ex.fe_len);
+			if (freed)
+				goto repeat;
+		}
 		*errp = -ENOSPC;
 	}
 
@@ -4377,9 +4422,11 @@ repeat:
 out:
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
-	if (inquota && ar->len < inquota)
+	if (inquota && (ar->flags & EXT4_MB_HINT_PA_ONLY))
+		dquot_free_block(ar->inode, inquota);
+	else if (inquota && ar->len < inquota)
 		dquot_free_block(ar->inode, inquota - ar->len);
-	if (!ar->len) {
+	if (!ar->len || (ar->flags & EXT4_MB_HINT_PA_ONLY)) {
 		if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
 			/* release all the reserved blocks if non delalloc */
 			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
@@ -4870,3 +4917,267 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	return ret;
 }
+
+/**
+ * ext4_mb_check_offset_overlap - Check file offset overlap
+ *
+ * @inode:	target inode
+ * @lstart:	start file offset
+ * @len:	the number of blocks to check overlap
+ *
+ * This function checks whether specified file offset has
+ * allocated/pre-allocated blocks or not. Return 0 if there is no allocated
+ * block in the range, return -EINVAL if there are some allocated blocks,
+ * or an error code on failure.
+ */
+static int ext4_mb_check_offset_overlap(struct inode *inode,
+					ext4_lblk_t lstart, unsigned int len)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_prealloc_space *pa;
+	struct ext4_map_blocks map;
+	int retval = 0;
+
+	map.m_lblk = lstart;
+	map.m_len = 1;
+
+	/* check allocated blocks */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		retval = ext4_ext_map_blocks(NULL, inode, &map, 0);
+		if (retval) {
+			goto out;
+		} else {
+			struct ext4_ext_path *path = NULL;
+			struct ext4_extent newex;
+
+			path = ext4_ext_find_extent(inode, lstart, path);
+			if (IS_ERR(path)) {
+				retval = PTR_ERR(path);
+				goto out;
+			}
+
+			newex.ee_block = cpu_to_le32(lstart);
+			newex.ee_len = cpu_to_le16(len);
+			retval = ext4_ext_check_overlap(inode, &newex, path);
+
+			ext4_ext_drop_refs(path);
+			kfree(path);
+
+			if (retval)
+				goto out;
+		}
+	} else {
+		/* with non-extent format, check one block at a time */
+		while (map.m_lblk < lstart + len) {
+			retval = ext4_ind_map_blocks(NULL, inode, &map, 0);
+			if (retval)
+				goto out;
+			map.m_lblk++;
+		}
+	}
+
+	/* check pre-allocated blocks */
+	rcu_read_lock();
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
+		if (!(pa->pa_lstart + pa->pa_len <= lstart ||
+				pa->pa_lstart >= lstart + len)) {
+			retval = 1;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+out:
+	if (retval > 0) {
+		ext4_debug("Offset %u is already allocated block [inode %lu]\n",
+					lstart, inode->i_ino);
+		retval = -EINVAL;
+	}
+
+	return retval;
+}
+
+/**
+ * ext4_mb_control_pa - Set the inode PA or discard all inode PA
+ *
+ * @inode:	target inode
+ * @pi:		the information of the inode PA and flags
+ *
+ * Return 0 if successful or a negative value on failure.
+ */
+int ext4_mb_control_pa(struct inode *inode, struct ext4_prealloc_info *pi)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_allocation_request ar;
+	struct ext4_prealloc_space *tmp;
+	ext4_group_t group, end_group;
+	ext4_fsblk_t blkcount = ext4_blocks_count(EXT4_SB(sb)->s_es);
+	ext4_fsblk_t blocks = 0;
+	ext4_grpblk_t pa_off, end_off;
+	handle_t *handle;
+	loff_t maxbytes;
+	int flag_count;
+	int bsbits = EXT4_BLOCK_SIZE_BITS(sb);
+	int pa_count = 0;
+	int i, err1;
+
+	flag_count = ((pi->pi_flags & EXT4_MB_MANDATORY) > 0) +
+				((pi->pi_flags & EXT4_MB_ADVISORY) > 0) +
+				((pi->pi_flags & EXT4_MB_DISCARD_PA) > 0);
+	if (flag_count != 1) {
+		ext4_debug("pi_flags should be set only one flag "
+				"[inode %lu]\n", inode->i_ino);
+		return -EINVAL;
+	}
+
+	if (pi->pi_flags & EXT4_MB_DISCARD_PA) {
+		down_write(&ei->i_data_sem);
+		ext4_discard_preallocations(inode);
+		up_write(&ei->i_data_sem);
+		return 0;
+	}
+
+	/* calculate block group number of PA start and end block */
+	ext4_get_group_no_and_offset(sb, pi->pi_pstart, &group, &pa_off);
+	ext4_get_group_no_and_offset(sb, pi->pi_pstart + pi->pi_len - 1,
+							&end_group, &end_off);
+
+	/* Get maximum file size */
+	maxbytes = ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ?
+				sb->s_maxbytes : EXT4_SB(sb)->s_bitmap_maxbytes;
+
+	/* The "-10" takes into account some metadata blocks */
+	if (pi->pi_len > EXT4_BLOCKS_PER_GROUP(sb) - 10) {
+		ext4_debug("pi_len should not be more than %lu [inode %lu]\n",
+				EXT4_BLOCKS_PER_GROUP(sb) - 10, inode->i_ino);
+		return -EINVAL;
+	} else if ((pi->pi_flags & EXT4_MB_MANDATORY) && (group != end_group)) {
+		ext4_debug("pi_len steps over BG boundary (%u blocks over) "
+				"[inode %lu]\n", end_off + 1, inode->i_ino);
+		return -EINVAL;
+	} else if (!pi->pi_len) {
+		ext4_debug("pi_len cannot be set 0 because the length of PA"
+				"is more than one block [inode %lu]\n",
+				inode->i_ino);
+		return -EINVAL;
+	} else if ((pi->pi_flags & EXT4_MB_MANDATORY) &&
+			((pi->pi_pstart > (1ULL << 48) - 1) ||
+			(pi->pi_pstart + pi->pi_len > blkcount))) {
+		ext4_debug("pi_pstart is too big: pi_pstart = %llu pi_len = %u"
+				" [inode %lu]\n", pi->pi_pstart,
+				pi->pi_len, inode->i_ino);
+		return -EFBIG;
+	} else if (((loff_t)pi->pi_lstart + pi->pi_len) << bsbits
+				> maxbytes) {
+		ext4_debug("pi_lstart is too big: pi_lstart = %u pi_len = %u"
+				" [inode %lu]\n", pi->pi_lstart,
+				pi->pi_len, inode->i_ino);
+		return -EINVAL;
+	}
+
+	/*
+	 * We get journal handle before locking i_data_sem for
+	 * ext4_dirty_inode() called in ext4_mb_new_blocsk().
+	 */
+	handle = ext4_journal_start(inode, 2);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	down_write(&ei->i_data_sem);
+
+	err1 = ext4_mb_check_offset_overlap(inode, pi->pi_lstart, pi->pi_len);
+	if (err1)
+		goto out;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tmp, &ei->i_prealloc_list, pa_inode_list)
+		pa_count++;
+	rcu_read_unlock();
+
+	/*
+	 * If inode PA is already created more than EXT4_MAX_PREALLOC,
+	 * EXT4_IOC_CONTROL_PA cannot create any inode PAs.
+	 */
+	if (pa_count >= EXT4_MAX_PREALLOC) {
+		err1 = -EBUSY;
+		goto out;
+	}
+
+	memset(&ar, 0, sizeof(ar));
+	ar.inode = inode;
+	ar.len = pi->pi_len;
+	ar.logical = pi->pi_lstart;
+	ar.goal = pi->pi_pstart;
+
+	ar.flags = EXT4_MB_HINT_PA_ONLY | EXT4_MB_HINT_TRY_GOAL;
+	if (pi->pi_flags & EXT4_MB_MANDATORY)
+		ar.flags |= EXT4_MB_HINT_GOAL_ONLY;
+
+	/* create inode PA */
+	blocks = ext4_mb_new_blocks(handle, &ar, &err1);
+
+out:
+	up_write(&ei->i_data_sem);
+	ext4_journal_stop(handle);
+	pi->pi_len = 0;
+
+	if (!err1) {
+		/* success creating inode PA */
+		pi->pi_pstart = blocks;
+		pi->pi_len = ar.len;
+		return 0;
+	}
+
+	if (err1 == -ENOSPC && (pi->pi_flags & EXT4_MB_MANDATORY)) {
+		struct ext4_buddy e4b;
+		ext4_group_t ngroups;
+		ext4_grpblk_t off;
+		int max, bit, err2;
+		void *buddy;
+
+		/* search free space and return its information to user space */
+		ngroups = ext4_get_groups_count(sb);
+		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+			ngroups = EXT4_SB(sb)->s_blockfile_groups;
+
+		for (i = 0, off = pa_off; i <= ngroups; i++, group++) {
+			if (group == ngroups)
+				group = 0;
+
+			err2 = ext4_mb_load_buddy(sb, group, &e4b);
+			if (err2) {
+				ext4_error(sb, "Error in loading buddy "
+						"information for %u", group);
+				continue;
+			}
+			ext4_lock_group(sb, group);
+			buddy = mb_find_buddy(&e4b, 0, &max);
+			BUG_ON(buddy == NULL);
+
+			/*
+			 * If check BG of the inode PA again, set maximum
+			 * length to avoid double checking of the first check
+			 */
+			if (i == ngroups)
+				max = pa_off;
+			bit = mb_find_next_zero_bit(buddy, max, off);
+			if (bit < max) {
+				pi->pi_pstart = ext4_group_first_block_no(sb,
+							group) + bit;
+				pi->pi_len = mb_find_next_bit(buddy,
+							max, bit) - bit;
+				ext4_unlock_group(sb, group);
+				ext4_mb_unload_buddy(&e4b);
+				break;
+			}
+			ext4_unlock_group(sb, group);
+			ext4_mb_unload_buddy(&e4b);
+
+			off = 0;
+		}
+	}
+
+	return err1;
+}
+
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index b619322..4d040a1 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -225,4 +225,12 @@ static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 {
 	return ext4_group_first_block_no(sb, fex->fe_group) + fex->fe_start;
 }
+
+/*
+ * EXT4_IOC_CONTROL_PA flags to specify its behavior
+ */
+#define EXT4_MB_MANDATORY	0x0001
+#define EXT4_MB_ADVISORY	0x0002
+#define EXT4_MB_DISCARD_PA	0x0004
+
 #endif
