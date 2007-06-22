From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Fri, 22 Jun 2007 19:54:32 -0400
Message-ID: <20070622235432.GC22889@thunk.org>
References: <1182331988.9772.7.camel@garfield> <20070622222056.GB22889@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52733 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXFVXyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 19:54:37 -0400
Content-Disposition: inline
In-Reply-To: <20070622222056.GB22889@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here's what I've committed into the e2fsprogs tree.

						- Ted

# HG changeset patch
# User tytso@mit.edu
# Date 1182556401 14400
# Node ID deeb424beb36d9fb1ff401aca7a5761a451436b8
# Parent  702632e66380e459f60b238570edd1e911dd46bc
Fix byte-swapping issues for the i_extra_size field

Thanks to Andreas Dilger and Kalpak Shah for spotting this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r 702632e66380 -r deeb424beb36 lib/ext2fs/ChangeLog
--- a/lib/ext2fs/ChangeLog	Fri Jun 22 02:22:38 2007 -0400
+++ b/lib/ext2fs/ChangeLog	Fri Jun 22 19:53:21 2007 -0400
@@ -1,3 +1,8 @@ 2007-06-12  Theodore Tso  <tytso@mit.edu
+2007-06-22  Theodore Tso  <tytso@mit.edu>
+
+	* swapfs.c (ext2fs_swap_inode_full): Fix byte-swapping issues for
+		i_extra_size field.
+
 2007-06-12  Theodore Tso  <tytso@mit.edu>
 
 	* openfs.c (ext2fs_open2): We now set EXT2_FLAG_MASTER_SB_ONLY
diff -r 702632e66380 -r deeb424beb36 lib/ext2fs/swapfs.c
--- a/lib/ext2fs/swapfs.c	Fri Jun 22 02:22:38 2007 -0400
+++ b/lib/ext2fs/swapfs.c	Fri Jun 22 19:53:21 2007 -0400
@@ -133,7 +133,7 @@ void ext2fs_swap_inode_full(ext2_filsys 
 			    struct ext2_inode_large *f, int hostorder,
 			    int bufsize)
 {
-	unsigned i, has_data_blocks;
+	unsigned i, has_data_blocks, extra_isize;
 	int islnk = 0;
 	__u32 *eaf, *eat;
 
@@ -214,31 +214,35 @@ void ext2fs_swap_inode_full(ext2_filsys 
 	if (bufsize < (int) (sizeof(struct ext2_inode) + sizeof(__u16)))
 		return; /* no i_extra_isize field */
 
+	if (hostorder)
+		extra_isize = f->i_extra_isize;
 	t->i_extra_isize = ext2fs_swab16(f->i_extra_isize);
-	if (t->i_extra_isize > EXT2_INODE_SIZE(fs->super) -
+	if (!hostorder)
+		extra_isize = t->i_extra_isize;
+	if (extra_isize > EXT2_INODE_SIZE(fs->super) -
 				sizeof(struct ext2_inode)) {
 		/* this is error case: i_extra_size is too large */
 		return;
 	}
 
-	i = sizeof(struct ext2_inode) + t->i_extra_isize + sizeof(__u32);
+	i = sizeof(struct ext2_inode) + extra_isize + sizeof(__u32);
 	if (bufsize < (int) i)
 		return; /* no space for EA magic */
 
 	eaf = (__u32 *) (((char *) f) + sizeof(struct ext2_inode) +
-					f->i_extra_isize);
+					extra_isize);
 
 	if (ext2fs_swab32(*eaf) != EXT2_EXT_ATTR_MAGIC)
 		return; /* it seems no magic here */
 
 	eat = (__u32 *) (((char *) t) + sizeof(struct ext2_inode) +
-					f->i_extra_isize);
+					extra_isize);
 	*eat = ext2fs_swab32(*eaf);
 
 	/* convert EA(s) */
 	ext2fs_swap_ext_attr((char *) (eat + 1), (char *) (eaf + 1),
 			     bufsize - sizeof(struct ext2_inode) -
-			     t->i_extra_isize - sizeof(__u32), 0);
+			     extra_isize - sizeof(__u32), 0);
 
 }
 
