Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793326899;
	b=mUJilHLXqwgq1D4WBlUIVq0/+1oGS3LAUSNVu1Wl1enQGFyM/F4vXLrbDz+Hlrg5emZF
	 EDz9KLRB75xyT3LEHbTD+NQvoNn8qfgypxVmc3gCsyJlWrLMkTnf561xFfTMrFtIgrjOb
	 yrtttJpGoqHBk62k5+Vy/tg2eBWTp1mHbvJg4cQpUdv2OkjiSkwqZm0FmGmzVsoDID1dr
	 f5MYrxcL5eP/JnbD7+G/wKurtXx1dVSQGIyAnr05jgMNWbWMIcyvVfWC+5WJn88yqd/9g
	 4NhUOUUHgOzM3hLxQWXOiHY//mdKoBNqHrkDeXL7g+QQpFq7uBlXI6d3YuvjCzC1hMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793326899;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=PUUn0CPDPh2hEHWVe738DxX2+G0wvbw3bsMHEdQr8Vw=;
	b=c5GRMjqBG3Fge+WfehFFKfPLqde37NuKnU7/8hNnySjgsfnlW5Jrgk1ROEti+AIyvS7L
	 ISaDWXYt6Cl64TMTXkEX+6jtyRQ7UCl95fYSqL55eT3xlz3z/VU870CBVZ8ByTop8S+hE
	 AXo6wgs1frVVy4kPd1jap9xo140KA3t+y8/SLswz61wTRt5aK+0mnSMOVjvH5UuZjVyCP
	 KQFsOp/EbllpMhdFHRFHvjzMrK4cIU+4BeotwVZStLWOuLaEhmNjpUgKqzmBqqdejgcKB
	 pWboEIKjuZxiCb6y9/XEmKzb6UUFMbpKVPZVI6CWVrYA3TByu7MlVnoVd7knsfivb6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5E4606A31E;
	Fri, 30 Oct 2026 02:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A5E4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jG4bH6QqWz1c2Hs;
	Fri, 30 Oct 2026 10:21:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B695340576;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzewm_+NqieRyCQ--.40911S6;
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
Subject: [PATCH v2 2/4] ext4: fix extent status cache clearing when truncating inline data
Date: Fri, 30 Oct 2026 10:13:36 +0800
Message-ID: <20261030021338.1768292-3-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXzewm_+NqieRyCQ--.40911S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4UKF17GFyfKw18Xry7KFg_yoW5WFW5pF
	ZxCw4UGr1kW348GF97Z3WjqF1Fga1xGrW7WFy2gr1DWFy5CFyIgF90krWYva48Kr4vvayj
	vFWYvr1DCa15JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUF5rcDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_inline_data_truncate() clears the whole extent status tree of the
inode when it truncates the inline data, with

	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);

It does that when the inode still carries inline data while the
EXT4_STATE_MAY_INLINE_DATA state bit is already cleared.  This is the
case once an inline-to-extent conversion has been initiated, which is
triggered by a delalloc buffered write larger than the inline space in
ext4_da_convert_inline_data_to_extent().

The clear is meant to drop stale extent status entries of such an inode
to prevent stale extents and stale reserved space after the conversion,
but the range is too wide.  It also drops the entries of the blocks
below the new end of file, that is the blocks that stay in the file.

When writeback of these blocks starts later, the lookup of such a block
misses the extent status tree, falls back to the extent tree and caches
a hole entry for it.  Those blocks then have dirty, mapped and delayed
buffers together with a hole extent status entry.  This is an
unexpected inconsistency.

This problem has been hidden so far because we allocate blocks and new
extents for them during writeback.  But once '244392197bb9 ("ext4: skip
block allocation for holes in the data submission path")' is merged
during the iomap conversion, the writeback behavior will be normalized,
and it will no longer allocate blocks for holes, thus exposing this
problem.

Therefore, restrict the range to the blocks that are actually truncated
away, and pass EXT_MAX_BLOCKS minus lblk as the length.

Reported-by: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com/
Fixes: 0add491df4e5 ("ext4: remove extent cache entries when truncating inline data")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inline.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482b..b630e56815bb5 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 		 * the extent status cache must be cleared to avoid leaving
 		 * behind stale delayed allocated extent entries
 		 */
-		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
-			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
+
+			ext4_es_remove_extent(inode, lblk,
+					      EXT_MAX_BLOCKS - lblk);
+		}
 
 		/* Clear the content in the xattr space. */
 		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
-- 
2.52.0

