Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7D3DB652;
	Fri,  8 May 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242579; cv=none; b=eAtNHaxsEd3LpHKSnITG3GXVWgdQMGz2sXWOpZ950L89rbHlW3aYvNzfVbfW7apSapnR+YOlc+S1QbF61My0mucBKT/b8FeuvMu+i9B6Rq2FNRElHLSJMqgXjwNcAA7WexkWIN52AyJfg/Z4m8wgZDYU+CQ+RySaGeGzKm61VDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242579; c=relaxed/simple;
	bh=GU5GzNKyqcSOveYboJHbIMTB2oMGtzcAc4UAMgb3Ywg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQMvpXG8Wyb1X2uihLldzDeILqu3Uaew/lM0VwHqudAuuLn8czTU5/sGLBjxy2hTGm36DRgPoPuhAeTgh7N5nhbb79SANaO57PD2wy+9sjQ2PmdFWUFJsKSnLOrUIoag2L31R+LvhtUeXkjohu/fJIKv/cg260jwUdwK0lbx6Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=h3SnqpWM; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="h3SnqpWM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242568; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Rlokru3c3o+OyN0sDITif8sT6fm26WlVenfbU5I/VP4=;
	b=h3SnqpWMoVMXg0B4ZK3CW/6o5zc+4q+1JwvmR2qmtL+l7myx0l/RzZhKDFwcFIzU96g9gF1ldg9Mwiz+5GjV5Zu5wNy0F+XRpb6YRYtAeUwKlBxNfz7uTuWjtl4bGcDd6RLhBlBe8IYV0p9Cvxm1144SMG8jDkQnbp9eTip/7RM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgqK_1778242567;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgqK_1778242567 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:07 +0800
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
Subject: [PATCH RFC 10/17] ext4: use fast incremental CRC update in ext4_free_inode()
Date: Fri,  8 May 2026 20:15:32 +0800
Message-ID: <20260508121539.4174601-11-libaokun@linux.alibaba.com>
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

Replace ext4_inode_bitmap_csum_set() with the newly added
ext4_inode_bitmap_csum_set_fast() in ext4_free_inode() for incremental
inode bitmap checksum update.

This is safe because:
 - At inode free time, the inode bitmap checksum has already been
   initialized, so the old checksum is always valid.
 - The bitmap buffer modification and checksum update are protected
   by the same group lock, ensuring the old checksum is consistent
   with the bitmap content before the bit flip.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 3fd8f0099852..55eb69fbb4c9 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -327,7 +327,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		if (percpu_counter_initialized(&sbi->s_dirs_counter))
 			percpu_counter_dec(&sbi->s_dirs_counter);
 	}
-	ext4_inode_bitmap_csum_set(sb, gdp, bitmap_bh);
+	ext4_inode_bitmap_csum_set_fast(sb, gdp, bit);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 
-- 
2.43.7

