Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C3B3128B2;
	Wed, 22 Apr 2026 02:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824222; cv=none; b=kf7Q8Muv4nxlqMdiIlGZfBgBaA2Bju2TRLQUC8RRde/LBb5Dn5ukjJ3rv4Md813AW9wrhuE7waZIUHmrLB9bBZ0jf8s4ldGFnaVyQ6EAvuDzTgxVUS7lS8w/7+aKWGpVtSZhsGHqDFyaCWMq3S8ELjpv9IW+FnGL3n+xspldh3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824222; c=relaxed/simple;
	bh=AxOhwkfgQS+PDWAJdieVpQIzyuhddjFIhmvSBwoE34k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fxl5HUM890duuOJG+w7RM1KjkfzyBIRBk0Wa+kEASeVgUmfRGOYHlLzyAX1/wj1PxfTKGyek+v9efeFOSt+zghUsHNWMgKJpESnrL8vrhIrNJRrmnj/stHrN0ZzzLdQHMifcJuN5F0WsEVQD+HNl6+VutZBXSMkLFposcWRHLLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0jX40CmhzKHMPM;
	Wed, 22 Apr 2026 10:16:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 144AA405D4;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S9;
	Wed, 22 Apr 2026 10:16:55 +0800 (CST)
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
Subject: [PATCH v3 05/22] ext4: implement buffered read path using iomap
Date: Wed, 22 Apr 2026 10:10:25 +0800
Message-ID: <20260422021042.4157510-6-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S9
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW3tr4DXry8JFWktr1DJrb_yoW5Xr47pF
	90kFy5Gr4UWrnF9F4SqFZrXr1Ykan7Ja1UWryfGwnxWF90krW2gayjgF1YvF15tw47Ar40
	qF4jkry8Wr1UArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Implement the iomap read path for ext4 by introducing a new
ext4_iomap_buffered_read_ops instance. This provides the read_folio()
and readahead() callbacks for ext4_iomap_aops. The implementation
introduces:

 - ext4_iomap_map_blocks(): Helper function to query extent mappings for
   a given read range using ext4_map_blocks() and convert the mapping
   information to iomap type
 - ext4_iomap_buffered_read_begin(): The iomap_begin callback that maps
   blocks, validates filesystem state, and populates the iomap. It
   returns -ERANGE for inline data which is not yet supported.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9e9f421888ed..df21f6870ec4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3908,14 +3908,57 @@ const struct iomap_ops ext4_iomap_report_ops = {
 	.iomap_begin = ext4_iomap_begin_report,
 };
 
+static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
+		loff_t length, struct ext4_map_blocks *map)
+{
+	u8 blkbits = inode->i_blkbits;
+
+	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
+		return -EINVAL;
+
+	/* Calculate the first and last logical blocks respectively. */
+	map->m_lblk = offset >> blkbits;
+	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
+			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
+
+	return ext4_map_blocks(NULL, inode, map, 0);
+}
+
+static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
+		loff_t length, unsigned int flags, struct iomap *iomap,
+		struct iomap *srcmap)
+{
+	struct ext4_map_blocks map;
+	int ret;
+
+	if (unlikely(ext4_forced_shutdown(inode->i_sb)))
+		return -EIO;
+
+	/* Inline data support is not yet available. */
+	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
+		return -ERANGE;
+
+	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
+	if (ret < 0)
+		return ret;
+
+	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
+	return 0;
+}
+
+const struct iomap_ops ext4_iomap_buffered_read_ops = {
+	.iomap_begin = ext4_iomap_buffered_read_begin,
+};
+
 static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
 {
+	iomap_bio_read_folio(folio, &ext4_iomap_buffered_read_ops);
 	return 0;
 }
 
 static void ext4_iomap_readahead(struct readahead_control *rac)
 {
-
+	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
 }
 
 static int ext4_iomap_writepages(struct address_space *mapping,
-- 
2.52.0

