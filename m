From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 9/10] Fix bugs in multi-block allocation and locality-group
Date: Thu, 21 Jun 2007 10:56:07 +0900
Message-ID: <20070621105607t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39669 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbXFUB4I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 21:56:08 -0400
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l5L1u7Ak024130
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:56:07 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l5L1u7c01595 for linux-ext4@vger.kernel.org; Thu, 21 Jun 2007 10:56:07 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l5L1u6O06789 for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:56:06 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070621.105605.65602104 for <linux-ext4@vger.kernel.org>
	; Thu, 21 Jun 2007 10:56:05 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- Move lg_list to s_locality_dirty in ext4_lg_sync_single_group()
  to flush all of dirty inodes.
- Fix ext4_mb_new_blocks() to return err value when defrag failed.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr linux-2.6.19-rc6-test3/fs/ext4/lg.c Online-Defrag_linux-2.6.19-rc6-git/fs/ext4/lg.c
--- linux-2.6.19-rc6-test3/fs/ext4/lg.c	2007-06-20 16:56:16.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git/fs/ext4/lg.c	2007-06-18 14:21:54.000000000 +0900
@@ -389,6 +389,10 @@ int ext4_lg_sync_single_group(struct sup
 		cond_resched();
 		spin_lock(&inode_lock);
 		if (wbc->nr_to_write <= 0) {
+			if (!list_empty(&lg->lg_io)) {
+				set_bit(EXT4_LG_DIRTY, &lg->lg_flags);
+				list_move(&lg->lg_list, &sbi->s_locality_dirty);
+			}
 			rc = EXT4_STOP_WRITEBACK;
 			code = 6;
 			break;
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr linux-2.6.19-rc6-test3/fs/ext4/mballoc.c Online-Defrag_linux-2.6.19-rc6-git/fs/ext4/mballoc.c
--- linux-2.6.19-rc6-test3/fs/ext4/mballoc.c	2007-06-20 16:58:22.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git/fs/ext4/mballoc.c	2007-06-18 14:21:54.000000000 +0900
@@ -3732,8 +3732,10 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 		!(EXT4_I(ar->inode)->i_state & EXT4_STATE_BLOCKS_RESERVED)) {
 		reserved = ar->len;
 		err = ext4_reserve_blocks(sb, reserved);
-		if (err)
+		if (err) {
+			*errp = err;
 			return err;
+		}
 	}
 
 	if (!ext4_mb_use_preallocated(&ac)) {
