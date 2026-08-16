Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6289D33B6E8
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2026 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786892759; cv=none; b=T/mIh/bTiNvV22nsdoSetiMlbzAprqIsDZtykqqPDTShPtRKuNDi974WBNdKPkaJ/10fD94S20WR/PLdZMXtFcEC08OW/xnwSQIc97V4NjrkjJYDWWmThyTMbqkFVAwovNWTF56ATF4RkHOteJjBArJtAWvgsOMe7+QzMf/P3KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786892759; c=relaxed/simple;
	bh=otshLG7FBlZZghbF2WpdXmTB2dMSUHQOm3AZTKzDva8=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uuwKHa73ziXzd2J25WzincMCsqBMkRkvHoBwUWdAw2l+J3dO/JZg/UcbIQJ88Pzb+4wK6CQiPjj9faBXR8ptD5xYS22Lgrq6i2EuTdrFJ0ZXrF7aelc+xWIS7bYQOu+1DW5CCRBPBS0RER5LeO8RZGOkJzLJfq13Nb5iWwZjckY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Ha+0RNU/; arc=none smtp.client-ip=43.163.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Ha+0RNU/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786892747; bh=lkysBOuNh7hJQKyoOxe1ETaxI38YoJ6jpCDmOfGYH+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ha+0RNU/phTisx5UK7q+mvV9+8wtrEhN9tvefjQuozoGCb8PcOIfhHerKng7VRfj7
	 WmpLl2R0FXISjcnfYleIu/UPw46bXLHvFVLLV7NhPk6xhXDrCmiDSQEXR875BZ+Vqc
	 cqwxpi65y8SQEIZKqREs88sQA4V+szwhp1a8IH1I=
Received: from PIPISHUO.localdomain ([2409:8a00:175:6f10:5e8:e1d0:5179:38f8])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 9693AEA; Sun, 16 Aug 2026 23:02:22 +0800
X-QQ-mid: xmsmtpt1786892542tdleucmo4
Message-ID: <tencent_BDF7C28D876E422418FB57474B765F0C1A09@qq.com>
X-QQ-XMAILINFO: MUM9tpkn9N/zuF5xJxTA7Q7+V1QKJ1d1UipKHjFzj0PXLNvUVqKVnMs4Ipwqqf
	 hahPS9fn499+EOLJu7pBqrWLMLLpsp3MA9mt3ljFYo+ArRRqIpeZ/Yl0iERvZgvwafk+ESQQrwtO
	 plRWof/6ml7/VTVPPCVNDu3F8tBZz5g7kgCtC7QOzf0jmqOqGBCaFgmTYgDId1ylFDALIGfWl50p
	 WzyPQlnBIGQv22ktZ29oibb58Vp13a4tbQIXqyKbPCoDK39kdS+DH+m2HKTJiCQMgsA5KEkFXLTX
	 ZCz62pgs9Y60Y9bv11hUq8xcPgEbSkzRsTFfwSMXeSQjJQrA03mbFimTK2R57kF3kh4lsICbhZjn
	 JcBb0UqoXzuFX3HkOTjJ5+LUIRVNdimvbmlMuHCGgXQ75I0ku3FFfEVLj5T2g8Qr5ClP+CvD7uCc
	 TojPdCAj8c11v3jFh6bacdcie3Et1V7cEs5tOAWuwnmz23YhnjNkP0aRCQ/mRoMmI28dxzZIkKUD
	 hX5cyNE90f8AGf8nQ5/tPHsFSTffh8Q4Sa8C5Eoyb0C7kLP6gFwuMHI0gFDm0zpf98lsrYgD32CJ
	 zLEElju7WO2txnZAn6ghN2UML7GZ1U7GgN1OrhPnKjkrB0C6QcTYohSU0OXgAAI0hOPsmn8nodis
	 /6Lu7pPGzzCSdx2dHcJ8rVSMxLngg/3FOL5ZwR0LSiPmuG9nbyqCDwipOlACryYJdKtJavqhQ4Dc
	 gziBOs2uFsmqdBP4PrKtQAjTpy5UVg2FudmHQxZqIIx6Y4X67cTtuC6lLGdaMNmWqlIvF3FGkJ/q
	 U3OU5HAsfzLyeaXhV4V9BY0DAppcJLIL5U4NEHv/lyGgdW72RkO4uinrfUcBJY/+kdv85+/EHROK
	 kCwb10ufEoLmw//UjkKWsoIcb8fVQrZupgQThh28nVYazwWxCfYuYVk/o9PL2tiHmEa0wpL9WZSZ
	 een3nsalxdDkfvvIhHFXWc/i+JHGUAW0C3a2PMMbtSQVZ3yiBpWGbz6gMbL2ybYgNQ7BelEk8zEr
	 GWF/pvkr8cBB1cEEadV1O5tCgLNs3ybYHJ79XrwSeNFboaUSTTc286YAkn0U6oVKVGnY6NGt4nh8
	 UfLi3IQj6jLCy8Nl+pmcOFcko7qoYGDmfHlNSYZ5aJ4rdgRMU=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>
Subject: [PATCH v2] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Date: Sun, 16 Aug 2026 23:02:02 +0800
X-OQ-MSGID: <20260816150201.132685-2-1289151713@qq.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <an5_shcksPF6uIaW@mit.edu>
References: <an5_shcksPF6uIaW@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> We can also do the conversion in a much safer way, by allocating the
> data block first, and writing a copy of the data to the data block,
> and only if that is successful, do we update the extent tree or
> indirect block mapping in the inode.  Of course, this would require a
> rewrite of ext4_convert_inline_data_nolock(), but this would allow us
> to fix up the other aspects of the error handling which is not quite
> right.
Rewrite ext4_convert_inline_data_nolock() as suggested.

---
v1 -> v2:
- Rewrite ext4_convert_inline_data_nolock() to allocate blocks before
  destroying inline data
- Link to v1: https://lore.kernel.org/linux-ext4/tencent_7A0B62235E38C5907A080BE3D56A59C9FD06@qq.com/T/#t：
---
Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inline.c | 113 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 80 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..2a9299ea4146 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -14,6 +14,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include "ext4_extents.h"
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1070,21 +1071,67 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	return 0;
 }
 
-static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
-				     struct ext4_iloc *iloc,
-				     void *buf, int inline_size)
+static int ext4_set_inline_data_block(handle_t *handle, struct inode *inode,
+				      ext4_fsblk_t block, unsigned int len)
 {
-	int ret;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = 0, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM,
+		.name = EXT4_XATTR_SYSTEM_DATA,
+		.value = NULL,
+		.value_len = 0,
+	};
+	int error;
 
-	ret = ext4_create_inline_data(handle, inode, inline_size);
-	if (ret) {
-		ext4_msg(inode->i_sb, KERN_EMERG,
-			"error restoring inline_data for inode -- potential data loss! (inode %llu, error %d)",
-			inode->i_ino, ret);
-		return;
+	down_write(&ei->i_data_sem);
+	error = ext4_get_inode_loc(inode, &is.iloc);
+	if (error) {
+		up_write(&ei->i_data_sem);
+		return error;
 	}
-	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
-	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	error = ext4_xattr_ibody_find(inode, &i, &is);
+	if (error)
+		goto out;
+	BUFFER_TRACE(is.iloc.bh, "get_write_access");
+	error = ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh, EXT4_JTR_NONE);
+	if (error)
+		goto out;
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	if (error)
+		goto out;
+	memset((void *)ext4_raw_inode(&is.iloc)->i_block,
+		0, EXT4_MIN_INLINE_DATA_SIZE);
+	memset(ei->i_data, 0, EXT4_MIN_INLINE_DATA_SIZE);
+
+	if (ext4_has_feature_extents(inode->i_sb) &&
+		(S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode) || S_ISLNK(inode->i_mode))) {
+		ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+		ext4_ext_tree_init(handle, inode);
+		struct ext4_ext_path *path = ext4_find_extent(inode, 0, NULL, 0);
+		struct ext4_extent newex;
+
+		newex.ee_block = cpu_to_le32(0);
+		newex.ee_len = cpu_to_le16(len);
+		ext4_ext_store_pblock(&newex, block);
+		ext4_ext_insert_extent(handle, inode, path, &newex, 0);
+	} else {
+		EXT4_I(inode)->i_data[0] = cpu_to_le32(block);
+	}
+	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+	get_bh(is.iloc.bh);
+	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+	EXT4_I(inode)->i_inline_off = 0;
+	EXT4_I(inode)->i_inline_size = 0;
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+out:
+	brelse(is.iloc.bh);
+	if (error == -ENODATA)
+		error = 0;
+	up_write(&ei->i_data_sem);
+	return error;
 }
 
 static int ext4_convert_inline_data_nolock(handle_t *handle,
@@ -1094,8 +1141,9 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	int error;
 	void *buf = NULL;
 	struct buffer_head *data_bh = NULL;
-	struct ext4_map_blocks map;
 	int inline_size;
+	ext4_fsblk_t newblock = 0;
+	struct ext4_allocation_request ar;
 
 	inline_size = ext4_get_inline_size(inode);
 	buf = kmalloc(inline_size, GFP_NOFS);
@@ -1120,25 +1168,22 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 			goto out;
 	}
 
-	error = ext4_destroy_inline_data_nolock(handle, inode);
-	if (error)
-		goto out;
-
-	map.m_lblk = 0;
-	map.m_len = 1;
-	map.m_flags = 0;
-	error = ext4_map_blocks(handle, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	memset(&ar, 0, sizeof(ar));
+	ar.inode = inode;
+	ar.logical = 0;
+	ar.len = 1;
+	if (S_ISREG(inode->i_mode))
+		ar.flags = EXT4_MB_HINT_DATA;
+	else
+		ar.flags = 0;
+	newblock = ext4_mb_new_blocks(handle, &ar, &error);
 	if (error < 0)
-		goto out_restore;
-	if (!(map.m_flags & EXT4_MAP_MAPPED)) {
-		error = -EIO;
-		goto out_restore;
-	}
+		goto out;
 
-	data_bh = sb_getblk(inode->i_sb, map.m_pblk);
+	data_bh = sb_getblk(inode->i_sb, newblock);
 	if (!data_bh) {
 		error = -ENOMEM;
-		goto out_restore;
+		goto out_bh;
 	}
 
 	lock_buffer(data_bh);
@@ -1147,7 +1192,7 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	if (error) {
 		unlock_buffer(data_bh);
 		error = -EIO;
-		goto out_restore;
+		goto out_bh;
 	}
 	memset(data_bh->b_data, 0, inode->i_sb->s_blocksize);
 
@@ -1171,12 +1216,14 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 			error = ext4_mark_inode_dirty(handle, inode);
 	}
 
-out_restore:
 	if (error)
-		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
-
-out:
+		goto out_bh;
+	error = ext4_set_inline_data_block(handle, inode, newblock, ar.len);
+out_bh:
+	if (error)
+		ext4_free_blocks(handle, inode, data_bh, newblock, ar.len, EXT4_FREE_BLOCKS_FORGET);
 	brelse(data_bh);
+out:
 	kfree(buf);
 	return error;
 }
-- 
2.47.3

