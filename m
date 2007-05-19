From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] store RAID stride in superblock
Date: Fri, 18 May 2007 22:08:41 -0400
Message-ID: <20070519020841.GA8654@thunk.org>
References: <20070512020248.GQ6375@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36034 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbXESGQp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 May 2007 02:16:45 -0400
Content-Disposition: inline
In-Reply-To: <20070512020248.GQ6375@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 11, 2007 at 07:02:48PM -0700, Andreas Dilger wrote:
> It is possible to specify the RAID stride to mke2fs allow it to optimize
> the layout of the bitmaps.  With the new mballoc it is also possible to
> tell it via a mount option to do large allocations aligned on the RAID
> stride (by default it aligns on 1MB boundaries from the start of the LUN).

You asked for it, you got it.

						- Ted

# HG changeset patch
# User tytso@mit.edu
# Date 1179540413 14400
# Node ID 2afd1c039d26aaa66c55ede30770df1990392f84
# Parent  f95d161b454ec94e8974946d38e3e94c612f2cd2
Store the RAID stride value in the superblock and take advantage of it

Store the RAID stride value when a filesystem is created with a requested
RAID stride, and then use it automatically in resize2fs.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r f95d161b454e -r 2afd1c039d26 lib/ext2fs/ChangeLog
--- a/lib/ext2fs/ChangeLog	Fri May 18 21:44:29 2007 -0400
+++ b/lib/ext2fs/ChangeLog	Fri May 18 22:06:53 2007 -0400
@@ -1,3 +1,10 @@ 2007-05-08  Eric Sandeen <sandeen@redhat
+2007-05-18  Theodore Tso  <tytso@mit.edu>
+
+	* openfs.c (ext2fs_open2): Set fs->stride from the superblock's
+		s_raid_stride value.
+
+	* ext2_fs.h: Allocate space for RAID stride in the superblock.
+
 2007-05-08  Eric Sandeen <sandeen@redhat.com>
 
 	* ext2_fs.h (inode_uid, inode_gid): The inode_uid() and
diff -r f95d161b454e -r 2afd1c039d26 lib/ext2fs/ext2_fs.h
--- a/lib/ext2fs/ext2_fs.h	Fri May 18 21:44:29 2007 -0400
+++ b/lib/ext2fs/ext2_fs.h	Fri May 18 22:06:53 2007 -0400
@@ -573,7 +573,9 @@ struct ext2_super_block {
 	__u16	s_min_extra_isize;	/* All inodes have at least # bytes */
 	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__u32	s_flags;		/* Miscellaneous flags */
-	__u32	s_reserved[167];	/* Padding to the end of the block */
+	__u16   s_raid_stride;		/* RAID stride */
+	__u16   s_pad;			/* Padding */
+	__u32	s_reserved[166];	/* Padding to the end of the block */
 };
 
 /*
diff -r f95d161b454e -r 2afd1c039d26 lib/ext2fs/openfs.c
--- a/lib/ext2fs/openfs.c	Fri May 18 21:44:29 2007 -0400
+++ b/lib/ext2fs/openfs.c	Fri May 18 22:06:53 2007 -0400
@@ -297,6 +297,8 @@ errcode_t ext2fs_open2(const char *name,
 		dest += fs->blocksize;
 	}
 
+	fs->stride = fs->super->s_raid_stride;
+
 	*ret_fs = fs;
 	return 0;
 cleanup:
diff -r f95d161b454e -r 2afd1c039d26 misc/ChangeLog
--- a/misc/ChangeLog	Fri May 18 21:44:29 2007 -0400
+++ b/misc/ChangeLog	Fri May 18 22:06:53 2007 -0400
@@ -1,4 +1,6 @@ 2007-05-18  Theodore Tso  <tytso@mit.edu
 2007-05-18  Theodore Tso  <tytso@mit.edu>
+
+	* mke2fs.c (main): Save the raid stride to the superblock
 
 	* blkid.c (main): Add -g option to blkid which will garbage
 		collect the cache.
diff -r f95d161b454e -r 2afd1c039d26 misc/mke2fs.c
--- a/misc/mke2fs.c	Fri May 18 21:44:29 2007 -0400
+++ b/misc/mke2fs.c	Fri May 18 22:06:53 2007 -0400
@@ -1611,7 +1611,7 @@ int main (int argc, char *argv[])
 		test_disk(fs, &bb_list);
 
 	handle_bad_blocks(fs, bb_list);
-	fs->stride = fs_stride;
+	fs->stride = fs->super->s_raid_stride = fs_stride;
 	retval = ext2fs_allocate_tables(fs);
 	if (retval) {
 		com_err(program_name, retval,
diff -r f95d161b454e -r 2afd1c039d26 resize/ChangeLog
--- a/resize/ChangeLog	Fri May 18 21:44:29 2007 -0400
+++ b/resize/ChangeLog	Fri May 18 22:06:53 2007 -0400
@@ -1,3 +1,9 @@ 2007-03-18  Theodore Tso  <tytso@mit.edu
+2007-05-18  Theodore Tso  <tytso@mit.edu>
+
+	* main.c (determine_fs_stride): Use the superblock s_raid_stride
+		if it is set; save the hueristically determined stride to
+		the superblock if it is not set.
+
 2007-03-18  Theodore Tso  <tytso@mit.edu>
 
 	* resize2fs.c (check_and_change_inodes): Check to make sure the
diff -r f95d161b454e -r 2afd1c039d26 resize/main.c
--- a/resize/main.c	Fri May 18 21:44:29 2007 -0400
+++ b/resize/main.c	Fri May 18 22:06:53 2007 -0400
@@ -101,6 +101,8 @@ static void determine_fs_stride(ext2_fil
 	unsigned int	has_sb, prev_has_sb, num;
 	int		i_stride, b_stride;
 
+	if (fs->stride)
+		return;
 	num = 0; sum = 0;
 	for (group = 0; group < fs->group_desc_count; group++) {
 		has_sb = ext2fs_bg_has_super(fs, group);
@@ -131,6 +133,9 @@ static void determine_fs_stride(ext2_fil
 		fs->stride = sum / num;
 	else
 		fs->stride = 0;
+
+	fs->super->s_raid_stride = fs->stride;
+	ext2fs_mark_super_dirty(fs);
 
 #if 0
 	if (fs->stride)
@@ -348,7 +353,8 @@ int main (int argc, char ** argv)
 				_("Invalid stride length"));
 			exit(1);
 		}
-		fs->stride = use_stride;
+		fs->stride = fs->super->s_raid_stride = use_stride;
+		ext2fs_mark_super_dirty(fs);
 	} else
 		  determine_fs_stride(fs);
 	
