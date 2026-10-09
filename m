Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09094AD4A5;
	Fri,  9 Oct 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542250; cv=none; b=KBw7gVtBqV4tJNkZ127le8JCP9tJoCVLovTNPQ83MatvigONH2V6Lf+7emXV6uriiUsZEzZ9738IjA7cflZGpTbq4Bselceu3xy6CiL6bnRoWx1OBBOCIdHUt99RhXfy39PgoLbpADEC4XhzR1502Y7T+a80EM10GQ9f6swkoDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542250; c=relaxed/simple;
	bh=YU9hpAd9RznQbjc3wjAfsJo064BAMaaDPFaPmEnoSyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBTEPgFCnRrKD9VpFuaNQDdvyyiLi8yoYRZqvVZC/gEJ0PAAPahPHwQ9F34WNZEVsugDUVAj1gwlZpQCGywrTv5gxjuNnoD+bVzKbr5Xl+GbM0Fyb48zsSH3q4gAokOtn9fgFEusPG8FipHBMhZslwruo3A0+WCVdv9PBfbNlsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZW0cVhzYQv3f;
	Fri,  9 Oct 2026 18:36:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 48CDD40574;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S8;
	Fri, 09 Oct 2026 18:37:18 +0800 (CST)
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
Subject: [PATCH v7 04/31] ext4: recheck extent status tree before block allocation
Date: Fri,  9 Oct 2026 18:30:05 +0800
Message-ID: <20261009103033.2920530-5-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S8
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWUAw1rArW3Gr1UZryxKrg_yoW5Kw17pr
	Zak34rGr1vgw1I9Fs2yF1xZFySk3W8JF47JFZ2vryDZF15W3WfKF1Yy3WSyFy5Krs3t3yY
	qF4Fqry8uwnFy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7sRRtCztUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

After acquiring i_data_sem in write mode, recheck that the mapping
found via the extent status tree or disk query has not changed. A
racing truncate may have trimmed the extent between the earlier lookup
and the write lock acquisition, since writeback does not hold i_rwsem
or the folio locks covering the full extent. This could cause
ext4_map_create_blocks() to allocate blocks beyond the truncated range,
potentially leading to quota leaks in the upcomming iomap buffered
writeback path, because the iomap writeback infrastructure caches
extents beyond the folio range.

Therefore, if we find a valid extent and the sequence number has
changed, retry the entire lookup to obtain the correct trimmed mapping.

Note that a retry only happens when i_es_seq has actually changed, which
requires another thread to hold i_data_sem in write mode, so each retry
implies real lock contention, and the writer yields on the rwsem
slowpath rather than spinning. Moreover, the read-write lock also tries
its best to guarantee fairness, so even though no retry limit is added
here, livelock should not occur in theory. Also, the retry here mirrors
the existing write_ops->iomap_valid() + IOMAP_F_STALE mechanism in
iomap, which also rechecks the sequence number and retries without any
upper bound, and has not shown livelock problems in practice.

In addition, if ext4_map_query_blocks() fails, return the error
immediately. Otherwise the following sequence number comparison would
use a map->m_seq that may not have been updated, and silently
continuing on an error is not advisable.

Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/linux-ext4/b0781809-4759-4e12-be17-71555b764f48@gmail.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c0f8ff495dd82..739f8d3914653 100644
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
@@ -820,6 +823,21 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * with create == 1 flag.
 	 */
 	down_write(&EXT4_I(inode)->i_data_sem);
+
+	/*
+	 * Check the validity of the mapping found via the extent status
+	 * tree or the disk query. A racing truncate may have changed the
+	 * extent, since writeback may not hold i_rwsem or the folio locks
+	 * covering the full extent(e.g., the iomap writeback path may
+	 * allocate an extent that extends beyond the length of the locked
+	 * folio in advance).
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

