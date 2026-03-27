Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8F238CFFF;
	Fri, 27 Mar 2026 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774607680; cv=none; b=Nlo3ZbrSQHprbWv/3skqZzhGjiFwlPRiiNAJnziJfkayVidtWfhEm7s1YvGVBPjwyBqGfD7BNZ1P8YJSiOr9wXyvbbp0nW/2Y7EV/bYcSgXtNOv7SARqKogQ2qMo0hqUtUuow6u3+BonWVaP3P6E/gMhz7teOz/UBSqH6pP13LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774607680; c=relaxed/simple;
	bh=fMVXrpHueNdqeZTWFLtA8gyGmQHMRbTNJ3pFGiLRrRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4KVKyUUuExSez7s5/x+BWNU6LrxG1l3JMbEk5/4uVbjH4FQu3t/eXgIjAoxCAJt86NJvoyFj8cte+g0ftdkKjWMDRf+kSsuv+IjFjgLHPbn1mbHZlau7PhcMZZ5DsuTo8j03/PoQ9GgwfW/RczFvoIQoQtz79CinejkPnc73rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fhxnp3jyyzKHMbd;
	Fri, 27 Mar 2026 18:33:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3102840570;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgC3utouXcZp_T2cCQ--.28730S8;
	Fri, 27 Mar 2026 18:34:31 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 04/13] ext4: rename ext4_block_zero_page_range() to ext4_block_zero_range()
Date: Fri, 27 Mar 2026 18:29:30 +0800
Message-ID: <20260327102939.1095257-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3utouXcZp_T2cCQ--.28730S8
X-Coremail-Antispam: 1UD129KBjvJXoWxAw1fCr1rWF4DKF18tr43Wrg_yoW5try5pr
	y3tw15ur47W34v9a1xWF17Xr1Ik3Z3GFW8Xry7WryFv39xX3WfKF95K3Z5XF4jg3yxAa40
	qF4Yyry2gw17AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
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

Rename ext4_block_zero_page_range() to ext4_block_zero_range() since the
"page" naming is no longer appropriate for current context. Also change
its signature to take an inode pointer instead of an address_space. This
aligns with the caller ext4_block_zero_eof() and
ext4_zero_partial_blocks().

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1d6eb3ff437e..6e6bf693ef36 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4140,17 +4140,14 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
 }
 
 /*
- * ext4_block_zero_page_range() zeros out a mapping of length 'length'
- * starting from file offset 'from'.  The range to be zero'd must
- * be contained with in one block.  If the specified range exceeds
- * the end of the block it will be shortened to end of the block
- * that corresponds to 'from'
+ * Zeros out a mapping of length 'length' starting from file offset
+ * 'from'.  The range to be zero'd must be contained with in one block.
+ * If the specified range exceeds the end of the block it will be
+ * shortened to end of the block that corresponds to 'from'.
  */
-static int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length,
-		bool *did_zero)
+static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
+				 loff_t from, loff_t length, bool *did_zero)
 {
-	struct inode *inode = mapping->host;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	unsigned int max = blocksize - (from & (blocksize - 1));
 
@@ -4195,15 +4192,13 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
 	if (length > blocksize - offset)
 		length = blocksize - offset;
 
-	return ext4_block_zero_page_range(handle, inode->i_mapping, from,
-					  length, NULL);
+	return ext4_block_zero_range(handle, inode, from, length, NULL);
 }
 
 int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t length)
 {
 	struct super_block *sb = inode->i_sb;
-	struct address_space *mapping = inode->i_mapping;
 	unsigned partial_start, partial_end;
 	ext4_fsblk_t start, end;
 	loff_t byte_end = (lstart + length - 1);
@@ -4218,22 +4213,22 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 	/* Handle partial zero within the single block */
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
-		err = ext4_block_zero_page_range(handle, mapping,
-						 lstart, length, NULL);
+		err = ext4_block_zero_range(handle, inode, lstart,
+					    length, NULL);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
-		err = ext4_block_zero_page_range(handle, mapping, lstart,
-						 sb->s_blocksize, NULL);
+		err = ext4_block_zero_range(handle, inode, lstart,
+					    sb->s_blocksize, NULL);
 		if (err)
 			return err;
 	}
 	/* Handle partial zero out on the end of the range */
 	if (partial_end != sb->s_blocksize - 1)
-		err = ext4_block_zero_page_range(handle, mapping,
-						 byte_end - partial_end,
-						 partial_end + 1, NULL);
+		err = ext4_block_zero_range(handle, inode,
+					    byte_end - partial_end,
+					    partial_end + 1, NULL);
 	return err;
 }
 
-- 
2.52.0

