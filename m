Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E394388390;
	Mon, 11 May 2026 07:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484519; cv=none; b=jvcDgtcGUi1nghcbDOAPnzA9wJYVR251zUbH6hkFeFXXMp70Y8F8o6a7IaWbVvysHK+RzLQV3MhlVuBB/dI2/0JPyCcAQiOb3YY6oMaTjBjZMNqY462Uy2TytZA+xd5BQ/SqtJt4dbQjQPjB+C/VBIostuA44tVVWN7FS8hjFVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484519; c=relaxed/simple;
	bh=PMEVtIA0RqSxL0YdtSsnwtF2sqk55TO7wCLofEYzyuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibJGreS7aBXOOBP6G2mg4Z6RK3sE8R7fdqP7ph0DNdsz3eueZXlJhMDHE2soFKd6A5eal8ZKhJCV5TIE4r6Ny77MrR4acQJHxuX+XCvH3+B4Oz3pNAX3p6bQXKGp5Lw9YvX5MiZoWlIoDB52k6OqattuPj/1JS4hpddon1qCGJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gDWX56WMszKHMgD;
	Mon, 11 May 2026 15:27:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6FBCB40590;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S26;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
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
Subject: [PATCH v4 22/23] ext4: partially enable iomap for the buffered I/O path of regular files
Date: Mon, 11 May 2026 15:23:42 +0800
Message-ID: <20260511072344.191271-23-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S26
X-Coremail-Antispam: 1UD129KBjvJXoWxtF4UKF13Cr43KF1kJF1UZFb_yoWfZry3pr
	ZxK34rGrn0qryv9w4Iqr4UXr1Yv3WxG3yUGrZ3ur1kAa98Gw1IqFyjyF1YvF15JrWfWw12
	qF48tw1UuwsFkrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
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

 - Add WARN_ON_ONCE() guards in _ext4_get_block() and
   ext4_do_writepages() to catch inodes using the iomap path from
   accidentally entering the legacy buffer_head writeback path.

 - Reject extent-to-indirect migration via ext4_ind_migrate() for inodes
   on the iomap path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h      |  1 +
 fs/ext4/ext4_jbd2.c |  8 +++--
 fs/ext4/ialloc.c    |  1 +
 fs/ext4/inode.c     | 77 +++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/migrate.c   |  2 ++
 5 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0a3bb44f1e6e..afba952abd28 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3068,6 +3068,7 @@ int ext4_walk_page_buffers(handle_t *handle,
 int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
 void ext4_set_inode_mapping_order(struct inode *inode);
+void ext4_enable_buffered_iomap(struct inode *inode);
 int ext4_nonda_switch(struct super_block *sb);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2753..4534cf6f5e76 100644
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
index 3fd8f0099852..ea64b9e9e382 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1340,6 +1340,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		}
 	}
 
+	ext4_enable_buffered_iomap(inode);
 	ext4_set_inode_mapping_order(inode);
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cf83b4e619e0..0407e7b54dcd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -918,6 +918,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 
 	if (ext4_has_inline_data(inode))
 		return -ERANGE;
+	/* inode using the iomap buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
 
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
@@ -2797,6 +2800,12 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		goto out_writepages;
 
+	/* inode using the iomap buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(ext4_inode_buffered_iomap(inode))) {
+		ret = -EINVAL;
+		goto out_writepages;
+	}
+
 	/*
 	 * If the filesystem has aborted, it is read-only, so return
 	 * right away instead of dumping stack traces later on that
@@ -3929,6 +3938,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
 {
 	u8 blkbits = inode->i_blkbits;
 
+	/* inode using the buffer_head buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(!ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
 	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
 
@@ -4406,6 +4418,10 @@ static int ext4_iomap_writepages(struct address_space *mapping,
 		.ops = &ext4_writeback_ops,
 	};
 
+	/* inode using the buffer_head buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(!ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
+
 	ret = ext4_emergency_state(sb);
 	if (unlikely(ret))
 		return ret;
@@ -5864,6 +5880,59 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
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
+}
+
 void ext4_set_inode_mapping_order(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
@@ -6149,6 +6218,8 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	if (ret)
 		goto bad_inode;
 
+	ext4_enable_buffered_iomap(inode);
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
@@ -7326,9 +7397,10 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	 * the inode's in-core data-journaling state flag now.
 	 */
 
-	if (val)
+	if (val) {
 		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
-	else {
+		ext4_clear_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
+	} else {
 		err = jbd2_journal_flush(journal, 0);
 		if (err < 0) {
 			jbd2_journal_unlock_updates(journal);
@@ -7337,6 +7409,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 			return err;
 		}
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
+		ext4_enable_buffered_iomap(inode);
 	}
 	ext4_set_aops(inode);
 	ext4_set_inode_mapping_order(inode);
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 477d43d7e294..3b49ecf427ae 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -620,6 +620,8 @@ int ext4_ind_migrate(struct inode *inode)
 
 	if (ext4_has_feature_bigalloc(inode->i_sb))
 		return -EOPNOTSUPP;
+	if (ext4_inode_buffered_iomap(inode))
+		return -EOPNOTSUPP;
 
 	/*
 	 * In order to get correct extent info, force all delayed allocation
-- 
2.52.0

