Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF284AD4C3;
	Thu,  3 Sep 2026 12:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439654; cv=none; b=RsJc0Xp/MXQ+4M5ie1qDqv1P+7WrZ33PjnfqEBppDjDXrOo1ZuBdf6fCU5kA3PlR2tUeyqfnvbfG1/MFEWSQXiEhYuNcNP3u4eZLLWLopwoUizdUrsmBOqmeiinM7B7V3OdHfxEX3GQ+polsqx2WATnGNAHb09cLW5/RsNOy6Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439654; c=relaxed/simple;
	bh=ME1wRvnfPs0ygAjChHcBbUMgivrDIPwMqWUjW7fIVTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKdZhQutNu/UwFPbUAoK5USqSd8jCXwnGDj8Gn1re+dwHPi7mjFmZmzuQ+jl4rXU6zb/KNdPMorK9K7vxykp4iZpQNRiSzjT2N8Qob7aQZ+PLpcr7UlVD0UqfSnwKGeOS3mV3YeZmOYZccNAD5VcZMXHBFUvCwTE5FH8yhaFhX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK9G1C7WzYQtjh;
	Thu,  3 Sep 2026 20:46:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 0490F40D1F;
	Thu,  3 Sep 2026 20:47:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBnUAtUbJlqlPhrAg--.37288S5;
	Thu, 03 Sep 2026 20:47:24 +0800 (CST)
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
Subject: [PATCH v6 30/31] ext4: partially enable iomap for the buffered I/O path of regular files
Date: Thu,  3 Sep 2026 20:40:16 +0800
Message-ID: <20260903124017.2325538-2-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgBnUAtUbJlqlPhrAg--.37288S5
X-Coremail-Antispam: 1UD129KBjvJXoW3tw1DWw15JF48Cr48tr4rGrg_yoWDZw47pr
	9xK34rGr1DX34v9w4xtw4DXr1Yv3WxK3yUGrZ3ur1kZa98Jw1IqFyjyF1YvF15JrZ3Ww42
	qF40yw1Uuw1qkrDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmmb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJr0_GcWl84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj
	6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWlIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Cr1j6rxd
	YxBIdaVFxhVjvjDU0xZFpf9x0piRRR_UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Introduce ext4_enable_buffered_iomap() to determine whether a regular
file inode should use the iomap buffered I/O path. We now support the
default filesystem features, mount options, and the bigalloc feature.
However, inline data, fsverity, fscrypt, indirect inode type, and
data=journal mode are not fully supported.

The decision is made at inode initialization time in __ext4_new_inode()
and __ext4_iget() by setting the EXT4_STATE_BUFFERED_IOMAP state flag.
If any of these unsupported features are met, the inode silently falls
back to the traditional buffer_head path. Switching the buffered I/O
path on an active inode is not supported, with the exception of changing
a per-inode journal flag.

For features like encryption, verity, and inline data that can be
dynamically enabled at the superblock level, checking the global feature
flag avoids the complexity of toggling the path on individual inodes.

Additionally:

 - Extend ext4_inode_journal_mode() to force ordered mode for inodes
   using the iomap path under a data=journal mount. For the global data
   journal mode (EXT4_MOUNT_JOURNAL_DATA), dynamic enablement is
   deferred until the next inode re-initialization. For the per-inode
   data journal mode (EXT4_INODE_JOURNAL_DATA), dynamic changes take
   effect immediately, as it is safe to switch address_space operations
   and drop all page cache under i_rwsem and filemap_invalidate_lock.

 - Add a WARN_ON_ONCE() guard in _ext4_get_block() to catch inodes
   using the iomap path from accidentally entering the legacy
   buffer_head writeback path.

 - Place silent BUFFERED_IOMAP checks in ext4_do_writepages() and
   ext4_iomap_writepages() under the writepages rwsem. Unlike
   _ext4_get_block(), the writeback path does not hold i_rwsem or
   invalidate_lock and can race with ext4_change_inode_journal_flag()
   switching the inode's a_ops.

 - Reject extent-to-indirect migration via ext4_ind_migrate() for inodes
   on the iomap path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h      |   1 +
 fs/ext4/ext4_jbd2.c |   8 +++-
 fs/ext4/ialloc.c    |   1 +
 fs/ext4/inode.c     | 105 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/migrate.c   |   2 +
 5 files changed, 112 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 504dce9fdc6b..405e256a1802 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3170,6 +3170,7 @@ int ext4_walk_page_buffers(handle_t *handle,
 int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
 void ext4_set_inode_mapping_order(struct inode *inode);
+void ext4_enable_buffered_iomap(struct inode *inode);
 int ext4_nonda_switch(struct super_block *sb);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define EXT4_WRITE_DATA_INLINE	 2
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 53ddedb52a6f..a4664ddecdcd 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -17,8 +17,12 @@ int ext4_inode_journal_mode(struct inode *inode)
 	    test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
 	    (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
 	    !test_opt(inode->i_sb, DELALLOC))) {
-		/* We do not support data journalling for encrypted data */
-		if (S_ISREG(inode->i_mode) && IS_ENCRYPTED(inode))
+		/*
+		 * We do not support data journalling for encrypted data
+		 * and buffered IOMAP path.
+		 */
+		if (S_ISREG(inode->i_mode) &&
+		    (IS_ENCRYPTED(inode) || ext4_inode_buffered_iomap(inode)))
 			return EXT4_INODE_ORDERED_DATA_MODE;  /* ordered */
 		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
 	}
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a5831fc536db..f97a2f4904eb 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1346,6 +1346,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		}
 	}
 
+	ext4_enable_buffered_iomap(inode);
 	ext4_set_inode_mapping_order(inode);
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7454867ac8bd..e7849c25c110 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1036,6 +1036,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 
 	if (ext4_has_inline_data(inode))
 		return -ERANGE;
+	/* inode using the iomap buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
 
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
@@ -2906,6 +2909,13 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		goto out_writepages;
 
+	/*
+	 * Does ext4_change_inode_journal_flag() change the inode's
+	 * buffered I/O path?
+	 */
+	if (ext4_inode_buffered_iomap(inode))
+		goto out_writepages;
+
 	/*
 	 * If the filesystem has aborted, it is read-only, so return
 	 * right away instead of dumping stack traces later on that
@@ -4044,6 +4054,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
 {
 	u8 blkbits = inode->i_blkbits;
 
+	/* inode using the buffer_head buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(!ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
 	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
 
@@ -4482,11 +4495,18 @@ static int ext4_iomap_writepages(struct address_space *mapping,
 	ext4_iomap_wb_submit_zeroed_eof(inode, wbc);
 
 	alloc_ctx = ext4_writepages_down_read(sb);
+	/*
+	 * Does ext4_change_inode_journal_flag() change the inode's
+	 * buffered I/O path?
+	 */
+	if (!ext4_inode_buffered_iomap(inode))
+		goto out;
+
 	trace_ext4_writepages(inode, wbc);
 	ret = iomap_writepages(&wpc);
 	trace_ext4_writepages_result(inode, wbc, ret, nr - wbc->nr_to_write);
+out:
 	ext4_writepages_up_read(sb, alloc_ctx);
-
 	return ret;
 }
 
@@ -6054,6 +6074,81 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
 	return -EFSCORRUPTED;
 }
 
+/*
+ * Determine whether an inode should use the iomap buffered I/O path.
+ * EXT4_STATE_BUFFERED_IOMAP is generally set at inode initialization
+ * time. Online switching of the buffered I/O path on an active inode is
+ * NOT supported, with the exception of changing a per-inode journal
+ * flag.
+ *
+ * For features like inline data, fsverity, and encryption that can be
+ * dynamically enabled or disabled, we check the superblock-level
+ * feature flags. If any of these is globally enabled, no inode is
+ * allowed into the iomap buffered I/O path. This avoids the complexity
+ * of dynamic toggling.
+ *
+ * For the global data journal mode (EXT4_MOUNT_JOURNAL_DATA), dynamic
+ * change through remount is deferred. It will only become available
+ * after the inode is re-initialized (i.e., after the last reference
+ * drops and the inode is re-read from disk with the journal flag
+ * cleared).
+ *
+ * For the per-inode data journal mode (EXT4_INODE_JOURNAL_DATA),
+ * dynamic changes take effect immediately. This is safe because
+ * address_space operations can be switched and all page cache can be
+ * dropped under i_rwsem and filemap_invalidate_lock.
+ *
+ * For extent-to-indirect block migration (via EXT4_IOC_SETFLAGS
+ * clearing EXT4_EXTENTS_FL), this operation is directly rejected for
+ * inodes using the iomap path.
+ */
+void ext4_enable_buffered_iomap(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (!S_ISREG(inode->i_mode))
+		return;
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
+		return;
+
+	/* Unsupported Features */
+	if (ext4_has_feature_inline_data(sb))
+		return;
+	if (ext4_has_feature_verity(sb))
+		return;
+	if (ext4_has_feature_encrypt(sb))
+		return;
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
+	    ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
+		return;
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		return;
+
+	ext4_set_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
+
+	/*
+	 * Install the iomap end_io handler on the shared conversion
+	 * work.  This is safe at inode initialization and during the
+	 * buffered I/O path changes where we flush all pending
+	 * writebacks and drop page cache under i_rwsem and
+	 * filemap_invalidate_lock.
+	 */
+	INIT_WORK(&EXT4_I(inode)->i_rsv_conversion_work, ext4_iomap_end_io);
+}
+
+static void ext4_disable_buffered_iomap(struct inode *inode)
+{
+	ext4_clear_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
+
+	/*
+	 * Reinstall the buffer_head end_io handler on the shared
+	 * conversion work.  This is safe during the buffered I/O path
+	 * changes where we flush all pending writebacks and drop page
+	 * cache under i_rwsem and filemap_invalidate_lock.
+	 */
+	INIT_WORK(&EXT4_I(inode)->i_rsv_conversion_work, ext4_end_io_rsv_work);
+}
+
 void ext4_set_inode_mapping_order(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
@@ -6368,6 +6463,8 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	if (ret)
 		goto bad_inode;
 
+	ext4_enable_buffered_iomap(inode);
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
@@ -7593,9 +7690,10 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	 * the inode's in-core data-journaling state flag now.
 	 */
 
-	if (val)
+	if (val) {
 		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
-	else {
+		ext4_disable_buffered_iomap(inode);
+	} else {
 		err = jbd2_journal_flush(journal, 0);
 		if (err < 0) {
 			jbd2_journal_unlock_updates(journal);
@@ -7604,6 +7702,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 			return err;
 		}
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
+		ext4_enable_buffered_iomap(inode);
 	}
 	ext4_set_aops(inode);
 	ext4_set_inode_mapping_order(inode);
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5d60ef10fe11..09931d3ba2c6 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -621,6 +621,8 @@ int ext4_ind_migrate(struct inode *inode)
 
 	if (ext4_has_feature_bigalloc(inode->i_sb))
 		return -EOPNOTSUPP;
+	if (ext4_inode_buffered_iomap(inode))
+		return -EOPNOTSUPP;
 
 	/*
 	 * In order to get correct extent info, force all delayed allocation
-- 
2.52.0

