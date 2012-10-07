From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: Sun, 7 Oct 2012 18:54:03 -0400
Message-ID: <20121007225403.GA468@thunk.org>
References: <20121007181025.GA30198@thunk.org>
 <20121007201830.29646.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54327 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2JGWyI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Oct 2012 18:54:08 -0400
Content-Disposition: inline
In-Reply-To: <20121007201830.29646.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If you can replicate this, could you try applying the following patch
to e2fsck, and install it and then capture the output from e2fsck when
it repairs the file system?

That might give us some clues as to what is going on.  I've been going
through the sources and I don't see any place where we mark the
superblock as dirty and write it out without first writing the
checksum first.

There is a chance we could get screwed by a race in no journal mode
where two processes modify superblock at the same time, but we don't
actually modify the superblock that much.  The primary case where the
superblock gets modified while the file system is mounted is when we
add and remove inods from the orphan list, and that is serialized by a
mutex.  The other times when we modify the superblock is when we add a
feature in a few rare cases (the large file feature, or the xattr
compat feature, etc.) and of course during an online resizing.  But
that's not likely to be happening in your case.  So I really don't
understand what might be happening on your system, which is why this
patch will hopefully shed some light as to what is going on.

      	   	     	       	     	- Ted

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index d2b1bbd..b1fe32c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1064,6 +1064,13 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
 				      flags, 0, 0, io_ptr, ret_fs);
 
+	if (*ret_fs && (*ret_fs)->super && retval == EXT2_ET_SB_CSUM_INVALID) {
+		list_super((*ret_fs)->super);
+		ext2fs_superblock_csum_set(*ret_fs, (*ret_fs)->super);
+		printf("Expected checksum was %04x\n",
+		       (*ret_fs)->super->s_checksum);
+	}
+
 	if (ret_fs)
 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
 				       "default", NULL);
