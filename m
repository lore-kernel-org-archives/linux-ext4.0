Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F0A4ACC60;
	Fri,  9 Oct 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542249; cv=none; b=kZXKpBPMawhmdp3RfET+h3uVgJ5wNGORwTK5nffn4Bgvmj84v2dJmqX+RzpkzlDxaAsBWiRJZMy0EH0QT/eb01gEOFx4f6NkiTIaOCdAy/vm8EtC0GZMpFnqQzOyj30WuLSdmHO/Nw+Bw1K+MyNapGF6dYTFg8R1HwTf+QITCAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542249; c=relaxed/simple;
	bh=70dfTJg8ct7WaPi1j+hXoldab/s3PsHt4fc+YbhCXmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0KMQaBrcFXLrieylCDngdLPruZoYVyhGbFaWMQzd0/ihmOuwpXoSYOsgbMTk18CL8jCgPeDXaBnsW4tPTipm/VQXpvhD7rNcuBBFWyiX8mCBK0gPpScn5DnFDPnwGxVLsRn7eVSdNn4/hW8e5wN19s3dyOq1DGSjUdAIg+QVrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZN2mv3zKHMqn;
	Fri,  9 Oct 2026 18:36:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 5066D40D0E;
	Fri,  9 Oct 2026 18:37:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S18;
	Fri, 09 Oct 2026 18:37:20 +0800 (CST)
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
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v7 14/31] ext4: rework handle credit accounting for unwritten extent conversion
Date: Fri,  9 Oct 2026 18:30:15 +0800
Message-ID: <20261009103033.2920530-15-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S18
X-Coremail-Antispam: 1UD129KBjvJXoWxXr13AFWkAw1fCF48Jry5Jwb_yoWrtFWrpF
	y3Ca4Fkr15Ww129FWxAF48AF1ak3W8GrW7ArZ3Gr9xAay5Xr1SgFy5K3WFkFy5KrWxWFya
	vr4jk34UGws8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRRyxRDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

While converting the buffered I/O path to iomap, we noticed that the
writeback completion can hand over an ioend which was merged across an
arbitrary number of extents because iomap_ioend_try_merge() doesn't
limit the length of the merged ioends, while
ext4_convert_unwritten_extents() converts all of them with the handle
provided by the caller, and callers calculate the credits of that handle
without knowing the exact number of extents. Converting more extents
than that within one transaction can exhaust its credits.

Prepare for the iomap path nevertheless by making the conversion loop
check the remaining credits before each extent with
ext4_journal_ensure_credits(), so that the transaction is extended, or
restarted once it is full, as needed. Also estimate the credits with
ext4_meta_trans_blocks(..., alloc_extents = 0), since no data blocks are
allocated here, and manage an internally started transaction as a whole
instead of starting and stopping one for each extent.

The buffer_head writeback path is safe, as it passes a handle whose
credits are reserved by ext4_meta_trans_blocks(inode, bpf, bpf, 0),
which is enough to convert one extent per block of a folio, so the
reservation is sufficient and the handle is never restarted there.

This also helps the fallocate path, where ext4_alloc_file_blocks() sizes
the handle for the conversion with ext4_chunk_trans_blocks() as well,
i.e. for a single extent only, while a concurrent modification of the
extent tree can make the conversion cover more extents than the handle
has credits for.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 53 ++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6c36552..83d040e36b682 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5137,27 +5137,36 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 	int ret = 0, ret2 = 0, ret3 = 0;
 	struct ext4_map_blocks map;
 	unsigned int blkbits = inode->i_blkbits;
-	unsigned int credits = 0;
+	unsigned int credits;
+	bool internal_handle = !handle;
 
 	map.m_lblk = offset >> blkbits;
 	map.m_len = max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
 
-	if (!handle) {
-		/*
-		 * credits to insert 1 extent into extent tree
-		 */
-		credits = ext4_chunk_trans_blocks(inode, max_blocks);
+	/* Credits to convert one extent in this range to written state. */
+	credits = ext4_meta_trans_blocks(inode, max_blocks, 1, 0);
+
+	if (internal_handle) {
+		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS, credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
 	}
 
 	while (max_blocks) {
-		if (credits) {
-			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
-						    credits);
-			if (IS_ERR(handle)) {
-				ret = PTR_ERR(handle);
-				break;
-			}
-		}
+		/*
+		 * The caller cannot know how many extents the range covers,
+		 * so make sure the transaction can take one more extent,
+		 * extending or restarting it once it is full.  The reserved
+		 * handle of the buffer_head writeback path is safe as it has
+		 * enough credits for the conversion, so it is not restarted
+		 * here.
+		 */
+		ret = ext4_journal_ensure_credits(handle, credits, 0);
+		if (ret < 0)
+			break;
+
 		/*
 		 * Do not cache any unrelated extents, as it does not hold the
 		 * i_rwsem or invalidate_lock, which could corrupt the extent
@@ -5177,11 +5186,6 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 		}
 
 		ret2 = ext4_mark_inode_dirty(handle, inode);
-		if (credits) {
-			ret3 = ext4_journal_stop(handle);
-			if (unlikely(ret3))
-				ret2 = ret3;
-		}
 		ret = ret < 0 ? ret : ret2;
 		if (ret)
 			break;
@@ -5189,6 +5193,13 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 		map.m_lblk += map.m_len;
 		map.m_len = (max_blocks -= map.m_len);
 	}
+
+	if (internal_handle) {
+		ret3 = ext4_journal_stop(handle);
+		if (!ret)
+			ret = ret3;
+	}
+out:
 	/* Converted some or all blocks successfully? */
 	if (converted)
 		*converted = conv_blocks;
@@ -5203,8 +5214,8 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 
 	/*
 	 * This is somewhat ugly but the idea is clear: When transaction is
-	 * reserved, everything goes into it. Otherwise we rather start several
-	 * smaller transactions for conversion of each extent separately.
+	 * reserved, everything goes into it. Otherwise the conversion runs
+	 * its own transaction, extending or restarting it as it goes.
 	 */
 	if (handle) {
 		handle = ext4_journal_start_reserved(handle,
-- 
2.52.0

