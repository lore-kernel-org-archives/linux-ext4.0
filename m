Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AD63DA5DC;
	Fri,  8 May 2026 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242580; cv=none; b=JUdUBAP5OodZ6EgQjWzzANgZ+lyA3Gf8vdElxgZtdSFeP9YIicXISDoJnjRxSZE/oEQD98XnCHTQk/TJYDBdPw4Vo40rQFZDs7OUixebVcbtqavrNN0Pgn2Cac4KJ6fv5RBdX4c58fMgbHarvejuwgzzMEm+UmS2oQ3LP6z+J7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242580; c=relaxed/simple;
	bh=vBNO2Bvyb8M0KvGjxHVE5XxThYzHNdNL1nT/bjDLgeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqdjcyMakGK8xTAVqHHr+ZD17UFOk2drMxvlfL8rhXQmcbLqIQDoLe1RipQo3IW+UuBFqrEYS/mT0QuOzZSqFOffbKX8pxCHJ5jlJV7LKHyT+7kPnddptDJ0IrgPPWXU9x1PCr2XO7rPjiA0smclJCm1IFG6QZtokrwEyE9dD2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e/jNtFAx; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e/jNtFAx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242569; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Pyydu/+mSA8+HVaiGjvimdSM19JdEkQ9zUvMzEWmW5w=;
	b=e/jNtFAxpfMViYJVnBTmqLtcsE57duadw9Mcs3XIWmQFCs42TddxZu3fuvEXhjx3nlnSGAiXgEQHXvUotC3GaqYxJU6Psn35Fwhc+uI/EljAKGkaB7uKpS9Ya6ZRC8cGDxxALFtswwTFRJ36ycQJky5QqI0Com4r+4K3jiSvTd8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgqm_1778242568;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgqm_1778242568 cluster:ay36)
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
Subject: [PATCH RFC 12/17] ext4: factor out ext4_might_init_block_bitmap() helper
Date: Fri,  8 May 2026 20:15:34 +0800
Message-ID: <20260508121539.4174601-13-libaokun@linux.alibaba.com>
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

Extract the BLOCK_UNINIT initialization logic from ext4_mark_inode_used()
and __ext4_new_inode() into a shared ext4_might_init_block_bitmap() helper.

Both call sites perform the same sequence: check EXT4_BG_BLOCK_UNINIT,
read the block bitmap, dirty it, then clear the flag and establish the
correct block bitmap checksum under the group lock.  The only difference
is whether a journal handle is available (NULL during fast commit replay
in ext4_mark_inode_used()).

No functional change.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ialloc.c | 129 +++++++++++++++++++++--------------------------
 1 file changed, 58 insertions(+), 71 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 5896cdfb2ccf..90896b7f8c73 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -756,6 +756,58 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 	return 1;
 }
 
+/*
+ * If the block bitmap for @group is not yet initialized (EXT4_BG_BLOCK_UNINIT),
+ * read it into memory, dirty it, and clear the UNINIT flag under the group lock
+ * so that the on-disk checksum is established.  @handle may be NULL during fast
+ * commit replay (no journal credits needed in that path).
+ */
+static int ext4_might_init_block_bitmap(handle_t *handle,
+					struct super_block *sb,
+					ext4_group_t group,
+					struct ext4_group_desc *gdp)
+{
+	int err;
+	struct buffer_head *block_bitmap_bh;
+
+	if (!ext4_has_group_desc_csum(sb) ||
+	    !(gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
+		return 0;
+
+	block_bitmap_bh = ext4_read_block_bitmap(sb, group);
+	if (IS_ERR(block_bitmap_bh))
+		return PTR_ERR(block_bitmap_bh);
+
+	if (handle) {
+		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
+		err = ext4_journal_get_write_access(handle, sb,
+				block_bitmap_bh, EXT4_JTR_NONE);
+		if (err)
+			goto out_brelse;
+	}
+
+	BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
+	err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
+	if (!handle)
+		sync_dirty_buffer(block_bitmap_bh);
+
+	/* recheck and clear flag under lock if we still need to */
+	ext4_lock_group(sb, group);
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
+		ext4_free_group_clusters_set(sb, gdp,
+			ext4_free_clusters_after_init(sb, group, gdp));
+		ext4_block_bitmap_csum_set(sb, gdp, block_bitmap_bh);
+		ext4_group_desc_csum_set(sb, group, gdp);
+	}
+	ext4_unlock_group(sb, group);
+
+out_brelse:
+	brelse(block_bitmap_bh);
+	ext4_std_error(sb, err);
+	return err;
+}
+
 int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 {
 	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
@@ -801,38 +853,9 @@ int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 	}
 
 	/* We may have to initialize the block bitmap if it isn't already */
-	if (ext4_has_group_desc_csum(sb) &&
-	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		struct buffer_head *block_bitmap_bh;
-
-		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
-		if (IS_ERR(block_bitmap_bh)) {
-			err = PTR_ERR(block_bitmap_bh);
-			goto out;
-		}
-
-		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
-		err = ext4_handle_dirty_metadata(NULL, NULL, block_bitmap_bh);
-		sync_dirty_buffer(block_bitmap_bh);
-
-		/* recheck and clear flag under lock if we still need to */
-		ext4_lock_group(sb, group);
-		if (ext4_has_group_desc_csum(sb) &&
-		    (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))) {
-			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
-			ext4_free_group_clusters_set(sb, gdp,
-				ext4_free_clusters_after_init(sb, group, gdp));
-			ext4_block_bitmap_csum_set(sb, gdp, block_bitmap_bh);
-			ext4_group_desc_csum_set(sb, group, gdp);
-		}
-		ext4_unlock_group(sb, group);
-		brelse(block_bitmap_bh);
-
-		if (err) {
-			ext4_std_error(sb, err);
-			goto out;
-		}
-	}
+	err = ext4_might_init_block_bitmap(NULL, sb, group, gdp);
+	if (err)
+		goto out;
 
 	/* Update the relevant bg descriptor fields */
 	if (ext4_has_group_desc_csum(sb)) {
@@ -1154,45 +1177,9 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 	}
 
 	/* We may have to initialize the block bitmap if it isn't already */
-	if (ext4_has_group_desc_csum(sb) &&
-	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		struct buffer_head *block_bitmap_bh;
-
-		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
-		if (IS_ERR(block_bitmap_bh)) {
-			err = PTR_ERR(block_bitmap_bh);
-			goto out;
-		}
-		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
-		err = ext4_journal_get_write_access(handle, sb, block_bitmap_bh,
-						    EXT4_JTR_NONE);
-		if (err) {
-			brelse(block_bitmap_bh);
-			ext4_std_error(sb, err);
-			goto out;
-		}
-
-		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
-		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
-
-		/* recheck and clear flag under lock if we still need to */
-		ext4_lock_group(sb, group);
-		if (ext4_has_group_desc_csum(sb) &&
-		    (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))) {
-			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
-			ext4_free_group_clusters_set(sb, gdp,
-				ext4_free_clusters_after_init(sb, group, gdp));
-			ext4_block_bitmap_csum_set(sb, gdp, block_bitmap_bh);
-			ext4_group_desc_csum_set(sb, group, gdp);
-		}
-		ext4_unlock_group(sb, group);
-		brelse(block_bitmap_bh);
-
-		if (err) {
-			ext4_std_error(sb, err);
-			goto out;
-		}
-	}
+	err = ext4_might_init_block_bitmap(handle, sb, group, gdp);
+	if (err)
+		goto out;
 
 	/* Update the relevant bg descriptor fields */
 	if (ext4_has_group_desc_csum(sb)) {
-- 
2.43.7

