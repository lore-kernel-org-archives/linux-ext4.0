Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198EC4A484E;
	Thu,  3 Sep 2026 12:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439388; cv=none; b=ABuSOHxqJP/ft2QGc+sKvp45dOil2mm/QFG+53+x1QeU5RgLqF99a2bxMiVwb3014H5hUJ10jCuH+/XrZ7daYcEItx8qnjIVUzhSo6iZPFZkl9TPHS7VAAiRup+Jf9pPZRdkVB2hPcS3LCxKSAcMcIBvNtCdg36Jsk4ox4xV524=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439388; c=relaxed/simple;
	bh=55LWSlA+cZf0IUuWbriHoL+GYdRb5GJn2PHH18Wrrfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gb8itYyrXM5OTq6qHh5eDTZe0nwtWmMR+7e6jw8m2aK/7XnZAc9Qgod9GvkKDG2kdeY0/XUwS+d207b5MMhuj9N9t2jQ2D1ijQHysza21UPNl4o+HpwxAbTlTps7amwQjHwVn+Ey8Zw0DLf/M8Rdy0hdlPzL7nwYNYTmvn7GYRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK405YfBzYQv3w;
	Thu,  3 Sep 2026 20:42:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 9F90740B82;
	Thu,  3 Sep 2026 20:42:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S16;
	Thu, 03 Sep 2026 20:42:51 +0800 (CST)
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
Subject: [PATCH v6 12/31] ext4: pass out extent seq counter when mapping da blocks
Date: Thu,  3 Sep 2026 20:35:24 +0800
Message-ID: <20260903123543.2302999-13-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S16
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4UKFy7uF1xXFyUZr15twb_yoW8uFWDp3
	9Ykr15Gw1xZw1v9ayxX3WxZFyrKay3J3y7KFWfXw1Fkas8WFySgF1j9F12yFykKr4xXF4F
	vF40kry8Ca4ayFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTR_nYFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The iomap buffered write path does not hold the folio lock between
mapping the inode extent and copying data. Therefore, it can race
with writeback that modifies the extent type (e.g., from unwritten to
written). This can lead to data corruption on partial writes, as
iomap_block_needs_zeroing() may return a false positive based on a
stale extent. The iomap infrastructure uses the sequence counter
stored in the inode to detect such stale mappings.

Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
blocks") added the m_seq field to ext4_map_blocks to pass out extent
sequence numbers, but it missed two callsites within
ext4_da_map_blocks(). These callsites are on the delayed allocation
path, which is needed in the iomap buffered write path. Pass out the
sequence counter to ensure stale mappings can be detected.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d2398cf275ae..4c63fdc36626 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1972,7 +1972,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 	ext4_check_map_extents_env(inode);
 
 	/* Lookup extent status tree firstly */
-	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		map->m_len = min_t(unsigned int, map->m_len,
 				   es.es_len - (map->m_lblk - es.es_lblk));
 
@@ -2025,7 +2025,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 	 * is held in write mode, before inserting a new da entry in
 	 * the extent status tree.
 	 */
-	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		map->m_len = min_t(unsigned int, map->m_len,
 				   es.es_len - (map->m_lblk - es.es_lblk));
 
-- 
2.52.0

