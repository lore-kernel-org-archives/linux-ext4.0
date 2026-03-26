Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFDB36D4F3;
	Thu, 26 Mar 2026 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523757; cv=none; b=je4Wfg3U6KYW6SvVSmK4mbJ2/6DN0RoWnCaGH1oA8B/tR9FOq4sZnILyQ4dUyB83Rxyu2LdaDb8a8mmXXn97jJ1yycRUAEyTM0yruDkX+iZ1ldC9OREiBS8lIiCqnkYkMrIxPEMHmj/zQ6REBsPXabYqMvMVKutFlVzPTVhIUio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523757; c=relaxed/simple;
	bh=Vglqg+ydcyhGixaPRDhh554/99k9qa8m4O96LGyBQU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEupvXAltmCUZKaFdLRSyBFbLjOdw11ChUjE7jZCnJDL/o9ZOi1P9jakW/7ZLco0Z6okvvfembk005nFOYP4hCbl3uLZFL/tK3/s5Yk1cFFVFibWa0SbXOUSEdsyZeENtHawvo4tMzi2VHhvpixnGBXcn5X5kNu3briSCrSGTVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhLmT6zvZzYQv6x;
	Thu, 26 Mar 2026 19:15:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E1EF140573;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S8;
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
Subject: [PATCH v3 04/11] ext4: rename ext4_block_zero_page_range() to ext4_block_zero_range()
Date: Thu, 26 Mar 2026 19:10:47 +0800
Message-ID: <20260326111054.907252-5-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S8
X-Coremail-Antispam: 1UD129KBjvJXoWxAw1fAr4kZFyfZr4kGw15Jwb_yoW5Aryrpr
	y3tw15Cr47W34v93WxWF17Xr1Ik3Z3GFWkXrW7G3sYv3y7Xas3tF98K3Z5XF4j93yxXa40
	qF4Yyry2gw17AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
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
 fs/ext4/inode.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1d6eb3ff437e..543f7e4a60fa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4146,11 +4146,9 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
  * the end of the block it will be shortened to end of the block
  * that corresponds to 'from'
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
 
@@ -4195,15 +4193,13 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
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
@@ -4218,22 +4214,22 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
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

