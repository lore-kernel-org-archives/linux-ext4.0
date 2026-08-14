Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31435377EC6;
	Fri, 14 Aug 2026 09:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700394; cv=none; b=G+NB5XVFVUjDQ5NdC6H8xK5dIWJ9wQUH/FhZrZE8C47PfhU2hUhhH/5C1TkZR7lR06sH9/9PXboWBIO4EhEmp9Ysowk+KcM4/FtD/SqGFvkl2jLtB94Z2AJOUcglbvE9Vp/fSDWchxopBUrpwhm/EMvU+JNxG7UDYt7C0ZtT1WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700394; c=relaxed/simple;
	bh=fHnvvL2PcXYW2npa1XrNItDS5pTvHwExN8HGy/aZcDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWrgURJy2v+zpkpqugx2keecXEAZsukxwkhTtTXY1p6N7m8chSD72NSlBrnsMynZnXXG/IPSd2O+oGFP1Fcz25TvqhEw61gj3U6fB48dF5fAwwvOcus47ggA/wzGC9TuZCq/lQSbs0jdAWhFofUENXL4DrZk0BNykTQqX0johnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyg2whMzYQvQl;
	Fri, 14 Aug 2026 17:39:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 9770240590;
	Fri, 14 Aug 2026 17:39:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S8;
	Fri, 14 Aug 2026 17:39:47 +0800 (CST)
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
	yukuai@fnnas.com
Subject: [PATCH -next v5 04/32] ext4: skip ordered I/O wait when zeroing beyond i_disksize block
Date: Fri, 14 Aug 2026 17:33:03 +0800
Message-ID: <20260814093331.1703882-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S8
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy5Jr4fCw1fWw47uw1xXwb_yoW8Cr1xpa
	y3Gr18Cr4kG3s09w1vq3WIg34Ykan5Ga1rGFZrJr4q9FW3uw1v9F4xt34jvFW2yrs3Ga10
	qF45GrW3Z34DA3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNF4EDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_block_zero_eof() zeros the tail of a partial block beyond EOF.
After zeroing, it waits for ordered I/O completion to prevent stale
data exposure from concurrent post-EOF mmap writes during folio
writeback.

However, if the zeroed range lies entirely beyond the block containing
i_disksize, no stale data can be exposed because the zeroed region is
beyond existing on-disk data. The zeroed pages will be written out
before i_disksize is later extended past i_size, so the ordered I/O
wait is unnecessary. Add a condition to skip it.

Suggested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 76bf0e944ebe..7601fe3618b1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4241,9 +4241,16 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * truncating up or performing an append write, because there might be
 	 * exposing stale on-disk data which may caused by concurrent post-EOF
 	 * mmap write during folio writeback.
+	 *
+	 * Ordered I/O is required only when zeroing the tail of a block that
+	 * overlaps with i_disksize. If the zeroed range falls outside that
+	 * block, the zeroed data lies beyond the existing on-disk data. It
+	 * will be written out before i_disksize is later extended past
+	 * i_size, so no stale data can be exposed.
 	 */
 	if (ext4_should_order_data(inode) &&
-	    did_zero && zero_written && !IS_DAX(inode)) {
+	    did_zero && zero_written && !IS_DAX(inode) &&
+	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
 		handle_t *handle;
 
 		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-- 
2.52.0

