From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: If resize2fs fails, tell the user to run
	e2fsck
Date: Sat, 11 Jul 2009 14:25:23 -0400
Message-ID: <20090711182523.GA25844@mit.edu>
References: <1247249267-25715-1-git-send-email-tytso@mit.edu> <20090710184255.GF12939@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54848 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZGKSZa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jul 2009 14:25:30 -0400
Content-Disposition: inline
In-Reply-To: <20090710184255.GF12939@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 10, 2009 at 12:42:55PM -0600, Andreas Dilger wrote:
> On Jul 10, 2009  14:07 -0400, Theodore Ts'o wrote:
> > If the resize operation fails in the middle of the operation, mark the
> > filesystem as needing to be checked, and tell the user that they
> > should run e2fsck -fy on the device.
> 
> Isn't it a bit late to mark the filesystem inconsistent AFTER the resize
> failed?  If resize2fs dies for some reason it won't be marked.  It makes
> more sense to mark the filesystem in error at the start (at first change
> at least) and then clear it if there was no error.

Good point.

					- Ted

>From 96cdb37e27ff101fb23cefe422b4f77fb55209be Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 10 Jul 2009 13:14:00 -0400
Subject: [PATCH -V2] resize2fs: If resize2fs fails, tell the user to run e2fsck

If the resize operation fails in the middle of the operation, mark the
filesystem as needing to be checked, and tell the user that they
should run e2fsck -fy on the device.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c      |    9 +++++++--
 resize/resize2fs.c |    5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 2dae161..c6cbb5e 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -445,7 +445,8 @@ int main (int argc, char ** argv)
 				device_name);
 			exit(1);
 		}
-	printf("Resizing the filesystem on %s to %u (%dk) blocks.\n",
+		printf(_("Resizing the filesystem on "
+			 "%s to %u (%dk) blocks.\n"),
 		       device_name, new_size, fs->blocksize / 1024);
 		retval = resize_fs(fs, &new_size, flags,
 				   ((flags & RESIZE_PERCENT_COMPLETE) ?
@@ -455,7 +456,11 @@ int main (int argc, char ** argv)
 	if (retval) {
 		com_err(program_name, retval, _("while trying to resize %s"),
 			device_name);
-		ext2fs_close (fs);
+		fprintf(stderr,
+			_("Please run 'e2fsck -fy %s' to fix the filesystem\n"
+			  "after the aborted resize operation.\n"),
+			device_name);
+		ext2fs_close(fs);
 		exit(1);
 	}
 	printf(_("The filesystem on %s is now %u blocks long.\n\n"),
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index d907c9c..c0b00b6 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -84,6 +84,10 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 	if (retval)
 		return retval;
 
+	fs->super->s_state |= EXT2_ERROR_FS;
+	ext2fs_mark_super_dirty(fs);
+	ext2fs_flush(fs);
+
 	/*
 	 * Create the data structure
 	 */
@@ -153,6 +157,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 	if (retval)
 		goto errout;
 
+	rfs->new_fs->super->s_state &= ~EXT2_ERROR_FS;
 	rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 	retval = ext2fs_close(rfs->new_fs);
 	if (retval)
-- 
1.6.3.2.1.gb9f7d.dirty

