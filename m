Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7414A92EC;
	Thu,  3 Sep 2026 12:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439389; cv=none; b=sJn+XxnUKnND47nOmcicJfHXqk85+NdWhxOLF2uucfEGDbdiI+KwkIPJ99DXmNx3u0LQH16PNrh0ynwITDtlZfPWuGkqyRuvALM36FJ/xqAAx0o7AlTUxvx9MjWQ3J8+OeZlokys0q+tLBJ2Tc32cxWkQsS6v3C7TXVf4+lWOn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439389; c=relaxed/simple;
	bh=0xz0OAA9ja5SkrgMYdmHEibc3etDVNGg7l0PHoJSjOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISk1e+Ryg0YsJvn/kY0SAfQzmjkAIKZpPTjVFltX7R70G3q+E6X3BKgNzOrUtbrhfXPZqiK3py6o7PryWH/BCTuFM9mHUkhxyPft7JXh9Wc2c/k1R16/DKBapG0kS0ZFmQD62ICe+tHlMvrEAzRAYakpUvUkeJwC69upMPj1P6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK40240fzYQtyd;
	Thu,  3 Sep 2026 20:42:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 27BD6405C3;
	Thu,  3 Sep 2026 20:42:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S11;
	Thu, 03 Sep 2026 20:42:50 +0800 (CST)
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
Subject: [PATCH v6 07/31] ext4: allow ext4_map_blocks() to start its own transaction handle
Date: Thu,  3 Sep 2026 20:35:19 +0800
Message-ID: <20260903123543.2302999-8-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S11
X-Coremail-Antispam: 1UD129KBjvJXoWxGryUJFWfArWfJFWkur4DArb_yoW5WFyDpr
	WayFyrCr1UWF9a9F4Sya1UZF1aka48KrWUWFWfGryrZ34a9rnagF1UK3WayFWrKrZ3Xayj
	qF45try5Ca1UC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTR_nYFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Make ext4_map_blocks() start its own transaction handle when the caller
does not provide one. The handle is started after the lookup path
confirms that allocation is actually needed, and is stopped at the
unified out_handle exit path. This avoids unnecessarily starting a
handle for pure mapping queries. This prepares for the buffered iomap
writeback conversion, which improves performance for fragile overwrite
cases.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 73af6d386985..c9dea4ca5caf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -703,6 +703,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	struct extent_status es;
 	int retval;
 	int ret = 0;
+	bool internal_handle = false;
 	unsigned int orig_mlen;
 #ifdef ES_AGGRESSIVE_TEST
 	struct ext4_map_blocks orig_map;
@@ -787,13 +788,15 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	retval = ext4_map_query_blocks(handle, inode, map, flags);
 	up_read((&EXT4_I(inode)->i_data_sem));
 	if (retval < 0)
-		return retval;
+		goto out_handle;
 
 found:
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
 		ret = check_block_validity(inode, map);
-		if (ret != 0)
-			return ret;
+		if (ret != 0) {
+			retval = ret;
+			goto out_handle;
+		}
 	}
 
 	/* If it is only a block(s) look up */
@@ -813,8 +816,15 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		 * ext4_ext_map_blocks()
 		 */
 		if (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
-			return retval;
+			goto out_handle;
 
+	if (!handle) {
+		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+				ext4_chunk_trans_blocks(inode, orig_mlen));
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+		internal_handle = true;
+	}
 
 	ext4_fc_track_inode(handle, inode);
 	/*
@@ -843,12 +853,14 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	if (retval < 0)
 		ext_debug(inode, "failed with err %d\n", retval);
 	if (retval <= 0)
-		return retval;
+		goto out_handle;
 
 	if (map->m_flags & EXT4_MAP_MAPPED) {
 		ret = check_block_validity(inode, map);
-		if (ret != 0)
-			return ret;
+		if (ret != 0) {
+			retval = ret;
+			goto out_handle;
+		}
 
 		/*
 		 * Inodes with freshly allocated blocks where contents will be
@@ -869,12 +881,18 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			else
 				ret = ext4_jbd2_inode_add_write(handle, inode,
 						start_byte, length);
-			if (ret)
-				return ret;
+			if (ret) {
+				retval = ret;
+				goto out_handle;
+			}
 		}
 	}
 	ext4_fc_track_range(handle, inode, map->m_lblk, map->m_lblk +
 			    map->m_len - 1);
+
+out_handle:
+	if (internal_handle)
+		ext4_journal_stop(handle);
 	return retval;
 }
 
-- 
2.52.0

