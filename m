From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: only call ext4_truncate when size <= isize
Date: Mon, 22 Jun 2015 00:37:29 -0400
Message-ID: <20150622043729.GT29480@thunk.org>
References: <1432049337-3520-1-git-send-email-jbacik@fb.com>
 <alpine.LFD.2.00.1506021008030.4950@localhost.localdomain>
 <20150606202011.GC15306@thunk.org>
 <20150609160739.GT19168@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@fb.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47738 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbbFVEhd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Jun 2015 00:37:33 -0400
Content-Disposition: inline
In-Reply-To: <20150609160739.GT19168@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 09, 2015 at 12:07:39PM -0400, Theodore Ts'o wrote:
> 
> Unfortunately this patch is causing generic/239 to fail when run with
> 1k blocksizes.

So it turns out the original patch was completely busted; the on-disk
i_size wasn't getting updated when we were truncating up.  Part of the
problem was the original way ATTR_SIZE was handled in ext4_setattr was
a bit of a mess, and it made it hard to understand.  So I've reworked
patch completely to clean up ext4_setattr while I was it.

      		    	     		  	  - Ted

>From 0d209259066ca93548189668d1eb4c9497913932 Mon Sep 17 00:00:00 2001
From: Josef Bacik <jbacik@fb.com>
Date: Mon, 22 Jun 2015 00:31:26 -0400
Subject: [PATCH] ext4: only call ext4_truncate when size <= isize

At LSF we decided that if we truncate up from isize we shouldn't trim
fallocated blocks that were fallocated with KEEP_SIZE and are past the
new i_size.  This patch fixes ext4 to do this.

[ Completely reworked patch so that i_disksize would actually get set
  when truncating up.  Also reworked the code for handling truncate so
  that it's easier to handle. -- tytso ]

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ae93f0b..e057c6f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4681,8 +4681,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		ext4_journal_stop(handle);
 	}
 
-	if (attr->ia_valid & ATTR_SIZE && attr->ia_size != inode->i_size) {
+	if (attr->ia_valid & ATTR_SIZE) {
 		handle_t *handle;
+		loff_t oldsize = inode->i_size;
+		int shrink = (attr->ia_size <= inode->i_size);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4690,24 +4692,26 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			if (attr->ia_size > sbi->s_bitmap_maxbytes)
 				return -EFBIG;
 		}
+		if (!S_ISREG(inode->i_mode))
+			return -EINVAL;
 
 		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
 			inode_inc_iversion(inode);
 
-		if (S_ISREG(inode->i_mode) &&
+		if (ext4_should_order_data(inode) &&
 		    (attr->ia_size < inode->i_size)) {
-			if (ext4_should_order_data(inode)) {
-				error = ext4_begin_ordered_truncate(inode,
+			error = ext4_begin_ordered_truncate(inode,
 							    attr->ia_size);
-				if (error)
-					goto err_out;
-			}
+			if (error)
+				goto err_out;
+		}
+		if (attr->ia_size != inode->i_size) {
 			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
 			if (IS_ERR(handle)) {
 				error = PTR_ERR(handle);
 				goto err_out;
 			}
-			if (ext4_handle_valid(handle)) {
+			if (ext4_handle_valid(handle) && shrink) {
 				error = ext4_orphan_add(handle, inode);
 				orphan = 1;
 			}
@@ -4726,15 +4730,13 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			up_write(&EXT4_I(inode)->i_data_sem);
 			ext4_journal_stop(handle);
 			if (error) {
-				ext4_orphan_del(NULL, inode);
+				if (orphan)
+					ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		} else {
-			loff_t oldsize = inode->i_size;
-
-			i_size_write(inode, attr->ia_size);
-			pagecache_isize_extended(inode, oldsize, inode->i_size);
 		}
+		if (!shrink)
+			pagecache_isize_extended(inode, oldsize, inode->i_size);
 
 		/*
 		 * Blocks are going to be removed from the inode. Wait
@@ -4754,13 +4756,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		 * in data=journal mode to make pages freeable.
 		 */
 		truncate_pagecache(inode, inode->i_size);
+		if (shrink)
+			ext4_truncate(inode);
 	}
-	/*
-	 * We want to call ext4_truncate() even if attr->ia_size ==
-	 * inode->i_size for cases like truncation of fallocated space
-	 */
-	if (attr->ia_valid & ATTR_SIZE)
-		ext4_truncate(inode);
 
 	if (!rc) {
 		setattr_copy(inode, attr);
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
