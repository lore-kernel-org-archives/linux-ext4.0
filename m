From: Greg KH <gregkh@suse.de>
Subject: [patch 71/87] ext4: tighten restrictions on inode flags
Date: Tue, 09 Jun 2009 02:39:59 -0700
Message-ID: <20090609094109.038712318@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Duane Griffin <duaneg@dghda.com>,
	Andreas Dilger <adilger@sun.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:55455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395AbZFIKVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:36 -0400
Content-Disposition: inline; filename=ext4-tighten-restrictions-on-inode-flags.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Duane Griffin <duaneg@dghda.com>

(cherry picked from commit 2dc6b0d48ca0599837df21b14bb8393d0804af57)

At the moment there are few restrictions on which flags may be set on
which inodes.  Specifically DIRSYNC may only be set on directories and
IMMUTABLE and APPEND may not be set on links.  Tighten that to disallow
TOPDIR being set on non-directories and only NODUMP and NOATIME to be set
on non-regular file, non-directories.

Introduces a flags masking function which masks flags based on mode and
use it during inode creation and when flags are set via the ioctl to
facilitate future consistency.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h   |   17 +++++++++++++++++
 fs/ext4/ialloc.c |   14 +++++---------
 fs/ext4/ioctl.c  |    3 +--
 3 files changed, 23 insertions(+), 11 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -255,6 +255,23 @@ struct flex_groups {
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
 
+/* Flags that are appropriate for regular files (all but dir-specific ones). */
+#define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
+
+/* Flags that are appropriate for non-directories/regular files. */
+#define EXT4_OTHER_FLMASK (EXT4_NODUMP_FL | EXT4_NOATIME_FL)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & EXT4_REG_FLMASK;
+	else
+		return flags & EXT4_OTHER_FLMASK;
+}
+
 /*
  * Inode dynamic state flags
  */
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -885,16 +885,12 @@ got:
 	ei->i_disksize = 0;
 
 	/*
-	 * Don't inherit extent flag from directory. We set extent flag on
-	 * newly created directory and file only if -o extent mount option is
-	 * specified
+	 * Don't inherit extent flag from directory, amongst others. We set
+	 * extent flag on newly created directory and file only if -o extent
+	 * mount option is specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
-	if (S_ISLNK(mode))
-		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
-	/* dirsync only applies to directories */
-	if (!S_ISDIR(mode))
-		ei->i_flags &= ~EXT4_DIRSYNC_FL;
+	ei->i_flags =
+		ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
 	ei->i_file_acl = 0;
 	ei->i_dtime = 0;
 	ei->i_block_group = group;
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -48,8 +48,7 @@ long ext4_ioctl(struct file *filp, unsig
 		if (err)
 			return err;
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT4_DIRSYNC_FL;
+		flags = ext4_mask_flags(inode->i_mode, flags);
 
 		err = -EPERM;
 		mutex_lock(&inode->i_mutex);


