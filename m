Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795091227;
	b=YOIzk67d+9kSgnsWUbeOOyuXpPcDwD+OgrQQvNkeicxtGy9eZKDPz3pA6ZXb/KffT2/e
	 Sybge8SRJ9pvC8k0MTWq2nG2HiGxZHljwSpUtOOhQy5IOYnSUJcPrd6PIs3pPtNymSQD3
	 beC21X+pe5Cd9HNOyo4tklOErGA/zN/Bc+EdrA8fjYiHoeHZfATHVdwDFTDv3CApH2xpO
	 nX8ASU1WyDqzF1DckwGbwVKUbbVaAernYJl2DHJwgp4vz8a8C8vfjksTez5RfTyfU128I
	 cD2ZuyBr/P1tmaydcTVilysI+061bQVDmlLKub+SXumA6VyoNaWcRJdCcRdJ6X4YoMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795091227;
	h=DMARC-Filter:DKIM-Signature:Content-Transfer-Encoding:X-Mailer:
	 Content-Type:Cc:Mime-Version:X-Original-From:Message-Id:References:
	 In-Reply-To:Subject:Date:X-Lms-Return-Path:To:From;
	bh=bdk7rL+SMjtqsSvmRQqT/bmBCfni3od8MgLbH9XGxVA=;
	b=uI63q+RWQVqYdBxLfeDA6KL9okJR9JHYFUHl8aO4tWEVeX4W+ymN57txdPvoZ99xME5w
	 A2qWbFo/ajGWROI8kvBz9UUei6Bpmmphtjc7i16i6KD1y4QWO5j6dpopQs5U8iBRkfS9L
	 sZDm+YuxyOY1qlGgLGFTOuRj8K2sTcXBZ6CXGOVaa7DECrfuRFDAtCcFTpn3843JweMeE
	 H5JT5k70KDpy3C7ckfIUrX9o1njWB/tmVfU0K8YF6no32Ot5zCmmjF8VYpunjTx43ptlk
	 GX0Es2OlgVY9m6X5MXgacWD4y1IN4DHSvtlmo9giol3kGcrjiJVk0gnB/vizo84q4WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=S6GvBjMq;
	arc=none smtp.remote-ip=209.127.230.115
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5234F606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 12:27:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5234F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=S6GvBjMq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795091221; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=bdk7rL+SMjtqsSvmRQqT/bmBCfni3od8MgLbH9XGxVA=;
 b=S6GvBjMqLpjo293vOkATypwJJQJMkaaedCDfNBFalGK9zDVLtjIdMdPMTCibz7X+MGQCov
 PyQxikyUZzz1W8KtE4b1VEGFKvjVBHz50a2w9oA3Lai7RnrTn4JaifskZ8/ClbsX7qe7op
 D4JWLcxcaXswfIDypAexBBAm4xprHG7Kyg5VfxTtPf0y2QJKguCu+an7PiE+LJb5iqfF62
 c2VfEt1Q/BANNfoF1EvpMsjjIlP8Rne+l6BZ3duLQsHqvBZTGran74QiUerctkNxPfJu/o
 PwARNSSeQzCcDff7AzTq+S7q2aycKxq0B2q0Hpg47yI6OCj8o+hks5KDUoUbhw==
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
Cc: "Zhao Gongyi" <zhaogongyi@bytedance.com>, <linux-kernel@vger.kernel.org>, 
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Message-Id: <20261119122601.85293-3-zhaogongyi@bytedance.com>
References: <20261119122601.85293-1-zhaogongyi@bytedance.com>
In-Reply-To: <20261119122601.85293-1-zhaogongyi@bytedance.com>
Subject: [PATCH v2 2/2] ext4: reject impossible group free cluster counts
Date: Thu, 19 Nov 2026 20:26:01 +0800
X-Lms-Return-Path: <lba+26afeeb13+074b3d+vger.kernel.org+zhaogongyi@bytedance.com>
To: <linux-ext4@vger.kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>

ext4_count_free_clusters() sums the free-cluster counts from the group
descriptors when initializing the mount's free-space counters. A corrupt
bigalloc filesystem can report 201327130 free clusters in a group that
holds only 32. Reject counts above the group's capacity, using the same
calculation as the block bitmap, including for short final groups and
read-only mounts. Read both halves of the count under the group lock so
updates from deferred EA inode eviction cannot yield a mixed value.

Journal replay can replace both the group descriptors and the
superblock used to interpret them. For mounts that need recovery,
validate the descriptor for the internal journal inode before loading
it. Validate the recovered superblock geometry and all descriptors
after replaying journal blocks. Reload the descriptor table if replay
of an online resize changed the group count or descriptor layout.

Use the JBD2 recovery callback to validate recovered metadata before
fast commit replay consumes it. Check the descriptors again after
fast commit replay modifies them. Both checks run before JBD2 resets
the journal and before ext4 initializes its free-space counters.

Link: https://lore.kernel.org/linux-ext4/20261102042428.65204-1-zhaogongyi@bytedance.com/
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
 fs/ext4/balloc.c |  10 +-
 fs/ext4/ext4.h   |   2 +
 fs/ext4/super.c  | 294 +++++++++++++++++++++++++++++++++++++----------
 3 files changed, 238 insertions(+), 68 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 778fe87..0f36630 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -159,8 +159,8 @@ static unsigned ext4_num_overhead_clusters(struct super_block *sb,
 	return num_clusters;
 }
 
-static unsigned int num_clusters_in_group(struct super_block *sb,
-					  ext4_group_t block_group)
+unsigned int ext4_num_clusters_in_group(struct super_block *sb,
+					ext4_group_t block_group)
 {
 	unsigned int blocks;
 
@@ -228,7 +228,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
 	 * the blocksize * 8 ( which is the size of bitmap ), set rest
 	 * of the block bitmap to 1
 	 */
-	ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
+	ext4_mark_bitmap_end(ext4_num_clusters_in_group(sb, block_group),
 			     sb->s_blocksize * 8, bh->b_data);
 	return 0;
 }
@@ -240,7 +240,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
 {
-	return num_clusters_in_group(sb, block_group) -
+	return ext4_num_clusters_in_group(sb, block_group) -
 		ext4_num_overhead_clusters(sb, block_group, gdp);
 }
 
@@ -313,7 +313,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap_padding(struct super_block *sb,
 {
 	ext4_grpblk_t next_zero_bit;
 	unsigned long bitmap_size = sb->s_blocksize * 8;
-	unsigned int offset = num_clusters_in_group(sb, block_group);
+	unsigned int offset = ext4_num_clusters_in_group(sb, block_group);
 
 	if (bitmap_size <= offset)
 		return 0;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aa0f230..598528f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3480,6 +3480,8 @@ extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 				     struct ext4_group_desc *bg);
+unsigned int ext4_num_clusters_in_group(struct super_block *sb,
+					ext4_group_t block_group);
 extern __u32 ext4_free_group_clusters(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern __u32 ext4_free_inodes_count(struct super_block *sb,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 359f9d4..68c33a9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -66,7 +66,8 @@ static DEFINE_MUTEX(ext4_li_mtx);
 static struct ratelimit_state ext4_mount_msg_ratelimit;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
-			     unsigned long journal_devnum);
+			     unsigned long journal_devnum,
+			     ext4_group_t *first_not_zeroed);
 static int ext4_show_options(struct seq_file *seq, struct dentry *root);
 static void ext4_update_super(struct super_block *sb);
 static int ext4_commit_super(struct super_block *sb);
@@ -3366,7 +3367,9 @@ void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
 /* Called at mount-time, super-block is locked */
 static int ext4_check_descriptors(struct super_block *sb,
 				  ext4_fsblk_t sb_block,
-				  ext4_group_t *first_not_zeroed)
+				  unsigned int journal_inum,
+				  ext4_group_t *first_not_zeroed,
+				  bool readonly)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
@@ -3376,15 +3379,27 @@ static int ext4_check_descriptors(struct super_block *sb,
 	ext4_fsblk_t inode_bitmap;
 	ext4_fsblk_t inode_table;
 	int flexbg_flag = 0;
-	ext4_group_t i, grp = sbi->s_groups_count;
+	ext4_group_t i = 0, end = sbi->s_groups_count, grp = end;
 
 	if (ext4_has_feature_flex_bg(sb))
 		flexbg_flag = 1;
 
+	/* Before recovery, check the group needed to load the journal inode. */
+	if (journal_inum) {
+		if (journal_inum < EXT4_ROOT_INO ||
+		    journal_inum > le32_to_cpu(sbi->s_es->s_inodes_count))
+			return 0;
+		i = (journal_inum - 1) / EXT4_INODES_PER_GROUP(sb);
+		end = i + 1;
+		if (!flexbg_flag)
+			first_block = ext4_group_first_block_no(sb, i);
+	}
+
 	ext4_debug("Checking group descriptors");
 
-	for (i = 0; i < sbi->s_groups_count; i++) {
+	for (; i < end; i++) {
 		struct ext4_group_desc *gdp = ext4_get_group_desc(sb, i, NULL);
+		unsigned int free_clusters = 0;
 
 		if (i == sbi->s_groups_count - 1 || flexbg_flag)
 			last_block = ext4_blocks_count(sbi->s_es) - 1;
@@ -3401,7 +3416,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Block bitmap for group %u overlaps "
 				 "superblock", i);
-			if (!sb_rdonly(sb))
+			if (!readonly)
 				return 0;
 		}
 		if (block_bitmap >= sb_block + 1 &&
@@ -3409,7 +3424,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Block bitmap for group %u overlaps "
 				 "block group descriptors", i);
-			if (!sb_rdonly(sb))
+			if (!readonly)
 				return 0;
 		}
 		if (block_bitmap < first_block || block_bitmap > last_block) {
@@ -3423,7 +3438,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Inode bitmap for group %u overlaps "
 				 "superblock", i);
-			if (!sb_rdonly(sb))
+			if (!readonly)
 				return 0;
 		}
 		if (inode_bitmap >= sb_block + 1 &&
@@ -3431,7 +3446,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Inode bitmap for group %u overlaps "
 				 "block group descriptors", i);
-			if (!sb_rdonly(sb))
+			if (!readonly)
 				return 0;
 		}
 		if (inode_bitmap < first_block || inode_bitmap > last_block) {
@@ -3445,7 +3460,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Inode table for group %u overlaps "
 				 "superblock", i);
-			if (!sb_rdonly(sb))
+			if (!readonly)
 				return 0;
 		}
 		if (inode_table >= sb_block + 1 &&
@@ -3453,11 +3468,12 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Inode table for group %u overlaps "
 				 "block group descriptors", i);
-			if (!sb_rdonly(sb))
+			if (!readonly)
 				return 0;
 		}
 		if (inode_table < first_block ||
-		    inode_table + sbi->s_itb_per_group - 1 > last_block) {
+		    inode_table > last_block ||
+		    sbi->s_itb_per_group - 1 > last_block - inode_table) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 			       "Inode table for group %u not in group "
 			       "(block %llu)!", i, inode_table);
@@ -3469,16 +3485,30 @@ static int ext4_check_descriptors(struct super_block *sb,
 				 "Checksum for group %u failed (%u!=%u)",
 				 i, le16_to_cpu(ext4_group_desc_csum(sb, i,
 				     gdp)), le16_to_cpu(gdp->bg_checksum));
-			if (!sb_rdonly(sb)) {
+			if (!readonly) {
 				ext4_unlock_group(sb, i);
 				return 0;
 			}
 		}
+		/* Sample both halves of the count under the group lock. */
+		if (!journal_inum)
+			free_clusters = ext4_free_group_clusters(sb, gdp);
 		ext4_unlock_group(sb, i);
+
+		if (!journal_inum) {
+			unsigned int capacity = ext4_num_clusters_in_group(sb, i);
+
+			if (free_clusters > capacity) {
+				ext4_msg(sb, KERN_ERR,
+					 "group %u has invalid free clusters count %u > %u",
+					 i, free_clusters, capacity);
+				return 0;
+			}
+		}
 		if (!flexbg_flag)
 			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 	}
-	if (NULL != first_not_zeroed)
+	if (first_not_zeroed)
 		*first_not_zeroed = grp;
 	return 1;
 }
@@ -4875,7 +4905,8 @@ static int ext4_check_feature_compatibility(struct super_block *sb,
 }
 
 static int ext4_check_geometry(struct super_block *sb,
-			       struct ext4_super_block *es)
+			       struct ext4_super_block *es,
+			       ext4_group_t *groups_count)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	__u64 blocks_count;
@@ -4939,88 +4970,193 @@ static int ext4_check_geometry(struct super_block *sb,
 		       EXT4_BLOCKS_PER_GROUP(sb));
 		return -EINVAL;
 	}
-	sbi->s_groups_count = blocks_count;
-	sbi->s_blockfile_groups = min(sbi->s_groups_count,
-			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
-	if (((u64)sbi->s_groups_count * sbi->s_inodes_per_group) !=
+	if (blocks_count * sbi->s_inodes_per_group !=
 	    le32_to_cpu(es->s_inodes_count)) {
 		ext4_msg(sb, KERN_ERR, "inodes count not valid: %u vs %llu",
 			 le32_to_cpu(es->s_inodes_count),
-			 ((u64)sbi->s_groups_count * sbi->s_inodes_per_group));
+			 blocks_count * sbi->s_inodes_per_group);
 		return -EINVAL;
 	}
 
+	*groups_count = blocks_count;
 	return 0;
 }
 
-static int ext4_group_desc_init(struct super_block *sb,
-				struct ext4_super_block *es,
+/* Mount and recovery load the table before publishing the superblock. */
+static int ext4_load_group_desc(struct super_block *sb,
 				ext4_fsblk_t logical_sb_block,
-				ext4_group_t *first_not_zeroed)
+				ext4_group_t groups_count)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+	struct buffer_head **group_desc;
 	unsigned int db_count;
 	ext4_fsblk_t block;
-	int i;
+	int err, i;
 
-	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
-		   EXT4_DESC_PER_BLOCK(sb);
-	if (ext4_has_feature_meta_bg(sb)) {
-		if (le32_to_cpu(es->s_first_meta_bg) > db_count) {
-			ext4_msg(sb, KERN_WARNING,
-				 "first meta block group too large: %u "
-				 "(group descriptor block count %u)",
-				 le32_to_cpu(es->s_first_meta_bg), db_count);
-			return -EINVAL;
-		}
-	}
-	rcu_assign_pointer(sbi->s_group_desc,
-			   kvmalloc_objs(struct buffer_head *, db_count));
-	if (sbi->s_group_desc == NULL) {
-		ext4_msg(sb, KERN_ERR, "not enough memory");
-		return -ENOMEM;
+	db_count = DIV_ROUND_UP(groups_count, EXT4_DESC_PER_BLOCK(sb));
+	if (ext4_has_feature_meta_bg(sb) &&
+	    le32_to_cpu(es->s_first_meta_bg) > db_count) {
+		ext4_msg(sb, KERN_ERR,
+			 "first meta block group too large: %u (group descriptor block count %u)",
+			 le32_to_cpu(es->s_first_meta_bg), db_count);
+		return -EINVAL;
 	}
 
-	bgl_lock_init(sbi->s_blockgroup_lock);
+	group_desc = kvmalloc_objs(struct buffer_head *, db_count);
+	if (!group_desc)
+		return -ENOMEM;
 
-	/* Pre-read the descriptors into the buffer cache */
+	/* Pre-read the descriptors into the buffer cache. */
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
+		if (block >= ext4_blocks_count(es)) {
+			ext4_msg(sb, KERN_ERR,
+				 "group descriptor block %d outside filesystem", i);
+			kvfree(group_desc);
+			return -EFSCORRUPTED;
+		}
 		ext4_sb_breadahead_unmovable(sb, block);
 	}
 
 	for (i = 0; i < db_count; i++) {
-		struct buffer_head *bh;
-
 		block = descriptor_loc(sb, logical_sb_block, i);
-		bh = ext4_sb_bread_unmovable(sb, block);
-		if (IS_ERR(bh)) {
+		group_desc[i] = ext4_sb_bread_unmovable(sb, block);
+		if (IS_ERR(group_desc[i])) {
 			ext4_msg(sb, KERN_ERR,
-			       "can't read group descriptor %d", i);
-			sbi->s_gdb_count = i;
-			return PTR_ERR(bh);
+				 "can't read group descriptor %d", i);
+			err = PTR_ERR(group_desc[i]);
+			goto out_free;
 		}
-		rcu_read_lock();
-		rcu_dereference(sbi->s_group_desc)[i] = bh;
-		rcu_read_unlock();
 	}
+
+	ext4_group_desc_free(sbi);
+	rcu_assign_pointer(sbi->s_group_desc, group_desc);
 	sbi->s_gdb_count = db_count;
-	if (!ext4_check_descriptors(sb, logical_sb_block, first_not_zeroed)) {
-		ext4_msg(sb, KERN_ERR, "group descriptors corrupted!");
+	sbi->s_groups_count = groups_count;
+	sbi->s_blockfile_groups = min(groups_count,
+				      EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb));
+	return 0;
+
+out_free:
+	while (i--)
+		brelse(group_desc[i]);
+	kvfree(group_desc);
+	return err;
+}
+
+struct ext4_replay_callback_data {
+	struct ext4_super_block super;
+	ext4_group_t *first_not_zeroed;
+	bool readonly;
+};
+
+static int ext4_validate_replayed_metadata(journal_t *journal, void *data,
+					   bool after_fast_commit)
+{
+	struct ext4_replay_callback_data *replay = data;
+	struct super_block *sb = journal->j_private;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+	struct ext4_super_block *old = &replay->super;
+	ext4_fsblk_t sb_block = sbi->s_sbh->b_blocknr;
+	ext4_group_t groups_count;
+	unsigned int inode_size, first_ino;
+	u32 incompat, ro_compat;
+	int err;
+
+	/* Fast commits only change descriptor contents, such as counts. */
+	if (after_fast_commit) {
+		if (!(sbi->s_mount_state & EXT4_FC_REPLAY))
+			return 0;
+		goto check_descriptors;
+	}
+
+	incompat = le32_to_cpu(es->s_feature_incompat ^ old->s_feature_incompat);
+	ro_compat = le32_to_cpu(es->s_feature_ro_compat ^ old->s_feature_ro_compat);
+	if (es->s_rev_level == cpu_to_le32(EXT4_GOOD_OLD_REV)) {
+		inode_size = EXT4_GOOD_OLD_INODE_SIZE;
+		first_ino = EXT4_GOOD_OLD_FIRST_INO;
+	} else {
+		inode_size = le16_to_cpu(es->s_inode_size);
+		first_ino = le32_to_cpu(es->s_first_ino);
+	}
+
+	/* Online resize can grow the filesystem without changing group units. */
+	if (es->s_magic != old->s_magic ||
+	    es->s_log_block_size != old->s_log_block_size ||
+	    es->s_log_cluster_size != old->s_log_cluster_size ||
+	    es->s_blocks_per_group != old->s_blocks_per_group ||
+	    es->s_clusters_per_group != old->s_clusters_per_group ||
+	    es->s_inodes_per_group != old->s_inodes_per_group ||
+	    es->s_first_data_block != old->s_first_data_block ||
+	    inode_size != sbi->s_inode_size || first_ino != sbi->s_first_ino ||
+	    es->s_desc_size != old->s_desc_size ||
+	    es->s_log_groups_per_flex != old->s_log_groups_per_flex ||
+	    ext4_blocks_count(es) < ext4_blocks_count(old) ||
+	    (incompat & (EXT4_FEATURE_INCOMPAT_64BIT |
+			 EXT4_FEATURE_INCOMPAT_FLEX_BG)) ||
+	    (ro_compat & (EXT4_FEATURE_RO_COMPAT_BIGALLOC |
+			  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
+			  EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+			  EXT4_FEATURE_RO_COMPAT_READONLY))) {
+		ext4_msg(sb, KERN_ERR, "invalid filesystem geometry after journal replay");
 		return -EFSCORRUPTED;
 	}
 
+	/* An unreplayed superblock can contain mount-time hash flags. */
+	if (memcmp(es, old, sizeof(*es)) &&
+	    (!ext4_verify_csum_type(sb, es) ||
+	     !ext4_superblock_csum_verify(sb, es))) {
+		ext4_msg(sb, KERN_ERR, "invalid superblock checksum after journal replay");
+		return -EFSBADCRC;
+	}
+
+	if (ext4_has_feature_metadata_csum(sb) &&
+	    sbi->s_csum_seed != (ext4_has_feature_csum_seed(sb) ?
+		le32_to_cpu(es->s_checksum_seed) :
+		ext4_chksum(~0, es->s_uuid, sizeof(es->s_uuid)))) {
+		ext4_msg(sb, KERN_ERR, "metadata checksum seed changed during journal replay");
+		return -EFSCORRUPTED;
+	}
+
+	if (!ext4_feature_set_ok(sb, replay->readonly))
+		return -EINVAL;
+
+	err = ext4_check_geometry(sb, es, &groups_count);
+	if (err)
+		return err;
+
+	if (groups_count != sbi->s_groups_count ||
+	    es->s_first_meta_bg != old->s_first_meta_bg ||
+	    (incompat & EXT4_FEATURE_INCOMPAT_META_BG) ||
+	    (ro_compat & EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) ||
+	    ((es->s_feature_compat ^ old->s_feature_compat) &
+	     cpu_to_le32(EXT4_FEATURE_COMPAT_SPARSE_SUPER2)) ||
+	    memcmp(es->s_backup_bgs, old->s_backup_bgs, sizeof(es->s_backup_bgs))) {
+		err = ext4_load_group_desc(sb, sb_block, groups_count);
+		if (err)
+			return err;
+	}
+
+	super_set_uuid(sb, es->s_uuid, sizeof(es->s_uuid));
+
+check_descriptors:
+	if (!ext4_check_descriptors(sb, sb_block, 0, replay->first_not_zeroed,
+				    replay->readonly))
+		return -EFSCORRUPTED;
 	return 0;
 }
 
 static int ext4_load_and_init_journal(struct super_block *sb,
 				      struct ext4_super_block *es,
-				      struct ext4_fs_context *ctx)
+				      struct ext4_fs_context *ctx,
+				      ext4_group_t *first_not_zeroed)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err;
 
-	err = ext4_load_journal(sb, es, ctx->journal_devnum);
+	err = ext4_load_journal(sb, es, ctx->journal_devnum, first_not_zeroed);
 	if (err)
 		return err;
 
@@ -5406,7 +5542,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	struct inode *root;
 	int needs_recovery;
 	int err;
-	ext4_group_t first_not_zeroed;
+	ext4_group_t first_not_zeroed, groups_count;
 	struct ext4_fs_context *ctx = fc->fs_private;
 	int silent = fc->sb_flags & SB_SILENT;
 
@@ -5496,7 +5632,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	if (err)
 		goto failed_mount;
 
-	err = ext4_check_geometry(sb, es);
+	err = ext4_check_geometry(sb, es, &groups_count);
 	if (err)
 		goto failed_mount;
 
@@ -5505,10 +5641,19 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	mutex_init(&sbi->s_error_notify_mutex);
 	INIT_WORK(&sbi->s_sb_upd_work, update_super_work);
 
-	err = ext4_group_desc_init(sb, es, logical_sb_block, &first_not_zeroed);
+	bgl_lock_init(sbi->s_blockgroup_lock);
+	err = ext4_load_group_desc(sb, logical_sb_block, groups_count);
 	if (err)
 		goto failed_mount3;
 
+	if ((test_opt(sb, NOLOAD) || !ext4_has_feature_journal(sb) ||
+	     !ext4_has_feature_journal_needs_recovery(sb)) &&
+	    !ext4_check_descriptors(sb, logical_sb_block, 0, &first_not_zeroed,
+				    sb_rdonly(sb))) {
+		err = -EFSCORRUPTED;
+		goto failed_mount3;
+	}
+
 	err = ext4_es_register_shrinker(sbi);
 	if (err)
 		goto failed_mount3;
@@ -5574,7 +5719,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	 * root first: it may be modified in the journal!
 	 */
 	if (!test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb)) {
-		err = ext4_load_and_init_journal(sb, es, ctx);
+		err = ext4_load_and_init_journal(sb, es, ctx, &first_not_zeroed);
 		if (err)
 			goto failed_mount3a;
 		if (bdev_read_only(sb->s_bdev))
@@ -6169,10 +6314,15 @@ out_bdev:
 
 static int ext4_load_journal(struct super_block *sb,
 			     struct ext4_super_block *es,
-			     unsigned long journal_devnum)
+			     unsigned long journal_devnum,
+			     ext4_group_t *first_not_zeroed)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_replay_callback_data *replay = NULL;
+	jbd2_replay_callback_t callback = NULL;
 	journal_t *journal;
 	unsigned int journal_inum = le32_to_cpu(es->s_journal_inum);
+	bool recover = ext4_has_feature_journal_needs_recovery(sb);
 	dev_t journal_dev;
 	int err = 0;
 	int really_read_only;
@@ -6197,6 +6347,10 @@ static int ext4_load_journal(struct super_block *sb,
 	}
 
 	if (journal_inum) {
+		if (recover &&
+		    !ext4_check_descriptors(sb, sbi->s_sbh->b_blocknr,
+					    journal_inum, NULL, sb_rdonly(sb)))
+			return -EFSCORRUPTED;
 		journal = ext4_open_inode_journal(sb, journal_inum);
 		if (IS_ERR(journal))
 			return PTR_ERR(journal);
@@ -6221,7 +6375,7 @@ static int ext4_load_journal(struct super_block *sb,
 	 * crash?  For recovery, we need to check in advance whether we
 	 * can get read-write access to the device.
 	 */
-	if (ext4_has_feature_journal_needs_recovery(sb)) {
+	if (recover) {
 		if (sb_rdonly(sb)) {
 			ext4_msg(sb, KERN_INFO, "INFO: recovery "
 					"required on readonly filesystem");
@@ -6241,8 +6395,19 @@ static int ext4_load_journal(struct super_block *sb,
 	if (!(journal->j_flags & JBD2_BARRIER))
 		ext4_msg(sb, KERN_INFO, "barriers disabled");
 
-	if (!ext4_has_feature_journal_needs_recovery(sb))
+	if (recover) {
+		replay = kmalloc_obj(*replay);
+		if (!replay) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+		replay->super = *es;
+		replay->first_not_zeroed = first_not_zeroed;
+		replay->readonly = sb_rdonly(sb);
+		callback = ext4_validate_replayed_metadata;
+	} else {
 		err = jbd2_journal_wipe(journal, !really_read_only);
+	}
 	if (!err) {
 		char *save = kmalloc(EXT4_S_ERR_LEN, GFP_KERNEL);
 		__le16 orig_state;
@@ -6261,9 +6426,11 @@ static int ext4_load_journal(struct super_block *sb,
 		 */
 		if (enable_write)
 			sb->s_flags &= ~SB_RDONLY;
-		err = jbd2_journal_load(journal);
+		err = jbd2_journal_load_with_callback(journal, callback, replay);
 		if (enable_write)
 			sb->s_flags |= SB_RDONLY;
+		kfree(replay);
+
 		if (save && memcmp(((char *) es) + EXT4_S_ERR_START,
 				   save, EXT4_S_ERR_LEN)) {
 			memcpy(((char *) es) + EXT4_S_ERR_START,
@@ -6285,6 +6452,7 @@ static int ext4_load_journal(struct super_block *sb,
 	}
 
 	if (err) {
+		ext4_fc_replay_cleanup(sb);
 		ext4_msg(sb, KERN_ERR, "error loading journal");
 		goto err_out;
 	}
