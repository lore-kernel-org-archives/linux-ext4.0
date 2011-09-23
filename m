From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH e2fsprogs] Add flag to ext2fs_flush and ext2fs_close to avoid
 fsync.
Date: Fri, 23 Sep 2011 11:23:42 +0100
Message-ID: <20110923102342.GC31740@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GPJrCs/72TxItFYR"
Cc: tytso@mit.edu, berrange@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1IWKXp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Sep 2011 06:23:45 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[Hopefully sent to the right place this time ...]

This patch allows users of the ext2fs library to avoid doing an fsync
on close (obviously this is optional, and doesn't affect existing callers).

Where this helps us is when constructing a throwaway ext2 filesystem
just to boot a virtual machine.  By avoiding the 2 x fsync, we save
over 5 seconds and many many unnecessary disk writes.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
http://cocan.org/getting_started_with_ocaml_on_red_hat_and_fedora

--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Add-flag-to-ext2fs_flush-and-ext2fs_close-to-avoid-f.patch"

>From 6d62a08743b6ea4b0a2b12dbded568a36676bfa5 Mon Sep 17 00:00:00 2001
From: "Richard W.M. Jones" <rjones@redhat.com>
Date: Fri, 23 Sep 2011 10:53:43 +0100
Subject: [PATCH] Add flag to ext2fs_flush and ext2fs_close to avoid fsync.

This adds new APIs: ext2fs_flush2 and ext2fs_close2 which take an
extra 'int flags' parameter.

This allows us to pass in an EXT2_FLAG_FLUSH_NO_SYNC flag which avoids
fsync'ing the filesystem when closing it.  For the case we have in
mind where we are just constructing a throwaway ext2 filesystem in a
file in order to boot a VM, this saves over 5 seconds during the boot
process and avoids many unnecessary disk writes.

Existing code using ext2fs_flush and ext2fs_close remains unaffected
by this change.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 lib/ext2fs/closefs.c |   18 +++++++++++++++---
 lib/ext2fs/ext2fs.h  |    8 ++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 51ef63c..128452a 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -261,6 +261,11 @@ static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
 
 errcode_t ext2fs_flush(ext2_filsys fs)
 {
+	return ext2fs_flush2(fs, 0);
+}
+
+errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
+{
 	dgrp_t		i;
 	errcode_t	retval;
 	unsigned long	fs_state;
@@ -401,14 +406,16 @@ write_primary_superblock_only:
 	ext2fs_swap_super(super_shadow);
 #endif
 
-	retval = io_channel_flush(fs->io);
+	if (!(flags & EXT2_FLAG_FLUSH_NO_SYNC))
+		retval = io_channel_flush(fs->io);
 	retval = write_primary_superblock(fs, super_shadow);
 	if (retval)
 		goto errout;
 
 	fs->flags &= ~EXT2_FLAG_DIRTY;
 
-	retval = io_channel_flush(fs->io);
+	if (!(flags & EXT2_FLAG_FLUSH_NO_SYNC))
+		retval = io_channel_flush(fs->io);
 errout:
 	fs->super->s_state = fs_state;
 #ifdef WORDS_BIGENDIAN
@@ -422,6 +429,11 @@ errout:
 
 errcode_t ext2fs_close(ext2_filsys fs)
 {
+	return ext2fs_close2(fs, 0);
+}
+
+errcode_t ext2fs_close2(ext2_filsys fs, int flags)
+{
 	errcode_t	retval;
 	int		meta_blks;
 	io_stats stats = 0;
@@ -446,7 +458,7 @@ errcode_t ext2fs_close(ext2_filsys fs)
 			fs->flags |= EXT2_FLAG_SUPER_ONLY | EXT2_FLAG_DIRTY;
 	}
 	if (fs->flags & EXT2_FLAG_DIRTY) {
-		retval = ext2fs_flush(fs);
+		retval = ext2fs_flush2(fs, flags);
 		if (retval)
 			return retval;
 	}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1b9acc3..7fc398e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -593,6 +593,12 @@ typedef struct stat ext2fs_struct_stat;
 #endif
 
 /*
+ * For ext2fs_close2 and ext2fs_flush2, this flag allows you to avoid
+ * the fsync call.
+ */
+#define EXT2_FLAG_FLUSH_NO_SYNC          1
+
+/*
  * function prototypes
  */
 
@@ -876,7 +882,9 @@ extern errcode_t ext2fs_check_desc(ext2_filsys fs);
 
 /* closefs.c */
 extern errcode_t ext2fs_close(ext2_filsys fs);
+extern errcode_t ext2fs_close2(ext2_filsys fs, int flags);
 extern errcode_t ext2fs_flush(ext2_filsys fs);
+extern errcode_t ext2fs_flush2(ext2_filsys fs, int flags);
 extern int ext2fs_bg_has_super(ext2_filsys fs, int group_block);
 extern errcode_t ext2fs_super_and_bgd_loc2(ext2_filsys fs,
 				    dgrp_t group,
-- 
1.7.6


--GPJrCs/72TxItFYR--
