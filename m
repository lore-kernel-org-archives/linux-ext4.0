From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][e2fsprogs] fix 0 file creation time
Date: Thu, 14 Aug 2008 14:45:43 -0400
Message-ID: <20080814184543.GD22488@mit.edu>
References: <48996A3F.3050607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34527 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752672AbYHNSpp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 14:45:45 -0400
Content-Disposition: inline
In-Reply-To: <48996A3F.3050607@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 06, 2008 at 05:09:19PM +0800, Li Zefan wrote:
> $ lsattr -c
> 1970-01-01 08:00:00.0 +0800 --------------- ./lost+found
> 
> It turns out that the crtime of files created by e2fsprogs is 0.
> 
> +	large_inode->i_crtime = large_inode->i_atime;
>  


Your patch assumes that i_atime is appropriately set, which is not
necessarily the case.  Enclosed the patch which I have committed into
e2fsprogs.

						- Ted

commit 3bcc6276a0c229791ca4a4fee4cf6d8d48ebe824
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Aug 14 14:30:05 2008 -0400

    libext2fs: Initialize unset inode timestamps when writing a new inode
    
    As Li Zefan <lizf@cn.fujitsu.com> reported, the creation timestamp was
    not getting set on the lost+found inode.  This patch makes sure all of
    the timestamps are appropriately set.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index ba15dda..b45de87 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -752,6 +752,14 @@ errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
 	int 			size = EXT2_INODE_SIZE(fs->super);
 	struct ext2_inode_large	*large_inode;
 	errcode_t		retval;
+	__u32 			t = fs->now ? fs->now : time(NULL);
+
+	if (!inode->i_ctime)
+		inode->i_ctime = t;
+	if (!inode->i_mtime)
+		inode->i_mtime = t;
+	if (!inode->i_atime)
+		inode->i_atime = t;
 
 	if (size == sizeof(struct ext2_inode))
 		return ext2fs_write_inode_full(fs, ino, inode,
@@ -767,6 +775,8 @@ errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
 	large_inode = (struct ext2_inode_large *) buf;
 	large_inode->i_extra_isize = sizeof(struct ext2_inode_large) - 
 		EXT2_GOOD_OLD_INODE_SIZE;
+	if (!large_inode->i_crtime)
+		large_inode->i_crtime = t;
 
 	retval = ext2fs_write_inode_full(fs, ino, buf, size);
 	free(buf);
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 34242df..e769ed5 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -85,7 +85,6 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	ext2fs_iblk_set(fs, &inode, 1);
 	inode.i_block[0] = blk;
 	inode.i_links_count = 2;
-	inode.i_ctime = inode.i_atime = inode.i_mtime = fs->now ? fs->now : time(NULL);
 	inode.i_size = fs->blocksize;
 
 	/*
