From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Fri, 22 Jun 2007 22:34:15 -0400
Message-ID: <20070623023414.GE22889@thunk.org>
References: <1182331988.9772.7.camel@garfield> <20070622222056.GB22889@thunk.org> <20070622235432.GC22889@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60908 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXFWCeV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 22:34:21 -0400
Content-Disposition: inline
In-Reply-To: <20070622235432.GC22889@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Also applied into the e2fsprogs tree.

					- Ted

# HG changeset patch
# User tytso@mit.edu
# Date 1182565963 14400
# Node ID 98d5fa14e7dedde4754cd42f4d2af2622c4ba3ee
# Parent  deeb424beb36d9fb1ff401aca7a5761a451436b8
Fix ext2fs_read_inode_full() so that the whole inode is byte-swapped

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r deeb424beb36 -r 98d5fa14e7de lib/ext2fs/ChangeLog
--- a/lib/ext2fs/ChangeLog	Fri Jun 22 19:53:21 2007 -0400
+++ b/lib/ext2fs/ChangeLog	Fri Jun 22 22:32:43 2007 -0400
@@ -1,4 +1,7 @@ 2007-06-22  Theodore Tso  <tytso@mit.edu
 2007-06-22  Theodore Tso  <tytso@mit.edu>
+
+	* inode.c (ext2fs_read_inode_full): Pass in bufsize so the full
+		inode is byte-swapped.
 
 	* swapfs.c (ext2fs_swap_inode_full): Fix byte-swapping issues for
 		i_extra_size field.
diff -r deeb424beb36 -r 98d5fa14e7de lib/ext2fs/inode.c
--- a/lib/ext2fs/inode.c	Fri Jun 22 19:53:21 2007 -0400
+++ b/lib/ext2fs/inode.c	Fri Jun 22 22:32:43 2007 -0400
@@ -586,7 +586,7 @@ errcode_t ext2fs_read_inode_full(ext2_fi
 	    (fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
 		ext2fs_swap_inode_full(fs, (struct ext2_inode_large *) inode, 
 				       (struct ext2_inode_large *) inode, 
-				       0, length);
+				       0, bufsize);
 #endif
 
 	/* Update the inode cache */
