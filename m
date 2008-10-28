From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] print unsigned RAM usage statistics
Date: Tue, 28 Oct 2008 14:44:21 -0600
Message-ID: <20081028204420.GA3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44427 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYJ1Uor (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Oct 2008 16:44:47 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m9SKiiMU010687
	for <linux-ext4@vger.kernel.org>; Tue, 28 Oct 2008 13:44:46 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9G00901UT4FL00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 28 Oct 2008 13:44:44 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Running e2fsck against a 14.5TB filesystem with -tt it reported
-200904kB for RAM usage in pass3 instead of the correct 2300773kB.
The RAM usage statistics were being printed with %d instead of %u.

Also fix a few places using %ld for inode numbers instead of %lu.

Signed-off-by: Andreas Dilger <adilger@sun.com>

============================================================================

diff --git a/e2fsck/util.c b/e2fsck/util.c
index 256100c..cf156bd 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -63,7 +63,7 @@ void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
 	char buf[256];
 
 #ifdef DEBUG_ALLOCATE_MEMORY
-	printf("Allocating %d bytes for %s...\n", size, description);
+	printf("Allocating %u bytes for %s...\n", size, description);
 #endif
 	ret = malloc(size);
 	if (!ret) {
@@ -329,11 +329,11 @@ void print_resource_track(const char *desc, struct resource_track *track,
 #define kbytes(x)	(((x) + 1023) / 1024)
 
 	malloc_info = mallinfo();
-	printf(_("Memory used: %dk/%dk (%dk/%dk), "),
+	printf(_("Memory used: %uk/%uk (%uk/%uk), "),
 	       kbytes(malloc_info.arena), kbytes(malloc_info.hblkhd),
 	       kbytes(malloc_info.uordblks), kbytes(malloc_info.fordblks));
 #else
-	printf(_("Memory used: %d, "),
+	printf(_("Memory used: %u, "),
 	       (int) (((char *) sbrk(0)) - ((char *) track->brk_start)));
 #endif
 #ifdef HAVE_GETRUSAGE
@@ -378,7 +378,7 @@ void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
 	retval = ext2fs_read_inode(ctx->fs, ino, inode);
 	if (retval) {
 		com_err("ext2fs_read_inode", retval,
-			_("while reading inode %ld in %s"), ino, proc);
+			_("while reading inode %lu in %s"), ino, proc);
 		fatal_error(ctx, 0);
 	}
 }
@@ -392,7 +392,7 @@ void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
 	retval = ext2fs_read_inode_full(ctx->fs, ino, inode, bufsize);
 	if (retval) {
 		com_err("ext2fs_read_inode_full", retval,
-			_("while reading inode %ld in %s"), ino, proc);
+			_("while reading inode %lu in %s"), ino, proc);
 		fatal_error(ctx, 0);
 	}
 }
@@ -406,7 +406,7 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 	retval = ext2fs_write_inode_full(ctx->fs, ino, inode, bufsize);
 	if (retval) {
 		com_err("ext2fs_write_inode", retval,
-			_("while writing inode %ld in %s"), ino, proc);
+			_("while writing inode %lu in %s"), ino, proc);
 		fatal_error(ctx, 0);
 	}
 }
@@ -419,7 +419,7 @@ extern void e2fsck_write_inode(e2fsck_t ctx, unsigned long ino,
 	retval = ext2fs_write_inode(ctx->fs, ino, inode);
 	if (retval) {
 		com_err("ext2fs_write_inode", retval,
-			_("while writing inode %ld in %s"), ino, proc);
+			_("while writing inode %lu in %s"), ino, proc);
 		fatal_error(ctx, 0);
 	}
 }

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

