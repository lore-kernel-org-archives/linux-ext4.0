Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D285318A6DB;
	Fri,  8 May 2026 12:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242575; cv=none; b=qN1Ndx+FMlS+9OZP8s88Z78q2XBPV9Fsn08/rIRpnQ8+rd0I0t/iDvYLt1iiQiV2xKNETt7xd2zeB/SJENUeHay3dQR0R0tMgoUoWjSdT9BfR/QCBxNbhBDp9Jx4btUvFpgMiz4o0fem40MioKsfbRQiikmUoT/ODe+dzyvOgh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242575; c=relaxed/simple;
	bh=4G3Y6xq4wZzCXzS0j6TRGac8M0LV74cS9SY50eOOF4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqmMc31NDwm6KKnCMd9PdBCIlqmRMOCBaN3fHvTM84xAzovWSn7NuFocc5E1uTYuHtar8Z9jlAVhyWkYc38Gdp3lnq+LSGp7Q0tj6DCEsbr1L1KNem0D6gxoddsy6xl6OzqsTHR39M3mdm+2RQ5bNmwXyqRf1W8x3sQi3Nwh3ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e+W7lInc; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e+W7lInc"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242564; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zuuWOmJdIlo1PEaHWCpLgBtQsMQbVbjkhmxvFfLl6Mg=;
	b=e+W7lIncTdD12sJ1vGTkHwZsCDp4KOkNs9ViaYjbWiRirg/JiF1iz4eBb1+X9GN9bXeOMXyhp06d6lXIC814mpkmnVJSQI6NygspHsTgRtO5e7/ymw9O3+BAYQXMH9ghVqQbR3SwxYMM7kSqju8ZsNq/dw8yH03fZKx6sD9eLNU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgp9_1778242563;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgp9_1778242563 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:04 +0800
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
Subject: [PATCH RFC 06/17] ext4: add ext4_block_bitmap_csum_set_range() for incremental checksum update
Date: Fri,  8 May 2026 20:15:28 +0800
Message-ID: <20260508121539.4174601-7-libaokun@linux.alibaba.com>
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

Add a helper function ext4_block_bitmap_csum_set_range() that updates
the block bitmap checksum using crc32c_flip_range() for incremental CRC
calculation. Unlike ext4_block_bitmap_csum_set() which re-scans the
entire bitmap buffer, this function efficiently computes the CRC delta
for a range of flipped bits, avoiding the cost of a full CRC
recalculation.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/bitmap.c | 24 ++++++++++++++++++++++++
 fs/ext4/ext4.h   |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index 46affc9e80ca..00b0a3c74859 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -110,3 +110,27 @@ void ext4_block_bitmap_csum_set(struct super_block *sb,
 	csum = ext4_chksum(sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
 	ext4_block_bitmap_csum_store(sb, gdp, csum);
 }
+
+/*
+ * Update block bitmap checksum using incremental CRC calculation.
+ *
+ * This function assumes that ALL bits in the range [offset, offset+len)
+ * have been flipped (XORed with 1). It uses crc32c_flip_range() to
+ * efficiently compute the CRC delta without re-scanning the entire bitmap.
+ * The csum_seed cancels out in the XOR delta, so it is not needed here.
+ */
+void ext4_block_bitmap_csum_set_range(struct super_block *sb,
+				      struct ext4_group_desc *gdp,
+				      ext4_grpblk_t offset, ext4_grpblk_t len)
+{
+	__u32 new_csum, old_csum;
+
+	if (!ext4_has_feature_metadata_csum(sb))
+		return;
+
+	old_csum = ext4_block_bitmap_csum_get(sb, gdp);
+	new_csum = crc32c_flip_range(old_csum, EXT4_CLUSTERS_PER_GROUP(sb),
+				     offset, len);
+
+	ext4_block_bitmap_csum_store(sb, gdp, new_csum);
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..c423a9a04047 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2770,6 +2770,9 @@ int ext4_inode_bitmap_csum_verify(struct super_block *sb,
 void ext4_block_bitmap_csum_set(struct super_block *sb,
 				struct ext4_group_desc *gdp,
 				struct buffer_head *bh);
+void ext4_block_bitmap_csum_set_range(struct super_block *sb,
+				      struct ext4_group_desc *gdp,
+				      ext4_grpblk_t offset, ext4_grpblk_t len);
 int ext4_block_bitmap_csum_verify(struct super_block *sb,
 				  struct ext4_group_desc *gdp,
 				  struct buffer_head *bh);
-- 
2.43.7

