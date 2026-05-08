Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96D3D5244;
	Fri,  8 May 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242579; cv=none; b=Q5gxnrtPFlvKV3w8E+RMQPZ1rjr5ndEZh31jIkWpz3tuNazM3mVoSnzAzaBMp//NT0GymRf9D7FGK+KGOf8pYb2pASWexgsSSDQLOMVLU4Bu+0Z/ZSwL5KU473ZUJMFvX8c8x87oQPu+VtXQHcHox0/EV0ICWByokd/GKYU0Ojg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242579; c=relaxed/simple;
	bh=PFc3imtu7npQUjqtdoe3If9Ky6yXQHRgCbyLYFArCkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TV47nrw983DmlqfO1fI1aitfVUnQO2Z7OgHkeDcW27tqeHxZ39V0vpjkag3bFcf9Xnpyy+IrMs9MnFcBXvH8l674DIT6ZoQM9NR1do3Y44PraaH1PLZV3rwc63y8Ml5pm9uzIiA5+9PWmZooP3j1JwK0QjEW8/JYFkRk16hiQ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uwSnD90S; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uwSnD90S"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242568; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=j+njTUQuSD4WJzz69aJY/AMPFzUNIY9l1EwDZIOoNNs=;
	b=uwSnD90SE3fsS0ngCYi214i94sTKNqISGyLTYB7vGKmENuhwTdtEFWCm5boOjy5nYKPsR4n3OQRQLoXgi7XXjsEL8ZAAG0tYx3On9pRuESprzMkBNCeTa4DM730BQUp56bye6iX47/6AmPx8aLIGKi8ZbJQReOYIQkBZ/fSZwJg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgqZ_1778242567;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgqZ_1778242567 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:08 +0800
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
Subject: [PATCH RFC 11/17] ext4: fix missing bg_used_dirs_count update in fast commit replay
Date: Fri,  8 May 2026 20:15:33 +0800
Message-ID: <20260508121539.4174601-12-libaokun@linux.alibaba.com>
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

ext4_mark_inode_used() did not update bg_used_dirs_count for directory
inodes during fast commit replay because it lacked the inode mode.
Add a mode parameter and pass it from both ext4_fc_replay_inode() (from
raw_fc_inode) and ext4_fc_replay_create() (after ext4_iget).

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ext4.h        |  2 +-
 fs/ext4/fast_commit.c | 13 +++++++------
 fs/ext4/ialloc.c      | 13 ++++++++++++-
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e6739d5af490..f48cb9d998ab 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2941,7 +2941,7 @@ extern int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 			  struct dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern int ext4_mark_inode_used(struct super_block *sb, int ino);
+extern int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode);
 extern struct inode *__ext4_new_inode(struct mnt_idmap *, handle_t *,
 				      struct inode *, umode_t,
 				      const struct qstr *qstr, __u32 goal,
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b3c22636251d..f68d7b2eb0db 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1578,7 +1578,7 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 	ret = sync_dirty_buffer(iloc.bh);
 	if (ret)
 		goto out_brelse;
-	ret = ext4_mark_inode_used(sb, ino);
+	ret = ext4_mark_inode_used(sb, ino, le16_to_cpu(raw_fc_inode->i_mode));
 	if (ret)
 		goto out_brelse;
 
@@ -1635,11 +1635,7 @@ static int ext4_fc_replay_create(struct super_block *sb,
 	trace_ext4_fc_replay(sb, EXT4_FC_TAG_CREAT, darg.ino,
 			darg.parent_ino, darg.dname_len);
 
-	/* This takes care of update group descriptor and other metadata */
-	ret = ext4_mark_inode_used(sb, darg.ino);
-	if (ret)
-		goto out;
-
+	/* Inode already on disk from TAG_INODE replay; iget first for mode. */
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		ext4_debug("inode %d not found.", darg.ino);
@@ -1648,6 +1644,11 @@ static int ext4_fc_replay_create(struct super_block *sb,
 		goto out;
 	}
 
+	/* This takes care of update group descriptor and other metadata */
+	ret = ext4_mark_inode_used(sb, darg.ino, inode->i_mode);
+	if (ret)
+		goto out;
+
 	if (S_ISDIR(inode->i_mode)) {
 		/*
 		 * If we are creating a directory, we need to make sure that the
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 55eb69fbb4c9..5896cdfb2ccf 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -756,11 +756,12 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 	return 1;
 }
 
-int ext4_mark_inode_used(struct super_block *sb, int ino)
+int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 {
 	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
 	struct buffer_head *inode_bitmap_bh = NULL, *group_desc_bh = NULL;
 	struct ext4_group_desc *gdp;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t group;
 	int bit;
 	int err;
@@ -858,6 +859,16 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	}
 
 	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
+	if (S_ISDIR(mode)) {
+		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
+		if (sbi->s_log_groups_per_flex) {
+			ext4_group_t f = ext4_flex_group(sbi, group);
+
+			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
+							f)->used_dirs);
+		}
+	}
+
 	if (ext4_has_group_desc_csum(sb)) {
 		ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
 		ext4_group_desc_csum_set(sb, group, gdp);
-- 
2.43.7

