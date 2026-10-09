Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960094AE135;
	Fri,  9 Oct 2026 10:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542729; cv=none; b=oAVP094EQ6HH9OusWpazOWZDzsixf/uLSCl6UYjA/pqTxHPTv574YmDBxX7bRFQ5qEylPOCcZmapn7huL2DYBc7vHU08ej/IgIvewOxWgUxCPfYqNbkGa03rWRjFhSfLfwra+wQI8JESrMGX11MbXneGDy1BwLHOtEIaRL6i2Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542729; c=relaxed/simple;
	bh=NlcHlTTRmmwNL3jv67BBOUISRFutF3kwRoB90PlYTCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7ode35z6ckD8F/Mns/UviIqTcwPxlzgtiNh70KBwxhg2vej3f0EMpA051p1bFtcv5yhWARmnkpmiZGBLmkIf4zswHyv4fXDbJuN40eg7llqQbx/S8kga9L2P+te8/0cEfzjV9cGngDqQkCxlx6nducpHbdD4zt9IrM3P0FgthQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1Nll6Yt3zYQv3x;
	Fri,  9 Oct 2026 18:44:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 23F3B40577;
	Fri,  9 Oct 2026 18:45:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xim0xchqcxdfDQ--.55186S5;
	Fri, 09 Oct 2026 18:45:19 +0800 (CST)
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
Subject: [PATCH v7 30/31] ext4: partially enable iomap for the buffered I/O path of regular files
Date: Fri,  9 Oct 2026 18:38:30 +0800
Message-ID: <20261009103831.2978767-2-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3xim0xchqcxdfDQ--.55186S5
X-Coremail-Antispam: 1UD129KBjvJXoW3tw1DWw15JF48Cr48tr4rGrg_yoWDZw45pr
	9xK34rGr1DX34v9w4xtw4DXr1Yv3WxK3yUGrZ3ur1kAa98Jw1IqFyjyF1jvF15JrZ3Ww42
	qF40yw1UuwnFk37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnIWIev
	Ja73UjIFyTuYvjTRJku4DUUUU
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
 fs/ext4/inode.c     | 105 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/migrate.c   |   2 +
 5 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 504dce9fdc6b9..405e256a1802b 100644
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
index 53ddedb52a6f7..a4664ddecdcd6 100644
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
index a5831fc536db9..f97a2f4904ebb 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1346,6 +1346,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		}
 	}
 
+	ext4_enable_buffered_iomap(inode);
 	ext4_set_inode_mapping_order(inode);
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c3a6f3dce3d86..a07ce368e6e82 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1039,6 +1039,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 
 	if (ext4_has_inline_data(inode))
 		return -ERANGE;
+	/* inode using the iomap buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
 
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
@@ -2915,6 +2918,13 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
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
@@ -4053,6 +4063,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
 {
 	u8 blkbits = inode->i_blkbits;
 
+	/* inode using the buffer_head buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(!ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
 	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
 
@@ -4496,6 +4509,15 @@ static int ext4_iomap_writepages(struct address_space *mapping,
 	ext4_iomap_wb_submit_zeroed_eof(inode, wbc);
 
 	alloc_ctx = ext4_writepages_down_read(sb);
+	/*
+	 * Does ext4_change_inode_journal_flag() change the inode's
+	 * buffered I/O path?
+	 */
+	if (!ext4_inode_buffered_iomap(inode)) {
+		ext4_writepages_up_read(sb, alloc_ctx);
+		return ret;
+	}
+
 	trace_ext4_writepages(inode, wbc);
 	ret = iomap_writepages(&wpc);
 	trace_ext4_writepages_result(inode, wbc, ret, nr - wbc->nr_to_write);
@@ -6076,6 +6098,81 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
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
@@ -6390,6 +6487,8 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	if (ret)
 		goto bad_inode;
 
+	ext4_enable_buffered_iomap(inode);
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
@@ -7620,9 +7719,10 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
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
@@ -7631,6 +7731,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 			return err;
 		}
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
+		ext4_enable_buffered_iomap(inode);
 	}
 	ext4_set_aops(inode);
 	ext4_set_inode_mapping_order(inode);
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5d60ef10fe110..09931d3ba2c6a 100644
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

