Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59603BED37;
	Wed,  8 Jul 2026 06:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492133; cv=none; b=XlQEXrW6MyRfR8YRkA7iG+ONy65OkPjsSTPZKMH9NAPgutYX2v34AGaMjAyOL7zZL0h1QRt7gDEBXCM5UW9t23WnwfBqDKVbwMKIyHHIamCeY1pnq3hZADOqHIjstwqwBzCUKWnSfmAUjCewO7St6POYEtKhLzheTbIXOgLqfNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492133; c=relaxed/simple;
	bh=9xQo5ZeSQpPUFCrc4/MevScdTTm3r4CSudmzzQ7nJOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqgLcnTJO2oVQkp0VBo2qVKYBST6NPhkiDgMgM80ljomlEWYy3+ES03Gx0KalnO5MvHXEcaMP7fbPDkE3vOcJCQ49YpMDI+5reFNrSqRqbVOl1iPI6FyEqeN0qtypDveZMSzafHsX0pm/ncbI6MGJdiy9UJ1WeUqOzsLGyvMpFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gw7TQ6DhlzYQtlt;
	Wed,  8 Jul 2026 14:28:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 71D304056D;
	Wed,  8 Jul 2026 14:28:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCnt3MT7k1q4VPeAQ--.18748S13;
	Wed, 08 Jul 2026 14:28:47 +0800 (CST)
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
Subject: [PATCH v3 9/9] ext4: protect WRITE_ZEROES written extents with orphan list
Date: Wed,  8 Jul 2026 14:20:49 +0800
Message-ID: <20260708062049.1982410-10-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgCnt3MT7k1q4VPeAQ--.18748S13
X-Coremail-Antispam: 1UD129KBjvJXoWxCFWfury8uFW3Xw1ktF4rAFb_yoWrGw1UpF
	W5Ar1rGFyrWasa9rZavF4DZF1Ykas7G3yUWryfW34jqan8Xr1FkFyaga4FvFWYqrWUZF4Y
	qr4Dt34UGa15ZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjfUriihUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
extents to written in one transaction while i_disksize is updated to
cover them only in a later transaction. A crash in between leaves
written extents beyond i_disksize on disk, which fsck will complain
about this.

Add the inode to the orphan list in the same handle that does the
conversion, and remove it once i_disksize has caught up. Fold
ext4_convert_unwritten_extents() into the same handle so the orphan
add and the conversion are atomic. Also add a check before conversion
to ensure the conversion does not extend beyond the end of the file.

Reported-by: Jan Kara <jack@suse.cz>
Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c083703bf704..9a1b06c8dd97 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4585,6 +4585,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	loff_t epos = 0, old_size = i_size_read(inode);
 	unsigned int blkbits = inode->i_blkbits;
 	bool alloc_zero = false;
+	bool orphan = false;
 
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
 	map.m_lblk = offset >> blkbits;
@@ -4659,12 +4660,35 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 
 		if (alloc_zero &&
 		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
+			WARN_ON_ONCE(map.m_lblk + map.m_len >
+				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
+
 			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
 						 map.m_len);
-			if (likely(!ret))
-				ret = ext4_convert_unwritten_extents(NULL,
+			if (unlikely(ret))
+				break;
+
+			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+						    credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				break;
+			}
+
+			if (new_size) {
+				ret = ext4_orphan_add(handle, inode);
+				orphan = true;
+				if (ret) {
+					ext4_journal_stop(handle);
+					break;
+				}
+			}
+
+			ret = ext4_convert_unwritten_extents(handle,
 					inode, (loff_t)map.m_lblk << blkbits,
 					(loff_t)map.m_len << blkbits);
+			ret2 = ext4_journal_stop(handle);
+			ret = ret ? ret : ret2;
 			if (ret)
 				break;
 		}
@@ -4678,7 +4702,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 		goto retry;
 
 	if (!epos || !new_size)
-		return ret;
+		goto out;
 
 	/*
 	 * Allocate blocks, update the file size to match the size of the
@@ -4687,12 +4711,16 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	if (epos > new_size)
 		epos = new_size;
 
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-	if (IS_ERR(handle))
-		return ret ? ret : PTR_ERR(handle);
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
+	if (IS_ERR(handle)) {
+		ret = ret ? ret : PTR_ERR(handle);
+		goto out;
+	}
 
 	ext4_update_inode_size(inode, epos);
 	ret2 = ext4_mark_inode_dirty(handle, inode);
+	if (orphan && inode->i_nlink)
+		ext4_orphan_del(handle, inode);
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 	ret3 = ext4_journal_stop(handle);
 	ret2 = ret3 ? ret3 : ret2;
@@ -4701,6 +4729,11 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 		pagecache_isize_extended(inode, old_size, epos);
 
 	return ret ? ret : ret2;
+
+out:
+	if (orphan && inode->i_nlink)
+		ext4_orphan_del(NULL, inode);
+	return ret;
 }
 
 static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
-- 
2.52.0

