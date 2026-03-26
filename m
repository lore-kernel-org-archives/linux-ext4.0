Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235113859EC;
	Thu, 26 Mar 2026 11:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523756; cv=none; b=Lsz5v2Fc2dYStt6047KoS5EgK/8799oWxIAzShIaMWYmCF+X4FwZ+gSXGpZF4JFtofQ64TmmNC295t5yhLGmRwGfqLspHc52s7VsIteQIvjndQ4+nrSdsQtr0A+44MvWLCSJmv96QxrdfdfDfF4QQnMbu3pqJgLRlzIiGffBfVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523756; c=relaxed/simple;
	bh=O3/imx8V6zIXOmaZ3jq7idWbuIt/Pkm26283YKmlLb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn5fcCpYNa1J6LSkEjTW+TXONRD9zQYwGvrpd98XZnAXwS2X07bfOjRNmWxu9FiTVfIG63ERR8Qmy9ySrkRQ44hShUYUlFUIcR+nfEZzlj7Ncj1ckrlRxdFSsirUOQIrhkR0xAh7v26Tno8OaqNyaxaj7LdVX7rGwxlWfq3nnMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fhLly1lBhzKHMm3;
	Thu, 26 Mar 2026 19:15:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6444740592;
	Thu, 26 Mar 2026 19:15:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S14;
	Thu, 26 Mar 2026 19:15:50 +0800 (CST)
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
Subject: [PATCH v3 10/11] ext4: move pagecache_isize_extended() out of active handle
Date: Thu, 26 Mar 2026 19:10:53 +0800
Message-ID: <20260326111054.907252-11-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S14
X-Coremail-Antispam: 1UD129KBjvJXoWxJFy3Xr1fKr1rCr1UXrykGrg_yoW5try3pr
	W3CF1rtF1FgFyq9r4ftr4DZr4Yga48KrWUZr93Wr9Yv3ZxXr1rKr1YyFyFvFW5trW8XF4Y
	qrs0yw15G3WUZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In ext4_alloc_file_blocks(), pagecache_isize_extended() is called under
an active handle and may also hold folio lock if the block size is
smaller than the folio size. This also breaks the "folio lock ->
transaction start" lock ordering for the upcoming iomap buffered I/O
path.

Therefore, move pagecache_isize_extended() outside of an active handle.
Additionally, it is unnecessary to update the file length during each
iteration of the allocation loop. Instead, update the file length only
to the position where the allocation is successful. Postpone updating
the inode size until after the allocation loop completes or is
interrupted due to an error.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 69 +++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4155a2e37070..19fc1ef7b2c3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4618,44 +4618,61 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 			ext4_journal_stop(handle);
 			break;
 		}
+		ext4_update_inode_fsync_trans(handle, inode, 1);
+		ret = ext4_journal_stop(handle);
+		if (unlikely(ret))
+			break;
+
 		/*
 		 * allow a full retry cycle for any remaining allocations
 		 */
 		retries = 0;
-		epos = EXT4_LBLK_TO_B(inode, map.m_lblk + ret);
-		if (new_size) {
-			if (epos > new_size)
-				epos = new_size;
-			ext4_update_inode_size(inode, epos);
-			if (epos > old_size)
-				pagecache_isize_extended(inode, old_size, epos);
+
+		if (alloc_zero &&
+		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
+			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
+						 map.m_len);
+			if (likely(!ret))
+				ret = ext4_convert_unwritten_extents(NULL,
+					inode, (loff_t)map.m_lblk << blkbits,
+					(loff_t)map.m_len << blkbits);
+			if (ret)
+				break;
 		}
+
+		map.m_lblk += map.m_len;
+		map.m_len = len_lblk = len_lblk - map.m_len;
+	}
+
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+
+	if (!new_size)
+		return ret;
+
+	/*
+	 * Update the file size to match the size of the already successfully
+	 * allocated blocks.
+	 */
+	epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
+	if (epos > new_size)
+		epos = new_size;
+	if (epos > old_size) {
+		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		ext4_update_inode_size(inode, epos);
+
 		ret2 = ext4_mark_inode_dirty(handle, inode);
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 		ret3 = ext4_journal_stop(handle);
 		ret2 = ret3 ? ret3 : ret2;
-		if (unlikely(ret2))
-			break;
 
-		if (alloc_zero &&
-		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
-			ret2 = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
-						  map.m_len);
-			if (likely(!ret2))
-				ret2 = ext4_convert_unwritten_extents(NULL,
-					inode, (loff_t)map.m_lblk << blkbits,
-					(loff_t)map.m_len << blkbits);
-			if (ret2)
-				break;
-		}
-
-		map.m_lblk += ret;
-		map.m_len = len_lblk = len_lblk - ret;
+		pagecache_isize_extended(inode, old_size, epos);
 	}
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-		goto retry;
 
-	return ret > 0 ? ret2 : ret;
+	return ret ? ret : ret2;
 }
 
 static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
-- 
2.52.0

