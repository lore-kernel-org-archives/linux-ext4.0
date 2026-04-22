Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596B43537D2;
	Wed, 22 Apr 2026 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824227; cv=none; b=TWrdYo7IJE/MAsRUOJzNceIJz5qz5kMdPMiVLUoyfqd5JRbIyCoYi3jKjG1xEqSCQ49IpPwNEhbHZbMOYZ/0v/RrChJymDxwSaE2ahSY9vGNktujOy0pOtYA9SrFvgrBgpHYOWjo4XOHqpVv/Y99ZYJw6RliRUmR2BvdSpxLaKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824227; c=relaxed/simple;
	bh=YXZHG7P9OY/dRX5x+8FscTuosfa5/dTxnRRQxgnAInY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H85vH6KuXpCQzZN4o7I2zmIhl6QjlOPpe1Opg6Q7W1rcHNj5yzmsiTWUyB9vYGBbb2FFnAUiSdylLNFCC3WRRRF07z1CZVo8W4YEoR+KK5J6qo5OFCS/xt4RioLlhygHMbRULDTWOu5cGCL/iLzpTB73HAgluyLpj5V5bYisdQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0jWN1YmtzYQts7;
	Wed, 22 Apr 2026 10:16:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 677A540609;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S23;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 19/22] ext4: submit zeroed post-EOF data immediately in the iomap buffered I/O path
Date: Wed, 22 Apr 2026 10:10:39 +0800
Message-ID: <20260422021042.4157510-20-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S23
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1UKr1rKr1fAry8uFyUJrb_yoW5ZrWxpr
	W3Kw1rAw4q9F9F9r4SqF17Xr1aka1rGw48GFWxWr40vay3X3WrKFy2k34rAFWUtr45Way2
	qF45JFWDWF1UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In the generic buffered_head I/O path, we rely on the data=order mode to
ensure that the zeroed EOF block data is written before updating
i_disksize, thus preventing stale data from being exposed.

However, the iomap buffered I/O path cannot use this mechanism. Instead,
we issue the I/O immediately after performing the zero operation
(without synchronous waiting). This can reduce the risk of exposing
stale data, but it does not guarantee that the zero data will be flushed
to disk before the metadata of i_disksize is updated. The subsequent
patches will wait for this I/O to complete before updating i_disksize.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 58 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d2f7af7922d7..d55899c1ef4c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4766,8 +4766,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
 
-	if (length > blocksize - offset)
+	if (length > blocksize - offset) {
 		length = blocksize - offset;
+		end = from + length;
+	}
 
 	err = ext4_block_zero_range(inode, from, length,
 				    &did_zero, &zero_written);
@@ -4782,18 +4784,52 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * TODO: In the iomap path, handle this by updating i_disksize to
 	 * i_size after the zeroed data has been written back.
 	 */
-	if (ext4_should_order_data(inode) &&
-	    did_zero && zero_written && !IS_DAX(inode)) {
-		handle_t *handle;
+	if (did_zero && zero_written && !IS_DAX(inode)) {
+		if (ext4_should_order_data(inode)) {
+			handle_t *handle;
 
-		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
+			if (IS_ERR(handle))
+				return PTR_ERR(handle);
 
-		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
-		ext4_journal_stop(handle);
-		if (err)
-			return err;
+			err = ext4_jbd2_inode_add_write(handle, inode, from,
+							length);
+			ext4_journal_stop(handle);
+			if (err)
+				return err;
+		/*
+		 * inodes using the iomap buffered I/O path do not use the
+		 * data=ordered mode. We submit zeroed range here.
+		 *
+		 * TODO: The end_io process needs to wait for I/O to completes
+		 * before updating i_disksize.
+		 */
+		} else if (ext4_inode_buffered_iomap(inode)) {
+			struct folio *folio;
+			bool do_submit = false;
+
+			folio = filemap_lock_folio(inode->i_mapping,
+						   from >> PAGE_SHIFT);
+			if (IS_ERR(folio))
+				/* Already writeback and clear? */
+				return PTR_ERR(folio) == -ENOENT ? 0 :
+						PTR_ERR(folio);
+
+			folio_wait_writeback(folio);
+			WARN_ON_ONCE(folio_test_writeback(folio));
+
+			if (likely(folio_test_dirty(folio)))
+				do_submit = true;
+			folio_unlock(folio);
+			folio_put(folio);
+
+			if (do_submit) {
+				err = filemap_fdatawrite_range(inode->i_mapping,
+							       from, end - 1);
+				if (err)
+					return err;
+			}
+		}
 	}
 
 	return 0;
-- 
2.52.0

