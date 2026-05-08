Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BC43DBD76;
	Fri,  8 May 2026 12:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242575; cv=none; b=doyl6c/SCbkkW9IhVSST/WN0pC0naACR7lvfqg+eYJAVG/wXbVX3RFrhgjEXF926aXQKsEC8w86E1DtGgpBNd+LbUCS7Wa5y5i8ZyKUtLavFpPfGuV4P3TwXb8rFoTjwX5oRf+TZ5zprFRfiwWC6qMgtupT4htqj/SThOal4/bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242575; c=relaxed/simple;
	bh=olkM4+FWlC4BLP/SL9xpg/LejXRBiGobEelmKBOsTW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYfRMFmdcgzCUJ8khwVgjHPpy6aMm/R79xWa+sIBq0lOlipQ5znd7COKtdQfkYGR9IBWbEyzKmi8sCO7O2uVDrsnh7bvfdLSxXLQHfvOn/EDPUxl4j4ci6hGWoDGpTkOxqqD1RWrXVy3SeTPsYUunwRhkKIXPQoLEg2se8DiGCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hhz1eRJA; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hhz1eRJA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242564; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=1Y3Dg8VLiBIuOI2ZnBPqViCvDT9IQnATlwd9T0kLB3w=;
	b=hhz1eRJACJfkXsCdLfROL2V9PrNYZhdf5Jr+ECV+njfrKA33hwW0yVnYTlJ9EE6Ejw3PCEoqiUT0Q5hBN0BZQPy2/BircuTocSHTrYkj2kjkXE7RRNGObweV/TzjCmI6I5xRFHmBFVBVv4yjy2PS1KZUPTsANg9iSzRbkfRls8s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgob_1778242562;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgob_1778242562 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:03 +0800
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
Subject: [PATCH RFC 05/17] ext4: extract block bitmap checksum get and store helpers
Date: Fri,  8 May 2026 20:15:27 +0800
Message-ID: <20260508121539.4174601-6-libaokun@linux.alibaba.com>
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

Add ext4_block_bitmap_csum_get() and ext4_block_bitmap_csum_store()
helpers, and use EXT4_DESC_SIZE(sb) instead of sbi->s_desc_size for
consistency. No functional change.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/bitmap.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index 87760fabdd2e..46affc9e80ca 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -58,11 +58,29 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb,
 		gdp->bg_inode_bitmap_csum_hi = cpu_to_le16(csum >> 16);
 }
 
+static inline __u32 ext4_block_bitmap_csum_get(struct super_block *sb,
+					       struct ext4_group_desc *gdp)
+{
+	__u32 csum = le16_to_cpu(gdp->bg_block_bitmap_csum_lo);
+
+	if (EXT4_DESC_SIZE(sb) >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_END)
+		csum |= (__u32)le16_to_cpu(gdp->bg_block_bitmap_csum_hi) << 16;
+	return csum;
+}
+
+static inline void ext4_block_bitmap_csum_store(struct super_block *sb,
+						struct ext4_group_desc *gdp,
+						__u32 csum)
+{
+	gdp->bg_block_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_END)
+		gdp->bg_block_bitmap_csum_hi = cpu_to_le16(csum >> 16);
+}
+
 int ext4_block_bitmap_csum_verify(struct super_block *sb,
 				  struct ext4_group_desc *gdp,
 				  struct buffer_head *bh)
 {
-	__u32 hi;
 	__u32 provided, calculated;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int sz = EXT4_CLUSTERS_PER_GROUP(sb) / 8;
@@ -70,12 +88,9 @@ int ext4_block_bitmap_csum_verify(struct super_block *sb,
 	if (!ext4_has_feature_metadata_csum(sb))
 		return 1;
 
-	provided = le16_to_cpu(gdp->bg_block_bitmap_csum_lo);
+	provided = ext4_block_bitmap_csum_get(sb, gdp);
 	calculated = ext4_chksum(sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
-	if (sbi->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_END) {
-		hi = le16_to_cpu(gdp->bg_block_bitmap_csum_hi);
-		provided |= (hi << 16);
-	} else
+	if (EXT4_DESC_SIZE(sb) < EXT4_BG_BLOCK_BITMAP_CSUM_HI_END)
 		calculated &= 0xFFFF;
 
 	return provided == calculated;
@@ -93,7 +108,5 @@ void ext4_block_bitmap_csum_set(struct super_block *sb,
 		return;
 
 	csum = ext4_chksum(sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
-	gdp->bg_block_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
-	if (sbi->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_END)
-		gdp->bg_block_bitmap_csum_hi = cpu_to_le16(csum >> 16);
+	ext4_block_bitmap_csum_store(sb, gdp, csum);
 }
-- 
2.43.7

