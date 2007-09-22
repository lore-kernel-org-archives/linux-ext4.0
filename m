From: "Vladimir V. Saveliev" <vs@clusterfs.com>
Subject: [RFC] [PATCH] e2fsprogs: dblist iteration loop is unbreakable
Date: Sat, 22 Sep 2007 03:24:48 +0300
Message-ID: <46F460D0.9020605@clusterfs.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090205050104060801040001"
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:42240 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXIUXWI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 19:22:08 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184])
	by mail.clusterfs.com (Postfix) with ESMTP id 3FC194E456E
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2007 17:22:05 -0600 (MDT)
Received: by nf-out-0910.google.com with SMTP id b2so768717nfb
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2007 16:22:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------090205050104060801040001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------090205050104060801040001
Content-Type: text/x-patch;
 name="break-dblist-loop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="break-dblist-loop.patch"


ext2fs_dblist_iterate breaks its iteration loop if callback's return value
has set DBLIST_ABORT bit.
If ext2fs_dblist_iterate is called by ext2fs_dblist_dir_iterate,
the callback is db_dir_proc->ext2fs_process_dir_block, which returns BLOCK_ABORT
if something goes wrong.
BLOCK_ABORT is defined as 2, whereas DBLIST_ABORT is 1.
As result ext2fs_dblist_iterate does not break the iteration loop when
ext2fs_process_dir_block returns BLOCK_ABORT.



diff -puN lib/ext2fs/dblist.c~break-dblist-loop lib/ext2fs/dblist.c
--- e2fsprogs-1.40.2/lib/ext2fs/dblist.c~break-dblist-loop	2007-09-22 03:13:22.000000000 +0300
+++ e2fsprogs-1.40.2-plodder/lib/ext2fs/dblist.c	2007-09-22 03:13:22.000000000 +0300
@@ -232,7 +232,7 @@ errcode_t ext2fs_dblist_iterate(ext2_dbl
 		ext2fs_dblist_sort(dblist, 0);
 	for (i=0; i < dblist->count; i++) {
 		ret = (*func)(dblist->fs, &dblist->list[(int)i], priv_data);
-		if (ret & DBLIST_ABORT)
+		if ((ret & DBLIST_ABORT) || (ret == BLOCK_ABORT))
 			return 0;
 	}
 	return 0;

_

--------------090205050104060801040001--
