Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9511A7264
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 10:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788343892; cv=none; b=i7mlz/og9lQ99kLJuvmd64tqEXRixZzDGQHMFOn6oktbwf016wu7DCZwIVZZXl3deXI2UYHrkx+oIryZnE6lrH7eF+e/WW7cHPwnQTU8bt3emN5hMAPaPqgwL8/8iCuC1ioJJC0pjjB1w4fICwVoV+gzBJZh7/NWbeELaJ4aIEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788343892; c=relaxed/simple;
	bh=VUyHmJ0SKY5NKLJnuTS8fESvsZh/bJ1Dsqqp2WokQeM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=pDrGEe/7QSK6dKayGuPoUEUWN+NtClEyuAPAOKhOSj1u7T/Tb4+/loFsT80Iecu+hI8DmiQFeS5rvmPPoTc28NtaVGLU09osyqNkCdmq2w0+V30a+sJIOQM+1OkY2BPWDBsRC5JBzfGIDVnptQO5k040k4DW6t38YYNINQPXrrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=HTAmFnH9; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="HTAmFnH9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788343878; bh=Lqv3PdpD0XglpSRpMQOgUvmmlb9PBEuQlPDh9QbDbXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTAmFnH9oxtGh80y0csXNgGOZKR23oBu+m1acL7tSejvhwcwyIJhT2ckUFI53u7AS
	 JeNvUaR4x/FdtIeHjE0XYOexdqcgavmYGEuzHVLA2fq21s7gSnKziRn5UIvP4dfKD2
	 M4BTrHzcg+gSIh6d2dI5Sva1V8qMICB35WNzHzhc=
Received: from DESKTOP-AT5F202.lan ([183.242.244.64])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 2CE2E00E; Wed, 02 Sep 2026 18:11:14 +0800
X-QQ-mid: xmsmtpt1788343874t4ls1u0ex
Message-ID: <tencent_FBF9C69AF090A1BF9003C68555A8928D1707@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJwG5cQcedzeaePf361VkaY4IHF8/xjVk1XhDiNzCS1+GP038Lc1
	 OVGQkyr77w7OOYB6WfM5LenRn/3ybvSLsIhyvXndseRwYN6xu+jKJlkcHzgvzGzv7jZsWBr0FSjx
	 9fkiGJea1Z0nkFtA0v4+vVvdOouvfH5sArD63libRd0yC4yNl7ouXB2BvfDxxYKwagX0QuwOh9Lj
	 5hXnC44gCdPhQDLbs9oAcM2+hBKGGS1hW0pCVUmnse3WDF5ICPcWiKP222q7b7nh0/61AAWZaWYK
	 nc6luP7bajwm0ln0izc8zZsEhYmzkPA0HZ7NeC1VAom7mnh1sF7f3H8rzJJfOSoDzmzPSDc8FTLs
	 4nugfeClUg0NBjRqEI8Hb9Qhp/KyI8KJtQurColF5htH79fFtgxRolvCVgqQN4HZTYxZQ4qmhT86
	 f/WK+DFdtxHJnECMXxVh0fPxJMwLcJBxo7k2KF7v5pdzD+MdKDVaDAuoPamcErZqHsJywATeQufg
	 V2Bs1tkaWx9izu0SyHgIqtw5xTIU7qsHuZlHrzMzX1JDK4SqHVJDoC43SWCn9Okc75gUBPMJVqe6
	 DqhEavpKfYtJqehXjgCdCOI89SD6FjC0wQPn1Y4mR6JgJNAe4bUlA5mlyA5rTyUm1b4iWrMVfbm3
	 guVMxNyLtgpdnIDdEw7AIbU1A3/H4BW6iA8p51gMyU+UK0K0RIgOK749OfPqa9QprGFe+WGK9wVm
	 owO7kvwuw2PK/GjwwUu8+BQ8qktQeIQchAkq9N6s1LziOTzD+Om1DuruN0x8krteI9/h2tzW+Tu9
	 L0J2q3JIFM8101vgRb/hb70YWfT514uwWNbhrTtlGQ12IVRQCB/TDsG0+U8IN/W7Lhka+xvCvUI7
	 C/X4uSmuyYV0XmZGy+AsqdbNqekjtf0J0pnMG01psOvL2Gx+Y4BcH3HTD1RatouswOsgWf3KJnRP
	 VtzzjIeF6EB6LeEtW8qopnOPF08dNOxtWc2gAixmVFG79y2WdaQTxQ0guPtTq6VvkPMW2jYIdHF2
	 EbFhHSmaKu5FwHdLrTGUqYjpFhxuOTZ6AIV08Brfrel8mIiRkXMcsNI754I/XJuspZ7R9oamHd9D
	 6uN3TdkVmh2B7tJr8=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>
Subject: [PATCH v5] ext4: rewrite ext4_convert_inline_data_nolock to make it safer
Date: Wed,  2 Sep 2026 18:10:06 +0800
X-OQ-MSGID: <20260902101005.183699-2-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <tencent_8756434A305EF41A89C387860E424A199709@qq.com>
References: <tencent_8756434A305EF41A89C387860E424A199709@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix issues raised by sashiko-bot.
---
v4 -> v5:
> - [High] Buffer head reference leak on the xattr_buf allocation error path.
Adjust error label placement.
> - [Critical] Incomplete error rollback leaves the on-disk inode corrupted
> with EXT4_INODE_EXTENTS flag set but inline data present in i_block.
Call ext4_mark_iloc_dirty() to mark the inode dirty.
---
While running tests with kvm-xfstests -c ext4/inline -g auto after
building with kvm-xfstests install-kconfig --lockdep,
I noticed the following RCU stall warning during test generic/579:
[14978.768399] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[14978.768626] rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P35/1:b..l
[14978.769616] rcu: 	(detected by 0, t=7802 jiffies, g=5566345, q=27344 ncpus=2)
[14978.769867] task:khugepaged      state:R  running task     stack:0     pid:35    tgid:35    ppid:2      task_flags:0x200040 flags:0x00080000
[14978.770723] Call Trace:
[14978.770898]  <TASK>
[14978.771103]  __schedule+0x3ad/0x9d0
[14978.771545]  preempt_schedule_irq+0x34/0x60
[14978.771622]  irqentry_exit+0x1ad/0x740
[14978.771692]  ? trace_hardirqs_off_finish+0xa5/0xc0
[14978.771769]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[14978.771923] RIP: 0010:copy_mc_enhanced_fast_string+0x8/0xf
[14978.772071] Code: e9 bd fe ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 f3 a4 <31> c0 c3 cc
cc cc cc 48 89 c8 c3 cc cc cc cc 66 0f 1f 84 00 00 00
[14978.772302] RSP: 0018:ffa000000012fb50 EFLAGS: 00010286
[14978.772392] RAX: ff1100000e5c7000 RBX: ff11000013dc5000 RCX: 0000000000000000
[14978.772557] RDX: 0000000000001000 RSI: ff11000039dc8000 RDI: ff1100000e5c8000
[14978.772653] RBP: ffd4000000390000 R08: ff11000009b2cc00 R09: 000056287b200000
[14978.772737] R10: ffffffff816136da R11: 0000000000000001 R12: 0000000000000200
[14978.772819] R13: 000000ffffffffff R14: 00000000000001c7 R15: 0000000000001000
[14978.772921]  ? __pte_offset_map+0x2a/0x170
[14978.772997]  __collapse_huge_page_copy+0xa1/0x230
[14978.773073]  collapse_huge_page+0x7e9/0x890
[14978.773146]  mthp_collapse+0x1ef/0x310
[14978.773222]  collapse_scan_pmd+0x698/0x860
[14978.773315]  collapse_single_pmd+0x16d/0x250
[14978.773385]  collapse_scan_mm_slot.constprop.0+0x320/0x4b0
[14978.773462]  khugepaged+0x203/0x210
[14978.773524]  ? __pfx_autoremove_wake_function+0x10/0x10
[14978.773608]  ? __pfx_khugepaged+0x10/0x10
[14978.773674]  kthread+0xf4/0x130
[14978.773737]  ? __pfx_kthread+0x10/0x10
[14978.773805]  ret_from_fork+0x1ff/0x2a0
[14978.773873]  ? __pfx_kthread+0x10/0x10
[14978.773936]  ret_from_fork_asm+0x1a/0x30
[14978.774189]  </TASK>
The test continued to run after the warning and completed without
reporting a failure for this case.
Is this considered noise, or does it indicate a real issue
that needs further investigation?

Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inline.c | 208 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 155 insertions(+), 53 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..2ac41423f0a7 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -14,6 +14,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include "ext4_extents.h"
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1070,21 +1071,120 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
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
@@ -1093,9 +1193,12 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
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
@@ -1120,63 +1223,62 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
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

