From: Jan Kara <jack@suse.cz>
Subject: ext2fs_block_iterate() on fast symlink
Date: Wed, 20 Jun 2007 14:56:53 +0200
Message-ID: <20070620125653.GG27218@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46806 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754104AbXFTMnU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2007 08:43:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  when  ext2fs_block_iterate() is called on a fast symlink (and I assume
device inodes would be no different), then random things happen - the
problem is ext2fs_block_iterate() just blindly takes portions of the inode
and treats them as block numbers. Now I agree that garbage went in (it
makes no sence to call this function on such inode) so garbage results but
maybe it would be nicer to handle it more gracefully. Attached patch should
do it.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--MGYHOYXEY6WxJCY8
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs-block_iterate_fix.diff"

--- a/lib/ext2fs/inode.c	2007-06-20 13:55:52.000000000 +0200
+++ b/lib/ext2fs/inode.c	2007-06-20 14:11:15.000000000 +0200
@@ -771,6 +771,10 @@ errcode_t ext2fs_get_blocks(ext2_filsys 
 	retval = ext2fs_read_inode(fs, ino, &inode);
 	if (retval)
 		return retval;
+	if (LINUX_S_ISCHR(inode.i_mode) || LINUX_S_ISBLK(inode.i_mode) ||
+	    (LINUX_S_ISLNK(inode.i_mode) &&
+	     ext2fs_inode_data_blocks(fs, &inode) == 0))
+		return EXT2_ET_INVAL_INODE_TYPE;
 	for (i=0; i < EXT2_N_BLOCKS; i++)
 		blocks[i] = inode.i_block[i];
 	return 0;
--- a/lib/ext2fs/ext2_err.et.in	2007-06-20 14:09:18.000000000 +0200
+++ b/lib/ext2fs/ext2_err.et.in	2007-06-20 14:11:25.000000000 +0200
@@ -296,5 +296,8 @@ ec	EXT2_ET_RESIZE_INODE_CORRUPT,
 ec	EXT2_ET_SET_BMAP_NO_IND,
 	"Missing indirect block not present"
 
+ec	EXT2_ET_INVAL_INODE_TYPE,
+	"Invalid inode type for the operation."
+
 	end
 

--MGYHOYXEY6WxJCY8--
