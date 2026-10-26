Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015966;
	b=XBowGIa9pzTFz/t5/GsI+9AdTHqywP2R48OLw0B5EBS1UOcGVP1pmReNwmkpKrh0XMAd
	 fVWplf4gGqe6514r6+xkJV16l7ynxjFeAywcWAB6aaucPmdALmGNXIwRiHNcwCklzNtQn
	 kpBPpyTqPeeNmXfgpEVzwIR5d1EX5C11vuxKONoKNCkE0ZYO6KkVTZ9AiKuOzKufFsHoS
	 OpgdJOSrhZvqmlJ81nHmUOanLkGjLhhbt9RIFVTMq9nwD4/VsTLwfynJPHqupRfwQ/m5g
	 8U/tZM5IoSbjBQ7RFwnUJqB2jK0TRtePxrCt4VUWugZUPfXHubZRV5AXQ7jZqVa6wPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015966;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=fuxILKIBlqafUPpm4FalHB7THGnKSbpGvyxYNqYhqTc=;
	b=YjJG5TVJf4r68HI+mduUEF3Xgim8oxI0wPvyAZbRjhhuZJitJmOEoIqLWjSJwIKcfq8B
	 F/io0tYHYrcu7KLmAvRSBITIJGgRsqJhFegUlo9GZjVz2+8LSkB3jwoR6aUXsVxpsRkce
	 q+oiPBCeWRCliVtEg7te65ajtF7LS6uqPjwnrAzCpdsFJIDaxga+4Ec2PNFSLzIa3GDSL
	 OFwQAoMR5KmAUcRE2yYJPq4mqEZxD1H29Ag54D7UAitL8wi8HUbeio2eQH/cIL2lc5Y6c
	 IHbyVOboxyA+7hFe4r8fCrFZEnZZdjSac3lan5g4VCJFAogSQgVQh1zttT8vn+E3ChQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53183606A323;
	Mon, 26 Oct 2026 11:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53183606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jCsbr6077z1c1cT;
	Mon, 26 Oct 2026 19:59:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2AB6B4056B;
	Mon, 26 Oct 2026 19:59:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvWLQN9q6RyfBw--.40032S7;
	Mon, 26 Oct 2026 19:59:15 +0800 (CST)
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
Subject: [PATCH 3/4] ext4: add inode to orphan list before extent conversion
Date: Mon, 26 Oct 2026 19:51:30 +0800
Message-ID: <20261026115131.1735014-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnZvWLQN9q6RyfBw--.40032S7
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4xJr4UKrW5Jw1DJw47urg_yoWrZr1kpr
	W3Ar1rGanYqa4Ygas7ZF4jv3WYkayxGrWUXrySgry0vas8Xr1rKrW5Ka4j9FZYqrZ5XF1Y
	vF4UtryUCa1DZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUO_MaUUUUU
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
 fs/ext4/extents.c | 49 +++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f609..71dda0ffeb34a 100644
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
@@ -4708,23 +4725,19 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
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
 
-		map.m_lblk += map.m_len;
-		map.m_len = len_lblk = len_lblk - map.m_len;
-		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
+		/*
+		 * The conversion may have failed without converting
+		 * anything.
+		 */
+		if (map.m_len) {
+			map.m_lblk += map.m_len;
+			map.m_len = len_lblk = len_lblk - map.m_len;
+			epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
+		}
 		if (ret)
 			break;
 	}
@@ -4732,12 +4745,13 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
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
@@ -4755,7 +4769,8 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 		goto out;
 	}
 
-	ext4_update_inode_size(inode, epos);
+	if (epos)
+		ext4_update_inode_size(inode, epos);
 	if (orphan && inode->i_nlink)
 		ext4_orphan_del(handle, inode);
 
-- 
2.52.0

