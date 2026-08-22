Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1DF3ABDA4
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2026 16:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787415994; cv=none; b=s7QR48oADLdGsB3qqjHcNS1Cid7u+NkMnee8ZL2ke+SH7NInC8lLpZhBlnhOK5azoNao0HKXpr2zm37IyVTuyqw19DhOrTuePTpGzaxIjQaxt6tg8V8vfmOjiHTG+hOi/zAemGL09F/us/xx8FDmNWAmlUIqtW6dZEKUPGh1OS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787415994; c=relaxed/simple;
	bh=mBjTRf+F1/kezZHN4LL2i+IOUQBbNoXTJXVPvYLqFjA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=a6YMcqUM01rErczuRo7G5IUPGdhT+zpC4LXBW3GSLARjkYWXgRrB/G9qSpX7v/dppuZZoE7oh4ObqutUKv/slzKlYFlvqkEdK19sZ/B9x4tTAb2fXi8k6X396ZTDBUviZc0nnpjkLPyo5rI8LTTKsMZV8XypCmAe+yD4RUHN/KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=nD97Ngv0; arc=none smtp.client-ip=203.205.221.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="nD97Ngv0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787415988; bh=v8Ip1fk2d0+kfrrxP+fQqCzDoAFGtXeny4TOSAcUZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nD97Ngv0B4i39ZSF4pxdh9Gkq1S13c3tfv3IYTvGw7/3dVYso1cw+QUi5Zg3GZWLy
	 +9BpPTUGyS7CFIR+L+uO4c2lWMgYaLONbAjJNINjYSPuZwuSCnz+HcI2EaJzwwLCdL
	 iGnqzpM6t4eaRzASA+NZpK7Jmv++HJpWNHFwQotY=
Received: from DESKTOP-AT5F202.lan ([183.242.132.32])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 69829EC3; Sun, 23 Aug 2026 00:26:24 +0800
X-QQ-mid: xmsmtpt1787415984t0fyrcu0m
Message-ID: <tencent_7FDF0CFD84843032AE9A95DCBD443746860A@qq.com>
X-QQ-XMAILINFO: NHgT31LhP5vDMzPRKEOrB/1rQ0TWNh8443n4rcxrSV4G/2mx7kgF5vAqaCzZAL
	 KN91FQjqftFaIVKQhRsG+6KL+DHJSBPJjziw/rjAoieIfnSntVpCxQhit5uoPoAKC2E5CSjb4yXb
	 2RTqiG2HQTpsNIV3rVRfQN+/xAjC6EvjdQW6DDBEuVpQv1wmTLkfn6eQMY9ZxOjIsi4yzeymsnGb
	 qHhv7SiQg5Y41bTnWEIKdEu2Ke6dKyEw+hcbyHsBEbFJf1tHfux3H8mxCKbrP6WZEi/Zyhrtf70E
	 f+Zai9Mr/GY0x4Kee59JDJEq0bXPPM2UUBG3JGxmrrk9nCRFkWAG5wlV33ylbtnX/Rw2WBDzmx56
	 zSYXhUn+jTjlkafO5MxFFDHJVoGIvt5iJ/QhuIGoodgT8y3WoXVVlmmzg4tt+8h8Pf5jvBwC3w3o
	 +NzAfX5jOe1u1Onm2yYsLTl+3XuzM5YVS5No4GPa2QL2qgCghD+9vK3tOBqXhG7lZy7cXmM5mNTs
	 cNJNsqBArx4HHc6GEHnCRRSWhgDhab9NcYfHMpt5Ld5lgSrORlm0k+GsZPp4AMt/W972/3ieBRyg
	 OgvG7PPP/UdoGOL66jTEVmkpeSlrbfI8PSzuz65mTAXzm7usf2JQw0Cj4HkY0B1t8QpsguCN24x2
	 bLggwoa+lDkAsmrADAQQ40+KbvgPLZ2jqFeAML7DxQkfgNP7wmHjXlc7hilR3alAYfTkIvyd9CCE
	 IZx9Xn/gziRGkNdR/Qvxs7x7sVa2WTgC4GA97ctHYkMltODKVsNyA16ey6LBnNLO3FbptNV8l6fa
	 F0OPd0Lw7IfZEsHoNyKt4sLIGMw7aWTWbkaq6JfWWYndf4vti2M4LivxQJYTQvWev/SJQHFgWNfD
	 J/p4iys/UvaiIfs1ue3Fxou66EAx7MXebcKRoXHko2euZ6osyyESowf5HQjyL8koZB50oiY6Wszi
	 wZ3JPB1vAn7jPkx+MvYk/S2gxCDBneWtWB3DDTOolhx349kYvdBIeHKKbmmHyIDwJkvH59QEEpaz
	 nkm7nSD+T9FytQqWhIP/UHg1F+Q5h37j4vfAP+2jf9bpAGxR3o7kMdQuOAuMew2uRPukLYNTlMmP
	 ApNorcdgtkpXqS19I=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	pipishuo <1289151713@qq.com>
Subject: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Date: Sun, 23 Aug 2026 00:26:06 +0800
X-OQ-MSGID: <20260822162606.140588-1-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aoJ4bJZNgNAt4pLD@mit.edu>
References: <aoJ4bJZNgNAt4pLD@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: pipishuo <1289151713@qq.com>

---
v2 -> v3:
-Add error recovery for ext4_find_extent() and ext4_ext_insert_extent()
-Add additional error handling code
---

Signed-off-by: pipishuo <1289151713@qq.com>
---
 fs/ext4/inline.c | 179 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 139 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..507106c72e82 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -14,6 +14,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include "ext4_extents.h"
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1070,21 +1071,115 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
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
+	int inode_size;
+	void *inode_buf = NULL;
+	struct ext4_inode *raw_inode;
 
-	ret = ext4_create_inline_data(handle, inode, inline_size);
-	if (ret) {
-		ext4_msg(inode->i_sb, KERN_EMERG,
-			"error restoring inline_data for inode -- potential data loss! (inode %llu, error %d)",
-			inode->i_ino, ret);
-		return;
+	inode_size = EXT4_INODE_SIZE(inode->i_sb);
+	inode_buf = kmalloc(inode_size, GFP_NOFS);
+	if (!inode_buf) {
+		error = -ENOMEM;
+		down_write(&ei->i_data_sem);
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, bh, block, len, EXT4_FREE_BLOCKS_FORGET);
+		up_write(&ei->i_data_sem);
+		return error;
 	}
-	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
-	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	down_write(&ei->i_data_sem);
+	error = ext4_get_inode_loc(inode, &is.iloc);
+	if (error) {
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, bh, block, len, EXT4_FREE_BLOCKS_FORGET);
+		up_write(&ei->i_data_sem);
+		kfree(inode_buf);
+		return error;
+	}
+	raw_inode = ext4_raw_inode(&is.iloc);
+	BUFFER_TRACE(is.iloc.bh, "get_write_access");
+	error = ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh, EXT4_JTR_NONE);
+	if (error) {
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, bh, block, len, EXT4_FREE_BLOCKS_FORGET);
+		goto out;
+	}
+	memcpy(inode_buf, (void *)raw_inode, inode_size);
+	memset((void *)raw_inode->i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
+	memset(ei->i_data, 0, EXT4_MIN_INLINE_DATA_SIZE);
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
+			if (error == -EDQUOT || error == -ENOSPC) {
+				goto recovery;
+			} else {
+				ext4_forget(handle, 0, inode, bh, block);
+				goto nofree;
+			}
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
+		ext4_free_blocks(handle, inode, bh, block, len, EXT4_FREE_BLOCKS_FORGET);
+nofree:
+		memcpy((void *)raw_inode, inode_buf, inode_size);
+		memcpy(ei->i_data, raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
+	} else {
+		ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+		get_bh(is.iloc.bh);
+		error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+		EXT4_I(inode)->i_inline_off = 0;
+		EXT4_I(inode)->i_inline_size = 0;
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		if (S_ISDIR(inode->i_mode)) {
+			i_size_write(inode, inode->i_sb->s_blocksize);
+			EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
+		}
+		brelse(bh);
+	}
+out:
+	brelse(is.iloc.bh);
+	up_write(&ei->i_data_sem);
+	kfree(inode_buf);
+	return error;
 }
 
 static int ext4_convert_inline_data_nolock(handle_t *handle,
@@ -1094,8 +1189,11 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	int error;
 	void *buf = NULL;
 	struct buffer_head *data_bh = NULL;
-	struct ext4_map_blocks map;
 	int inline_size;
+	ext4_fsblk_t newblock = 0;
+	struct ext4_allocation_request ar;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned int allocated_block;
 
 	inline_size = ext4_get_inline_size(inode);
 	buf = kmalloc(inline_size, GFP_NOFS);
@@ -1120,25 +1218,22 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
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
+		goto out;
+	allocated_block = EXT4_C2B(sbi, ar.len);
+	data_bh = sb_getblk(inode->i_sb, newblock);
 	if (!data_bh) {
 		error = -ENOMEM;
-		goto out_restore;
+		goto out_bh;
 	}
 
 	lock_buffer(data_bh);
@@ -1147,7 +1242,7 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	if (error) {
 		unlock_buffer(data_bh);
 		error = -EIO;
-		goto out_restore;
+		goto out_bh;
 	}
 	memset(data_bh->b_data, 0, inode->i_sb->s_blocksize);
 
@@ -1159,24 +1254,28 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 						   inode, data_bh);
 	} else {
 		unlock_buffer(data_bh);
-		inode->i_size = inode->i_sb->s_blocksize;
-		i_size_write(inode, inode->i_sb->s_blocksize);
-		EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-
 		error = ext4_init_dirblock(handle, inode, data_bh,
 			  le32_to_cpu(((struct ext4_dir_entry_2 *)buf)->inode),
 			  buf + EXT4_INLINE_DOTDOT_SIZE,
 			  inline_size - EXT4_INLINE_DOTDOT_SIZE);
-		if (!error)
-			error = ext4_mark_inode_dirty(handle, inode);
 	}
+out_bh:
+	if (error) {
+		int flags = 0;
 
-out_restore:
-	if (error)
-		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
+		if (data_bh)
+			flags |= EXT4_FREE_BLOCKS_FORGET;
+		struct ext4_inode_info *ei = EXT4_I(inode);
 
+		down_write(&ei->i_data_sem);
+		ext4_discard_preallocations(inode);
+		ext4_free_blocks(handle, inode, data_bh, newblock, allocated_block, flags);
+		up_write(&ei->i_data_sem);
+	} else {
+		error = ext4_set_inline_data_block(handle, inode,
+				newblock, allocated_block, data_bh);
+	}
 out:
-	brelse(data_bh);
 	kfree(buf);
 	return error;
 }
-- 
2.47.3

