From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: delay metadata checksum in pass1
Date: Tue, 31 Jul 2012 15:50:28 -0400
Message-ID: <20120731195028.GC32228@thunk.org>
References: <1340937356-12493-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42346 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2GaTug (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 15:50:36 -0400
Content-Disposition: inline
In-Reply-To: <1340937356-12493-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 29, 2012 at 10:35:56AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> in __ext4_get_inode_loc, when all other inodes are free, we will skip I/O.
> Thus, all of inodes in this block are set to 0.  Then when we scan these inodes
> in pass1, we will get a metadata checksum error.  However, we don't need to scan
> these inodes because they have been freed.
> 
> This bug can be reproduced by xfstests #013.
> 
> Reported-by: Tao Ma <boyu.tm@taobao.com>
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

The problem with this patch is that it means that we're not checking
the checksums of some of the reserved inodes (since they happen before
the point where the check has been moved, and some of them ---
including the journal inode --- have their own special case code and
they then continue out).

It also doesn't solve the problem with other potential users of
ext2fs_get_next_inode().  So I chose to fix the problem in
ext2fs_inode_csum_verify() instead.

Regards,

					- Ted

commit 4f0ba51ece06286deed18b86ef9b154d602dd9c6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Jul 31 15:27:29 2012 -0400

    libext2fs: when checking the inode's checksum, allow an all-zero inode
    
    When the kernel writes an inode where all of the other inodes in in
    the inode table (itable) block are unused, it skips reading the itable
    block from disk, and instead uses an all zeros block.  This can cause
    e2fsck to complain when it iterates over the inodes using
    ext2fs_get_next_inode() since the inode apparently has an invalid
    checksum.  Normally the inode won't be returned at all if it is at the
    end of the block group's part of the inode table, thanks to the
    bg_itable_unused field.  But it's possible for this situation to
    happen earlier in the inode table block.
    
    Fix this by changing ext2fs_inode_csum_verify() to allow the inode to
    be all zero's; if the checksum fails, and the inode is all zero's,
    treat it as a valid checksum.
    
    Reported-by: Zheng Liu <wenqing.lz@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 86f5fd2..9196903 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -667,7 +667,8 @@ int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 {
 	errcode_t retval;
 	__u32 provided, calculated;
-	int has_hi;
+	int i, has_hi;
+	char *cp;
 
 	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
 	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
@@ -687,7 +688,23 @@ int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 	} else
 		calculated &= 0xFFFF;
 
-	return provided == calculated;
+	if (provided == calculated)
+		return 1;
+
+	/*
+	 * If the checksum didn't match, it's possible it was due to
+	 * the inode being all zero's.  It's unlikely this is the
+	 * case, but it can happen.  So check for it here.  (We only
+	 * check the base inode since that's good enough, and it's not
+	 * worth the bother to figure out how much of the extended
+	 * inode, if any, is present.)
+	 */
+	for (cp = (char *) inode, i = 0;
+	     i < sizeof(struct ext2_inode);
+	     cp++, i++)
+		if (*cp)
+			return 0;
+	return 1;		/* Inode must have been all zero's */
 }
 
 errcode_t ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
