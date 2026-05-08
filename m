Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F453DB63C;
	Fri,  8 May 2026 12:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242581; cv=none; b=OxKKBC511uCpn/iaal5z2HxU+dmLaLGxkubgceHixyEEbzXoob4AC5xPYrFsWN2A9PvnhmDKnJis3q9IPODgg/HG6QdkRFbKSiujMjOemeEOdqdxt8xzJF0cVUDkhhGw3Dskv4/kwEYV/CmFJuygXx/2i279LkksN9VoyWwnCPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242581; c=relaxed/simple;
	bh=OUftgixMNWlG++qrrDs5ZeGmxtXp1jfQD5mN2C6rp6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5E+YwD1Sulilr9UsZ1mOyDvoUSIl/898ycOwhosz3AvE1og9bRR5K+ttB01MuNfyx+JnONkXRQV57bMaLOUMsz6HthvV2qVh+L+Qa2ILLPPGi2HEpub5mSxAq2L+GnXcBeaomPRe5xghPqXrvnmiZkvW3TIjKl3pU5GD+HW2qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Aw4Wh/zW; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Aw4Wh/zW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242573; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jzJIYLNOQ5UlZMTTubAeA23KJPWfOAbaezYvUFo6acU=;
	b=Aw4Wh/zW++Mqs2Wb1rzSIOQ0VmRSdME6eTelCkYCpdGLzbtQZC79JOJGXAxQ4n9PF72S9ERWB4ODpqKalZhqaRW7VCSyeYVL+xaKnNApOgElNu21GXzq79U/CbY2FyB9wx2w5d8gaWyR4DdJuYO3j8MM1NkT6kw+wMBzewOcL/g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgru_1778242572;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgru_1778242572 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:13 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	ebiggers@kernel.org,
	ardb@kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH RFC 17/17] ext4: add ext4_get_flex_group() helper to simplify flex group lookups
Date: Fri,  8 May 2026 20:15:39 +0800
Message-ID: <20260508121539.4174601-18-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
References: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce ext4_get_flex_group() that combines ext4_flex_group() and
sbi_array_rcu_deref() into a single call, replacing the repeated
pattern across ialloc.c, mballoc.c, resize.c, and super.c.

No functional change.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ext4.h    |  7 +++++++
 fs/ext4/ialloc.c  | 19 +++++--------------
 fs/ext4/mballoc.c |  4 +---
 fs/ext4/resize.c  |  4 +---
 fs/ext4/super.c   |  4 +---
 5 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f48cb9d998ab..e38ada51972a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3457,6 +3457,13 @@ static inline unsigned int ext4_flex_bg_size(struct ext4_sb_info *sbi)
 	return 1 << sbi->s_log_groups_per_flex;
 }
 
+static inline struct flex_groups *ext4_get_flex_group(struct ext4_sb_info *sbi,
+						      ext4_group_t block_group)
+{
+	return sbi_array_rcu_deref(sbi, s_flex_groups,
+				   ext4_flex_group(sbi, block_group));
+}
+
 static inline loff_t ext4_get_maxbytes(struct inode *inode)
 {
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25430c572818..d88160afd6b6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -336,8 +336,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	if (sbi->s_log_groups_per_flex) {
 		struct flex_groups *fg;
 
-		fg = sbi_array_rcu_deref(sbi, s_flex_groups,
-					 ext4_flex_group(sbi, block_group));
+		fg = ext4_get_flex_group(sbi, block_group);
 		atomic_inc(&fg->free_inodes);
 		if (is_directory)
 			atomic_dec(&fg->used_dirs);
@@ -826,12 +825,8 @@ static void ext4_update_inode_group_desc(struct super_block *sb,
 	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
 	if (S_ISDIR(mode)) {
 		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
-		if (sbi->s_log_groups_per_flex) {
-			ext4_group_t f = ext4_flex_group(sbi, group);
-
-			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
-							f)->used_dirs);
-		}
+		if (sbi->s_log_groups_per_flex)
+			atomic_inc(&ext4_get_flex_group(sbi, group)->used_dirs);
 	}
 
 	if (!ext4_has_group_desc_csum(sb))
@@ -997,7 +992,6 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 	int ret2, err;
 	struct inode *ret;
 	ext4_group_t i;
-	ext4_group_t flex_group;
 	struct ext4_group_info *grp = NULL;
 	bool encrypt = false;
 
@@ -1220,11 +1214,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
 
-	if (sbi->s_log_groups_per_flex) {
-		flex_group = ext4_flex_group(sbi, group);
-		atomic_dec(&sbi_array_rcu_deref(sbi, s_flex_groups,
-						flex_group)->free_inodes);
-	}
+	if (sbi->s_log_groups_per_flex)
+		atomic_dec(&ext4_get_flex_group(sbi, group)->free_inodes);
 
 	/* the inode bitmap is zero-based */
 	inode->i_ino = bit + 1 + group * EXT4_INODES_PER_GROUP(sb);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 77f6309916d1..9e30c9eefd35 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4181,9 +4181,7 @@ ext4_mb_mark_context(handle_t *handle, struct super_block *sb, bool state,
 		*ret_changed = changed;
 
 	if (sbi->s_log_groups_per_flex) {
-		ext4_group_t flex_group = ext4_flex_group(sbi, group);
-		struct flex_groups *fg = sbi_array_rcu_deref(sbi,
-					   s_flex_groups, flex_group);
+		struct flex_groups *fg = ext4_get_flex_group(sbi, group);
 
 		if (state)
 			atomic64_sub(changed, &fg->free_clusters);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 2c5b851c552a..8d2cd1bc17bb 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1495,11 +1495,9 @@ static void ext4_update_super(struct super_block *sb,
 	ext4_debug("free blocks count %llu",
 		   percpu_counter_read(&sbi->s_freeclusters_counter));
 	if (ext4_has_feature_flex_bg(sb) && sbi->s_log_groups_per_flex) {
-		ext4_group_t flex_group;
 		struct flex_groups *fg;
 
-		flex_group = ext4_flex_group(sbi, group_data[0].group);
-		fg = sbi_array_rcu_deref(sbi, s_flex_groups, flex_group);
+		fg = ext4_get_flex_group(sbi, group_data[0].group);
 		atomic64_add(EXT4_NUM_B2C(sbi, free_blocks),
 			     &fg->free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..064e06163716 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3211,7 +3211,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = NULL;
 	struct flex_groups *fg;
-	ext4_group_t flex_group;
 	int i, err;
 
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
@@ -3227,8 +3226,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	for (i = 0; i < sbi->s_groups_count; i++) {
 		gdp = ext4_get_group_desc(sb, i, NULL);
 
-		flex_group = ext4_flex_group(sbi, i);
-		fg = sbi_array_rcu_deref(sbi, s_flex_groups, flex_group);
+		fg = ext4_get_flex_group(sbi, i);
 		atomic_add(ext4_free_inodes_count(sb, gdp), &fg->free_inodes);
 		atomic64_add(ext4_free_group_clusters(sb, gdp),
 			     &fg->free_clusters);
-- 
2.43.7

