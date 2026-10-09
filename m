Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD84AC17D;
	Fri,  9 Oct 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542251; cv=none; b=GU19Zu1lZQ3Qy391Fzp0pI60b+hetWEtr9DTrcruyfeniTJVIVLv9bq4X8n+QzChd+fIopSpvnEvQxRFdkdrk6HiTGY6Fno1XNCcd/fEBPzJRmT8OU/S7wIa6W+wAPCjIRW4xu4p582ZxqPLSBCjNTnIzBw59nDQp/MI1NBfAMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542251; c=relaxed/simple;
	bh=2vFWI8Ay74Fzx+td3jy7AAajC/99VABdMuYzHa3Uzoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwyvNCG9N+Bf/Kih5EOqKlTYy1GxiwlYERPKAc/w7yf96LD0SiPRSG3UgwdlTXTqJrmH/+1xIAzvG4BRD+nlEPVkTe2Dty+5G529yzztZy7fsYlqEH/5Sk5Zx6O0uCVhaHh2cuEH508lBH6996ovLDC9mg1pEQN25lD62zY689A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZN6lnKzKHMr7;
	Fri,  9 Oct 2026 18:36:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id DA6B040561;
	Fri,  9 Oct 2026 18:37:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S22;
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
Subject: [PATCH v7 18/31] ext4: drain writeback before removing extents on the iomap path
Date: Fri,  9 Oct 2026 18:30:19 +0800
Message-ID: <20261009103033.2920530-19-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S22
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4fuFykAF18Kr17tw1UZFb_yoW5urW8pF
	9Ikw1rGr1UWay7urs7XF1Iqr10gw4kGFWUuFy3WF13XF95C34IgFyUK3WF9ay5trWxAry0
	vF48ury8XFy5ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
    [ transaction commits, freed blocks released to buddy ]
    [ allocator reuses freed blocks for another inode ]
                                    [bio completes]
                                    ext4_iomap_finish_ioend()
                                      ext4_convert_unwritten_extents()
                                        ext4_map_blocks(IO_CONVERT_EXT)
                                          -> returns 0 (hole found)
                                    [bio writes to reallocated blocks ]
                                    -> silent data corruption

If the bio completes after the freed blocks have been reallocated to
another inode, it silently overwrites them and causes data corruption.
Therefore, on the iomap path, drain writeback in ext4_punch_hole() after
partial zeroing and before starting the freeing transaction, so any bio
in flight on a partial folio completes against blocks still owned by
this inode before extent removal.  Once extent removal begins, the ES
hole insert and the existing IO_SUBMIT short-circuit prevent further bio
submission.

This is a workaround. The proper fix is for the iomap infrastructure to
always maintain an ifs when folio size is larger than blocksize, so that
partial invalidate reliably clears sub-block dirty bits and no draining
is needed.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 35a2c96535c03..35767c3a7ffff 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5028,7 +5028,14 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	ret = ext4_zero_partial_blocks(inode, offset, length, &partial_zeroed);
 	if (ret)
 		return ret;
-	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
+	/*
+	 * On the iomap path, partial invalidate of a folio without an ifs
+	 * leaves sub-block dirty bits uncleared.  Drain writeback before
+	 * removing extents so that any bio in flight on a partial folio
+	 * completes against blocks still owned by this inode.
+	 */
+	if (ext4_inode_buffered_iomap(inode) ||
+	    (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed)) {
 		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
 						   end - 1);
 		if (ret)
-- 
2.52.0

