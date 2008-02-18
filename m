From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] don't set extents flag for _any_ symlinks
Date: Mon, 18 Feb 2008 16:27:52 -0600
Message-ID: <47BA0668.5020006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbYBRW1x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 17:27:53 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1IMRrtb005503
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 17:27:53 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IMRq1q002039
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 17:27:52 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m1IMRqFZ007173
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 17:27:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As symlinks are limited to a single block anyway, and e2fsck
doesn't expect to find it set, don't set the extents flag on 
any type of symlinks at all: fast/in-inode, or the 
external-block flavor.

There are a lot of filesystems out there by now w/ exent-style 
symlink blocks though, so e2fsck should probably be able to 
repair that at some point...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24/fs/ext4/namei.c
===================================================================
--- linux-2.6.24.orig/fs/ext4/namei.c
+++ linux-2.6.24/fs/ext4/namei.c
@@ -2223,7 +2226,6 @@ retry:
 		inode->i_op = &ext4_fast_symlink_inode_operations;
 		memcpy((char*)&EXT4_I(inode)->i_data,symname,l);
 		inode->i_size = l-1;
-		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 	}
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	err = ext4_add_nondir(handle, dentry, inode);

Index: linux-2.6.24/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.24.orig/fs/ext4/ialloc.c
+++ linux-2.6.24/fs/ext4/ialloc.c
@@ -744,7 +744,7 @@ got:
 		ext4_std_error(sb, err);
 		goto fail_free_drop;
 	}
-	if (test_opt(sb, EXTENTS)) {
+	if (test_opt(sb, EXTENTS) && !S_ISLNK(mode)) {
 		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
 		ext4_ext_tree_init(handle, inode);
 		err = ext4_update_incompat_feature(handle, sb,
