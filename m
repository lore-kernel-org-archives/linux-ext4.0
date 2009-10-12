From: Scott James Remnant <scott@ubuntu.com>
Subject: [PATCH] e2fsck: Always fix last mount/write/check time with -p
Date: Mon, 12 Oct 2009 16:10:31 +0100
Message-ID: <E1MxMjT-0003XH-Mn@zelda.netsplit.com>
Cc: Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:52137 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbZJLPX0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 11:23:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After much debugging, we've come to the conclusion that the problems
with a last mount, write and check time in the future by up to 24
hours are not caused by buggy init scripts.  In fact, in every report,
the "now" time was always correct and it was the last mount/write/check
time that was wrong.

Investigation has led us to the following common scenarios:

 - Overwriting a system that previously had Windows installed, and
   thus a localtime ticking hardware clock.  The installer may not
   even be aware that the hardware clock is in localtime, and the
   user fails to notice that the clock is wrong while they are
   installing.

   The system is (properly) configured to assume the hardware clock
   is in UTC, but until the user connects to a network (usually after
   the first reboot) there is no external source to actually configure
   this.

   Thus the first mount of the filesystem is in the future, a reboot
   will cause the fsck error.

 - Installing onto a system with an externally synchronised hardware
   clock, where the hardware clock is (without the user's knowledge
   and beyond the capabilities of the Installer to detect) being set
   to local time.

   Again, each time NTP will fix the problem, but after each reboot
   the mount time will again be in the future.

   (This is a common case when using virtualisation, where the hardware
    clock is in fact being emulated based off something's system clock.)

Ironically this error is in of itself counter-productive, since if you
fix the underlying configuration problems or hardware clock problem,
it doesn't solve the fact that the last *mount* time is still in the
future.  So rebooting after fixing the problem actually gives you the
fsck inconsistency!  This leads people to both the wrong assumptions
and the wrong fixes!

This kind of filesystem issue is exactly what the -p ("preen") option
is for, it can be safely fixed without human intervention.  Indeed,
the very people that tend to run into this are the ones who are not
equipped to fix it themselves.

Remove the previous "buggy_init_scripts" option and make its behaviour
the default.  As with that option, fsck without -p will still treat
this as an error.

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
---
 debian/rules              |    6 ------
 e2fsck/e2fsck.conf.5.in   |   14 --------------
 e2fsck/e2fsck.conf.ubuntu |    2 --
 e2fsck/e2fsck.h           |    1 -
 e2fsck/problem.c          |    4 ++--
 e2fsck/super.c            |   39 +++++++++++++++------------------------
 e2fsck/unix.c             |    2 +-
 7 files changed, 18 insertions(+), 50 deletions(-)
 delete mode 100644 e2fsck/e2fsck.conf.ubuntu

diff --git a/debian/rules b/debian/rules
index f62e86f..f658bd1 100755
--- a/debian/rules
+++ b/debian/rules
@@ -445,12 +445,6 @@ endif
 	$(INSTALL) -p -m 0644 debugfs/debug_cmds.ct \
 		${debdir}/ss-dev/usr/share/doc/libss${SS_SOVERSION}/examples
 
-	if test -f /etc/lsb-release && \
-		grep -q DISTRIB_ID=Ubuntu /etc/lsb-release; then \
-	$(INSTALL) -p -m 0644 e2fsck/e2fsck.conf.ubuntu \
-		${debdir}/e2fsprogs/etc/e2fsck.conf; \
-	fi
-
 	dh_installinfo -pcomerr-dev ${stdbuilddir}/lib/et/com_err.info
 	dh_installinfo -pe2fslibs-dev ${stdbuilddir}/doc/libext2fs.info
 
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index 6638a39..daa4e9f 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -87,20 +87,6 @@ interrupts e2fsck using ^C, and the filesystem is not explicitly flagged
 as containing errors, e2fsck will exit with an exit status of 0 instead
 of 32.  This setting defaults to false.
 .TP
-.I buggy_init_scripts
-Some buggy distributions (such as Ubuntu) have init scripts and/or
-installers which fail to correctly set the system clock before running
-e2fsck and/or formatting the filesystem initially.  Normally this
-happens because the hardware clock is ticking localtime, instead of the
-more proper and less error-prone UTC time.  So while the kernel is
-booting, the system time (which in Linux systems always ticks in UTC
-time) is set from the hardware clock, but since the hardware clock is
-ticking localtime, the system time is incorrect.  Unfortunately, some
-buggy distributions do not correct this before running e2fsck.  If this
-option is set to a boolean value of true, we attempt to work around this
-situation by allowing the superblock last write time, last mount time,
-and last check time to be in the future by up to 24 hours.
-.TP
 .I clear_test_fs_flag
 This boolean relation controls whether or not 
 .BR e2fsck (8)
diff --git a/e2fsck/e2fsck.conf.ubuntu b/e2fsck/e2fsck.conf.ubuntu
deleted file mode 100644
index 49d6d19..0000000
--- a/e2fsck/e2fsck.conf.ubuntu
+++ /dev/null
@@ -1,2 +0,0 @@
-[options]
-	buggy_init_scripts = 1
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index ff73444..a5a811f 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -339,7 +339,6 @@ struct e2fsck_struct {
 
 	/* misc fields */
 	time_t now;
-	time_t time_fudge;	/* For working around buggy init scripts */
 	int ext_attr_ver;
 	profile_t	profile;
 	int blocks_per_page;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 540ac91..7e3cafb 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -388,13 +388,13 @@ static struct e2fsck_problem problem_table[] = {
 	/* Last mount time is in the future (fudged) */
 	{ PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
 	  N_("@S last mount time is in the future.\n\t(by less than a day, "
-	     "probably due to buggy init scripts)  "),
+	     "probably due to bad system clock last boot)  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	/* Last write time is in the future (fudged) */
 	{ PR_0_FUTURE_SB_LAST_WRITE_FUDGED,
 	  N_("@S last write time is in the future.\n\t(by less than a day, "
-	     "probably due to buggy init scripts).  "),
+	     "probably due to bad system clock last boot).  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	/* Block group checksum (latch question) is invalid. */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 097c87a..3fa0441 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -465,7 +465,6 @@ void check_super_block(e2fsck_t ctx)
 	int	inodes_per_block;
 	int	ipg_max;
 	int	inode_size;
-	int	buggy_init_scripts;
 	dgrp_t	i;
 	blk_t	should_be;
 	struct problem_context	pctx;
@@ -801,34 +800,26 @@ void check_super_block(e2fsck_t ctx)
 	}
 
 	/*
-	 * Some buggy distributions (such as Ubuntu) have init scripts
-	 * and/or installers which fail to correctly set the system
-	 * clock before running e2fsck and/or formatting the
-	 * filesystem initially.  Normally this happens because the
-	 * hardware clock is ticking localtime, instead of the more
-	 * proper and less error-prone UTC time.  So while the kernel
-	 * is booting, the system time (which in Linux systems always
-	 * ticks in UTC time) is set from the hardware clock, but
-	 * since the hardware clock is ticking localtime, the system
-	 * time is incorrect.  Unfortunately, some buggy distributions
-	 * do not correct this before running e2fsck.  If this option
-	 * is set to a boolean value of true, we attempt to work
-	 * around this situation by allowing the superblock last write
-	 * time, last mount time, and last check time to be in the
-	 * future by up to 24 hours.
-	 */
-	profile_get_boolean(ctx->profile, "options", "buggy_init_scripts",
-			    0, 0, &buggy_init_scripts);
-	ctx->time_fudge = buggy_init_scripts ? 86400 : 0;
-
-	/*
 	 * Check to see if the superblock last mount time or last
 	 * write time is in the future.
+	 *
+	 * Unfortunately it's remarkably easy for users to get
+	 * themselves into a problem where they've mounted the
+	 * filesystem at least once before the hardware clock has
+	 * been corrected by NTP (especially when overwriting or
+	 * dual booting with Windows).  Sadly these are the very
+	 * users who have no idea what to do when presented with a
+	 * root shell and invited to fix their filesystem.
+	 *
+	 * Work around this situation by always allowing the
+	 * superblock last write time, last mount time, and last
+	 * check time to be in the future by up to 24 hours (when
+	 * fsck called with -a/-p).
 	 */
 	if (fs->super->s_mtime > (__u32) ctx->now) {
 		pctx.num = fs->super->s_mtime;
 		problem = PR_0_FUTURE_SB_LAST_MOUNT;
-		if (fs->super->s_mtime <= (__u32) ctx->now + ctx->time_fudge)
+		if (fs->super->s_mtime <= (__u32) ctx->now + 86400)
 			problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
 		if (fix_problem(ctx, problem, &pctx)) {
 			fs->super->s_mtime = ctx->now;
@@ -838,7 +829,7 @@ void check_super_block(e2fsck_t ctx)
 	if (fs->super->s_wtime > (__u32) ctx->now) {
 		pctx.num = fs->super->s_wtime;
 		problem = PR_0_FUTURE_SB_LAST_WRITE;
-		if (fs->super->s_wtime <= (__u32) ctx->now + ctx->time_fudge)
+		if (fs->super->s_wtime <= (__u32) ctx->now + 86400)
 			problem = PR_0_FUTURE_SB_LAST_WRITE_FUDGED;
 		if (fix_problem(ctx, problem, &pctx)) {
 			fs->super->s_wtime = ctx->now;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index e629602..fe7093b 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -304,7 +304,7 @@ static void check_if_skip(e2fsck_t ctx)
 
 	lastcheck = fs->super->s_lastcheck;
 	if (lastcheck > ctx->now)
-		lastcheck -= ctx->time_fudge;
+		lastcheck -= 86400; /* see comment in super.c */
 	if ((fs->super->s_state & EXT2_ERROR_FS) ||
 	    !ext2fs_test_valid(fs))
 		reason = _(" contains a file system with errors");
-- 
1.6.3.3

