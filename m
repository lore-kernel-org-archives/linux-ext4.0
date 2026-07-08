Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0373BD647;
	Wed,  8 Jul 2026 06:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492133; cv=none; b=I4Z8z0sW0TDl4UnV6PLFWCtjngU1sO2iA/ryuc1ksse1GjQBry2oCi6zz0E/sYHU2czklNl/WGUjp3q4vgooVcCRx5a5GMAZ95JDapGXhw2uiS/oKtuLedrn0PqN3A9UX+rotelxYaPExJuZxet90AwNl1TKNPOcT59mPRni5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492133; c=relaxed/simple;
	bh=er5gSXh4WoEeObr+y+xU144WDRdSn80S3L1zLSycrGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAN4Ya6tJ+RKaCDCwz9tjtEAluwdsanNIpYOrYZeHxKS2O0Y3UbrPR2Dq8UScD+/xJ0mavAqE1AEhxkKCbpOlEzxyX70ybhI+F5yi/jld4NYoHtURdCfJhDE3bEHcLYlM9WxaPNFv6CF0wrVePNsvcobDjJ/v0aFJPqlgpfM8Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gw7T63gmXzKHMNP;
	Wed,  8 Jul 2026 14:28:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 11C6340592;
	Wed,  8 Jul 2026 14:28:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCnt3MT7k1q4VPeAQ--.18748S8;
	Wed, 08 Jul 2026 14:28:46 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 4/9] ext4: move partial block zeroing earlier in ext4_zero_range()
Date: Wed,  8 Jul 2026 14:20:44 +0800
Message-ID: <20260708062049.1982410-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCnt3MT7k1q4VPeAQ--.18748S8
X-Coremail-Antispam: 1UD129KBjvJXoW7uFy3uF4fGFyUGry3ur1kuFg_yoW8CF4fp3
	93XF13Kr4fWry5uFWIkF15Zw4Yk3Z7GF4UGrWagr1jva9xXryfKFs0kF10gF40qrZ7AayU
	ZF4Yy347Kr45uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUriihUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In ext4_zero_range(), move the ext4_zero_partial_blocks() call, which
handles unaligned edges, into the same branch where the unaligned range
is preallocated, immediately after ext4_alloc_file_blocks(). This is
safe because there is no dependency between partial block handling and
the subsequent full block handling.

This change will be used by later patches that handle unaligned
FALLOC_FL_WRITE_ZEROES operations, which will need to check the partial
zeroed result.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 125f628e738a..27ca641e701b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4734,10 +4734,16 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	}
 
 	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
-	/* Preallocate the range including the unaligned edges */
+	/*
+	 * Preallocate the range including the unaligned edges, and zero
+	 * out partial blocks if they already contain data.
+	 */
 	if (!IS_ALIGNED(offset | end, blocksize)) {
 		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
 					     flags);
+		if (!ret)
+			ret = ext4_zero_partial_blocks(inode, offset, len,
+						       &partial_zeroed);
 		if (ret)
 			return ret;
 	}
@@ -4770,10 +4776,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (IS_ALIGNED(offset | end, blocksize))
 		return ret;
 
-	/* Zero out partial block at the edges of the range */
-	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
-	if (ret)
-		return ret;
 	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
 		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
 						   end - 1);
-- 
2.52.0

