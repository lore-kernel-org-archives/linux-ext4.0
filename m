Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17398376469
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 01:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485477; cv=none; b=bl0WUxxENBCj+pDzJ4zB8BkTF5T4CSegbftyrUHtYYK6+n7xpzme/FG2M7k7tFiac6EcZPM5N228ozomIG9Wy/OdjrUJ/yW9JlJJz+2GVm5Pa4xGbOa8hyGItjCeawgQcQHzbQQJzLAq9w18vn9DdmsZWN7NlkTDyIttzXZ/07U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485477; c=relaxed/simple;
	bh=08lFz3xmKbp99AgAd7+lprOKFgfAVbhfEnZnfP0bVwA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=QejmNHD1dtkr6BepOZcpzxOx2tj74cu+6YSPJY0ljFqmdm1z6wShnubStigWOnSMZKjCa7lHGMu4xUUxlqj2hfMag0nUEmjlzT6X8YCAOi2dPiZwyEKH+8g2Zl77i5mnZPQGEvyYDDzfY949bO/+QuLLyo08XPGIV93LuSyWHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=o2DZ0YRu; arc=none smtp.client-ip=203.205.221.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="o2DZ0YRu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788485465; bh=qN2wEWFVQUiB63Jpud75xUR4dU3a8gvxXU7GquNP9tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2DZ0YRuomb1GgWvMe7mMfsqHj6hlQ32Ova1hFhW8zWp5NUlG4ts+LOGeyGh6EXZg
	 WPnWZD9YKg+TWw4GDmQk61AuhpCUJF5Y36kxOPtsO3s09Un53ADSDWM9KHXVl9Ai/6
	 dwr2fcvMYnMEOyEE+vdrn/Gnmkf3tSNELo16FhTU=
Received: from DESKTOP-AT5F202.lan ([183.242.132.32])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 7C192863; Fri, 04 Sep 2026 09:31:01 +0800
X-QQ-mid: xmsmtpt1788485461to3s55cer
Message-ID: <tencent_3656CB4AA45EA01A8DC2B9865242BA18A709@qq.com>
X-QQ-XMAILINFO: MhK4DKsBP06i4HEyxA3P5nEdniiCPNdkzvGxDmbPyWssyXCGVhjGKPZCawsnox
	 haXUJCcuDpf8pgSXTb49aXJw4hZ2QujOcNAu90BrX4T75c6JafvfLROkcfdK3DB/2egdbEE/eQ0m
	 dqsjYqEuU1hokO5OXrGwWkHmO7XrBC2WQnqlmw9mCCzKegEpxyO22PQWOJSGvDf/b6zYpCOH6TGS
	 FwXqyPkef1LYT4tpIZ7jkeAiUISUE++3lid/HyjH7kwYzRP6wS6j6eKCv7ANzctBIrXnHNEhn/yf
	 gAmY70n6t2rICbTIW0nnig6E8+iabpUD108kswxptfD9EUZfZVlm5A1mHSXW8XqkqwgG/LlXf90k
	 2Q+82R72drFqNWrfCVfxwZ+4wt7w2mUlso/C53UFGi7uI3BdBMzXbkHLegcY/MCOIptAHayJEx2Z
	 0K1hD3XqOHOKxgRLLO5kkbvwS6kCIid9MsDXaLOfA0XrAxaOKjECP9XZWZg/SkqEO7t7shC52kBP
	 VSA8uRXb4pV1sQXpTsDSNiSoM3vk2TIjK1A4/WbYKZLDE7m+WIL50adBKYhftsOvqnFSb33hvoA/
	 bGQWnCi/m0IIghEEhVo9rbbV1xc7kYPosirhaRg/i4a2Mj1z/aaVGImv560H/RMkyjUOv+rFT0kP
	 nQ7PE1OdUVeNFBGJGJtsLszP2USqYLuzcgZ0LwdJUk6DIPhJ0EMu2BSVnZu7IG7L2woSzNUuW91U
	 apUNteg8+0tF2aYDwOSCBvLzSlVjjyfBDr6Pnbu10VdGh0AKE0Dl3639520+Wkj+h4DRgW9gtBf/
	 3yMCDrgt2l9nYGC+QbBfzLxg+uX7mLw4IocfT5JQRQw8GxSdJi49l+qEsmX8ty+h0teIy88S+81B
	 HN1qc8xYoVJQNFGTUGLNOj9ZHpGvYVaPmpCJ5DhLKv7VMSKu0PccUwnX5nKqN+a1EQDHrNGiD99t
	 gMz81GNsnQmR5q8k1kegKTVuLwyyH8d6oZP9RyBa8kbUyEX6eq612o9FBJYjky8vVK6ddmTP1pnq
	 N5oSdt/ND15oAdP1usBIkZlFWdLITB2wpweC6x0qwwBa69Msh3mkZ0JszqxZGUuAPpGsGrjVhiF6
	 zh+4a3
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>
Subject: [PATCH v6] ext4: rewrite ext4_convert_inline_data_nolock to make it safer
Date: Fri,  4 Sep 2026 09:30:27 +0800
X-OQ-MSGID: <20260904013026.314998-2-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <tencent_93CC3232AC6A9418BCE4372286770F91850A@qq.com>
References: <tencent_93CC3232AC6A9418BCE4372286770F91850A@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix issues raised by sashiko-bot.
---
v5 -> v6:
> - [High] Zero-initialization of not_found causes out-of-bounds memory
> operations on uninitialized xattr space.
Use -ENODATA as the initial value.
> - [Critical] Silent data loss when ext4_ext_insert_extent() fails
> with errors like -ENOMEM or -EIO.
Revert the inode to inline data if the error is neither EDQUOT nor ENOSPC.
---

Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inline.c | 211 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 158 insertions(+), 53 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..fef98acee688 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -14,6 +14,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include "ext4_extents.h"
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1070,21 +1071,123 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	return 0;
 }
 
-static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
-				     struct ext4_iloc *iloc,
-				     void *buf, int inline_size)
+static int ext4_set_inline_data_block(handle_t *handle, struct inode *inode, ext4_fsblk_t block,
+					unsigned int len, struct buffer_head *bh)
 {
-	int ret;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM,
+		.name = EXT4_XATTR_SYSTEM_DATA,
+		.value = NULL,
+		.value_len = 0,
+	};
+	int error;
+	void *i_block_buf = NULL;
+	void *xattr_buf = NULL;
+	void *header = NULL;
+	void *tail = NULL;
+	int xattr_size;
+	struct ext4_inode *raw_inode;
 
-	ret = ext4_create_inline_data(handle, inode, inline_size);
-	if (ret) {
-		ext4_msg(inode->i_sb, KERN_EMERG,
-			"error restoring inline_data for inode -- potential data loss! (inode %llu, error %d)",
-			inode->i_ino, ret);
-		return;
+	i_block_buf = kmalloc(EXT4_MIN_INLINE_DATA_SIZE, GFP_NOFS);
+	if (!i_block_buf) {
+		error = -ENOMEM;
+		down_write(&ei->i_data_sem);
+		goto error;
 	}
-	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
-	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	down_write(&ei->i_data_sem);
+	error = ext4_get_inode_loc(inode, &is.iloc);
+	if (error)
+		goto error;
+	raw_inode = ext4_raw_inode(&is.iloc);
+	header = IHDR(inode, raw_inode);
+	tail = ITAIL(inode, raw_inode);
+	xattr_size = tail - header;
+	xattr_buf = kmalloc(xattr_size, GFP_NOFS);
+	if (!xattr_buf) {
+		error = -ENOMEM;
+		goto error;
+	}
+	BUFFER_TRACE(is.iloc.bh, "get_write_access");
+	error = ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh, EXT4_JTR_NONE);
+	if (error)
+		goto error;
+	memcpy(i_block_buf, (void *)raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+	memset((void *)raw_inode->i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
+	memset(ei->i_data, 0, EXT4_MIN_INLINE_DATA_SIZE);
+	memcpy(xattr_buf, header, xattr_size);
+	if (ext4_has_feature_extents(inode->i_sb) &&
+		(S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode) || S_ISLNK(inode->i_mode))) {
+		ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+		ext4_ext_tree_init(handle, inode);
+		struct ext4_ext_path *path = ext4_find_extent(inode, 0, NULL, 0);
+
+		if (IS_ERR(path)) {
+			error = PTR_ERR(path);
+			goto recovery;
+		}
+		struct ext4_extent newex;
+
+		newex.ee_block = cpu_to_le32(0);
+		newex.ee_len = cpu_to_le16(1);
+		ext4_ext_store_pblock(&newex, block);
+		path = ext4_ext_insert_extent(handle, inode, path, &newex, 0);
+		if (IS_ERR(path)) {
+			error = PTR_ERR(path);
+			if (error == -EDQUOT || error == -ENOSPC)
+				goto recovery;
+			else
+				goto no_free;
+		} else {
+			ext4_free_ext_path(path);
+		}
+	} else {
+		EXT4_I(inode)->i_data[0] = cpu_to_le32(block);
+	}
+	error = ext4_xattr_ibody_find(inode, &i, &is);
+	if (error)
+		goto recovery;
+	if (!is.s.not_found)
+		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+recovery:
+	if (error) {
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, NULL, block, len, 0);
+		memcpy(header, xattr_buf, xattr_size);
+no_free:
+		ext4_forget(handle, 0, inode, bh, block);
+		memcpy((void *)raw_inode->i_block, i_block_buf, EXT4_MIN_INLINE_DATA_SIZE);
+		memcpy(ei->i_data, raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
+		get_bh(is.iloc.bh);
+		ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+	} else {
+		ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+		if (S_ISDIR(inode->i_mode)) {
+			i_size_write(inode, inode->i_sb->s_blocksize);
+			EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
+		}
+		get_bh(is.iloc.bh);
+		error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+		EXT4_I(inode)->i_inline_off = 0;
+		EXT4_I(inode)->i_inline_size = 0;
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		brelse(bh);
+	}
+	goto out;
+error:
+	ext4_forget(handle, 0, inode, bh, block);
+	ext4_discard_preallocations(inode);
+	ext4_free_blocks(handle, inode, NULL, block, len, 0);
+out:
+	brelse(is.iloc.bh);
+	up_write(&ei->i_data_sem);
+	kfree(i_block_buf);
+	kfree(xattr_buf);
+	return error;
 }
 
 static int ext4_convert_inline_data_nolock(handle_t *handle,
@@ -1093,9 +1196,12 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 {
 	int error;
 	void *buf = NULL;
-	struct buffer_head *data_bh = NULL;
-	struct ext4_map_blocks map;
+	struct buffer_head *bh = NULL;
 	int inline_size;
+	ext4_fsblk_t newblock = 0;
+	struct ext4_allocation_request ar;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned int allocated_block;
 
 	inline_size = ext4_get_inline_size(inode);
 	buf = kmalloc(inline_size, GFP_NOFS);
@@ -1120,63 +1226,62 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
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
-
-	data_bh = sb_getblk(inode->i_sb, map.m_pblk);
-	if (!data_bh) {
+		goto out;
+	allocated_block = EXT4_C2B(sbi, ar.len);
+	bh = sb_getblk(inode->i_sb, newblock);
+	if (!bh) {
 		error = -ENOMEM;
-		goto out_restore;
+		goto out_bh;
 	}
 
-	lock_buffer(data_bh);
-	error = ext4_journal_get_create_access(handle, inode->i_sb, data_bh,
+	lock_buffer(bh);
+	error = ext4_journal_get_create_access(handle, inode->i_sb, bh,
 					       EXT4_JTR_NONE);
 	if (error) {
-		unlock_buffer(data_bh);
+		unlock_buffer(bh);
 		error = -EIO;
-		goto out_restore;
+		goto out_bh;
 	}
-	memset(data_bh->b_data, 0, inode->i_sb->s_blocksize);
+	memset(bh->b_data, 0, inode->i_sb->s_blocksize);
 
 	if (!S_ISDIR(inode->i_mode)) {
-		memcpy(data_bh->b_data, buf, inline_size);
-		set_buffer_uptodate(data_bh);
-		unlock_buffer(data_bh);
+		memcpy(bh->b_data, buf, inline_size);
+		set_buffer_uptodate(bh);
+		unlock_buffer(bh);
 		error = ext4_handle_dirty_metadata(handle,
-						   inode, data_bh);
+						   inode, bh);
 	} else {
-		unlock_buffer(data_bh);
-		inode->i_size = inode->i_sb->s_blocksize;
-		i_size_write(inode, inode->i_sb->s_blocksize);
-		EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-
-		error = ext4_init_dirblock(handle, inode, data_bh,
+		unlock_buffer(bh);
+		error = ext4_init_dirblock(handle, inode, bh,
 			  le32_to_cpu(((struct ext4_dir_entry_2 *)buf)->inode),
 			  buf + EXT4_INLINE_DOTDOT_SIZE,
 			  inline_size - EXT4_INLINE_DOTDOT_SIZE);
-		if (!error)
-			error = ext4_mark_inode_dirty(handle, inode);
 	}
+out_bh:
+	if (error) {
+		if (bh)
+			ext4_forget(handle, 0, inode, bh, newblock);
+		struct ext4_inode_info *ei = EXT4_I(inode);
 
-out_restore:
-	if (error)
-		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
-
+		down_write(&ei->i_data_sem);
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, NULL, newblock, allocated_block, 0);
+		up_write(&ei->i_data_sem);
+	} else {
+		error = ext4_set_inline_data_block(handle, inode,
+				newblock, allocated_block, bh);
+	}
 out:
-	brelse(data_bh);
 	kfree(buf);
 	return error;
 }
-- 
2.55.0

