From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] clear extents flag on inodes created in ext4_mknod
Date: Mon, 18 Feb 2008 15:00:33 -0600
Message-ID: <47B9F1F1.30604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbYBRVAf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 16:00:35 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1IL0ZKX010235
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 16:00:35 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IL0Y2b011349
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 16:00:34 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m1IL0YsE020300
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 16:00:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck doesn't expect to find char, block, fifo, or socket
files with the extent flag set, so clear that in ext4_mknod.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.24/fs/ext4/namei.c
===================================================================
--- linux-2.6.24.orig/fs/ext4/namei.c
+++ linux-2.6.24/fs/ext4/namei.c
@@ -1766,6 +1766,7 @@ retry:
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 		inode->i_op = &ext4_special_inode_operations;
 #endif
+		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);
