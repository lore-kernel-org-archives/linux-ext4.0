Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E4E3D5244;
	Fri,  8 May 2026 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242582; cv=none; b=OdBps8L+tL6BKlsBYUaSerlAV7acwNzqFYIZ6h8GvGaccmbFFDNgC+ow80XlZVs3Bf4rrfi2OpvK5TnLVjXx8PYxysNiZ2cSLylrkWK5TGbC/rG4um6GA6L1ZQaJAnTCiGbsgBMQbLeqUd3DAgOtew3i4Uaj8xawaCUyc5Y2hnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242582; c=relaxed/simple;
	bh=ru7eSD7FE1o2zyOuZ/OIwiAjOXqgGwTWmXfp8+TDFjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEtKwVmCmUqvbuBZYK9kdBoyQ1uBzp9jkpG6uxJtYR0wR0cIRldAXqkWggkAtBPMryTOZyGkFxgCdUbvIK65ZNX4Vo48Y0kvs962oLt40Aju7Y2TwRoVPUnppJAFewElAOdWT5gPE3ESl+2O3MZuEEznVVXPXbLWxBQZZG18dI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tjgu8Aa9; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tjgu8Aa9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242572; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=rBO8Eie88UmrTBPFytczv1QUExFDkjPYiN01+iCNxl8=;
	b=tjgu8Aa9zc2a6556hUC7phsd//b5zRVUlcwfgIjNFQcWiPBFmV9RTjMLaBuDSgImkhq3N88njUSBBryFCf8TPey0SdC1jR4cvR8DPeFbL3Jwne0N4bQzsSA0CHZDm63wqpdgwribyAq5qNfxASwTwb4OmClYUMSyhHa0akhTDFA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgrP_1778242570;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgrP_1778242570 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:11 +0800
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
Subject: [PATCH RFC 15/17] ext4: use fast incremental CRC update in __ext4_new_inode()
Date: Fri,  8 May 2026 20:15:37 +0800
Message-ID: <20260508121539.4174601-16-libaokun@linux.alibaba.com>
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

Merge the bitmap modification and group descriptor update into a single
group lock acquisition in __ext4_new_inode(). Previously the bitmap bit
was set under one lock/unlock pair, and the GDP fields (UNINIT,
itable_unused, free_inodes, dirs, csum) were updated under a separate
lock/unlock pair with a gap in between. Another thread could modify the
bitmap and update the checksum during that gap, making incremental CRC
incorrect.

Now the full sequence -- set bit, update free inodes, clear UNINIT,
update itable_unused, and compute checksum -- happens atomically under
the same ext4_lock_group(). The alloc_sem is acquired before the group
lock to maintain correct locking order with itable lazyinit.

Use ext4_inode_bitmap_csum_set_fast() for the normal path where the
stored checksum is valid. When EXT4_BG_INODE_UNINIT is set, fall back
to ext4_inode_bitmap_csum_set() for a full recalculation to establish
a correct baseline (mkfs leaves the checksum as zero for UNINIT groups).

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ialloc.c | 129 +++++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 66 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 8b75b331b26e..9dd1cdb367ba 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1135,7 +1135,25 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 			ext4_std_error(sb, err);
 			goto out;
 		}
+
+		BUFFER_TRACE(group_desc_bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, sb, group_desc_bh,
+						    EXT4_JTR_NONE);
+		if (err) {
+			ext4_std_error(sb, err);
+			goto out;
+		}
+
+		/* We may have to initialize the block bitmap if it isn't already */
+		err = ext4_might_init_block_bitmap(handle, sb, group, gdp);
+		if (err)
+			goto out;
+
+		if (ext4_has_group_desc_csum(sb) &&
+		    !(sbi->s_mount_state & EXT4_FC_REPLAY))
+			down_read(&grp->alloc_sem);
 		ext4_lock_group(sb, group);
+
 		ret2 = ext4_test_and_set_bit(bit, inode_bitmap_bh->b_data);
 		if (ret2) {
 			/* Someone already took the bit. Repeat the search
@@ -1147,9 +1165,54 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 				ret2 = 0;
 			} else {
 				ret2 = 1; /* we didn't grab the inode */
+				goto unlock_group;
+			}
+		}
+
+		/* Update the relevant bg descriptor fields */
+		ext4_free_inodes_set(sb, gdp,
+				     ext4_free_inodes_count(sb, gdp) - 1);
+		if (S_ISDIR(mode)) {
+			ext4_used_dirs_set(sb, gdp,
+					   ext4_used_dirs_count(sb, gdp) + 1);
+			if (sbi->s_log_groups_per_flex) {
+				ext4_group_t f = ext4_flex_group(sbi, group);
+				atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
+								f)->used_dirs);
+			}
+		}
+
+		if (ext4_has_group_desc_csum(sb)) {
+			bool fast_crc = true;
+			int free = EXT4_INODES_PER_GROUP(sb) -
+					ext4_itable_unused_count(sb, gdp);
+
+			if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+				gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
+				free = 0;
+				/* Incremental CRC needs a valid csum baseline */
+				fast_crc = false;
 			}
+			/*
+			 * Check the relative inode number against the
+			 * last used relative inode number in this group.
+			 * If it is greater we need to update the
+			 * bg_itable_unused count.
+			 */
+			if (bit >= free)
+				ext4_itable_unused_set(sb, gdp,
+					EXT4_INODES_PER_GROUP(sb) - bit - 1);
+			if (fast_crc)
+				ext4_inode_bitmap_csum_set_fast(sb, gdp, bit);
+			else
+				ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
+			ext4_group_desc_csum_set(sb, group, gdp);
 		}
+unlock_group:
 		ext4_unlock_group(sb, group);
+		if (ext4_has_group_desc_csum(sb) &&
+		    !(sbi->s_mount_state & EXT4_FC_REPLAY))
+			up_read(&grp->alloc_sem);
 		if (!ret2)
 			goto got; /* we grabbed the inode! */
 
@@ -1168,72 +1231,6 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		goto out;
 	}
 
-	BUFFER_TRACE(group_desc_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, sb, group_desc_bh,
-					    EXT4_JTR_NONE);
-	if (err) {
-		ext4_std_error(sb, err);
-		goto out;
-	}
-
-	/* We may have to initialize the block bitmap if it isn't already */
-	err = ext4_might_init_block_bitmap(handle, sb, group, gdp);
-	if (err)
-		goto out;
-
-	/* Update the relevant bg descriptor fields */
-	if (ext4_has_group_desc_csum(sb)) {
-		int free;
-		struct ext4_group_info *grp = NULL;
-
-		if (!(sbi->s_mount_state & EXT4_FC_REPLAY)) {
-			grp = ext4_get_group_info(sb, group);
-			if (!grp) {
-				err = -EFSCORRUPTED;
-				goto out;
-			}
-			down_read(&grp->alloc_sem); /*
-						     * protect vs itable
-						     * lazyinit
-						     */
-		}
-		ext4_lock_group(sb, group); /* while we modify the bg desc */
-		free = EXT4_INODES_PER_GROUP(sb) -
-			ext4_itable_unused_count(sb, gdp);
-		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
-			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
-			free = 0;
-		}
-		/*
-		 * Check the relative inode number against the last used
-		 * relative inode number in this group. if it is greater
-		 * we need to update the bg_itable_unused count
-		 */
-		if (bit >= free)
-			ext4_itable_unused_set(sb, gdp,
-					(EXT4_INODES_PER_GROUP(sb) - bit - 1));
-		if (!(sbi->s_mount_state & EXT4_FC_REPLAY))
-			up_read(&grp->alloc_sem);
-	} else {
-		ext4_lock_group(sb, group);
-	}
-
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
-	if (ext4_has_group_desc_csum(sb)) {
-		ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
-		ext4_group_desc_csum_set(sb, group, gdp);
-	}
-	ext4_unlock_group(sb, group);
-
 	BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
 	if (err) {
-- 
2.43.7

