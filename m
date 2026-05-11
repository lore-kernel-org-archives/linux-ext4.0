Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5382C3859F3;
	Mon, 11 May 2026 07:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484514; cv=none; b=fpznGLTfMv0kjCenaIKvhS4B3WfLgyUzwLZ5o014SeefGymBmf5rUd8S9szwBl/Q5G8BOB707LY9Uy9iKCI3pNWyVc841SewPQPT1kHH5WhadrDH421taSXXQkfU8BH5AJHICEZS13iyL4quwgZvVUMRL0eVSiRN44DnLr2euEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484514; c=relaxed/simple;
	bh=/eHJMpsNuAXg57jXYSG9wTnSZHNzT6OePUgv7hxBe7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1LWxxNQL9oRfb9xtsFIEt4FQLPrA/eF1M4ksmdFUgiKa++AToBM2LW8Cl0APDvQvPHBHf4I2uKnSKjypDWEVJc4wdKEmz8tKSg0k0Pp7Nm5cjzj09jDYdRADF2vcJGJgH8+eQ3Bx1nCTQ4jENp848qXXpRdkDo0DeZcoAH0f3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXV23j9zYQv2V;
	Mon, 11 May 2026 15:27:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EBC4840574;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S10;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
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
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 06/23] ext4: pass out extent seq counter when mapping da blocks
Date: Mon, 11 May 2026 15:23:26 +0800
Message-ID: <20260511072344.191271-7-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S10
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1ftFWDJr48AF4xKw1kuFg_yoW8CrWxp3
	9YkF1rGw1xZw1q9ay0q3W7ZFyrKa15ArW7GrWfXw1j9a4DGFySqF4jkF12yFykKr4xXr1F
	vF40kryUC3ySkFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The iomap buffered write path does not hold any locks between querying
inode extent mapping information and performing buffered writes. It
relies on the sequence counter saved in the inode to detect stale
mappings.

Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
blocks") added the m_seq field to ext4_map_blocks to pass out extent
sequence numbers, but it missed two callsites within
ext4_da_map_blocks(). These callsites are on the delayed allocation
path, which is also used in the iomap buffered write path. Pass out the
sequence counter to ensure stale mappings can be detected.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6c4d9137b279..39577a6b65b9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1929,7 +1929,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 	ext4_check_map_extents_env(inode);
 
 	/* Lookup extent status tree firstly */
-	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		map->m_len = min_t(unsigned int, map->m_len,
 				   es.es_len - (map->m_lblk - es.es_lblk));
 
@@ -1982,7 +1982,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 	 * is held in write mode, before inserting a new da entry in
 	 * the extent status tree.
 	 */
-	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
 		map->m_len = min_t(unsigned int, map->m_len,
 				   es.es_len - (map->m_lblk - es.es_lblk));
 
-- 
2.52.0

