From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: write only core inode in update_path()
Date: Wed, 17 Jun 2009 10:50:18 -0500
Message-ID: <4A3910BA.5040105@redhat.com>
References: <4A381EC8.4010202@redhat.com> <4A383F97.1080002@redhat.com> <20090617153537.GB25451@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZFQPuV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 11:50:21 -0400
In-Reply-To: <20090617153537.GB25451@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

>
> Probably it would be better/simpler to replace this with:
>
> 		retval = ext2fs_write_inode(handle->fs, handle->ino,
> 					    handle->inode);
>
> 							- Ted
>   
Sure, that makes more sense, revised below:

libext2fs: write only core inode in update_path()

The ext2_extent_handle only has a struct ext2_inode allocated on
it, and the same amount copied into it in that same function, 
but in update_path() we're possibly writing out more than that - 
for example 256 bytes, from that address.  This causes uninitialized 
memory to get  written to disk, overwriting the parts of the 
inode past the osd2 member (the end of the smaller structure).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index b7eb617..15ce302 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -546,8 +546,8 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 	struct ext3_extent_idx		*ix;
 
 	if (handle->level == 0) {
-		retval = ext2fs_write_inode_full(handle->fs, handle->ino,
-			   handle->inode, EXT2_INODE_SIZE(handle->fs->super));
+		retval = ext2fs_write_inode(handle->fs, handle->ino,
+				   handle->inode);
 	} else {
 		ix = handle->path[handle->level - 1].curr;
 		blk = ext2fs_le32_to_cpu(ix->ei_leaf) +

