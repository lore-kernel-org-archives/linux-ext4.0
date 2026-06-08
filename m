Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D7A346E68
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 11:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917127; cv=none; b=M+an+mm3BLgGXir6Xnf6NcO7GzinTrxkkLc9aZ2Z/IC8PPcDEgXJi5qs2FLf6Luj7+V9l+GBxvqfJcsQit2rN1hpk5JqTh6g1xpPBJedH6ajhogvkMP+Xm6XSpRPOOenogHi8ENDydW4nYvUe9O/yrv8nWiAjqBFWr4lIkU0hrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917127; c=relaxed/simple;
	bh=88ZBq+ICDrTWpbPK/4AzZKQdZIn5aDLXt4mPK1FiyVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoiVAECY+iPaEfm9sVcMi4TTUlXj1l5/HJlC726HiOAExzw6o6h7c/KhjQTSOj+1d5abcA7NB8vS3eDwJ+e8JPgtyHhktv0Ur0nQI8SXF77Nv3O3QCDVdYlwn1JRlv8FA2ELEYViKTXZUJvuteR3eEUMVjtjjv6tjHgDyuLf6do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nbpol8ej; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nbpol8ej"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780917122; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ea1dkdVuj9VJG3S69RbqT7C8iLB/VIR2/WsrMRa0G0U=;
	b=nbpol8ejVj8FE+GDAFSLaJiyj0uzZ1fOPZd2oQ2qgT3Zo/65gTOc5+ohY3N5jYTaFtgdgzZiG3d9lOAQHIw2zBIYcwWfHe7G3g/THv9D9l43J+V4QoGuzWfcEln6JpagmH2VrjONqozGupRrmQkj+H0XD8JLnJtMh+vVQGyGzQM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X4Nw8Rw_1780917121;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4Nw8Rw_1780917121 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 19:12:02 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 1/3] ext4: reject mount if clusters/inodes per group are not 8-aligned
Date: Mon,  8 Jun 2026 19:11:48 +0800
Message-ID: <20260608111150.827117-2-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260608111150.827117-1-libaokun@linux.alibaba.com>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The block and inode bitmap checksums are computed over a whole number of
bytes: ext4_inode_bitmap_csum_*() use EXT4_INODES_PER_GROUP(sb) >> 3 and
ext4_block_bitmap_csum_*() use EXT4_CLUSTERS_PER_GROUP(sb) / 8 as the
length passed to ext4_chksum().

If s_inodes_per_group or s_clusters_per_group is not a multiple of 8, the
trailing fractional bits are excluded from the checksum.  Those bits are
then unprotected, and any incremental csum update path that assumes a
byte-aligned bitmap can compute a checksum inconsistent with the full
recalculation, corrupting the on-disk bitmap checksum.

Reject such filesystems at mount time by adding the missing " & 7"
alignment checks alongside the existing range validation.

Suggested-by: Theodore Ts'o <tytso@mit.edu>
Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260508121539.4174601-1-libaokun%40linux.alibaba.com?part=10
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..3ddcb4a8d4db 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4472,8 +4472,9 @@ static int ext4_handle_clustersize(struct super_block *sb)
 		sbi->s_cluster_bits = 0;
 	}
 	sbi->s_clusters_per_group = le32_to_cpu(es->s_clusters_per_group);
-	if (sbi->s_clusters_per_group > sb->s_blocksize * 8) {
-		ext4_msg(sb, KERN_ERR, "#clusters per group too big: %lu",
+	if (sbi->s_clusters_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_clusters_per_group & 7) {
+		ext4_msg(sb, KERN_ERR, "invalid #clusters per group: %lu",
 			 sbi->s_clusters_per_group);
 		return -EINVAL;
 	}
@@ -5304,8 +5305,9 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
 		return -EINVAL;
 	}
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
-	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
-		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
+	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_inodes_per_group & 7) {
+		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
 			 sbi->s_inodes_per_group);
 		return -EINVAL;
 	}
-- 
2.43.7

