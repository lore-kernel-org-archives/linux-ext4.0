From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC] Flex_BG ialloc awareness.
Date: Mon, 3 Dec 2007 13:05:39 -0600
Message-ID: <20071203130539.52e096a0@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:57184 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXLCTFo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 14:05:44 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB3J5in6002694
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 14:05:44 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3J5h24106366
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 12:05:43 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB3J5hOE027280
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 12:05:43 -0700
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id lB3J5hT4027230
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 12:05:43 -0700
Received: from gara (wecm-9-67-18-163.wecm.ibm.com [9.67.18.163])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id lB3J5a55041886
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 13:05:41 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folk,

Im preparing to clean up the FLEX_BG ialloc patch for inclusion into
the patch queue and decided that might as well send the current version
of the patch to the mailing list to get any early feedback from folks.

This patch mostly controls the way inode are allocated in order to make
ialloc aware of flex_bg block group grouping.  It achieves this by
bypassing the Orlov allocator when the use of FLEX_BG is detected.
Since the impact on the block allocator is minimal, this patch should
have little or no effect on other block allocation algorithms. By
controlling the inode allocation, I can basically control where the
initial search for new block begins and thus indirectly manipulate the
block allocator.

This allocator favors data and meta-data locality so the disk will
gradually be filled from begging to end unlike the Orlov algorithm that
places a new inode anywhere on the disk where more free inodes and
blocks are available.  Since the group of inode tables within one
flex_bg are treated as one giant inode table, uninitialized block groups
would not need to partially initialize as many inode table as with Orlov
which would help fsck time as the filesystem usage goes up.

I've done testing on both SCSI and Fiber Channel attached storage
sub-systems and the performance seems to be mostly equal or better than
with the regular meta-data allocation.  Multi-threaded results on Fiber
Channel disk are very impresive though...

FFSB multi-threaded IO workload with no flexbg, flexbg with 64 groups
and flexbg with 128 groups:

ext4-normal-profile-crt-delete-append-read-small-threads_64 read :
89490 ops (5.456950%) write : 130001 ops (7.927243%)
create : 1116427 ops (68.077847%)
append : 217196 ops (13.244248%)
delete : 86813 ops (5.293711%)
5437.50 Transactions per Second
5.5% User   Time
599.9% System Time
605.4% CPU Utilization

ext4-flexbg-64-profile-crt-delete-append-read-small-threads_64
read : 124273 ops (5.462826%)
write : 181257 ops (7.967743%)
create : 1547156 ops (68.010295%)
append : 301872 ops (13.269770%)
delete : 120327 ops (5.289366%)
7559.41 Transactions per Second
7.5% User   Time
281.7% System Time
289.2% CPU Utilization

ext4-flexbg-128-profile-crt-delete-append-read-small-threads_64
read : 115689 ops (5.460529%)
write : 168328 ops (7.945093%)
create : 1441175 ops (68.023558%)
append : 280600 ops (13.244339%)
delete : 112849 ops (5.326481%)
7024.59 Transactions per Second
6.6% User   Time
296.1% System Time
302.7% CPU Utilization

Also tried Compilebench with 300 initial dirs to see if the
improvements seen in FFSB could also be seen in other benchmarks and
the results are encouraging.

Normal:
intial create total runs 50 avg 55.74 MB/s (user 1.87s sys 3.68s)
create total runs 5 avg 60.24 MB/s (user 1.91s sys 3.37s)
patch total runs 4 avg 19.33 MB/s (user 0.77s sys 3.07s)
compile total runs 7 avg 110.79 MB/s (user 0.39s sys 4.12s)
clean total runs 4 avg 633.64 MB/s (user 0.08s sys 0.64s)
read tree total runs 2 avg 11.26 MB/s (user 1.92s sys 2.70s)
read compiled tree total runs 1 avg 30.98 MB/s (user 2.44s sys 4.80s)
delete tree total runs 2 avg 4.05 seconds (user 1.31s sys 2.78s)
no runs for delete compiled tree
stat tree total runs 4 avg 3.78 seconds (user 1.35s sys 0.89s)
stat compiled tree total runs 1 avg 4.15 seconds (user 1.45s sys 1.07s)

FLEX_BG 64 groups:
intial create total runs 50 avg 71.97 MB/s (user 1.89s sys 3.82s)
create total runs 5 avg 57.35 MB/s (user 1.89s sys 4.85s)
patch total runs 4 avg 19.89 MB/s (user 0.76s sys 2.99s)
compile total runs 7 avg 116.79 MB/s (user 0.39s sys 4.17s)
clean total runs 4 avg 736.80 MB/s (user 0.07s sys 0.62s)
read tree total runs 2 avg 15.53 MB/s (user 1.97s sys 2.80s)
read compiled tree total runs 1 avg 31.59 MB/s (user 2.48s sys 5.02s)
delete tree total runs 2 avg 3.15 seconds (user 1.18s sys 2.50s)
no runs for delete compiled tree
stat tree total runs 4 avg 2.43 seconds (user 1.25s sys 0.90s)
stat compiled tree total runs 1 avg 3.13 seconds (user 1.48s sys 1.03s)


There are still a couple of things that need fixing in the patch but I
would to get some opinions as well.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b102b0e..4ece12d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -600,6 +600,7 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
 	struct ext4_sb_info *sbi;
 	int err = 0, ret;
 	ext4_grpblk_t group_freed;
+	ext4_group_t meta_group;
 
 	*pdquot_freed_blocks = 0;
 	sbi = EXT4_SB(sb);
@@ -745,6 +746,11 @@ do_more:
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
+	meta_group = ext4_meta_group(sbi, block_group);
+	spin_lock(&sbi->s_meta_groups[meta_group].meta_group_lock);
+	sbi->s_meta_groups[meta_group].free_blocks += count;
+	spin_unlock(&sbi->s_meta_groups[meta_group].meta_group_lock);
+
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
@@ -1610,6 +1616,7 @@ ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
 	unsigned short windowsz = 0;
 	ext4_group_t ngroups;
 	unsigned long num = *count;
+	ext4_group_t meta_group;
 
 	*errp = -ENOSPC;
 	sb = inode->i_sb;
@@ -1815,6 +1822,11 @@ allocated:
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
+	meta_group = ext4_meta_group(sbi, group_no);
+	spin_lock(&sbi->s_meta_groups[meta_group].meta_group_lock);
+	sbi->s_meta_groups[meta_group].free_blocks -= num;
+	spin_unlock(&sbi->s_meta_groups[meta_group].meta_group_lock);
+
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext4_journal_dirty_metadata(handle, gdp_bh);
 	if (!fatal)
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 17b5df1..4c3c738 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -158,6 +158,7 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err;
+	ext4_group_t meta_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
 		printk ("ext4_free_inode: inode has count=%d\n",
@@ -235,6 +236,12 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 			if (is_directory)
 				percpu_counter_dec(&sbi->s_dirs_counter);
 
+			meta_group = ext4_meta_group(sbi, block_group);
+			spin_lock(&sbi->s_meta_groups[meta_group].meta_group_lock);
+			sbi->s_meta_groups[meta_group].free_inodes++;
+			if (is_directory)
+				sbi->s_meta_groups[meta_group].num_dirs--;
+			spin_unlock(&sbi->s_meta_groups[meta_group].meta_group_lock);
 		}
 		BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
 		err = ext4_journal_dirty_metadata(handle, bh2);
@@ -289,6 +296,71 @@ static int find_group_dir(struct super_block *sb, struct inode *parent,
 	return ret;
 }
 
+#define free_block_ratio 10
+
+int find_group_meta(struct super_block *sb, struct inode *parent)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *desc;
+	struct buffer_head *bh;
+	struct meta_groups *meta_group = sbi->s_meta_groups;
+	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
+	ext4_group_t parent_mgroup = parent_group / sbi->s_groups_per_meta;
+	ext4_group_t ngroups = sbi->s_groups_count;
+	int meta_size = sbi->s_groups_per_meta;
+	ext4_group_t best_meta = -1;
+	ext4_group_t best_group = -1;
+	int blocks_per_meta = sbi->s_blocks_per_group * meta_size;
+	int meta_freeb_ratio;
+	ext4_group_t nmgroups;
+	ext4_group_t i;
+
+	nmgroups = (sbi->s_groups_count + meta_size - 1) / meta_size;
+	best_meta = parent_mgroup;
+
+find_close_to_parent:
+	meta_freeb_ratio = meta_group[best_meta].free_blocks*100/blocks_per_meta;
+	if (meta_group[best_meta].free_inodes &&
+	    meta_freeb_ratio > free_block_ratio)
+		goto found_meta;
+
+	if (best_meta && best_meta == parent_mgroup) {
+		best_meta--;
+		goto find_close_to_parent;
+	}
+
+	for (i = 0; i < nmgroups; i++) {
+		if (i == parent_mgroup || i == parent_mgroup - 1)
+			continue;
+
+		meta_freeb_ratio = meta_group[i].free_blocks*100/blocks_per_meta;
+
+		if (meta_freeb_ratio > free_block_ratio &&
+		    meta_group[i].free_inodes) {
+			best_meta = i;
+			break;
+		}
+
+		if (best_meta < 0 ||
+		    (meta_group[i].free_blocks >
+		     meta_group[best_meta].free_blocks &&
+		     meta_group[i].free_inodes))
+			best_meta = i;
+	}
+
+found_meta:
+	for (i = best_meta * meta_size; i < ngroups &&
+		     i < (best_meta + 1) * meta_size; i++) {
+		desc = ext4_get_group_desc(sb, i, &bh);
+		if (le16_to_cpu(desc->bg_free_inodes_count)) {
+			best_group = i;
+			goto out;
+		}
+	}
+out:
+	return best_group;
+}
+
 /*
  * Orlov's allocator for directories.
  *
@@ -504,6 +576,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
+	ext4_group_t meta_group;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -517,6 +590,12 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 
 	sbi = EXT4_SB(sb);
 	es = sbi->s_es;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		group = find_group_meta(sb, dir);
+		goto got_group;
+	}
+
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
 			ret2 = find_group_dir(sb, dir, &group);
@@ -525,6 +604,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	} else
 		ret2 = find_group_other(sb, dir, &group);
 
+got_group:
 	err = -ENOSPC;
 	if (ret2 == -1)
 		goto out;
@@ -681,6 +761,13 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
+	meta_group = ext4_meta_group(sbi, group);
+	spin_lock(&sbi->s_meta_groups[meta_group].meta_group_lock);
+	sbi->s_meta_groups[meta_group].free_inodes--;
+	if (S_ISDIR(mode))
+		sbi->s_meta_groups[meta_group].num_dirs++;
+	spin_unlock(&sbi->s_meta_groups[meta_group].meta_group_lock);
+
 	inode->i_uid = current->fsuid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b626339..ad418e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -518,6 +518,7 @@ static void ext4_put_super (struct super_block * sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
+	kfree(sbi->s_meta_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1423,6 +1424,72 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	return res;
 }
 
+static int ext4_fill_meta_info(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *gdp = NULL;
+	struct buffer_head *bh;
+	ext4_group_t meta_group_count;
+	ext4_group_t meta_group;
+	int groups_per_meta = 0;
+	int tmp = 0;
+	__u64 block_bitmap = 0, cur_block_bitmap;
+	int i;
+
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		gdp = ext4_get_group_desc(sb, i, &bh);
+		cur_block_bitmap = ext4_block_bitmap(sb, gdp);
+		if (!block_bitmap || cur_block_bitmap == block_bitmap + 1) {
+			tmp++;
+			block_bitmap = cur_block_bitmap;
+		} else {
+			groups_per_meta = tmp;
+			break;
+		}
+	}
+
+	sbi->s_groups_per_meta = groups_per_meta;
+	meta_group_count = (sbi->s_groups_count + groups_per_meta - 1) /
+		groups_per_meta;
+	sbi->s_meta_groups = kmalloc(meta_group_count *
+				     sizeof(struct meta_groups), GFP_KERNEL);
+	if (sbi->s_meta_groups == NULL) {
+		printk(KERN_ERR "EXT4-fs: not enough memory\n");
+		goto failed;
+	}
+	memset(sbi->s_meta_groups, 0, meta_group_count *
+		sizeof(struct meta_groups));
+
+	gdp = ext4_get_group_desc(sb, 1, &bh);
+	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
+
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		gdp = ext4_get_group_desc(sb, i, &bh);
+
+		if (!groups_per_meta) {
+			cur_block_bitmap = ext4_block_bitmap(sb, gdp);
+			if (cur_block_bitmap == block_bitmap+1) {
+				tmp++;
+				block_bitmap = cur_block_bitmap;
+			} else
+				groups_per_meta = tmp;
+		}
+
+		meta_group = ext4_meta_group(sbi, i);
+		spin_lock_init(&sbi->s_meta_groups[meta_group].meta_group_lock);
+		sbi->s_meta_groups[meta_group].free_inodes +=
+			le16_to_cpu(gdp->bg_free_inodes_count);
+		sbi->s_meta_groups[meta_group].free_blocks +=
+			le16_to_cpu(gdp->bg_free_blocks_count);
+		sbi->s_meta_groups[meta_group].num_dirs +=
+			le16_to_cpu(gdp->bg_used_dirs_count);
+	}
+
+	return 1;
+failed:
+	return 0;
+}
+
 __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 			    struct ext4_group_desc *gdp)
 {
@@ -2037,6 +2104,12 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		printk(KERN_ERR "EXT4-fs: group descriptors corrupted!\n");
 		goto failed_mount2;
 	}
+	if (!ext4_fill_meta_info(sb)) {
+		printk(KERN_ERR
+		       "EXT4-fs: unable to initialize flex_bg meta info!\n");
+		goto failed_mount2;
+	}
+
 	sbi->s_gdb_count = db_count;
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index bcdb59d..9aaae0a 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -152,6 +152,17 @@ struct ext4_group_desc
 	__u32	bg_reserved2[3];
 };
 
+/*
+ * Structure of a meta block group info
+ */
+
+struct meta_groups {
+	__u32 free_inodes;
+	__u32 free_blocks;
+	__u32 num_dirs;
+	spinlock_t meta_group_lock;
+};
+
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
 #define EXT4_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not in use */
 #define EXT4_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
@@ -1120,6 +1131,12 @@ static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
 	raw_inode->i_size_high = cpu_to_le32(i_size >> 32);
 }
 
+static inline ext4_group_t ext4_meta_group(struct ext4_sb_info *sbi,
+					     ext4_group_t block_group)
+{
+	return block_group/sbi->s_groups_per_meta;
+}
+
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 744e746..6ed33b9 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -147,6 +147,9 @@ struct ext4_sb_info {
 
 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
+
+	unsigned int s_groups_per_meta;
+	struct meta_groups *s_meta_groups;
 };
 #define EXT4_GROUP_INFO(sb, group)					   \
 	EXT4_SB(sb)->s_group_info[(group) >> EXT4_DESC_PER_BLOCK_BITS(sb)] \
