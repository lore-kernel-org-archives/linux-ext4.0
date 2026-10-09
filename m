Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A6741D4D4;
	Fri,  9 Oct 2026 10:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542245; cv=none; b=YF/pD8SFwV/v/1B9Ye0FklaoXtUB50wZ2/rl1N8rAlysxQwEMtQGpRN1f3rXwMH0uuMPHJkasWxpriQRUj/SsDUObzAqyM25E26dmdmX4jLFBBRdmCmjH7tb6t02Z4cuw+ipe2rUxsfj1VAbK8irajaoIvMohWwznnE0XJ6uDyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542245; c=relaxed/simple;
	bh=M8SoUqJvjb5zhkWHw2cNBzhuNfhxqiZdb4+hoF/qQwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9SuYkfNp8odCiS9pffnmGTV0Y3DPqMPjAiwujyEgP2491yG302IdXX3i+4F8gdaivdI9cb0/Gi6x5+DmEen1toTvbkrHsByEQc/F2vqEtkUj6XlqxA9uirQT58AYzDGMzoN+ss/JMPnBC6/ph3wACIB7w+N0UD5XhaeVl8QaKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZM3t1zzKHMpm;
	Fri,  9 Oct 2026 18:36:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 77EAC40574;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S10;
	Fri, 09 Oct 2026 18:37:19 +0800 (CST)
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
Subject: [PATCH v7 06/31] ext4: allow ext4_map_blocks() to start its own transaction handle
Date: Fri,  9 Oct 2026 18:30:07 +0800
Message-ID: <20261009103033.2920530-7-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S10
X-Coremail-Antispam: 1UD129KBjvJXoWxGryUJFWkCry3tw1DJF4ruFg_yoW5KFyrp3
	y2kFyrCr4UWFyS9F4Sya1UXF1ak3W8GrWUWFWxG3s5C34ayrn3tF15KF15tFW5KrWfXa1j
	qF45A34Uua1UJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRRyxRDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Make ext4_map_blocks() start its own transaction handle when the caller
does not provide one. The handle is started after the lookup path
confirms that allocation is actually needed, and is stopped at the
unified out exit path. This avoids unnecessarily starting a handle for
pure mapping queries. This prepares for the buffered iomap writeback
conversion, which improves performance for fragile overwrite cases.

Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/linux-ext4/i536qqwj5eyulec3r2ki2ycnelqdd4bkpat2drn7t72t6p622k@ktueynysgo3j/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 64d223eda0ffe..553b767148c7b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -686,6 +686,11 @@ int ext4_map_create_blocks(handle_t *handle, struct inode *inode,
  * Otherwise, call with ext4_ind_map_blocks() to handle indirect mapping
  * based files
  *
+ * ext4_map_blocks() may also be called with a NULL @handle. In that case
+ * it starts its own transaction handle only when block allocation is
+ * actually needed, i.e. after the lookup confirms the blocks are not yet
+ * mapped, and stops it before returning.
+ *
  * On success, it returns the number of blocks being mapped or allocated.
  * If flags doesn't contain EXT4_GET_BLOCKS_CREATE the blocks are
  * pre-allocated and unwritten, the resulting @map is marked as unwritten.
@@ -703,6 +708,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	struct extent_status es;
 	int retval;
 	int ret = 0;
+	bool internal_handle = false;
 	unsigned int orig_mlen;
 #ifdef ES_AGGRESSIVE_TEST
 	struct ext4_map_blocks orig_map;
@@ -787,13 +793,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	retval = ext4_map_query_blocks(handle, inode, map, flags);
 	up_read((&EXT4_I(inode)->i_data_sem));
 	if (retval < 0)
-		return retval;
+		goto out;
 
 found:
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
 		ret = check_block_validity(inode, map);
 		if (ret != 0)
-			return ret;
+			goto out;
 	}
 
 	/* If it is only a block(s) look up */
@@ -813,8 +819,17 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		 * ext4_ext_map_blocks()
 		 */
 		if (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
-			return retval;
+			goto out;
 
+	if (!handle) {
+		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+				ext4_chunk_trans_blocks(inode, orig_mlen));
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
+		internal_handle = true;
+	}
 
 	ext4_fc_track_inode(handle, inode);
 	/*
@@ -845,12 +860,12 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	if (retval < 0)
 		ext_debug(inode, "failed with err %d\n", retval);
 	if (retval <= 0)
-		return retval;
+		goto out;
 
 	if (map->m_flags & EXT4_MAP_MAPPED) {
 		ret = check_block_validity(inode, map);
 		if (ret != 0)
-			return ret;
+			goto out;
 
 		/*
 		 * Inodes with freshly allocated blocks where contents will be
@@ -872,12 +887,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 				ret = ext4_jbd2_inode_add_write(handle, inode,
 						start_byte, length);
 			if (ret)
-				return ret;
+				goto out;
 		}
 	}
 	ext4_fc_track_range(handle, inode, map->m_lblk, map->m_lblk +
 			    map->m_len - 1);
-	return retval;
+out:
+	if (internal_handle)
+		ext4_journal_stop(handle);
+
+	return ret ? ret : retval;
 }
 
 /*
-- 
2.52.0

