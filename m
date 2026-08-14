Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D237243F4DB;
	Fri, 14 Aug 2026 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700409; cv=none; b=dffOse/Wqiq22n08Zc8nITVPEN2r0Dm0MMWawYJEUEXE1YOLz2qiIbEpSRNi5w3J0/dTWdbPR+jea124aqgxapMWECTkT7MfdbRPvC1OwcX5WwXd8edi1FkhmHzEbDX0HrTptDkykSCiKL1iAl0JYyUT+/hOYniOW0m5f0MPMQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700409; c=relaxed/simple;
	bh=LRvGFX15gSlEMgzikCfEppkdkc3qZZAtD8cFysYgEmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDYyUASJSrJ/o8N8jI+FrPeHq+w0E5QkUcicnCFJLGobsjS8nPiQwWSvn/zkP7tR4mwhN+Pp6+lLwqnkzSKAQWz7+zd8RFqE+KvE4NbWDybccMlLsVekaUlrsRZ9trYJ0+FlMl6uErBekaCRNezFVcG5U29Z6OeFPxjHaNouCSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyR5Tx5zKHNL5;
	Fri, 14 Aug 2026 17:39:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 7F8CA40B08;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S17;
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
Subject: [PATCH -next v5 13/32] ext4: pass out extent seq counter when mapping da blocks
Date: Fri, 14 Aug 2026 17:33:12 +0800
Message-ID: <20260814093331.1703882-14-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S17
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4UKFy7uF1xXFyUZr15twb_yoW8uFWDp3
	9Ykr15Gw1xZw1v9ayxXF1xZFy5Kay5JrW7GFWfXw1Ygas8WFySgF1jkF12yFykKr4xXr1F
	vF40kry8Ca4SyFDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Ar0_tr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNF4EDUUUU
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
index 376cb9783835..9098d9a5fc05 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1970,7 +1970,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 	ext4_check_map_extents_env(inode);
 
 	/* Lookup extent status tree firstly */
-	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		map->m_len = min_t(unsigned int, map->m_len,
 				   es.es_len - (map->m_lblk - es.es_lblk));
 
@@ -2023,7 +2023,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 	 * is held in write mode, before inserting a new da entry in
 	 * the extent status tree.
 	 */
-	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		map->m_len = min_t(unsigned int, map->m_len,
 				   es.es_len - (map->m_lblk - es.es_lblk));
 
-- 
2.52.0

