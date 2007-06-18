From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck journal recovery can corrupt all superblock backups
Date: Mon, 18 Jun 2007 18:27:56 -0400
Message-ID: <20070618222756.GA1218@thunk.org>
References: <20070209062444.GA2438@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jim Garlick <garlick@llnl.gov>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46845 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762879AbXFRW2F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2007 18:28:05 -0400
Content-Disposition: inline
In-Reply-To: <20070209062444.GA2438@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 08, 2007 at 11:24:44PM -0700, Andreas Dilger wrote:
> Looking through the e2fsck code it would also seem possible to move the
> setting of EXT2_FLAG_MASTER_SB_ONLY before the journal replay.  That
> is the second patch.  I'm not sure which one is better.

I ended up doing both just to be paranoid; the following will be in
e2fsprogs 1.40.

					- Ted

# HG changeset patch
# User tytso@mit.edu
# Date 1182205610 14400
# Node ID 5c00c21991974cc750efa2474fab484b0a1f1522
# Parent  449d075befe0e4be32cce9d34ca1f03575e292d2
Don't write changes to the backup superblocks by default

This patch changes ext2fs_open() to set EXT2_FLAG_MASTER_SB_ONLY by
default.  This avoids some problems in e2fsck (reported by Jim Garlick)
where a corrupt journal can end up writing the bad superblock to the
backups.  In general, only e2fsck (after the filesystem is clean),
tune2fs, and resize2fs should change the backup superblocks by default.
Most callers of ext2fs_open() should not be touching anything where the
backups should be touched.  So let's change the defaults to avoid
potential problems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r 449d075befe0 -r 5c00c2199197 e2fsck/ChangeLog
--- a/e2fsck/ChangeLog	Mon Jun 04 01:49:51 2007 -0400
+++ b/e2fsck/ChangeLog	Mon Jun 18 18:26:50 2007 -0400
@@ -1,3 +1,10 @@ 2007-06-04  Theodore Tso  <tytso@mit.edu
+2007-06-18  Theodore Tso  <tytso@mit.edu>
+
+	* journal.c (e2fsck_run_ext3_journal), unix.c (main): Explicitly
+		add the EXT2_FLAG_MASTER_SB_ONLY flag to make sure we
+		won't write out the backup superblocks until we're sure
+		that we want write them out.
+
 2007-06-04  Theodore Tso  <tytso@mit.edu>
 
 	* super.c (check_super_block, e2fsck_get_device_size), 
diff -r 449d075befe0 -r 5c00c2199197 e2fsck/journal.c
--- a/e2fsck/journal.c	Mon Jun 04 01:49:51 2007 -0400
+++ b/e2fsck/journal.c	Mon Jun 18 18:26:50 2007 -0400
@@ -832,6 +832,7 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx
 	}
 	ctx->fs->priv_data = ctx;
 	ctx->fs->now = ctx->now;
+	ctx->fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
 
 	/* Set the superblock flags */
 	e2fsck_clear_recover(ctx, recover_retval);
diff -r 449d075befe0 -r 5c00c2199197 e2fsck/unix.c
--- a/e2fsck/unix.c	Mon Jun 04 01:49:51 2007 -0400
+++ b/e2fsck/unix.c	Mon Jun 18 18:26:50 2007 -0400
@@ -981,6 +981,18 @@ restart:
 			fix_problem(ctx, PR_0_SB_CORRUPT, &pctx);
 		fatal_error(ctx, 0);
 	}
+	/*
+	 * We only update the master superblock because (a) paranoia;
+	 * we don't want to corrupt the backup superblocks, and (b) we
+	 * don't need to update the mount count and last checked
+	 * fields in the backup superblock (the kernel doesn't update
+	 * the backup superblocks anyway).  With newer versions of the
+	 * library this flag is set by ext2fs_open2(), but we set this
+	 * here just to be sure.  (No, we don't support e2fsck running
+	 * with some other libext2fs than the one that it was shipped
+	 * with, but just in case....)
+	 */
+	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
 
 	if (!(ctx->flags & E2F_FLAG_GOT_DEVSIZE)) {
 		__u32 blocksize = EXT2_BLOCK_SIZE(fs->super);
@@ -1127,15 +1139,6 @@ restart:
 	    !(ctx->options & E2F_OPT_READONLY))
 		ext2fs_mark_super_dirty(fs);
 
-	/*
-	 * We only update the master superblock because (a) paranoia;
-	 * we don't want to corrupt the backup superblocks, and (b) we
-	 * don't need to update the mount count and last checked
-	 * fields in the backup superblock (the kernel doesn't
-	 * update the backup superblocks anyway).
-	 */
-	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
-
 	ehandler_init(fs->io);
 
 	if (ctx->superblock)
diff -r 449d075befe0 -r 5c00c2199197 lib/ext2fs/ChangeLog
--- a/lib/ext2fs/ChangeLog	Mon Jun 04 01:49:51 2007 -0400
+++ b/lib/ext2fs/ChangeLog	Mon Jun 18 18:26:50 2007 -0400
@@ -1,3 +1,10 @@ 2007-05-31  Theodore Tso  <tytso@mit.edu
+2007-06-12  Theodore Tso  <tytso@mit.edu>
+
+	* openfs.c (ext2fs_open2): We now set EXT2_FLAG_MASTER_SB_ONLY
+		when we open a filesystem.  Applications that want to
+		write changes to the backup superblocks need to explicitly
+		clear this flag.
+
 2007-05-31  Theodore Tso  <tytso@mit.edu>
 
 	* tst_super_size.c (main): Add sanity check to make sure the
diff -r 449d075befe0 -r 5c00c2199197 lib/ext2fs/openfs.c
--- a/lib/ext2fs/openfs.c	Mon Jun 04 01:49:51 2007 -0400
+++ b/lib/ext2fs/openfs.c	Mon Jun 18 18:26:50 2007 -0400
@@ -101,6 +101,8 @@ errcode_t ext2fs_open2(const char *name,
 	memset(fs, 0, sizeof(struct struct_ext2_filsys));
 	fs->magic = EXT2_ET_MAGIC_EXT2FS_FILSYS;
 	fs->flags = flags;
+	/* don't overwrite sb backups unless flag is explicitly cleared */
+	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
 	fs->umask = 022;
 	retval = ext2fs_get_mem(strlen(name)+1, &fs->device_name);
 	if (retval)
diff -r 449d075befe0 -r 5c00c2199197 misc/ChangeLog
--- a/misc/ChangeLog	Mon Jun 04 01:49:51 2007 -0400
+++ b/misc/ChangeLog	Mon Jun 18 18:26:50 2007 -0400
@@ -1,3 +1,9 @@ 2007-06-04  Theodore Tso  <tytso@mit.edu
+2007-06-12  Theodore Tso  <tytso@mit.edu>
+
+	* tune2fs.c (main): Clear the EXT2_FLAG_MASTER_SB_ONLY flag
+		because we want tune2fs changes to get written to the
+		backup blocks.
+
 2007-06-04  Theodore Tso  <tytso@mit.edu>
 
 	* badblocks.c (main): Fix error checking of the last-block and
diff -r 449d075befe0 -r 5c00c2199197 misc/tune2fs.c
--- a/misc/tune2fs.c	Mon Jun 04 01:49:51 2007 -0400
+++ b/misc/tune2fs.c	Mon Jun 18 18:26:50 2007 -0400
@@ -780,6 +780,7 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 	sb = fs->super;
+	fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 	if (print_label) {
 		/* For e2label emulation */
 		printf("%.*s\n", (int) sizeof(sb->s_volume_name),
diff -r 449d075befe0 -r 5c00c2199197 resize/ChangeLog
--- a/resize/ChangeLog	Mon Jun 04 01:49:51 2007 -0400
+++ b/resize/ChangeLog	Mon Jun 18 18:26:50 2007 -0400
@@ -1,3 +1,9 @@ 2007-05-22  Theodore Tso  <tytso@mit.edu
+2007-06-12  Theodore Tso  <tytso@mit.edu>
+
+	* resize2fs.c (resize_fs): Clear the EXT2_FLAG_MASTER_SB_ONLY flag
+		to make sure the superblock changes are written out to the
+		backup superblocks.
+
 2007-05-22  Theodore Tso  <tytso@mit.edu>
 
 	* sim_progress.c (ext2fs_progress_init): Fix type-punning warning.
diff -r 449d075befe0 -r 5c00c2199197 resize/resize2fs.c
--- a/resize/resize2fs.c	Mon Jun 04 01:49:51 2007 -0400
+++ b/resize/resize2fs.c	Mon Jun 18 18:26:50 2007 -0400
@@ -138,6 +138,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_
 	if (retval)
 		goto errout;
 
+	rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;	
 	retval = ext2fs_close(rfs->new_fs);
 	if (retval)
 		goto errout;
