From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Fix buffer head ref leaks after calls to
	ext4_get_inode_loc()
Date: Mon, 22 Mar 2010 08:46:42 -0700
Message-ID: <6601abe91003220846x46a2a8d5u2769c0563910c7d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:42710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab0CVPqq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 11:46:46 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [10.3.21.7])
	by smtp-out.google.com with ESMTP id o2MFkjlP003717
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 16:46:45 +0100
Received: from qw-out-2122.google.com (qwi5.prod.google.com [10.241.195.5])
	by hpaq7.eem.corp.google.com with ESMTP id o2MFkh3M023684
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 16:46:44 +0100
Received: by qw-out-2122.google.com with SMTP id 5so951283qwi.13
        for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 08:46:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix buffer head reference leaks in ext4_write_inode() and
ext4_xattr_fiemap().

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

ext4_get_inode_loc() returns with a reference to the iloc->bh; the two call
sites below do not release this reference.


diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
--- orig/fs/ext4/extents.c	2010-03-22 08:16:57.000000000 -0700
+++ new/fs/ext4/extents.c	2010-03-22 08:35:40.000000000 -0700
@@ -3879,6 +3879,7 @@ static int ext4_xattr_fiemap(struct inod
 		physical += offset;
 		length = EXT4_SB(inode->i_sb)->s_inode_size - offset;
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
+		brelse(iloc.bh);
 	} else { /* external block */
 		physical = EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2010-03-22 08:16:57.000000000 -0700
+++ new/fs/ext4/inode.c	2010-03-22 08:36:18.000000000 -0700
@@ -5385,6 +5385,7 @@ int ext4_write_inode(struct inode *inode
 				   (unsigned long long)iloc.bh->b_blocknr);
 			err = -EIO;
 		}
+		brelse(iloc.bh);
 	}
 	return err;
 }
