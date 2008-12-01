From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH]ext4: fix s_dirty_blocks_counter if block allocation failed
 with nodelalloc
Date: Mon, 01 Dec 2008 19:21:54 +0900
Message-ID: <4933BAC2.6080004@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62970 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYLAKWX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 05:22:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If block allocation failed after marking claimed blocks as dirty blocks
with nodelalloc, we have to subtract these blocks from
s_dirty_blocks_counter in error handling.
Otherwise s_dirty_blocks_counter goes wrong so that
filesystem's free blocks decreases incorrectly.

This issue was reported as ext4 online defrag's bug by Li Zefan.
http://marc.info/?l=linux-ext4&m=122697235715170&w=2

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 mballoc.c |    9 +++++++++
 1 file changed, 9 insertions(+)
diff -X linux-2.6.28-rc6-ext4/Documentation/dontdiff -upNr linux-2.6.28-rc6-ext4/fs/ext4/mballoc.c linux-2.6.28-rc6-mballoc-fix/fs/ext4/mballoc.c
--- linux-2.6.28-rc6-ext4/fs/ext4/mballoc.c	2008-12-01 11:44:28.000000000 +0900
+++ linux-2.6.28-rc6-mballoc-fix/fs/ext4/mballoc.c	2008-12-01 12:04:06.000000000 +0900
@@ -4495,12 +4495,18 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	if (!ac) {
 		ar->len = 0;
 		*errp = -ENOMEM;
+		if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
+			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						reserv_blks);
 		goto out1;
 	}

 	*errp = ext4_mb_initialize_context(ac, ar);
 	if (*errp) {
 		ar->len = 0;
+		if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
+			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						reserv_blks);
 		goto out2;
 	}

@@ -4541,6 +4547,9 @@ repeat:
 		if (freed)
 			goto repeat;
 		*errp = -ENOSPC;
+		if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
+			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						reserv_blks);
 		ac->ac_b_ex.fe_len = 0;
 		ar->len = 0;
 		ext4_mb_show_ac(ac);

