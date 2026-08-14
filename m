Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECBA3E0C73;
	Fri, 14 Aug 2026 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700400; cv=none; b=Nj7U0k3h9LSfyaDfMx4HGfE2rEyDCSXwbqFu44Jw6D8UcmTmi4aDDElBRYGxWzi4RQa2jZ82cLdBbl9Dr7RCEeTaw4Q1EhmYFTNbaNtEk51jKllpjwbDocK6PhZbgzvtFsK+rz2dWMTJ/yed7fEydmSocYXQXUeb50il/10MME4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700400; c=relaxed/simple;
	bh=r5OWhPbD/O7OI1582H0ED157Jfnu0DM1I3zMlrkol8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spnxRJ7GsKBXOeYp8LjFFeuG7Bhk/CWomb8OLPs1W1Dk1S9yrcJFzeoOOdxyYRAgFgaGL9uGruFh3GVO2rlKPT4byMqBNMMfSz9Eu8UU/3mu6P0S4B0t7icxTMZF36v3DNvubRtgHtgo0ibOi6jOoS87BPJOSmzWksVpDvkfP0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyR0VMRzKHNMZ;
	Fri, 14 Aug 2026 17:39:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C76F64056D;
	Fri, 14 Aug 2026 17:39:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S10;
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
Subject: [PATCH -next v5 06/32] ext4: recheck extent status tree before block allocation
Date: Fri, 14 Aug 2026 17:33:05 +0800
Message-ID: <20260814093331.1703882-7-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S10
X-Coremail-Antispam: 1UD129KBjvJXoW7KrW8GFy3Xry8Cw4xJw17trb_yoW8urW3pr
	Zak34rGr1vgw1I9rZ7CF18ZF1Ska18XrW7JFZFqr1jvFyUWFyftFyYy3WSyFy5tws3tr4Y
	qFWrKryUuw4UArJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 fs/ext4/inode.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9dbece14ae56..548a3968c5a7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -734,6 +734,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	else
 		ext4_check_map_extents_env(inode);
 
+create_retry:
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
@@ -820,6 +821,19 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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

