Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CFC33998;
	Wed, 14 Oct 2026 02:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791944661; cv=none; b=eD2YsQGV6C7UHPccPEHrHUJkToRshYrhy/mlvT2PI5tWVY89xC156rhAirHwSg6akaDGSuYVrfdM8FHdfN57b55DQcre/lyRGnSftgj7J2XsY+GViyldgiL8B7DsFbVy4T51BPAni7iztfks04IM/4nrvtTTfHGoQKjFwSnPftc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791944661; c=relaxed/simple;
	bh=YE6wK3ozoIsjpnQjO3ubaqmPoCJNCipXKKtmbJoQ1ss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MBLvWXWj1TCkm8Yi8AeQ19I6izo//SmvU1W7dn8TY7I8h9vEEWG0GY1VWAWNI6iPVJO/eC8/+0vJVQbeTLcEnTyPS2d9EQl8KqqybqfiZWGf+HZtTtOISlblDeBifc+/B/kHSFQiDdsSmsutphighav+A5qsJKnWTHjSz8/3xAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j4FNy0rRgzKHMQ3;
	Wed, 14 Oct 2026 10:23:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B74D34056E;
	Wed, 14 Oct 2026 10:24:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCn4O_H585qBNZzAQ--.21104S4;
	Wed, 14 Oct 2026 10:24:13 +0800 (CST)
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
	enwlinux@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH] ext4: fix extent status cache clearing when truncating inline data
Date: Wed, 14 Oct 2026 10:17:14 +0800
Message-ID: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn4O_H585qBNZzAQ--.21104S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4UKF13Ar1UJrW3Kw4kZwb_yoW5Wr1fpa
	9xCr4UGr1kW348WFZ7u3WUXF1Yga1fGr47uryagw17WFy3CFyIgFZ0k3yUZa4xKr4vvayj
	vFWYvF1DCa15JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbmsjUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_inline_data_truncate() clears the whole extent status tree of the
inode when it truncates the inline data, with

	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);

It does that when the inode still carries inline data while the
EXT4_STATE_MAY_INLINE_DATA state bit is already cleared, which is the
case once an inline to extent conversion has been initiated, for
example a delalloc buffered write larger than the inline space.

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
extents for them during writeback.  But once [1] is merged during the
iomap conversion, the writeback behavior will be normalized, and it will
no longer allocate blocks for holes, thus exposing this problem.

Therefore, restrict the range to the blocks that are actually truncated
away, and pass EXT_MAX_BLOCKS minus lblk as the length.

[1] https://lore.kernel.org/linux-ext4/20261009103033.2920530-9-yi.zhang@huaweicloud.com/

Reported-by: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com/
Fixes: 0add491df4e5 ("ext4: remove extent cache entries when truncating inline data")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
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

