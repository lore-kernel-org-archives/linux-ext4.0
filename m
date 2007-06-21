From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 8/10] Release reserved block
Date: Thu, 21 Jun 2007 10:55:38 +0900
Message-ID: <20070621105538t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64528 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbXFUBzj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 21:55:39 -0400
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l5L1tcDU019970
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:55:38 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l5L1tcD27787 for linux-ext4@vger.kernel.org; Thu, 21 Jun 2007 10:55:38 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l5L1tcB17856 for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:55:38 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070621.105537.25001704 for <linux-ext4@vger.kernel.org>
	; Thu, 21 Jun 2007 10:55:37 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- Release reserved blocks if defrag failed.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr Online-Defrag_linux-2.6.19-rc6-git-BLOCK_RELEASE/fs/ext4/extents.c Online-Defrag_linux-2.6.19-rc6-git-lg-mballoc-bugfix/fs/ext4/extents.c
--- Online-Defrag_linux-2.6.19-rc6-git-BLOCK_RELEASE/fs/ext4/extents.c	2007-06-19 20:19:14.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-lg-mballoc-bugfix/fs/ext4/extents.c	2007-06-18 14:23:07.000000000 +0900
@@ -3066,6 +3066,10 @@ int ext4_ext_ioctl(struct inode *inode, 
 
 		err = ext4_ext_defrag_victim(filp, &ext_info);
 
+	} else if (cmd == EXT4_IOC_BLOCK_RELEASE) {
+		mutex_lock(&EXT4_I(inode)->truncate_mutex);
+		ext4_discard_reservation(inode);
+		mutex_unlock(&EXT4_I(inode)->truncate_mutex);
 	} else if (cmd == EXT4_IOC_DEFRAG) {
 		struct ext4_ext_defrag_data defrag;
 
