From: Alex Tomas <alex@clusterfs.com>
Subject: [PATCH] free blocks in case of error
Date: Sat, 17 Feb 2007 00:55:16 +0300
Message-ID: <m3zm7dvk7e.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.245.246] ([80.71.245.246]:58506 "EHLO nsold.rialcom.ru"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946242AbXBPW14 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 17:27:56 -0500
Received: from nsold.rialcom.ru (localhost.rialcom.ru [127.0.0.1])
	by nsold.rialcom.ru (Postfix) with ESMTP id C4106BC8B6
	for <linux-ext4@vger.kernel.org>; Sat, 17 Feb 2007 00:58:08 +0300 (MSK)
Received: from gw.home.net (unknown [80.71.248.82])
	by nsold.rialcom.ru (Postfix) with ESMTP id 66BB5BC881
	for <linux-ext4@vger.kernel.org>; Sat, 17 Feb 2007 00:58:08 +0300 (MSK)
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.13.7/8.13.4) with ESMTP id l1GMu1cN022564
	for <linux-ext4@vger.kernel.org>; Sat, 17 Feb 2007 01:56:01 +0300
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Good day,

when ext4_ext_insert_extent() fails to insert new blocks
we should free just allocated blocks. please, consider
for review.

thanks, Alex


Signed-off-by: Alex Tomas <alex@clusterfs.com>

Index: linux-2.6.20/fs/ext4/extents.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/extents.c	2007-02-11 23:16:58.000000000 +0300
+++ linux-2.6.20/fs/ext4/extents.c	2007-02-17 00:34:32.000000000 +0300
@@ -2044,8 +2044,12 @@
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(allocated);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
-	if (err)
+	if (err) {
+		/* free data blocks we just allocated */
+		ext4_free_blocks(handle, inode, ext_pblock(&newex),
+					le16_to_cpu(newex.ee_len));
 		goto out2;
+	}
 
 	if (extend_disksize && inode->i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = inode->i_size;
