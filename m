From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: do not clear resize inode for 0 resvd blocks
Date: Tue, 21 Dec 2010 15:32:05 -0600
Message-ID: <4D111CD5.2040800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab0LUVcH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Dec 2010 16:32:07 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBLLW6JA008247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 16:32:07 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oBLLW55p026212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 16:32:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ran into odd behavior where mkfs.ext4 of a 16T filesystem would
create a resize inode with 0 reserved blocks, and mark the resize_inode
feature.

A subsequent slight downward resize of the filesystem would remove
the resize inode, making any further offline resizing impossible.

This is especially odd in light of the fact that a large downward
resize (say, to 8T) will actually add blocks to the resize inode -
so a small resize removes it, a large resize expands it ...

commit 8ade268cf2fde8629b51bfd1c044a83db88234cd had added this:

  If the filesystem is grown to the point where the resize_inode is no
  longer needed, clean it up properly so e2fsck doesn't have to.

but, it seems e2fsck does not care about this situation, either.

So, simply leave the resize_inode intact in this case, and everything
seems to be happy.

Note, this is for the 1.41.xx branch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/resize/resize2fs.c
===================================================================
--- e2fsprogs.orig/resize/resize2fs.c
+++ e2fsprogs/resize/resize2fs.c
@@ -1711,7 +1711,6 @@ static errcode_t fix_resize_inode(ext2_f
 	struct ext2_inode	inode;
 	errcode_t		retval;
 	char *			block_buf;
-	blk_t			blk;
 
 	if (!(fs->super->s_feature_compat &
 	      EXT2_FEATURE_COMPAT_RESIZE_INODE))
@@ -1723,20 +1722,6 @@ static errcode_t fix_resize_inode(ext2_f
 	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
 	if (retval) goto errout;
 
-	if (fs->super->s_reserved_gdt_blocks == 0) {
-		fs->super->s_feature_compat &=
-			~EXT2_FEATURE_COMPAT_RESIZE_INODE;
-		ext2fs_mark_super_dirty(fs);
-
-		if ((blk = inode.i_block[EXT2_DIND_BLOCK]) != 0)
-			ext2fs_block_alloc_stats(fs, blk, -1);
-
-		memset(&inode, 0, sizeof(inode));
-
-		retval = ext2fs_write_inode(fs, EXT2_RESIZE_INO, &inode);
-		goto errout;
-	}
