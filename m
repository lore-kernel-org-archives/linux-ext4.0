From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: [RFC][PATCH 4/4] ext4_locality_group bug fix
Date: Thu, 26 Apr 2007 21:14:11 +0900
Message-ID: <20070426211412sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51295 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031193AbXDZMOM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Apr 2007 08:14:12 -0400
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3QCEBFm013702
	for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2007 21:14:11 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3QCEBE06996 for linux-ext4@vger.kernel.org; Thu, 26 Apr 2007 21:14:11 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l3QCEA221297 for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2007 21:14:11 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070426.211410.39102564 for <linux-ext4@vger.kernel.org>
	; Thu, 26 Apr 2007 21:14:10 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Move lg_list to s_locality_dirty and mark lg as dirty
if nr_to_write(total page count which has not written in disk yet)
is 0 or less and lg_io is not empty in ext4_lg_sync_single_group(). 
This makes sure that inode is written to disk.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
---
diff -Nrup -X linux-2.6.19-rc6-lg/Documentation/dontdiff linux-2.6.19-rc6-lg/fs/ext4/lg.c linux-2.6.19-rc6-full/fs/ext4/lg.c
--- linux-2.6.19-rc6-lg/fs/ext4/lg.c	2007-04-26 19:55:37.000000000 +0900
+++ linux-2.6.19-rc6-full/fs/ext4/lg.c	2007-04-26 19:17:59.000000000 +0900
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
