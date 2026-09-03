Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654424A9D75;
	Thu,  3 Sep 2026 12:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439388; cv=none; b=bzMi7nhmPBd772ELTbZqp7OsUMm+kDN8n9gC1E2BtnkkkFOFkiq18iQhJHsyhiFsr5l/VPDvJU1CBWa6FoZ4AGxIawi42RFAgC83V/kGxzga0hdcLFB3sduA+GcFwe3TNRxIz8+Q8g3w3d/I+fqsEqKgknQ22jmqqxkZTqHqQhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439388; c=relaxed/simple;
	bh=UDypW03g6Gn7yY3pYXXIX9mj1x7g547TqHNMHkNw4K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2p0LXhTyGP0z3O/9shazTIsAmZHHYrMGlmtLpyoL21Meh1LtsALviXkLsGwiihJISQGEQPZwCffv4J+nUe7Ts/WVCoP9VWFBdmZ87dJXuO1LnrRuX0/SmzPIsDI6G4ZTsVrihX+f26ENDLylcdIntgJMrYIn1haGOSjr/HGltA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK4041GZzYQv0n;
	Thu,  3 Sep 2026 20:42:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6DD0540B88;
	Thu,  3 Sep 2026 20:42:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S14;
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
Subject: [PATCH v6 10/31] ext4: add iomap address space operations for buffered I/O
Date: Thu,  3 Sep 2026 20:35:22 +0800
Message-ID: <20260903123543.2302999-11-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S14
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1DuryDWryrtF4rGryfZwb_yoWrJw1fpF
	98Kas8GF18XF9rua1Sqa9rZrWYka4fGw4jgFW3W3Wa9Fy5GrW2gFW0k3WYyFyUK3ykJr12
	qF4j9rW7WF17ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Introduce initial support for iomap in the buffered I/O path for regular
files on ext4.

  - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
    inode uses iomap instead of buffer_head for buffered I/O
  - Add helper ext4_inode_buffered_iomap() to check the flag
  - Add new address space operations ext4_iomap_aops with callbacks that
    will use generic iomap implementations
  - Add ext4_iomap_aops to ext4_set_aops() when the flag is set

The following callbacks(read_folio(), readahead(), writepages()) are
provided as placeholders and will be implemented in later patches.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h  |  7 +++++++
 fs/ext4/inode.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 724a27e8be61..24ec205da2d7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2049,6 +2049,7 @@ enum {
 	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
 	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
+	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
@@ -2148,6 +2149,12 @@ static inline struct mapping_metadata_bhs *ext4_i_metadata_bhs(
 	return READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
 }
 
+/* Whether the inode pass through the iomap infrastructure for buffered I/O */
+static inline bool ext4_inode_buffered_iomap(struct inode *inode)
+{
+	return ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
+}
+
 /*
  * Codes for operating systems
  */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2881596bff8b..7619633506c4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3958,6 +3958,22 @@ const struct iomap_ops ext4_iomap_report_ops = {
 	.iomap_next = ext4_iomap_next_report,
 };
 
+static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
+{
+	return 0;
+}
+
+static void ext4_iomap_readahead(struct readahead_control *rac)
+{
+
+}
+
+static int ext4_iomap_writepages(struct address_space *mapping,
+				 struct writeback_control *wbc)
+{
+	return 0;
+}
+
 /*
  * For data=journal mode, folio should be marked dirty only when it was
  * writeably mapped. When that happens, it was already attached to the
@@ -4044,6 +4060,20 @@ static const struct address_space_operations ext4_da_aops = {
 	.swap_activate		= ext4_iomap_swap_activate,
 };
 
+static const struct address_space_operations ext4_iomap_aops = {
+	.read_folio		= ext4_iomap_read_folio,
+	.readahead		= ext4_iomap_readahead,
+	.writepages		= ext4_iomap_writepages,
+	.dirty_folio		= iomap_dirty_folio,
+	.bmap			= ext4_bmap,
+	.invalidate_folio	= iomap_invalidate_folio,
+	.release_folio		= iomap_release_folio,
+	.migrate_folio		= filemap_migrate_folio,
+	.is_partially_uptodate  = iomap_is_partially_uptodate,
+	.error_remove_folio	= generic_error_remove_folio,
+	.swap_activate		= ext4_iomap_swap_activate,
+};
+
 static const struct address_space_operations ext4_dax_aops = {
 	.writepages		= ext4_dax_writepages,
 	.dirty_folio		= noop_dirty_folio,
@@ -4065,6 +4095,8 @@ void ext4_set_aops(struct inode *inode)
 	}
 	if (IS_DAX(inode))
 		inode->i_mapping->a_ops = &ext4_dax_aops;
+	else if (ext4_inode_buffered_iomap(inode))
+		inode->i_mapping->a_ops = &ext4_iomap_aops;
 	else if (test_opt(inode->i_sb, DELALLOC))
 		inode->i_mapping->a_ops = &ext4_da_aops;
 	else
-- 
2.52.0

