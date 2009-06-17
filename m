From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: write only core inode in update_path()
Date: Wed, 17 Jun 2009 18:50:39 -0400
Message-ID: <20090617225039.GE7867@mit.edu>
References: <4A381EC8.4010202@redhat.com> <4A383F97.1080002@redhat.com> <20090617153537.GB25451@mit.edu> <4A3910BA.5040105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44314 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762948AbZFQWuj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 18:50:39 -0400
Content-Disposition: inline
In-Reply-To: <4A3910BA.5040105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is what I ultimately checked in.  It converts all calls of
ext2fs_write_inode_full() to ext2fs_write_inode().

							- Ted

commit 125a36780626cdb0fc4d62fd529486baa8bce54c
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Jun 17 18:49:01 2009 -0400

    libext2fs: write only core inode in update_path()
    
    The ext2_extent_handle only has a struct ext2_inode allocated on
    it, and the same amount copied into it in that same function,
    but in update_path() we're possibly writing out more than that -
    for example 256 bytes, from that address.  This causes uninitialized
    memory to get  written to disk, overwriting the parts of the
    inode past the osd2 member (the end of the smaller structure).
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 2b88739..35b080e 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -546,8 +546,8 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 	struct ext3_extent_idx		*ix;
 
 	if (handle->level == 0) {
-		retval = ext2fs_write_inode_full(handle->fs, handle->ino,
-			   handle->inode, EXT2_INODE_SIZE(handle->fs->super));
+		retval = ext2fs_write_inode(handle->fs, handle->ino,
+					    handle->inode);
 	} else {
 		ix = handle->path[handle->level - 1].curr;
 		blk = ext2fs_le32_to_cpu(ix->ei_leaf) +
@@ -1011,8 +1011,8 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 
 	/* new node hooked in, so update inode block count (do this here?) */
 	handle->inode->i_blocks += handle->fs->blocksize / 512;
-	retval = ext2fs_write_inode_full(handle->fs, handle->ino,
-		handle->inode, EXT2_INODE_SIZE(handle->fs->super));
+	retval = ext2fs_write_inode(handle->fs, handle->ino,
+				    handle->inode);
 	if (retval)
 		goto done;
 
@@ -1370,9 +1370,8 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 
 			retval = ext2fs_extent_delete(handle, flags);
 			handle->inode->i_blocks -= handle->fs->blocksize / 512;
-			retval = ext2fs_write_inode_full(handle->fs,
-					handle->ino, handle->inode,
-					EXT2_INODE_SIZE(handle->fs->super));
+			retval = ext2fs_write_inode(handle->fs, handle->ino,
+						    handle->inode);
 			ext2fs_block_alloc_stats(handle->fs, extent.e_pblk, -1);
 		}
 	} else {
