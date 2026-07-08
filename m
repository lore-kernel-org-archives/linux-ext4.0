Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701613C0A0F;
	Wed,  8 Jul 2026 06:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492133; cv=none; b=U/Z8IgKbY9+PR2pYHQJ50JdMicBDa0EaMY8zBk1jsMCAtDkVYVOJIs2lZgBw5qE5N/27i8jiXiC4V/XSgOAKmbMlt1CGriIFIIjQQxsWk04Q/kMHEpZg8Wr9jke15MbIM+5GCRgjSUVqo8DKYDzSKTaceUyv7VWrSsZuYZxsWns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492133; c=relaxed/simple;
	bh=PVA6DdCgLybyUqldxtr0sqWGMetb0y50f6resr6doE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d904RJkiPoAlbixkLdvz2ulz7p4ZMNtdfDJlVmQgNf0PXS1Jv5SSJF4stFrKnE9XnKR04bwsZp1DzlG6SB0K5ED+y6CNNVQeDTcRERBIi8Aw+a3NPRMDTk7xzpUTDvhct8rtWJ3flrc+aWOxf6MX5MZ/Mhn7Hg9ku/sSVKnHlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gw7T64MnXzKHMMC;
	Wed,  8 Jul 2026 14:28:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2AE364056E;
	Wed,  8 Jul 2026 14:28:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCnt3MT7k1q4VPeAQ--.18748S9;
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
Subject: [PATCH v3 5/9] ext4: clarify return semantics of ext4_load_tail_bh()
Date: Wed,  8 Jul 2026 14:20:45 +0800
Message-ID: <20260708062049.1982410-6-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgCnt3MT7k1q4VPeAQ--.18748S9
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF43ZF1kuF1xAr4UuryrtFb_yoW8ZrWUpa
	sIgasFgrWrW3s29ayxJ3W7Xr1rtasrGr4UWayfK3W2va45Wr4SqFnFyFya9F4jyrWfWrZ0
	qFWUKry7Gan8C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUriihUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_load_tail_bh() returns NULL for both holes and clean unwritten
buffers, but the conditions that lead to this are not obvious from the
code alone. Document this behavior to clarify the return value, so that
readers do not mistakenly assume that only holes result in a NULL
return.

Also update the inline comment following the ext4_get_block() call to
reflect this, and note that a lookup-only get_block (without
EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean unwritten
extents, which is why a clean unwritten bh falls through to the
"nothing to do" path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ba4fc3c93bb6..2cb1b93d3ed1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
  * because it might have data in pagecache (eg, if called from ext4_zero_range,
  * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
  * racing writeback can come later and flush the stale pagecache to disk.
+ *
+ * Return the loaded bh if it actually needs zeroing - in written, dirty
+ * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
+ * a clean unwritten block).
  */
 static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 {
@@ -4067,7 +4071,12 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 		err = ext4_get_block(inode, iblock, bh, 0);
 		if (err < 0)
 			goto unlock;
-		/* unmapped? It's a hole - nothing to do */
+		/*
+		 * It's a hole or a clean unwritten block - nothing to do.
+		 * Note that a lookup-only get_block (without
+		 * EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean
+		 * unwritten extents.
+		 */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
 			goto unlock;
-- 
2.52.0

