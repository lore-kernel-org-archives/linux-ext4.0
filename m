Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A29E3DB62F;
	Fri, 27 Mar 2026 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774607685; cv=none; b=Yey7DGtDPXCk69FXzucDduG/6mShrK617Stmu9vAYdA+4X1alsnUiJsVTqRTfeBGXDmV2BOtNjwZsgPw8CHqBFeqErqBcTBAPPnVa+9wvWEajJkKl6Zz2m6W7JKVr4uYANhKgbpEceLHaC0qftnzAnCcGwJ2xBDOUr8ZZT5IkmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774607685; c=relaxed/simple;
	bh=j/97nXmTe8IHvO2fi5SBryB3oogNc2Q7CceNOoEudAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohfzne9O1GJxm4uN3coBeeNoAh2X8UXG9N2mGkCbgvn1EX/o4IHm0pGw1XfWiEe1djNMQ3lBXFwfCfL8MknARsAj1LdTTwD2uFbLyfaGjW9nPcVHuzob0sSOi2B0epAnm70oQ7IN6L+R6CP0MnlEY6aEN+AbH4EIhoK14d9VV9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhxpM0zdjzYQv7N;
	Fri, 27 Mar 2026 18:34:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B425A4057A;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgC3utouXcZp_T2cCQ--.28730S13;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
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
Subject: [PATCH v4 09/13] ext4: ensure zeroed partial blocks are persisted in SYNC mode
Date: Fri, 27 Mar 2026 18:29:35 +0800
Message-ID: <20260327102939.1095257-10-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgC3utouXcZp_T2cCQ--.28730S13
X-Coremail-Antispam: 1UD129KBjvJXoWxJw1UKFyUXw4UKF17uFy5twb_yoWrtF18p3
	43JFy3Gr4fW348ur4fKF4UZr1ay3Z3GF48Wry3Grn8Za97X34xtFyDKF1FvF1YgrW3C340
	vF4Yy347Kr15CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In ext4_zero_range() and ext4_punch_hole(), when operating in SYNC mode
and zeroing a partial block, only data=journal modes guarantee that the
zeroed data is synchronously persisted after the operation completes.
For data=ordered/writeback mode and non-journal modes, this guarantee is
missing.

Introduce a partial_zero parameter to explicitly trigger writeback for
all scenarios where a partial block is zeroed, ensuring the zeroed data
is durably persisted.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/extents.c |  9 ++++++++-
 fs/ext4/inode.c   | 19 ++++++++++++++-----
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 859ae05339ad..bfe86479a83c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3101,7 +3101,7 @@ extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 				  int pextents);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
 extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
-				    loff_t length);
+				    loff_t length, bool *did_zero);
 extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 002b1ec8cee2..16386f499138 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4673,6 +4673,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	loff_t align_start, align_end, new_size = 0;
 	loff_t end = offset + len;
 	unsigned int blocksize = i_blocksize(inode);
+	bool partial_zeroed = false;
 	int ret, flags;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
@@ -4728,9 +4729,15 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		return ret;
 
 	/* Zero out partial block at the edges of the range */
-	ret = ext4_zero_partial_blocks(inode, offset, len);
+	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
 	if (ret)
 		return ret;
+	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
+		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
+						   end - 1);
+		if (ret)
+			return ret;
+	}
 
 	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
 	if (IS_ERR(handle)) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8aa4369e3150..b934ad86a96d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4227,7 +4227,8 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	return 0;
 }
 
-int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
+int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
+			     bool *did_zero)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned partial_start, partial_end;
@@ -4244,20 +4245,21 @@ int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
 	/* Handle partial zero within the single block */
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
-		err = ext4_block_zero_range(inode, lstart, length, NULL, NULL);
+		err = ext4_block_zero_range(inode, lstart, length, did_zero,
+					    NULL);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
 		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
-					    NULL, NULL);
+					    did_zero, NULL);
 		if (err)
 			return err;
 	}
 	/* Handle partial zero out on the end of the range */
 	if (partial_end != sb->s_blocksize - 1)
 		err = ext4_block_zero_range(inode, byte_end - partial_end,
-					    partial_end + 1, NULL, NULL);
+					    partial_end + 1, did_zero, NULL);
 	return err;
 }
 
@@ -4406,6 +4408,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t end = offset + length;
 	handle_t *handle;
 	unsigned int credits;
+	bool partial_zeroed = false;
 	int ret;
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
@@ -4441,9 +4444,15 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	if (ret)
 		return ret;
 
-	ret = ext4_zero_partial_blocks(inode, offset, length);
+	ret = ext4_zero_partial_blocks(inode, offset, length, &partial_zeroed);
 	if (ret)
 		return ret;
+	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
+		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
+						   end - 1);
+		if (ret)
+			return ret;
+	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		credits = ext4_chunk_trans_extent(inode, 0);
-- 
2.52.0

