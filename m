Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5713793DB;
	Thu, 26 Mar 2026 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523755; cv=none; b=idu/sHZCABHJyPd7r2cZZoQ3zIoZeglPJPDZiZATi2ovuokG9sBH5ILEMLQrzXBpIOVA4CRGXeSxYzuYnS5Hl6RQwhOxY/rrG1HGo/aCWvomLSXDvxiCk/BIfnQ9Kb/hXDpeHvW9hf2GBGAprwBC/n7KgxxKc2L7Q8Vqu4cdRMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523755; c=relaxed/simple;
	bh=viFvCHynwN2QwKfgVv4CMz86s7mPdhW8AzLlTm4Rt7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afgoLmF5hfrXErfoL2JEsPJImF1KTKMmvU3pzI2YpZKnuZa7HAULhuTI/rApgeugWh7xw3KcTbuPfxI60hAUGz28uab+DKFSn3F/2dZysaFeXyJP/Ex0m10sptOV1+X6S3SulB8WBRKHRlbvZNLcBdeFjGFJDUO5WsZU3bvYB30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhLmT590ZzYQv2F;
	Thu, 26 Mar 2026 19:15:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A5A2540574;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S5;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
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
Subject: [PATCH v3 01/11] ext4: add did_zero output parameter to ext4_block_zero_page_range()
Date: Thu, 26 Mar 2026 19:10:44 +0800
Message-ID: <20260326111054.907252-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260326111054.907252-1-yi.zhang@huaweicloud.com>
References: <20260326111054.907252-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S5
X-Coremail-Antispam: 1UD129KBjvJXoWxCF17XryfAw18KF1rKw15Jwb_yoW5uw1xpr
	y5t345ur47u34q9F4xWF1jvr1Sk3Z3GFW8W3y3G3s0v3yIq3WxKF95K3WFvF4jg3y7Xay0
	qF4Yy3y2gw1UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JU4OJ5UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add a bool *did_zero output parameter to ext4_block_zero_page_range()
and __ext4_block_zero_page_range(). The parameter reports whether a
partial block was zeroed out, which is needed for the upcoming iomap
buffered I/O conversion.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index af6d1759c8de..1c9474d5d11d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4003,7 +4003,8 @@ void ext4_set_aops(struct inode *inode)
  * racing writeback can come later and flush the stale pagecache to disk.
  */
 static int __ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length)
+		struct address_space *mapping, loff_t from, loff_t length,
+		bool *did_zero)
 {
 	unsigned int offset, blocksize, pos;
 	ext4_lblk_t iblock;
@@ -4091,6 +4092,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 			err = ext4_jbd2_inode_add_write(handle, inode, from,
 					length);
 	}
+	if (!err && did_zero)
+		*did_zero = true;
 
 unlock:
 	folio_unlock(folio);
@@ -4106,7 +4109,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
  * that corresponds to 'from'
  */
 static int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length)
+		struct address_space *mapping, loff_t from, loff_t length,
+		bool *did_zero)
 {
 	struct inode *inode = mapping->host;
 	unsigned blocksize = inode->i_sb->s_blocksize;
@@ -4120,10 +4124,11 @@ static int ext4_block_zero_page_range(handle_t *handle,
 		length = max;
 
 	if (IS_DAX(inode)) {
-		return dax_zero_range(inode, from, length, NULL,
+		return dax_zero_range(inode, from, length, did_zero,
 				      &ext4_iomap_ops);
 	}
-	return __ext4_block_zero_page_range(handle, mapping, from, length);
+	return __ext4_block_zero_page_range(handle, mapping, from, length,
+					    did_zero);
 }
 
 /*
@@ -4146,7 +4151,7 @@ static int ext4_block_truncate_page(handle_t *handle,
 	blocksize = i_blocksize(inode);
 	length = blocksize - (from & (blocksize - 1));
 
-	return ext4_block_zero_page_range(handle, mapping, from, length);
+	return ext4_block_zero_page_range(handle, mapping, from, length, NULL);
 }
 
 int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
@@ -4169,13 +4174,13 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
 		err = ext4_block_zero_page_range(handle, mapping,
-						 lstart, length);
+						 lstart, length, NULL);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
-		err = ext4_block_zero_page_range(handle, mapping,
-						 lstart, sb->s_blocksize);
+		err = ext4_block_zero_page_range(handle, mapping, lstart,
+						 sb->s_blocksize, NULL);
 		if (err)
 			return err;
 	}
@@ -4183,7 +4188,7 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 	if (partial_end != sb->s_blocksize - 1)
 		err = ext4_block_zero_page_range(handle, mapping,
 						 byte_end - partial_end,
-						 partial_end + 1);
+						 partial_end + 1, NULL);
 	return err;
 }
 
-- 
2.52.0

