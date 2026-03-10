Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156502D948D;
	Tue, 10 Mar 2026 01:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773107103; cv=none; b=mx1kC+oR+Ap8S4kI77/sKOeqww6oM2H6QF5wR8rs6iBu54/TuBgEBl3YuduEdmdZ/XonPq3MxiWX+LRa+Jpk1jKoPFz1I5T/TuCNtOAh/63ASDukrw5On6jPc+3dOkKdQazihsORIccZvMz4OvrW7AiDh+q7fr7/6o/2As+eHAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773107103; c=relaxed/simple;
	bh=Uy6cz216vRWwGv4DackxaFJkN/qF1b4+tW0m892G2f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHUyXcVVTeqtGPy6mtWKmlaCmyZZ9khccy3OaoVTZTSFSjVshrINlq7b/+edBMrQOR3FULO4L5vRoxLAzwGecAnhzBClL5eceZ4p4y9yuSxrh4VMcZtVr4pDJAs01wCObdJ0tV1YVdYu/nON6ADTdqI2JNRbQHEsmr2Zcade0ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVGs767F2zKHMm0;
	Tue, 10 Mar 2026 09:44:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 66BF940579;
	Tue, 10 Mar 2026 09:44:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgB3edmQd69pXNliAQ--.11692S14;
	Tue, 10 Mar 2026 09:44:58 +0800 (CST)
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
Subject: [PATCH 10/10] ext4: zero post-EOF partial block before appending write
Date: Tue, 10 Mar 2026 09:41:01 +0800
Message-ID: <20260310014101.4140698-11-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3edmQd69pXNliAQ--.11692S14
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW8WrWrtryxZr4DtFy5Jwb_yoWrJr1xpF
	ZIkF1fuw12gr9rWrWIgFsrZ34jka48JrW7GFyfKrWfZFnxAw18KF12q34UtFW5trZrXw4F
	qF4q9Fy8W3WUA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In cases of appending write beyond EOF, ext4_zero_partial_blocks() is
called within ext4_*_write_end() to zero out the partial block beyond
EOF. This prevents exposing stale data that might be written through
mmap.

However, supporting only the regular buffered write path is
insufficient. It is also necessary to support the DAX path as well as
the upcoming iomap buffered write path. Therefore, move this operation
to ext4_write_checks().

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/file.c  | 14 ++++++++++++++
 fs/ext4/inode.c | 21 +++++++--------------
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f1dc5ce791a7..b2e44601ab6a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -271,6 +271,8 @@ static ssize_t ext4_generic_write_checks(struct kiocb *iocb,
 
 static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t old_size = i_size_read(inode);
 	ssize_t ret, count;
 
 	count = ext4_generic_write_checks(iocb, from);
@@ -280,6 +282,18 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	ret = file_modified(iocb->ki_filp);
 	if (ret)
 		return ret;
+
+	/*
+	 * If the position is beyond the EOF, it is necessary to zero out the
+	 * partial block that beyond the existing EOF, as it may contains
+	 * stale data written through mmap.
+	 */
+	if (iocb->ki_pos > old_size && !ext4_verity_in_progress(inode)) {
+		ret = ext4_block_zero_eof(inode, old_size, iocb->ki_pos);
+		if (ret < 0)
+			return ret;
+	}
+
 	return count;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5288d36b0f09..67a4d12fcb4d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1456,10 +1456,9 @@ static int ext4_write_end(const struct kiocb *iocb,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (old_size < pos && !verity) {
+	if (old_size < pos && !verity)
 		pagecache_isize_extended(inode, old_size, pos);
-		ext4_block_zero_eof(inode, old_size, pos);
-	}
+
 	/*
 	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
 	 * makes the holding time of folio lock longer. Second, it forces lock
@@ -1574,10 +1573,8 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (old_size < pos && !verity) {
+	if (old_size < pos && !verity)
 		pagecache_isize_extended(inode, old_size, pos);
-		ext4_block_zero_eof(inode, old_size, pos);
-	}
 
 	if (size_changed) {
 		ret2 = ext4_mark_inode_dirty(handle, inode);
@@ -3196,7 +3193,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	loff_t old_size = inode->i_size;
 	bool disksize_changed = false;
-	loff_t new_i_size, zero_len = 0;
+	loff_t new_i_size;
 	handle_t *handle;
 
 	if (unlikely(!folio_buffers(folio))) {
@@ -3240,19 +3237,15 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (pos > old_size) {
+	if (pos > old_size)
 		pagecache_isize_extended(inode, old_size, pos);
-		zero_len = pos - old_size;
-	}
 
-	if (!disksize_changed && !zero_len)
+	if (!disksize_changed)
 		return copied;
 
-	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
-	if (zero_len)
-		ext4_block_zero_eof(inode, old_size, pos);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
 
-- 
2.52.0

