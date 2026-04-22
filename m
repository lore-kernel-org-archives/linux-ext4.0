Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BEB3537F8;
	Wed, 22 Apr 2026 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824228; cv=none; b=JyGv0owC3Mx6Al77cKdTch6Iz3XSwC3qdt/fWubJfQxcygy+kSxu+3seeB4BzIZFvkpZv5kb7nWbwewhT5AG1TzmL1sGT0SI3rBa5A395eBSNk4GiIf5FbLKLuF+T0Oj6TdbcThERaRKfHw5Jj4pITveSyHzxlAPMrwD+VORkss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824228; c=relaxed/simple;
	bh=EvEDJ4oSgF5i0Y+bxfo/CO9bC+0K95e4uWWm3+SznEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJt6A/MYX40Ezwp4kR7Bke7aPGh6JEyMaxRAWUUK2Z1drZ/A4MqUkkWfZ6LJUa3Sw8GG3IMUa9J5lm21ZYMtzqOJZCuiReMAO8EMi4nrseuY5mHzC/knD9IHMMIuORD7pFgVlXva8KQtw6E9zRX8FC1a57uaVrTU3oOUAhPqZ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0jX51kRXzKHMTT;
	Wed, 22 Apr 2026 10:16:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 457E0405F8;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S21;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
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
Subject: [PATCH v3 17/22] ext4: partially enable iomap for the buffered I/O path of regular files
Date: Wed, 22 Apr 2026 10:10:37 +0800
Message-ID: <20260422021042.4157510-18-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S21
X-Coremail-Antispam: 1UD129KBjvJXoWxCrW8CFykuryrJr1kAryUtrb_yoWrurWkpr
	9xKryrGr4DX3s29w4ftr4UZr1Yv3WxG3yUGrWfurs8ZrWDJw1IqFyUtF1YyF15JrWrWw4Y
	qF40kr1UursxCrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Partially enable iomap for the buffered I/O path of regular files. We
now support default filesystem features, mount options, and the bigalloc
feature. However, inline data, fsverity, fscrypt, online
defragmentation, and data=journal mode are not yet supported. Some of
these features are expected to be gradually supported in the future. The
filesystem will automatically fall back to the original buffer_head path
if these mount options or features are enabled.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h      |  1 +
 fs/ext4/ext4_jbd2.c |  1 +
 fs/ext4/ialloc.c    |  1 +
 fs/ext4/inode.c     | 36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0ffa81f86bc5..80d086d40990 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3059,6 +3059,7 @@ int ext4_walk_page_buffers(handle_t *handle,
 int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
 void ext4_set_inode_mapping_order(struct inode *inode);
+void ext4_enable_buffered_iomap(struct inode *inode);
 int ext4_nonda_switch(struct super_block *sb);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2753..9b25a1c414b9 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -16,6 +16,7 @@ int ext4_inode_journal_mode(struct inode *inode)
 	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE) ||
 	    test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
 	    (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
+	    !ext4_inode_buffered_iomap(inode) &&
 	    !test_opt(inode->i_sb, DELALLOC))) {
 		/* We do not support data journalling for encrypted data */
 		if (S_ISREG(inode->i_mode) && IS_ENCRYPTED(inode))
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
index 53fdcb50f3dd..57b5708235cf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -918,6 +918,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 
 	if (ext4_has_inline_data(inode))
 		return -ERANGE;
+	/* inodes using the iomap buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(ext4_inode_buffered_iomap(inode)))
+		return -EINVAL;
 
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
@@ -2797,6 +2800,12 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		goto out_writepages;
 
+	/* inodes using the iomap buffered I/O path should not go here. */
+	if (WARN_ON_ONCE(ext4_inode_buffered_iomap(inode))) {
+		ret = -EINVAL;
+		goto out_writepages;
+	}
+
 	/*
 	 * If the filesystem has aborted, it is read-only, so return
 	 * right away instead of dumping stack traces later on that
@@ -5737,6 +5746,31 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
 	return -EFSCORRUPTED;
 }
 
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
@@ -6022,6 +6056,8 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	if (ret)
 		goto bad_inode;
 
+	ext4_enable_buffered_iomap(inode);
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
-- 
2.52.0

