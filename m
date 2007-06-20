From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Wed, 20 Jun 2007 11:09:02 -0400
Message-ID: <20070620150902.GA15561@thunk.org>
References: <1182331988.9772.7.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37742 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbXFTPJO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2007 11:09:14 -0400
Content-Disposition: inline
In-Reply-To: <1182331988.9772.7.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 20, 2007 at 03:03:08PM +0530, Kalpak Shah wrote:
> In ext2fs_swap_inode_full() if to and from inodes are not the same
> (which is the case when called from e2fsck_get_next_inode_full),
> then e2fsck cannot recognize any in-inode EAs since the un-swabbed
> i_extra_isize was being used. So corrected that to use swabbed
> values all the time.

> Also in ext2fs_read_inode_full(), ext2fs_swap_inode_full() should be
> called with bufsize instead of with length argument. length was
> coming out to be 128 even with 512 byte inodes thus leaving the rest
> of the inode unswabbed.

Hi Kalpak, 

	In the future it would be really helpful if you split up your
patches so that each different thing is done in separate patches.

	Also, note there is a recent bug fix in this area, and the
byte-swapping extended attributes.  The issues involved here are
subtle; please see the discussion here:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=232663

So before your patches go in, we need to do a careful audit to make
sure they don't interact properly with this patch which is already in
e2fsprogs mainline.

						- Ted

# HG changeset patch
# User tytso@mit.edu
# Date 1176573631 14400
# Node ID aa8d65921c8922dfed73dd05027a097cc5946653
# Parent  4b2e34b5f7506f9f74b3fadf79280316d57e47d5
Correct byteswapping for fast symlinks with xattrs

Fix a problem byte-swapping fast symlinks inodes that contain extended
attributes.

Addresses Red Hat Bugzilla: #232663
Addresses LTC Bugzilla: #27634

Signed-off-by: "Bryn M. Reeves" <breeves@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r 4b2e34b5f750 -r aa8d65921c89 e2fsck/ChangeLog
--- a/e2fsck/ChangeLog	Sat Apr 14 12:01:39 2007 -0400
+++ b/e2fsck/ChangeLog	Sat Apr 14 14:00:31 2007 -0400
@@ -1,4 +1,10 @@ 2007-04-14  Theodore Tso  <tytso@mit.edu
 2007-04-14  Theodore Tso  <tytso@mit.edu>
+
+	* pass2.c (e2fsck_process_bad_inode): Remove special kludge that
+		dealt with long symlinks on big endian systems.  It turns
+		out this was a workaround to a bug described in Red Hat
+		Bugzilla #232663, with an odd twist.  See comment #12 for
+		more details.
 
 	* pass1.c, pass2.c, util.c: Add better ehandler_operation()
 		markers so it is clearer what e2fsck was doing when an I/O
diff -r 4b2e34b5f750 -r aa8d65921c89 e2fsck/pass2.c
--- a/e2fsck/pass2.c	Sat Apr 14 12:01:39 2007 -0400
+++ b/e2fsck/pass2.c	Sat Apr 14 14:00:31 2007 -0400
@@ -1202,22 +1202,6 @@ extern int e2fsck_process_bad_inode(e2fs
 	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_ZERO, &pctx)) {
 			inode.i_file_acl = 0;
-#ifdef EXT2FS_ENABLE_SWAPFS
-			/* 
-			 * This is a special kludge to deal with long
-			 * symlinks on big endian systems.  i_blocks
-			 * had already been decremented earlier in
-			 * pass 1, but since i_file_acl hadn't yet
-			 * been cleared, ext2fs_read_inode() assumed
-			 * that the file was short symlink and would
-			 * not have byte swapped i_block[0].  Hence,
-			 * we have to byte-swap it here.
-			 */
-			if (LINUX_S_ISLNK(inode.i_mode) &&
-			    (fs->flags & EXT2_FLAG_SWAP_BYTES) &&
-			    (inode.i_blocks == fs->blocksize >> 9))
-				inode.i_block[0] = ext2fs_swab32(inode.i_block[0]);
-#endif
 			inode_modified++;
 		} else
 			not_fixed++;
diff -r 4b2e34b5f750 -r aa8d65921c89 lib/ext2fs/ChangeLog
--- a/lib/ext2fs/ChangeLog	Sat Apr 14 12:01:39 2007 -0400
+++ b/lib/ext2fs/ChangeLog	Sat Apr 14 14:00:31 2007 -0400
@@ -1,3 +1,9 @@ 2007-04-06  Theodore Tso  <tytso@mit.edu
+2007-04-14  Theodore Tso  <tytso@mit.edu>
+
+	* swapfs.c (ext2fs_swap_inode_full): Fix a problem byte-swapping 
+		fast symlinks inodes that contain extended attributes.
+		(Addresses Red Hat Bugzilla #232663, LTC bugzilla #27634)
+
 2007-04-06  Theodore Tso  <tytso@mit.edu>
 
 	* icount.c (ext2fs_create_icount_tdb): Add support for using TDB
diff -r 4b2e34b5f750 -r aa8d65921c89 lib/ext2fs/swapfs.c
--- a/lib/ext2fs/swapfs.c	Sat Apr 14 12:01:39 2007 -0400
+++ b/lib/ext2fs/swapfs.c	Sat Apr 14 14:00:31 2007 -0400
@@ -133,7 +133,7 @@ void ext2fs_swap_inode_full(ext2_filsys 
 			    struct ext2_inode_large *f, int hostorder,
 			    int bufsize)
 {
-	unsigned i;
+	unsigned i, has_data_blocks;
 	int islnk = 0;
 	__u32 *eaf, *eat;
 
@@ -150,11 +150,17 @@ void ext2fs_swap_inode_full(ext2_filsys 
 	t->i_dtime = ext2fs_swab32(f->i_dtime);
 	t->i_gid = ext2fs_swab16(f->i_gid);
 	t->i_links_count = ext2fs_swab16(f->i_links_count);
+	if (hostorder)
+		has_data_blocks = ext2fs_inode_data_blocks(fs, 
+					   (struct ext2_inode *) f);
 	t->i_blocks = ext2fs_swab32(f->i_blocks);
+	if (!hostorder)
+		has_data_blocks = ext2fs_inode_data_blocks(fs, 
+					   (struct ext2_inode *) t);
 	t->i_flags = ext2fs_swab32(f->i_flags);
 	t->i_file_acl = ext2fs_swab32(f->i_file_acl);
 	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
-	if (!islnk || ext2fs_inode_data_blocks(fs, (struct ext2_inode *)t)) {
+	if (!islnk || has_data_blocks ) {
 		for (i = 0; i < EXT2_N_BLOCKS; i++)
 			t->i_block[i] = ext2fs_swab32(f->i_block[i]);
 	} else if (t != f) {
