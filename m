Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793326899;
	b=fOOVLdFDROC59e8OzjnbKO7o1JX9H1K8InblA2Nf/jWyU/FqCF7FU8c9oFvrLNN/OyDh
	 o1OOr+Vxp2VpvMiXnmrx01adrNrLGCyjmHiVie/JLjgIzkFqJoXjBdEaO5SsZc1gl/QA3
	 JRDWxpgE59v56szyjJVLUa3EnmaVR2PsGw1kFqEKu6VNltHa40UgX6D01miADYTQFiVx+
	 3TwvuuU7nD20sDzKrlGY4FCjk/oZTnqWq5PRraRhs6R/ecOjn471w8qCK44sVEmRLl+fg
	 FmRLxdjtQqEs6yHra2RNg57LivimIu9wMKipvrMgwxufVsWU9rZf+XOSwx2TO3MPHrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793326899;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=96pvUbD2oVPDXFefqTWjczvalAbiN+vB9gGlV9kuNGk=;
	b=b1Rd4uh3+5bpk1Ao8BNa/wi+aJ9Recrp2DD9D2lAfcDj5f0ts45U2uQXv0z9NUHae/L3
	 VU4MatNpmMOMYAr1Oi76HRrqSkA57/xzBS8hvmJlTvdprXKy65mBTjTfhx6zhNf3R4HBf
	 OrHivRakfllA4Amqki3VTKV+ZnfmuVI+ZEzbR8KCPAzGPKbhBShoDlgc8jnNxzLgrNVM+
	 bgGolRNTn/PLKuFwo5T0VJIAWG0l25ZaKL2tlHIWzD7362hHNXbTm1jiel7QwTnjsumjj
	 K3BBVGGt77BTsCu/ylATRXV/uQiWdv2jv+2XLQYhGSMwxq3lwwDAQBeEGO0UvXeFC/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0C0606A31F;
	Fri, 30 Oct 2026 02:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A0C0606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jG4bK3Yj9z20NG;
	Fri, 30 Oct 2026 10:21:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D1F1A40B47;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzewm_+NqieRyCQ--.40911S7;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
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
Subject: [PATCH v2 3/4] ext4: add inode to orphan list before extent conversion
Date: Fri, 30 Oct 2026 10:13:37 +0800
Message-ID: <20261030021338.1768292-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXzewm_+NqieRyCQ--.40911S7
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4xJr4UKrW5Jw1DJw47urg_yoWrZFy7p3
	y3AryrGanYqa4agas7ZF4jv3WYkayxGrWUXrWIgry0va45Xr1rKrW5Ka4j9FZYqrZ5XF1Y
	vF4UtryUCa1DZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7VU1sYFtUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_alloc_file_blocks() zeroes the blocks it has just allocated and
converts their unwritten extents in a handle started with
ext4_chunk_trans_blocks(), which reserves credits for a single extent.
The range is allocated with ext4_map_blocks() first and converted
afterwards, and only the unwritten extent conversion which runs on I/O
completion can modify the extent tree of that range in between, since
this path holds i_rwsem. If such a conversion converts part of the
range first, it splits the extent, and converting the whole range then
needs more credits than the handle has reserved.

Before commit 10660a0ca7ed ("ext4: rework handle credit accounting for
unwritten extent conversion"), this race condition led to insufficient
credits, which made the conversion fail with -ENOSPC in the middle of
the range. After it, ext4_convert_unwritten_extents() can extend or
restart the transaction. Restarting commits everything modified so
far, so the extents converted by the first iterations reach the disk
before this function adds the inode to the orphan list. A crash in
between leaves written extents beyond i_disksize on disk with the
inode not on the orphan list, which fsck complains about.

Add the inode to the orphan list before the conversion instead and keep
it there until i_disksize has caught up. A restart then commits the
orphan entry together with the extents converted so far, and the entry
is only removed by the transaction which raises i_disksize and i_size.

Fixes: 10660a0ca7ed ("ext4: rework handle credit accounting for unwritten extent conversion")
Fixes: f7237a775c8f ("ext4: protect WRITE_ZEROES written extents with orphan list")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f609..9f80beeaa1f29 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4701,6 +4701,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 				break;
 			}
 
+			/*
+			 * Add the inode to the orphan list before the
+			 * conversion, as it may restart the transaction and
+			 * commit the extents converted so far.  Written
+			 * extents must stay covered by the orphan list until
+			 * i_disksize catches up.
+			 */
+			if (new_size) {
+				ret2 = ext4_orphan_add(handle, inode);
+				orphan = true;
+				if (unlikely(ret2)) {
+					ret = ret2;
+					ext4_journal_stop(handle);
+					break;
+				}
+			}
+
 			ret = ext4_convert_unwritten_extents(handle,
 					inode, (loff_t)map.m_lblk << blkbits,
 					(loff_t)map.m_len << blkbits,
@@ -4708,23 +4725,21 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 			if (ret)
 				map.m_len = converted;
 
-			/*
-			 * If blocks beyond i_disksize are converted, add
-			 * the inode to the orphan list and advance the epos.
-			 */
-			if (new_size && converted) {
-				ret2 = ext4_orphan_add(handle, inode);
-				ret = ret ? ret : ret2;
-				orphan = true;
-			}
-
 			ret3 = ext4_journal_stop(handle);
 			ret = ret ? ret : ret3;
 		}
 
+		/*
+		 * The conversion may have failed without converting
+		 * anything. Only move epos over the blocks that were
+		 * actually converted, so that a failure updates
+		 * i_disksize just far enough to cover them.
+		 */
+		if (map.m_len)
+			epos = EXT4_LBLK_TO_B(inode, map.m_lblk + map.m_len);
+
 		map.m_lblk += map.m_len;
 		map.m_len = len_lblk = len_lblk - map.m_len;
-		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
 		if (ret)
 			break;
 	}
@@ -4732,12 +4747,13 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
-	if (!epos || !new_size)
+	if (!new_size || (!epos && !orphan))
 		return ret;
 
 	/*
-	 * Allocate blocks, update the file size to match the size of the
-	 * already successfully allocated blocks.
+	 * Update the file size to match the size of the already
+	 * successfully allocated blocks, and release the orphan entry
+	 * if we added one.
 	 */
 	if (epos > new_size)
 		epos = new_size;
@@ -4755,7 +4771,8 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 		goto out;
 	}
 
-	ext4_update_inode_size(inode, epos);
+	if (epos)
+		ext4_update_inode_size(inode, epos);
 	if (orphan && inode->i_nlink)
 		ext4_orphan_del(handle, inode);
 
-- 
2.52.0

