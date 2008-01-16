From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Wed, 16 Jan 2008 20:11:57 +0100
Message-ID: <1200510717.4561.11.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51106 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYAPQau (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2008 11:30:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A simple dd oopses the kernel (2.6.24-rc7 with the latest patch queue):
  dd if=/dev/zero of=/mnt/test/foo bs=1M count=8096

EXT4-fs: mballoc enabled
------------[ cut here ]------------
kernel BUG at fs/ext4/mballoc.c:3148!

The BUG_ON is:
	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));

where the value of "size" is 4293920768.

This is due to the overflow of the variable "start" in the 
ext4_mb_normalize_request() function.
The patch below fixes it.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 mballoc.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


Index: linux-2.6.24-rc7/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-rc7.orig/fs/ext4/mballoc.c	2008-01-16 19:22:45.000000000 +0100
+++ linux-2.6.24-rc7/fs/ext4/mballoc.c	2008-01-16 19:25:04.000000000 +0100
@@ -2990,6 +2990,7 @@ static void ext4_mb_normalize_request(st
 	struct list_head *cur;
 	loff_t size, orig_size;
 	ext4_lblk_t start, orig_start;
+	ext4_fsblk_t pstart;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 
 	/* do normalize only data requests, metadata requests
@@ -3029,7 +3030,7 @@ static void ext4_mb_normalize_request(st
 
 	/* first, try to predict filesize */
 	/* XXX: should this table be tunable? */
-	start = 0;
+	pstart = 0;
 	if (size <= 16 * 1024) {
 		size = 16 * 1024;
 	} else if (size <= 32 * 1024) {
@@ -3045,25 +3046,25 @@ static void ext4_mb_normalize_request(st
 	} else if (size <= 1024 * 1024) {
 		size = 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical << bsbits;
-		start = (start / (1024 * 1024)) * (1024 * 1024);
+		pstart = ac->ac_o_ex.fe_logical << bsbits;
+		pstart = (pstart / (1024 * 1024)) * (1024 * 1024);
 		size = 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical << bsbits;
-		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
+		pstart = ac->ac_o_ex.fe_logical << bsbits;
+		pstart = (pstart / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
 		size = 4 * 1024 * 1024;
 	} else if(NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,(8<<20)>>bsbits,max,bsbits)){
-		start = ac->ac_o_ex.fe_logical;
-		start = start << bsbits;
-		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
+		pstart = ac->ac_o_ex.fe_logical;
+		pstart = pstart << bsbits;
+		pstart = (pstart / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
 		size = 8 * 1024 * 1024;
 	} else {
-		start = ac->ac_o_ex.fe_logical;
-		start = start << bsbits;
+		pstart = ac->ac_o_ex.fe_logical;
+		pstart = pstart << bsbits;
 		size = ac->ac_o_ex.fe_len << bsbits;
 	}
 	orig_size = size = size >> bsbits;
-	orig_start = start = start >> bsbits;
+	orig_start = start = pstart >> bsbits;
 
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
