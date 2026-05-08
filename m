Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB0B36166A;
	Fri,  8 May 2026 12:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242579; cv=none; b=po/wB7hbsmZlQ48/mVWsatdAfRiceeB6f3WB2EgvuH8C5XYkPJ8eKrfz5x11es8oq3GGA/BvGE8ydNT9CigXrv/qM4Lgq59maw+bLq61DdQFO2+rzDKE7r5Z8ZQefRNMqewqMYA7kXNparFczD5NgEOH+gRn6y3HALNwQkYPTx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242579; c=relaxed/simple;
	bh=YCKFjQiZrOBBRxkTAZoWHoGW2GZSiBgcy/0+8q03k3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Onl+K1femMb2gCOHJ2r17a3orj2luEKP6JvjOUmwopB1SzQ7IzeK8r+Z89EhDugng5hvMtUM2QuWlbziJYPmRFkhAHh03KUVhNBEHrKR7s/BJq+OEX6Pm1MK3Jj2aKErKebik8VvoHDaxSOukIvU40QuGbYOM51FdmvwoJY/2x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UMSTwu8G; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UMSTwu8G"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242572; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=dB3zSaZqP7/b8wHGDUalrkHyVRQutKa9azzVpRzhLnQ=;
	b=UMSTwu8GwEjITJsF8pcxMkH2p9jJQzaDSRC0PknV2dbkId9htebVKxzq5ANYfoaAXc0vaxxeMg1/OL9FPQ6Xy99UQO4Ygy8SKilcWMUEWZeQGVyzICB3aZxhaA97JzzMpFKLPtIigjNg14WMKDzzGvw/D0kcHq07GDwszfwo1oQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgre_1778242571;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgre_1778242571 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:12 +0800
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
Subject: [PATCH RFC 16/17] ext4: extract ext4_update_inode_group_desc() to reduce duplication
Date: Fri,  8 May 2026 20:15:38 +0800
Message-ID: <20260508121539.4174601-17-libaokun@linux.alibaba.com>
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

ext4_mark_inode_used() and __ext4_new_inode() contain nearly
identical code blocks for updating group descriptor fields after
inode allocation (UNINIT flag clearing, itable_unused update,
inode bitmap checksum, group desc checksum). Extract the common
logic into ext4_update_inode_group_desc() to eliminate duplication.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ialloc.c | 136 ++++++++++++++++++++---------------------------
 1 file changed, 57 insertions(+), 79 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9dd1cdb367ba..25430c572818 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -808,12 +808,63 @@ static int ext4_might_init_block_bitmap(handle_t *handle,
 	return err;
 }
 
+/*
+ * Update group descriptor checksums and itable_unused after allocating
+ * inode @bit (0-based relative inode number within the group).
+ * Must be called with the group lock held.
+ */
+static void ext4_update_inode_group_desc(struct super_block *sb,
+					 ext4_group_t group,
+					 struct ext4_group_desc *gdp,
+					 struct buffer_head *inode_bitmap_bh,
+					 int bit, umode_t mode)
+{
+	int free;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	bool fast_crc = true;
+
+	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
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
+	if (!ext4_has_group_desc_csum(sb))
+		return;
+
+	free = EXT4_INODES_PER_GROUP(sb) - ext4_itable_unused_count(sb, gdp);
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
+		free = 0;
+		/* Incremental CRC needs a valid checksum baseline */
+		fast_crc = false;
+	}
+
+	/*
+	 * Check the relative inode number against the last used
+	 * relative inode number in this group. If it is greater
+	 * we need to update the bg_itable_unused count.
+	 */
+	if (bit >= free)
+		ext4_itable_unused_set(sb, gdp,
+				       EXT4_INODES_PER_GROUP(sb) - bit - 1);
+	if (fast_crc)
+		ext4_inode_bitmap_csum_set_fast(sb, gdp, bit);
+	else
+		ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
+	ext4_group_desc_csum_set(sb, group, gdp);
+}
+
 int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 {
 	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
 	struct buffer_head *inode_bitmap_bh = NULL, *group_desc_bh = NULL;
 	struct ext4_group_desc *gdp;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t group;
 	int bit;
 	int err;
@@ -848,44 +899,8 @@ int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 	ext4_set_bit(bit, inode_bitmap_bh->b_data);
 
 	/* Update the relevant bg descriptor fields */
-	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
-	if (S_ISDIR(mode)) {
-		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
-		if (sbi->s_log_groups_per_flex) {
-			ext4_group_t f = ext4_flex_group(sbi, group);
-
-			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
-							f)->used_dirs);
-		}
-	}
-
-	if (ext4_has_group_desc_csum(sb)) {
-		bool fast_crc = true;
-		int free = EXT4_INODES_PER_GROUP(sb) -
-				ext4_itable_unused_count(sb, gdp);
-
-		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
-			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
-			free = 0;
-			/* Incremental CRC needs a valid checksum baseline */
-			fast_crc = false;
-		}
-
-		/*
-		 * Check the relative inode number against the last used
-		 * relative inode number in this group. if it is greater
-		 * we need to update the bg_itable_unused count
-		 */
-		if (bit >= free)
-			ext4_itable_unused_set(sb, gdp,
-					(EXT4_INODES_PER_GROUP(sb) - bit - 1));
-		if (fast_crc)
-			ext4_inode_bitmap_csum_set_fast(sb, gdp, bit);
-		else
-			ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
-		ext4_group_desc_csum_set(sb, group, gdp);
-	}
-
+	ext4_update_inode_group_desc(sb, group, gdp,
+				     inode_bitmap_bh, bit, mode);
 	ext4_unlock_group(sb, group);
 
 	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
@@ -1165,50 +1180,13 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 				ret2 = 0;
 			} else {
 				ret2 = 1; /* we didn't grab the inode */
-				goto unlock_group;
 			}
 		}
 
 		/* Update the relevant bg descriptor fields */
-		ext4_free_inodes_set(sb, gdp,
-				     ext4_free_inodes_count(sb, gdp) - 1);
-		if (S_ISDIR(mode)) {
-			ext4_used_dirs_set(sb, gdp,
-					   ext4_used_dirs_count(sb, gdp) + 1);
-			if (sbi->s_log_groups_per_flex) {
-				ext4_group_t f = ext4_flex_group(sbi, group);
-				atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
-								f)->used_dirs);
-			}
-		}
-
-		if (ext4_has_group_desc_csum(sb)) {
-			bool fast_crc = true;
-			int free = EXT4_INODES_PER_GROUP(sb) -
-					ext4_itable_unused_count(sb, gdp);
-
-			if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
-				gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
-				free = 0;
-				/* Incremental CRC needs a valid csum baseline */
-				fast_crc = false;
-			}
-			/*
-			 * Check the relative inode number against the
-			 * last used relative inode number in this group.
-			 * If it is greater we need to update the
-			 * bg_itable_unused count.
-			 */
-			if (bit >= free)
-				ext4_itable_unused_set(sb, gdp,
-					EXT4_INODES_PER_GROUP(sb) - bit - 1);
-			if (fast_crc)
-				ext4_inode_bitmap_csum_set_fast(sb, gdp, bit);
-			else
-				ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
-			ext4_group_desc_csum_set(sb, group, gdp);
-		}
-unlock_group:
+		if (!ret2)
+			ext4_update_inode_group_desc(sb, group, gdp,
+						     inode_bitmap_bh, bit, mode);
 		ext4_unlock_group(sb, group);
 		if (ext4_has_group_desc_csum(sb) &&
 		    !(sbi->s_mount_state & EXT4_FC_REPLAY))
-- 
2.43.7

