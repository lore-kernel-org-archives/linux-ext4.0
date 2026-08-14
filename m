Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681D400DE8;
	Fri, 14 Aug 2026 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700402; cv=none; b=L33V2itXMpsRZCra2gRS15Jn5xx29ny4ev8H5Bnk+RNQWrvp57vbKIYzR9Mm6uLM/CJyMGUWJPQowkU+SpN+x5SkouZX0OYJzs5ztjNdSWqRd8VkEhDy4cl13OFfNrmoLj+P8LRzAd21qB+xObLO+UkoG6YJVz9EXzwvmelVaeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700402; c=relaxed/simple;
	bh=J7hB7ZVA/xufntpOwc1H0+mMTzrq/O1ftTvA6QzmsA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQfqdwV5tAndqJUXRV9IsyTBvIT+/Gig/nfjF6SHNsxfxXDEuAa95+Jx2urwp5XAL6tPi2dvoBlFvRYYppeMUD2/T2OW/SdTeSeXfNzW5cTjn63tD1JrfP5LJcJeU8wVof7f1I6VG/Ilsmzz5gA7fAGcDzmSSioMNL1HrbeE9v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyh6yFGzYQvY4;
	Fri, 14 Aug 2026 17:39:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 2F02A40592;
	Fri, 14 Aug 2026 17:39:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S23;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
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
Subject: [PATCH -next v5 19/32] ext4: tolerate unexpected holes in ext4_convert_unwritten_extents()
Date: Fri, 14 Aug 2026 17:33:18 +0800
Message-ID: <20260814093331.1703882-20-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S23
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4fuFykAF18Kr17tw1UZFb_yoW5Cr4fpF
	ZIkr15Kr1jga9I9rsrtFWxXr1Fk3WxGF47ZrWfGF13XFyDZr42g3WUKa4FyFy5tFWxJrya
	qrW8Jry8XF15ZaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Ar0_tr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRiyxR3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Because the iomap infrastructure does not always create an ifs to
manage sub-folio state when folio size is larger than blocksize,
invalidating a partial dirty folio during punch hole may fail to
clear the dirty state of the affected range. As a result, writeback
of that folio may observe a hole. At writeback submit time,
ext4_map_blocks() already handles this case and will not allocate
blocks. However, when punch hole races with writeback, the
following scenario can cause I/O completion to encounter a hole.

  punch hole                        writeback
  ----------                        ---------
  ext4_punch_hole()
    ext4_truncate_page_cache_block_range()
      iomap_invalidate_folio() [partial folio]
        iomap_clear_range_dirty()
        -- no ifs, sub-block dirty bits NOT cleared
                                    ext4_iomap_writepages()
                                      iomap_writepages()
                                        ext4_iomap_writeback_submit()
                                          ext4_iomap_map_writeback_range()
                                            ext4_map_blocks(IO_SUBMIT)
                                              -> extent exists, not a hole
                                          submit_io()  -> bio in flight
    down_write(&i_data_sem)
    ext4_es_remove_extent()
    ext4_ext_remove_space()
      -> extent removed, hole inserted
    up_write(&i_data_sem)
                                    [bio completes]
                                    ext4_iomap_finish_ioend()
                                      ext4_convert_unwritten_extents()
                                        ext4_map_blocks(IO_CONVERT_EXT)
                                          -> returns 0 (hole found)

Therefore, in ext4_convert_unwritten_extents() we need to be
careful about the case where ext4_map_blocks() returns 0. Instead
of triggering a warning, we should ignore the hole and continue
with the subsequent conversion.

Link: https://lore.kernel.org/linux-ext4/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0d62d9312284..5a06259a9b5d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5166,19 +5166,21 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 		ret = ext4_map_blocks(handle, inode, &map,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
 				      EXT4_EX_NOCACHE);
-		if (ret <= 0) {
-			/*
-			 * If the ret is zero, an unexpected hole may cause
-			 * conversion to fail.  To avoid data loss during I/O
-			 * end conversion, skip the hole and continue
-			 * converting subsequent blocks.
-			 */
+		/*
+		 * A return value of zero means an unexpected hole was found.
+		 * This can happen when writeback races with a concurrent
+		 * punch hole in the iomap path. Because iomap may not create
+		 * ifs for folios larger than block size, the dirty bit can
+		 * be set again after punching. If writeback happens between
+		 * partial folio invalidation and extent removal, a hole is
+		 * observed at I/O completion.
+		 */
+		if (ret < 0)
 			ext4_warning(inode->i_sb,
 				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
 				     inode->i_ino, map.m_lblk, map.m_len, ret);
-		} else {
+		else if (ret > 0)
 			conv_blocks += map.m_len;
-		}
 
 		ret2 = ext4_mark_inode_dirty(handle, inode);
 		if (credits) {
-- 
2.52.0

