Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4A735C1B1;
	Fri,  8 May 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242580; cv=none; b=cQa4L1gYQ0QzOvF7z52MMjVuqKaBmvlo+AxEEyCtzlUT8tr28eosFGAYmS/nImAnO2rpsqvGivPNdTslRES/D+3krtXot7Mh9ErZw1eMzyWRRIUb89QXbho1yrKPF+3NtQ0IozDlJd0ZE9r28wdh4zFidnNE7LKPzSuf3/ITqOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242580; c=relaxed/simple;
	bh=E1iM1lZsolq6iuP7YKbLXFWX7mH6dphdedRJnVUu10Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiHQVxSLutFU/MkG4BBv+vCw3108I6S/0RhvvsJ000cXlrpoCMBgYnFX6Upu7qG6auReXWjvZQLqJQ3WsWU1zTnBHA+gTIrD5AKbfC+06GthQpVHFu6oywCS4ftwZnJ+YXsVwhYgPF3SNO6l6phE44rowbeSQXGqxFwe0SlpJlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Tcvp3BN9; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Tcvp3BN9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242567; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ocXa+cNFtPu91m7KczsGdIvia8D3mi5RoPrjj8lNwlE=;
	b=Tcvp3BN9adMeGNBj0ctYwWda1D6NWGqjoCRl6TilLDQNqPTdwtZYQZ6JCsVXledJNsqhVwTJ/o0PgZ9pggY3T+n6/zDRJO5ARMc2R/qyO2HnBX0jFvFsNm7+6aTQMrbYEfukh+EtsPA6gLT9SZIpzhobWXeRnh46bXcNZTPRU+I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgpn_1778242565;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgpn_1778242565 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:05 +0800
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
Subject: [PATCH RFC 08/17] ext4: extract inode bitmap checksum get and store helpers
Date: Fri,  8 May 2026 20:15:30 +0800
Message-ID: <20260508121539.4174601-9-libaokun@linux.alibaba.com>
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

Add ext4_inode_bitmap_csum_get() and ext4_inode_bitmap_csum_store()
helpers, and use EXT4_DESC_SIZE(sb) instead of sbi->s_desc_size for
consistency. No functional change.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/bitmap.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index 00b0a3c74859..008acc439301 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -16,11 +16,29 @@ unsigned int ext4_count_free(char *bitmap, unsigned int numchars)
 	return numchars * BITS_PER_BYTE - memweight(bitmap, numchars);
 }
 
+static inline __u32 ext4_inode_bitmap_csum_get(struct super_block *sb,
+					       struct ext4_group_desc *gdp)
+{
+	__u32 csum = le16_to_cpu(gdp->bg_inode_bitmap_csum_lo);
+
+	if (EXT4_DESC_SIZE(sb) >= EXT4_BG_INODE_BITMAP_CSUM_HI_END)
+		csum |= (__u32)le16_to_cpu(gdp->bg_inode_bitmap_csum_hi) << 16;
+	return csum;
+}
+
+static inline void ext4_inode_bitmap_csum_store(struct super_block *sb,
+						struct ext4_group_desc *gdp,
+						__u32 csum)
+{
+	gdp->bg_inode_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_BG_INODE_BITMAP_CSUM_HI_END)
+		gdp->bg_inode_bitmap_csum_hi = cpu_to_le16(csum >> 16);
+}
+
 int ext4_inode_bitmap_csum_verify(struct super_block *sb,
 				  struct ext4_group_desc *gdp,
 				  struct buffer_head *bh)
 {
-	__u32 hi;
 	__u32 provided, calculated;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int sz;
@@ -29,12 +47,9 @@ int ext4_inode_bitmap_csum_verify(struct super_block *sb,
 		return 1;
 
 	sz = EXT4_INODES_PER_GROUP(sb) >> 3;
-	provided = le16_to_cpu(gdp->bg_inode_bitmap_csum_lo);
+	provided = ext4_inode_bitmap_csum_get(sb, gdp);
 	calculated = ext4_chksum(sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
-	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_END) {
-		hi = le16_to_cpu(gdp->bg_inode_bitmap_csum_hi);
-		provided |= (hi << 16);
-	} else
+	if (EXT4_DESC_SIZE(sb) < EXT4_BG_INODE_BITMAP_CSUM_HI_END)
 		calculated &= 0xFFFF;
 
 	return provided == calculated;
@@ -53,9 +68,7 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb,
 
 	sz = EXT4_INODES_PER_GROUP(sb) >> 3;
 	csum = ext4_chksum(sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
-	gdp->bg_inode_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
-	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_END)
-		gdp->bg_inode_bitmap_csum_hi = cpu_to_le16(csum >> 16);
+	ext4_inode_bitmap_csum_store(sb, gdp, csum);
 }
 
 static inline __u32 ext4_block_bitmap_csum_get(struct super_block *sb,
-- 
2.43.7

