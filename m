Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC2A4A6CE8;
	Thu,  3 Sep 2026 12:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439382; cv=none; b=T2zxXVJpw8dRKGPQbFNtYxc2Hp9/Ph8Ob8i44vFFfCOliw9vICKkXO8CEfslXyOPkRMPv5ihARdCcmYDyiYtBqwZ1FBjT35NS5aPA6IfpY5ZOqrtSbBmAVaQPZlUrhQeqi2rRuE6fR9FKRS+FTLLVMDsfrXLcRRjmeDsBQtwdqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439382; c=relaxed/simple;
	bh=vkMHOD+Go0ZpZJdysiNVEL3okh2GH7XiU5TYb5+u4OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h78cIw0OFrvuvHfSLkfin0cqZMOhcnMQiJNxSiPFsqIWdp/PAIeS5AAFNmCcG87t9cfOq3N7l2+A+Wg0DexZ6Jz15m7xnKtZhP29VZu9roNUc3WbWyTiCc5siMmWHM5tsWqlVbkS+nFAg1jVK8al+8driOaYdL/VY4v5kIL+q1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK400gPLzYQtlx;
	Thu,  3 Sep 2026 20:42:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id ECCD940EAF;
	Thu,  3 Sep 2026 20:42:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S9;
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
Subject: [PATCH v6 05/31] ext4: recheck extent status tree before block allocation
Date: Thu,  3 Sep 2026 20:35:17 +0800
Message-ID: <20260903123543.2302999-6-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S9
X-Coremail-Antispam: 1UD129KBjvJXoW7KrW8GFy3Xry8Cw4xWr1fCrg_yoW5Jr45pr
	Zak34rGr1vgw4I9FZakF18ZF1Sk3W8XrW7JFZFqryYvFyUW3WftFyYy3WSyFy5Kws3tw4j
	qFWrKryUuw47ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

After acquiring i_data_sem in write mode, recheck that the mapping
found via the extent status tree or disk query has not changed. A
racing truncate may have trimmed the extent between the earlier lookup
and the write lock acquisition, since writeback does not hold i_rwsem
or the folio locks covering the full extent. This could cause
ext4_map_create_blocks() to allocate blocks beyond the truncated range,
potentially leading to quota leaks in the upcomming iomap buffered
writeback path since the iomap writeback infrastructure caches extents
beyond the folio range.

Therefore, if we find a valid extent and the sequence number has
changed, retry the entire lookup to obtain the correct trimmed mapping.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 84991fe99071..b71b1d2588ae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -734,6 +734,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	else
 		ext4_check_map_extents_env(inode);
 
+create_retry:
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
@@ -784,6 +785,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	down_read(&EXT4_I(inode)->i_data_sem);
 	retval = ext4_map_query_blocks(handle, inode, map, flags);
 	up_read((&EXT4_I(inode)->i_data_sem));
+	if (retval < 0)
+		return retval;
 
 found:
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
@@ -820,6 +823,19 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * with create == 1 flag.
 	 */
 	down_write(&EXT4_I(inode)->i_data_sem);
+
+	/*
+	 * Check the validity of the mapping found via the extent status
+	 * tree or the disk query. A racing truncate may have changed the
+	 * extent, since writeback does not hold i_rwsem or the folio locks
+	 * covering the full extent.
+	 */
+	if (map->m_seq != READ_ONCE(EXT4_I(inode)->i_es_seq)) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		map->m_flags = 0;
+		map->m_len = orig_mlen;
+		goto create_retry;
+	}
 	retval = ext4_map_create_blocks(handle, inode, map, flags);
 	up_write((&EXT4_I(inode)->i_data_sem));
 
-- 
2.52.0

