From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 4/5] ext4: Use both hi and lo bits of the group
	desc values.
Date: Mon, 24 Nov 2008 16:08:02 +0530
Message-ID: <20081124103802.GA8462@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926F00D.6030403@redhat.com> <20081121174110.GH11212@skywalker> <20081124021302.GB2163@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Coly Li <coyli@suse.de>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:57364 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYKXKia (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 05:38:30 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id mAOAc4bQ016921
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 16:08:04 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAOAc56l3088636
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 16:08:05 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mAOAc3Eq010248
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 21:38:04 +1100
Content-Disposition: inline
In-Reply-To: <20081124021302.GB2163@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 23, 2008 at 09:13:02PM -0500, Theodore Tso wrote:
> On Fri, Nov 21, 2008 at 11:11:10PM +0530, Aneesh Kumar K.V wrote:
> > On Fri, Nov 21, 2008 at 11:29:49AM -0600, Eric Sandeen wrote:
> > > Aneesh Kumar K.V wrote:
> > > > Rename the lower bits with suffix _lo and add helper
> > > > to access the values. Also rename bg_itable_unused_hi
> > > > to bg_pad as in e2fsprogs. bg_itable_unused_hi is never
> > > > used before
> > > 
> > > Maybe you can add info about under which circumstances (what sort of
> > > fielsystem geometry) the hi bits are needed?  And the failure mode when
> > > we don't use them, if that's known?
> > 
> > Coly actually said it was added for inode reservation. But he agreed to
> > drop the high bits now and add them later once the performance issue
> > with the patch is addressed.
> 
> The bg_itable_unused field is used for the lazy initialization of
> inodes.  If the units of this field was blocks was blocks, we wouldn't
> need bg_itable_unused_hi for quite a larger set of blocks.
> 
> I don't think we should nuke bg_itable_unused_hi, especially given
> that we have a patch to support the kernel initializing the inodes
> (yet to be reviewed).  As near as I can tell at the time when the
> fields were added to e2fsprogs, we hadn't yet assigned the pad field
> to bg_itable_unused_hi, but it's clearly needed if we want to support
> a larger number of blocks or inodes per block group.
> 
> Instead we should create the helper functions for bg_itable_unused,
> and update e2fsprogs to also support these fields.  Adding e2fsprogs
> for large block groups is lower priority than large block numbers,
> though.

The patch already contain the helper function. Initially I had the patch
to use bg_itable_unused_hi. But later dropped it after discussion with
Coly.  Updated patch below.

ext4: Use high 16 bits of the block group descriptor's free counts fields

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Rename the lower bits with suffix _lo and add helper
to access the values. Also rename bg_itable_unused_hi
to bg_pad as in e2fsprogs.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |   13 ++++----
 fs/ext4/ext4.h    |   26 +++++++++++++----
 fs/ext4/ialloc.c  |   83 ++++++++++++++++++++++++++++-------------------------
 fs/ext4/inode.c   |    2 +
 fs/ext4/mballoc.c |   15 +++++-----
 fs/ext4/resize.c  |    4 +--
 fs/ext4/super.c   |   68 ++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 149 insertions(+), 62 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 39df492..8dd7b0d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -102,9 +102,9 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
 			ext4_error(sb, __func__,
 				  "Checksum bad for group %u\n", block_group);
-			gdp->bg_free_blocks_count = 0;
-			gdp->bg_free_inodes_count = 0;
-			gdp->bg_itable_unused = 0;
+			ext4_free_blks_set(sb, gdp, 0);
+			ext4_free_inodes_set(sb, gdp, 0);
+			ext4_itable_unused_set(sb, gdp, 0);
 			memset(bh->b_data, 0xff, sb->s_blocksize);
 			return 0;
 		}
@@ -372,7 +372,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	struct ext4_group_desc *desc;
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi;
-	int err = 0, ret;
+	int err = 0, ret, blk_free_count;
 	ext4_grpblk_t blocks_freed;
 	struct ext4_group_info *grp;
 
@@ -444,7 +444,8 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 		}
 	}
 	spin_lock(sb_bgl_lock(sbi, block_group));
-	le16_add_cpu(&desc->bg_free_blocks_count, blocks_freed);
+	blk_free_count = blocks_freed + ext4_free_blks_count(sb, desc);
+	ext4_free_blks_set(sb, desc, blk_free_count);
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);
@@ -741,7 +742,7 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		if (!gdp)
 			continue;
-		desc_count += le16_to_cpu(gdp->bg_free_blocks_count);
+		desc_count += ext4_free_blks_count(sb, gdp);
 	}
 
 	return desc_count;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f0c2e1..1f03808 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -156,12 +156,12 @@ struct ext4_group_desc
 	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
 	__le32	bg_inode_bitmap_lo;	/* Inodes bitmap block */
 	__le32	bg_inode_table_lo;	/* Inodes table block */
-	__le16	bg_free_blocks_count;	/* Free blocks count */
-	__le16	bg_free_inodes_count;	/* Free inodes count */
-	__le16	bg_used_dirs_count;	/* Directories count */
+	__le16	bg_free_blocks_count_lo;/* Free blocks count */
+	__le16	bg_free_inodes_count_lo;/* Free inodes count */
+	__le16	bg_used_dirs_count_lo;	/* Directories count */
 	__le16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
 	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
-	__le16  bg_itable_unused;	/* Unused inodes count */
+	__le16  bg_itable_unused_lo;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
 	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
@@ -169,7 +169,7 @@ struct ext4_group_desc
 	__le16	bg_free_blocks_count_hi;/* Free blocks count MSB */
 	__le16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
-	__le16	bg_itable_unused_hi;	/* Unused inodes count MSB */
+	__le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
 	__u32	bg_reserved2[3];
 };
 
@@ -1139,12 +1139,28 @@ extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 				     struct ext4_group_desc *bg);
+extern __u32 ext4_free_blks_count(struct super_block *sb,
+				struct ext4_group_desc *bg);
+extern __u32 ext4_free_inodes_count(struct super_block *sb,
+				 struct ext4_group_desc *bg);
+extern __u32 ext4_used_dirs_count(struct super_block *sb,
+				struct ext4_group_desc *bg);
+extern __u32 ext4_itable_unused_count(struct super_block *sb,
+				   struct ext4_group_desc *bg);
 extern void ext4_block_bitmap_set(struct super_block *sb,
 				  struct ext4_group_desc *bg, ext4_fsblk_t blk);
 extern void ext4_inode_bitmap_set(struct super_block *sb,
 				  struct ext4_group_desc *bg, ext4_fsblk_t blk);
 extern void ext4_inode_table_set(struct super_block *sb,
 				 struct ext4_group_desc *bg, ext4_fsblk_t blk);
+extern void ext4_free_blks_set(struct super_block *sb,
+			       struct ext4_group_desc *bg, __u32 count);
+extern void ext4_free_inodes_set(struct super_block *sb,
+				struct ext4_group_desc *bg, __u32 count);
+extern void ext4_used_dirs_set(struct super_block *sb,
+				struct ext4_group_desc *bg, __u32 count);
+extern void ext4_itable_unused_set(struct super_block *sb,
+				   struct ext4_group_desc *bg, __u32 count);
 
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4039af6..84f060b 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -76,9 +76,9 @@ unsigned ext4_init_inode_bitmap(struct super_block *sb, struct buffer_head *bh,
 	if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
 		ext4_error(sb, __func__, "Checksum bad for group %u\n",
 			   block_group);
-		gdp->bg_free_blocks_count = 0;
-		gdp->bg_free_inodes_count = 0;
-		gdp->bg_itable_unused = 0;
+		ext4_free_blks_set(sb, gdp, 0);
+		ext4_free_inodes_set(sb, gdp, 0);
+		ext4_itable_unused_set(sb, gdp, 0);
 		memset(bh->b_data, 0xff, sb->s_blocksize);
 		return 0;
 	}
@@ -168,7 +168,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	struct ext4_group_desc *gdp;
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi;
-	int fatal = 0, err;
+	int fatal = 0, err, count;
 	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
@@ -236,9 +236,12 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 
 		if (gdp) {
 			spin_lock(sb_bgl_lock(sbi, block_group));
-			le16_add_cpu(&gdp->bg_free_inodes_count, 1);
-			if (is_directory)
-				le16_add_cpu(&gdp->bg_used_dirs_count, -1);
+			count = ext4_free_inodes_count(sb, gdp) + 1;
+			ext4_free_inodes_set(sb, gdp, count);
+			if (is_directory) {
+				count = ext4_used_dirs_count(sb, gdp) - 1;
+				ext4_used_dirs_set(sb, gdp, count);
+			}
 			gdp->bg_checksum = ext4_group_desc_csum(sbi,
 							block_group, gdp);
 			spin_unlock(sb_bgl_lock(sbi, block_group));
@@ -291,13 +294,13 @@ static int find_group_dir(struct super_block *sb, struct inode *parent,
 
 	for (group = 0; group < ngroups; group++) {
 		desc = ext4_get_group_desc(sb, group, NULL);
-		if (!desc || !desc->bg_free_inodes_count)
+		if (!desc || !ext4_free_inodes_count(sb, desc))
 			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
+		if (ext4_free_inodes_count(sb, desc) < avefreei)
 			continue;
 		if (!best_desc ||
-		    (le16_to_cpu(desc->bg_free_blocks_count) >
-		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
+		    (ext4_free_blks_count(sb, desc) >
+		     ext4_free_blks_count(sb, best_desc))) {
 			*best_group = group;
 			best_desc = desc;
 			ret = 0;
@@ -369,7 +372,7 @@ static int find_group_flex(struct super_block *sb, struct inode *parent,
 	for (i = best_flex * flex_size; i < ngroups &&
 		     i < (best_flex + 1) * flex_size; i++) {
 		desc = ext4_get_group_desc(sb, i, &bh);
-		if (le16_to_cpu(desc->bg_free_inodes_count)) {
+		if (ext4_free_inodes_count(sb, desc)) {
 			*best_group = i;
 			goto out;
 		}
@@ -443,17 +446,17 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 		for (i = 0; i < ngroups; i++) {
 			grp = (parent_group + i) % ngroups;
 			desc = ext4_get_group_desc(sb, grp, NULL);
-			if (!desc || !desc->bg_free_inodes_count)
+			if (!desc || !ext4_free_inodes_count(sb, desc))
 				continue;
-			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
+			if (ext4_used_dirs_count(sb, desc) >= best_ndir)
 				continue;
-			if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
+			if (ext4_free_inodes_count(sb, desc) < avefreei)
 				continue;
-			if (le16_to_cpu(desc->bg_free_blocks_count) < avefreeb)
+			if (ext4_free_blks_count(sb, desc) < avefreeb)
 				continue;
 			*group = grp;
 			ret = 0;
-			best_ndir = le16_to_cpu(desc->bg_used_dirs_count);
+			best_ndir = ext4_used_dirs_count(sb, desc);
 		}
 		if (ret == 0)
 			return ret;
@@ -479,13 +482,13 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	for (i = 0; i < ngroups; i++) {
 		*group = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc(sb, *group, NULL);
-		if (!desc || !desc->bg_free_inodes_count)
+		if (!desc || !ext4_free_inodes_count(sb, desc))
 			continue;
-		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
+		if (ext4_used_dirs_count(sb, desc) >= max_dirs)
 			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) < min_inodes)
+		if (ext4_free_inodes_count(sb, desc) < min_inodes)
 			continue;
-		if (le16_to_cpu(desc->bg_free_blocks_count) < min_blocks)
+		if (ext4_free_blks_count(sb, desc) < min_blocks)
 			continue;
 		return 0;
 	}
@@ -494,8 +497,8 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	for (i = 0; i < ngroups; i++) {
 		*group = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc(sb, *group, NULL);
-		if (desc && desc->bg_free_inodes_count &&
-			le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
+		if (desc && ext4_free_inodes_count(sb, desc) &&
+			ext4_free_inodes_count(sb, desc) >= avefreei)
 			return 0;
 	}
 
@@ -524,8 +527,8 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 	 */
 	*group = parent_group;
 	desc = ext4_get_group_desc(sb, *group, NULL);
-	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
-			le16_to_cpu(desc->bg_free_blocks_count))
+	if (desc && ext4_free_inodes_count(sb, desc) &&
+			ext4_free_blks_count(sb, desc))
 		return 0;
 
 	/*
@@ -548,8 +551,8 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 		if (*group >= ngroups)
 			*group -= ngroups;
 		desc = ext4_get_group_desc(sb, *group, NULL);
-		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
-				le16_to_cpu(desc->bg_free_blocks_count))
+		if (desc && ext4_free_inodes_count(sb, desc) &&
+				ext4_free_blks_count(sb, desc))
 			return 0;
 	}
 
@@ -562,7 +565,7 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 		if (++*group >= ngroups)
 			*group = 0;
 		desc = ext4_get_group_desc(sb, *group, NULL);
-		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
+		if (desc && ext4_free_inodes_count(sb, desc))
 			return 0;
 	}
 
@@ -591,7 +594,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 	struct ext4_super_block *es;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int ret2, err = 0;
+	int ret2, err = 0, count;
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
@@ -717,7 +720,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			free = ext4_free_blocks_after_init(sb, group, gdp);
-			gdp->bg_free_blocks_count = cpu_to_le16(free);
+			ext4_free_blks_set(sb, gdp, free);
 			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
 								gdp);
 		}
@@ -751,7 +754,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 			free = 0;
 		} else {
 			free = EXT4_INODES_PER_GROUP(sb) -
-				le16_to_cpu(gdp->bg_itable_unused);
+				ext4_itable_unused_count(sb, gdp);
 		}
 
 		/*
@@ -761,13 +764,15 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 		 *
 		 */
 		if (ino > free)
-			gdp->bg_itable_unused =
-				cpu_to_le16(EXT4_INODES_PER_GROUP(sb) - ino);
+			ext4_itable_unused_set(sb, gdp,
+					(EXT4_INODES_PER_GROUP(sb) - ino));
 	}
 
-	le16_add_cpu(&gdp->bg_free_inodes_count, -1);
+	count = ext4_free_inodes_count(sb, gdp) - 1;
+	ext4_free_inodes_set(sb, gdp, count);
 	if (S_ISDIR(mode)) {
-		le16_add_cpu(&gdp->bg_used_dirs_count, 1);
+		count = ext4_used_dirs_count(sb, gdp) + 1;
+		ext4_used_dirs_set(sb, gdp, count);
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group));
@@ -981,7 +986,7 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		if (!gdp)
 			continue;
-		desc_count += le16_to_cpu(gdp->bg_free_inodes_count);
+		desc_count += ext4_free_inodes_count(sb, gdp);
 		brelse(bitmap_bh);
 		bitmap_bh = ext4_read_inode_bitmap(sb, i);
 		if (!bitmap_bh)
@@ -989,7 +994,7 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 
 		x = ext4_count_free(bitmap_bh, EXT4_INODES_PER_GROUP(sb) / 8);
 		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",
-			i, le16_to_cpu(gdp->bg_free_inodes_count), x);
+			i, ext4_free_inodes_count(sb, gdp), x);
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
@@ -1003,7 +1008,7 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		if (!gdp)
 			continue;
-		desc_count += le16_to_cpu(gdp->bg_free_inodes_count);
+		desc_count += ext4_free_inodes_count(sb, gdp);
 		cond_resched();
 	}
 	return desc_count;
@@ -1020,7 +1025,7 @@ unsigned long ext4_count_dirs(struct super_block * sb)
 		struct ext4_group_desc *gdp = ext4_get_group_desc(sb, i, NULL);
 		if (!gdp)
 			continue;
-		count += le16_to_cpu(gdp->bg_used_dirs_count);
+		count += ext4_used_dirs_count(sb, gdp);
 	}
 	return count;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 76b1d3a..2d31597 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3987,7 +3987,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 			num = EXT4_INODES_PER_GROUP(sb);
 			if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-				num -= le16_to_cpu(gdp->bg_itable_unused);
+				num -= ext4_itable_unused_count(sb, gdp);
 			table += num / inodes_per_block;
 			if (end > table)
 				end = table;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f6c1b0b..f97dfd8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2476,7 +2476,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 			ext4_free_blocks_after_init(sb, group, desc);
 	} else {
 		meta_group_info[i]->bb_free =
-			le16_to_cpu(desc->bg_free_blocks_count);
+			ext4_free_blks_count(sb, desc);
 	}
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
@@ -3004,12 +3004,12 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
-		gdp->bg_free_blocks_count =
-			cpu_to_le16(ext4_free_blocks_after_init(sb,
-						ac->ac_b_ex.fe_group,
-						gdp));
+		ext4_free_blks_set(sb, gdp,
+					ext4_free_blocks_after_init(sb,
+					ac->ac_b_ex.fe_group, gdp));
 	}
-	le16_add_cpu(&gdp->bg_free_blocks_count, -ac->ac_b_ex.fe_len);
+	len = ext4_free_blks_count(sb, gdp) - ac->ac_b_ex.fe_len;
+	ext4_free_blks_set(sb, gdp, len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
@@ -4785,7 +4785,8 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	spin_lock(sb_bgl_lock(sbi, block_group));
-	le16_add_cpu(&gdp->bg_free_blocks_count, count);
+	ret = ext4_free_blks_count(sb, gdp) + count;
+	ext4_free_blks_set(sb, gdp, ret);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 939cf26..6e61613 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -862,8 +862,8 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
 	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
 	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
-	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
-	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
+	ext4_free_blks_set(sb, gdp, input->free_blocks_count);
+	ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	/*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14cd87..5acd386 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -93,6 +93,38 @@ ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 		(ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
 }
 
+__u32 ext4_free_blks_count(struct super_block *sb,
+			      struct ext4_group_desc *bg)
+{
+	return le16_to_cpu(bg->bg_free_blocks_count_lo) |
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		(__u32)le16_to_cpu(bg->bg_free_blocks_count_hi) << 16 : 0);
+}
+
+__u32 ext4_free_inodes_count(struct super_block *sb,
+			      struct ext4_group_desc *bg)
+{
+	return le16_to_cpu(bg->bg_free_inodes_count_lo) |
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		(__u32)le16_to_cpu(bg->bg_free_inodes_count_hi) << 16 : 0);
+}
+
+__u32 ext4_used_dirs_count(struct super_block *sb,
+			      struct ext4_group_desc *bg)
+{
+	return le16_to_cpu(bg->bg_used_dirs_count_lo) |
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		(__u32)le16_to_cpu(bg->bg_used_dirs_count_hi) << 16 : 0);
+}
+
+__u32 ext4_itable_unused_count(struct super_block *sb,
+			      struct ext4_group_desc *bg)
+{
+	return le16_to_cpu(bg->bg_itable_unused_lo) |
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		(__u32)le16_to_cpu(bg->bg_itable_unused_hi) << 16 : 0);
+}
+
 void ext4_block_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
@@ -117,6 +149,38 @@ void ext4_inode_table_set(struct super_block *sb,
 		bg->bg_inode_table_hi = cpu_to_le32(blk >> 32);
 }
 
+void ext4_free_blks_set(struct super_block *sb,
+			  struct ext4_group_desc *bg, __u32 count)
+{
+	bg->bg_free_blocks_count_lo = cpu_to_le16((__u16)count);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
+		bg->bg_free_blocks_count_hi = cpu_to_le16(count >> 16);
+}
+
+void ext4_free_inodes_set(struct super_block *sb,
+			  struct ext4_group_desc *bg, __u32 count)
+{
+	bg->bg_free_inodes_count_lo = cpu_to_le16((__u16)count);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
+		bg->bg_free_inodes_count_hi = cpu_to_le16(count >> 16);
+}
+
+void ext4_used_dirs_set(struct super_block *sb,
+			  struct ext4_group_desc *bg, __u32 count)
+{
+	bg->bg_used_dirs_count_lo = cpu_to_le16((__u16)count);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
+		bg->bg_used_dirs_count_hi = cpu_to_le16(count >> 16);
+}
+
+void ext4_itable_unused_set(struct super_block *sb,
+			  struct ext4_group_desc *bg, __u32 count)
+{
+	bg->bg_itable_unused_lo = cpu_to_le16((__u16)count);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
+		bg->bg_itable_unused_hi = cpu_to_le16(count >> 16);
+}
+
 /*
  * Wrappers for jbd2_journal_start/end.
  *
@@ -1510,9 +1574,9 @@ static int ext4_fill_flex_info(struct super_block *sb)
 
 		flex_group = ext4_flex_group(sbi, i);
 		sbi->s_flex_groups[flex_group].free_inodes +=
-			le16_to_cpu(gdp->bg_free_inodes_count);
+			ext4_free_inodes_count(sb, gdp);
 		sbi->s_flex_groups[flex_group].free_blocks +=
-			le16_to_cpu(gdp->bg_free_blocks_count);
+			ext4_free_blks_count(sb, gdp);
 	}
 
 	return 1;
