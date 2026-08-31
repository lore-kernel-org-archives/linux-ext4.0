Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1E37646C
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 02:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788142923; cv=none; b=hHhqXeDhHeyEFTpLF3rlfylK8kXIQA47XbWqH053k/dlj2Cq11i+ZCmlp043hxSxYllgnFoD+tiaUfOTBVG1ItB/sSQO1jLzNbe0ZljpBECKFcHb8aXRyC61Gc8k3GL+lKiSFkALt/bAmfefxCm0IT+2XKe3O5S8WCOcuzh2pJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788142923; c=relaxed/simple;
	bh=3UkthinFoIKkyTyVZf+HWVqG7rQjd3qr6CBJgtsjlb8=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=E1o1gRfJqxI4+0LqcDzd+9sMj+4xwjv+mJxeKVopr2vEf5ySCC5llbRMolURblAnUCAfXv96QUPooqy0QWI2sbsCp71FfewfNPcmPenyUwm/WQbScHY4kU+VCn4qH255Wmye1DDdtaRJplG5vB3sdNubtPLCBronAU7WgALYbH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=RMPbG0cc; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="RMPbG0cc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788142899; bh=v6ryD8KK3MPgLmA01RsxwOgmHp5OnRRePW8oghBa0fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMPbG0cco8tajIGJEwoMqpqQLgSE5ZZkEClnCZ66/POCcQloqkcZ13kXGfgNVlEnW
	 hhmPe3f2L97xizd7DzDy83Wjg/8MFFi2VE+/Ie6zVq1iXxUExXcr60qhg69MfgI3+W
	 qG4rpVhKu97aQep44lu/xr6656/kYAOgDUWneRkU=
Received: from DESKTOP-AT5F202.lan ([183.242.244.64])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 5630B853; Mon, 31 Aug 2026 10:21:35 +0800
X-QQ-mid: xmsmtpt1788142895tpv3grz76
Message-ID: <tencent_54332AAC969648BF78341E85930FE984D80A@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuOyBc+k5x4jdG8nu/MjREhLtlMbpbp+/OKALP1naNMysdPf7EH5
	 IQUhagXB3M7knjPVR7HXF3wlg9e1lAbeh35rhXrssN8gpt+8Jv804PQ7k/34e4dL1YBkTPLOrBzV
	 I/00vEbKNk63ZmJI/m33eior7WdVyo/kT0aXWpzm0DtQ5T/lirXh4R/qGJXt4ScsjPdUrHFJgF03
	 s2vQ116xPaRqsQm8dzBoAqjQ7m5N/rC1zOhCiuxg6tp1AcGlo/jWn7zUQHi9DUcZZcrVX5DJgdZH
	 w3GC8OiLRBkmnQ0d5A/wp1U8+EGmKZCVt4AAZxYcuHt7Jtn/0k5Sj0Xtx2HheXD8fR5GgobDNl1S
	 YLpSRMYTZDZjoWNXyhY3uDzZRlRlj+2/dGTO2eOd73YIuqZV/+ZPrnpKux55O5x3dbp4npz0mNtL
	 9uMvjd0P7+onXdo0NHfAijqJwwdts+c5OAtM+22cwkOjZfWwIMvzEEdSTkWBbaSQgjfa11IDi45o
	 vRa9oDA+pQxH8lEFB+9FzTH1N/hvmfuyvFc+mIFEukD5dTG9YU9EwJejdbJaud/v4ikZADwiji2R
	 NB6JCtpTOni+MkIL5VgWvUhVUeppX7s8MaoZXQnXe4pDF0XU/DgRdRohCa/z4JscMwcf4q3zKeSZ
	 gAvF8RjcTDXzCOZm59TdMq1zC1n5ZZCruCPzP96fPgFWP7zEDoGsd0PHXq8utAZLSVFOzISIolhV
	 UBO/ZsmUd4xIqr38HoXSdlKWPwL3JqfEdzUBYgBa6pym7/MUWGeK44XCNcRDGOnEKwTaATE8VtIz
	 FhiMhsnl2d94qleoIw4DZaMrVu3CiBObBgey3KmZtD1qpz2CO9UZ22E03YWH9DwBO8U+pLCL+PB8
	 rcjYQhA3NjfQ6dlU6bzmh5XwPiMtY0j7wgeH/Q9nXHUxxmt3TCTVJQIfCYAT4oAbY3Hn2LsMYS2y
	 Y4El8PC3nLfP6hMaATJcMTCUJlenYF8Ln4jz3ghr/sMAiLxJTJ4ejEZy5wGc5dXTJgv+myx85doG
	 qhc79EXz8rxn4FlCkLxPF3X+MjRnwUDVJ2va5deQlyifpHRnCBG9rdAJaZPIRlhOeoAGo9BLUAZb
	 pzA3y9
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>
Subject: [PATCH v4] ext4: rewrite ext4_convert_inline_data_nolock to make it safer
Date: Mon, 31 Aug 2026 10:20:37 +0800
X-OQ-MSGID: <20260831022036.1266-2-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <tencent_DBADB12BBC6D88300488F16E75A384FAE505@qq.com>
References: <tencent_DBADB12BBC6D88300488F16E75A384FAE505@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix issues raised by sashiko-bot.
---
v3 -> v4:
> - [Critical] Misordered metadata update causes corrupt directory `i_size` on disk.
Fix the wrong order of data updates.
> - [Critical] Unconditional BUG_ON() crash in `ext4_free_blocks()` on error paths for allocations > 1 block.
Call ext4_forget separately.
> - [High] Permanent block leak when `ext4_ext_insert_extent` fails with an error other than EDQUOT or ENOSPC.
when `ext4_ext_insert_extent` fails with an error other than EDQUOT or
ENOSPC,Let's continue with the normal process.
> - [High] Concurrent inode metadata changes are overwritten during error recovery.
Back up i_block and xattr separately.
> - [Medium] The commit message describes a completely different change.
Update the subject line.
---
v3: https://lore.kernel.org/linux-ext4/aoJ4bJZNgNAt4pLD@mit.edu/T/#t

Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inline.c | 213 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 160 insertions(+), 53 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..939c6bf20b5b 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -14,6 +14,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include "ext4_extents.h"
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1070,21 +1071,125 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
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
+		.s = { .not_found = 0, },
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
+	if (error) {
+		ext4_forget(handle, 0, inode, bh, block);
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, NULL, block, len, 0);
+		goto out;
+	}
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
+		ext4_forget(handle, 0, inode, bh, block);
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, NULL, block, len, 0);
+		memcpy((void *)raw_inode->i_block, i_block_buf, EXT4_MIN_INLINE_DATA_SIZE);
+		memcpy(ei->i_data, raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+		memcpy(header, xattr_buf, xattr_size);
+		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
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
+out:
+	brelse(is.iloc.bh);
+	up_write(&ei->i_data_sem);
+	kfree(i_block_buf);
+	kfree(xattr_buf);
+	return error;
+error:
+	ext4_forget(handle, 0, inode, bh, block);
+	ext4_discard_preallocations(inode);
+	ext4_free_blocks(handle, inode, NULL, block, len, 0);
+	up_write(&ei->i_data_sem);
+	kfree(i_block_buf);
+	kfree(xattr_buf);
+	return error;
 }
 
 static int ext4_convert_inline_data_nolock(handle_t *handle,
@@ -1093,9 +1198,12 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
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
@@ -1120,63 +1228,62 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
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

