Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8273DCD9B;
	Fri,  8 May 2026 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242579; cv=none; b=mLcn1jd+2SDXxoV3sVccmWWwKeJ4XtjgK/SQ1JgJlTBSACAm8U2uIXCnAY7CVjLqfPBRnpEvCWJO26dW/RMBbAPnuUP4XwJe9aIQ9ZK0yzKSesu2x3MKTc9o2HwH4Q5a89fmC1dbav37ECp4rIZ5oGB/TQ55tpnVcXUaf7dGuGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242579; c=relaxed/simple;
	bh=DllS5YjXJieuqKLmfXZHKyOfeuzV6+C9HnBqMx1/zdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db181QG0yX2j1WqsCXelbGHt8dsrQ/DXRXIJPrVij82XbOh9fXe52h2FAIOtR2nSDVX8IZ8Z47SXca6JnLkzUt72TJHTiClcRPq3mGpf4/W0OQQoJYIWKj7vdaXpCr3AJVBYN7OquwcEbGbjonsEtscPLvwfUWfVg+sdRGyxbJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sp3I6mtT; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sp3I6mtT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242570; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=omI7SRikdqIgyxB0uPduOEBvp2jJZrJt0MRys7JIsEw=;
	b=sp3I6mtTrhZdXKTCvWN30d+yFixCGQ+Tq9wI2lWItqIL1PTJ5BsAne3i0Pxfk6/D8C0ICIRDxZzl5+/24/oHeK6bfbeRQRCq0jfOoYtMRIUiJUPYqqZLpadDfjvDMjZUBW7AlHZrK7kX5Ll6k1ewjBdaHmK9HFp4f4a3GDbomKE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgr2_1778242569;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgr2_1778242569 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:09 +0800
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
Subject: [PATCH RFC 13/17] ext4: use fast incremental CRC update in ext4_mark_inode_used()
Date: Fri,  8 May 2026 20:15:35 +0800
Message-ID: <20260508121539.4174601-14-libaokun@linux.alibaba.com>
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

Move the bitmap modification, GDP update, and checksum update into a
single group lock acquisition in ext4_mark_inode_used(), eliminating the
race window where another thread could interleave a full recomputation
between bitmap modification and checksum update.

Add a fast_crc flag to select between incremental and full CRC update.
When EXT4_BG_INODE_UNINIT is set, the stored checksum in the group
descriptor is not a valid CRC of the bitmap -- mkfs leaves it as zero
for UNINIT groups, and ext4_read_inode_bitmap() memsets the buffer to
zero without updating the gdp checksum. So fast_crc is forced to false
to fall back to ext4_inode_bitmap_csum_set() for a full recalculation
that establishes a correct baseline.

For non-UNINIT groups, ext4_inode_bitmap_csum_set_fast() computes the
CRC delta for the single flipped bit in O(log N) time.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ialloc.c | 69 ++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 90896b7f8c73..e209e27f827f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -838,35 +838,37 @@ int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 		goto out;
 	}
 
-	ext4_set_bit(bit, inode_bitmap_bh->b_data);
-
-	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(NULL, NULL, inode_bitmap_bh);
-	if (err) {
-		ext4_std_error(sb, err);
-		goto out;
-	}
-	err = sync_dirty_buffer(inode_bitmap_bh);
-	if (err) {
-		ext4_std_error(sb, err);
-		goto out;
-	}
-
 	/* We may have to initialize the block bitmap if it isn't already */
 	err = ext4_might_init_block_bitmap(NULL, sb, group, gdp);
 	if (err)
 		goto out;
 
+	ext4_lock_group(sb, group);
+	/* Fast commit replay is single-threaded, no need for test_and_set */
+	ext4_set_bit(bit, inode_bitmap_bh->b_data);
+
 	/* Update the relevant bg descriptor fields */
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
 	if (ext4_has_group_desc_csum(sb)) {
-		int free;
+		bool fast_crc = true;
+		int free = EXT4_INODES_PER_GROUP(sb) -
+				ext4_itable_unused_count(sb, gdp);
 
-		ext4_lock_group(sb, group); /* while we modify the bg desc */
-		free = EXT4_INODES_PER_GROUP(sb) -
-			ext4_itable_unused_count(sb, gdp);
 		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
 			free = 0;
+			/* Incremental CRC needs a valid checksum baseline */
+			fast_crc = false;
 		}
 
 		/*
@@ -877,27 +879,26 @@ int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 		if (bit >= free)
 			ext4_itable_unused_set(sb, gdp,
 					(EXT4_INODES_PER_GROUP(sb) - bit - 1));
-	} else {
-		ext4_lock_group(sb, group);
+		if (fast_crc)
+			ext4_inode_bitmap_csum_set_fast(sb, gdp, bit);
+		else
+			ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
+		ext4_group_desc_csum_set(sb, group, gdp);
 	}
 
-	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
-	if (S_ISDIR(mode)) {
-		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
-		if (sbi->s_log_groups_per_flex) {
-			ext4_group_t f = ext4_flex_group(sbi, group);
+	ext4_unlock_group(sb, group);
 
-			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
-							f)->used_dirs);
-		}
+	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(NULL, NULL, inode_bitmap_bh);
+	if (err) {
+		ext4_std_error(sb, err);
+		goto out;
 	}
-
-	if (ext4_has_group_desc_csum(sb)) {
-		ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
-		ext4_group_desc_csum_set(sb, group, gdp);
+	err = sync_dirty_buffer(inode_bitmap_bh);
+	if (err) {
+		ext4_std_error(sb, err);
+		goto out;
 	}
-
-	ext4_unlock_group(sb, group);
 	err = ext4_handle_dirty_metadata(NULL, NULL, group_desc_bh);
 	sync_dirty_buffer(group_desc_bh);
 out:
-- 
2.43.7

