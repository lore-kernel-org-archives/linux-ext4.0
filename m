From: number9652 <number9652@yahoo.com>
Subject: Re: [PATCH] libext2fs: write only core inode in update_path()
Date: Wed, 17 Jun 2009 13:11:21 -0700 (PDT)
Message-ID: <494208.86194.qm@web43505.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n69.bullet.mail.sp1.yahoo.com ([98.136.44.41]:38269 "HELO
	n69.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754461AbZFQULU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 16:11:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--- On Wed, 6/17/09, Eric Sandeen wrote:
> Theodore Tso wrote:
> > Probably it would be better/simpler to replace this
> with:
> >
> >         retval =
> ext2fs_write_inode(handle->fs, handle->ino,
>     handle->inode);
>         - Ted
> >   
> Sure, that makes more sense, revised below:
> 
> libext2fs: write only core inode in update_path()
> 
> The ext2_extent_handle only has a struct ext2_inode
> allocated on
> it, and the same amount copied into it in that same
> function, 

First, sorry for the original bug.  I don't think the above is the right way to fix it, however.  I am concerned that I may have basically broken write_inode_full on any inode with extents.  For example, there is another call to write_inode_full in extent.c that might exhibit this same problem.  I think the right fix would be to return to reading the full inode into memory in the extent_open function.  See the patch below for what I am talking about.

libext2fs: read the full inode in extent_open2

The inode pointed to in the extent handle structure is expected to have the same size as the on-disk inode so the entire inode can be updated and written to disk, but in extent_open2, only 128 bytes was read into the inode, regardless of the on-disk inode size.  Instead, read the entire inode.

Signed-off-by: Nic Case
---
diff --git a/e2fsprogs-1.41.6-orig/lib/ext2fs/extent.c b/e2fsprogs-1.41.6/lib/ext2fs/extent.c
index b7eb617..aebb9bc 100644
--- a/e2fsprogs-1.41.6-orig/lib/ext2fs/extent.c
+++ b/e2fsprogs-1.41.6/lib/ext2fs/extent.c
@@ -189,6 +189,7 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 {
 	struct ext2_extent_handle	*handle;
 	errcode_t			retval;
+	int				isize = EXT2_INODE_SIZE(fs->super);
 	int				i;
 	struct ext3_extent_header	*eh;
 
@@ -203,7 +204,7 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 		return retval;
 	memset(handle, 0, sizeof(struct ext2_extent_handle));
 
-	retval = ext2fs_get_mem(sizeof(struct ext2_inode), &handle->inode);
+	retval = ext2fs_get_mem(isize, &handle->inode);
 	if (retval)
 		goto errout;
 
@@ -211,10 +212,10 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 	handle->fs = fs;
 
 	if (inode) {
-		memcpy(handle->inode, inode, sizeof(struct ext2_inode));
+		memcpy(handle->inode, inode, isize);
 	}
 	else {
-		retval = ext2fs_read_inode(fs, ino, handle->inode);
+		retval = ext2fs_read_inode_full(fs, ino, handle->inode, isize);
 		if (retval)
 			goto errout;
 	}
---



      

