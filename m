From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 7/13]  Many inodes in filesystem.
Date: Tue, 24 Jul 2007 16:34:59 +0530
Message-ID: <1185275099.3789.72.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40566 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbXGXLEY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:04:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Handle filesystems with many hard links that have more than ~700M inodes.
The float variable lacks precision at this scale.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.40.1/lib/ext2fs/icount.c
===================================================================
--- e2fsprogs-1.40.1.orig/lib/ext2fs/icount.c
+++ e2fsprogs-1.40.1/lib/ext2fs/icount.c
@@ -376,6 +376,10 @@ static struct ext2_icount_el *get_icount
 					range = 0.1;
 			}
 			mid = low + ((int) (range * (high-low)));
+			if (mid > high)
+				mid = high;
+			if (mid < low)
+				mid = low;
 		}
 #endif
 		if (ino == icount->list[mid].ino) {
