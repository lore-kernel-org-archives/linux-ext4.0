From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Always fix last mount/write/check time with -p
Date: Fri, 16 Oct 2009 21:03:30 -0400
Message-ID: <20091017010330.GA8081@mit.edu>
References: <E1MxMjT-0003XH-Mn@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Scott James Remnant <scott@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51424 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZJQGGh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2009 02:06:37 -0400
Content-Disposition: inline
In-Reply-To: <E1MxMjT-0003XH-Mn@zelda.netsplit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2009 at 04:10:31PM +0100, Scott James Remnant wrote:
>  - Installing onto a system with an externally synchronised hardware
>    clock, where the hardware clock is (without the user's knowledge
>    and beyond the capabilities of the Installer to detect) being set
>    to local time.
> 
>    Again, each time NTP will fix the problem, but after each reboot
>    the mount time will again be in the future.
> 
>    (This is a common case when using virtualisation, where the hardware
>     clock is in fact being emulated based off something's system clock.)

I'm pretty sure this is caused by a buggy or misconfigured
virtualization manager.  The host OS knows the correct time, and the
guest OS's (emulated) RTC hardware clock should be set the host OS's
system time, which should be correct.  In fact qemu and kvm have an
option which controls this:

       -localtime
           Set the real time clock to local time (the default is to UTC time).
           This option is needed to have correct date in MS-DOS or Windows.

Qemu's default is correct for Linux, so I'm guessing either the user
copied a configuration for Windows, or the virtualization manager was
set up by default for running Windows as a guest OS.

In any case, I accept that in some cases it's not possible for the
distribution to do the right thing.  I do want to leave the
possibility for a "strict mode", in the hopes that one day we can do a
better job.  So here's what I ultimately checked into e2fsprogs.

       	     	       	      		 	 - Ted

>From ba5131f6d48eded504e84c2a8ffc8131df8a512e Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 16 Oct 2009 20:46:45 -0400
Subject: [PATCH] e2fsck: Accept superblock times to be fudged by up to 24 hours by default

Unfortunately, due to Windows' unfortunate design decision to
configure the hardware clock to tick localtime, instead of the more
proper and less error-prone UTC time, many users end up in the
situation where the system clock is incorrectly set at the time when
e2fsck is run.

Historically this was usually due to some distributions having buggy
init scripts and/or installers that didn't correctly detect this case
and take appropriate countermeasures.  However, it's still possible,
despite the best efforts of init script and installer authors to not
be able to detect this misconfiguration, usually due to a buggy or
misconfigured virtualization manager or the installer not having
access to a network time server during the installation process.  So
by default, we allow the superblock times to be fudged by up to 24
hours.  This can be disabled by setting options.accept_time_fudge to
the boolean value of false in e2fsck.conf.  The old
options.buggy_init_scripts is left for backwards compatibility.

Since we are now accepting the 24 hour time fudge by default, there is
no longer a need to install an Ubuntu-specific e2fsck.conf file, so we
can remove it.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debian/rules              |    6 ------
 e2fsck/e2fsck.conf.5.in   |   36 ++++++++++++++++++++++--------------
 e2fsck/e2fsck.conf.ubuntu |    2 --
 e2fsck/problem.c          |    4 ++--
 e2fsck/super.c            |   42 ++++++++++++++++++++++++------------------
 5 files changed, 48 insertions(+), 42 deletions(-)
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
index 6638a39..a5021bd 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -87,19 +87,27 @@ interrupts e2fsck using ^C, and the filesystem is not explicitly flagged
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
+.I accept_time_fudge
+Unfortunately, due to Windows' unfortunate design decision
+to configure the hardware clock to tick localtime, instead
+of the more proper and less error-prone UTC time, many
+users end up in the situation where the system clock is
+incorrectly set at the time when e2fsck is run.
+.IP
+Historically this was usually due to some distributions
+having buggy init scripts and/or installers that didn't
+correctly detect this case and take appropriate
+countermeasures.  However, it's still possible, despite the
+best efforts of init script and installer authors to not be
+able to detect this misconfiguration, usually due to a
+buggy or misconfigured virtualization manager or the
+installer not having access to a network time server
+during the installation process.  So by default, we allow
+the superblock times to be fudged by up to 24 hours.
+This can be disabled by setting
+.I accept_time_fudge
+to the
+boolean value of false.  This setting defaults to true.
 .TP
 .I clear_test_fs_flag
 This boolean relation controls whether or not 
@@ -111,7 +119,7 @@ defaults to true.
 .I defer_check_on_battery
 This boolean relation controls whether or not the interval between 
 filesystem checks (either based on time or number of mounts) should 
-be doubled if the system is running on battery.  It defaults to 
+be doubled if the system is running on battery.  This setting defaults to 
 true.
 .TP
 .I indexed_dir_slack_percentage
diff --git a/e2fsck/e2fsck.conf.ubuntu b/e2fsck/e2fsck.conf.ubuntu
deleted file mode 100644
index 49d6d19..0000000
--- a/e2fsck/e2fsck.conf.ubuntu
+++ /dev/null
@@ -1,2 +0,0 @@
-[options]
-	buggy_init_scripts = 1
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 540ac91..a713f1b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -388,13 +388,13 @@ static struct e2fsck_problem problem_table[] = {
 	/* Last mount time is in the future (fudged) */
 	{ PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
 	  N_("@S last mount time is in the future.\n\t(by less than a day, "
-	     "probably due to buggy init scripts)  "),
+	     "probably due to the hardware clock being incorrectly set)  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	/* Last write time is in the future (fudged) */
 	{ PR_0_FUTURE_SB_LAST_WRITE_FUDGED,
 	  N_("@S last write time is in the future.\n\t(by less than a day, "
-	     "probably due to buggy init scripts).  "),
+	     "probably due to the hardware clock being incorrectly set).  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	/* Block group checksum (latch question) is invalid. */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index c946664..951f6db 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -463,7 +463,7 @@ void check_super_block(e2fsck_t ctx)
 	int	inodes_per_block;
 	int	ipg_max;
 	int	inode_size;
-	int	buggy_init_scripts;
+	int	accept_time_fudge;
 	dgrp_t	i;
 	blk_t	should_be;
 	struct problem_context	pctx;
@@ -795,25 +795,31 @@ void check_super_block(e2fsck_t ctx)
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
+	 * Unfortunately, due to Windows' unfortunate design decision
+	 * to configure the hardware clock to tick localtime, instead
+	 * of the more proper and less error-prone UTC time, many
+	 * users end up in the situation where the system clock is
+	 * incorrectly set at the time when e2fsck is run.
+	 *
+	 * Historically this was usually due to some distributions
+	 * having buggy init scripts and/or installers that didn't
+	 * correctly detect this case and take appropriate
+	 * countermeasures.  However, it's still possible, despite the
+	 * best efforts of init script and installer authors to not be
+	 * able to detect this misconfiguration, usually due to a
+	 * buggy or misconfigured virtualization manager or the
+	 * installer not having access to a network time server during
+	 * the installation process.  So by default, we allow the
+	 * superblock times to be fudged by up to 24 hours.  This can
+	 * be disabled by setting options.accept_time_fudge to the
+	 * boolean value of false in e2fsck.conf.  We also support
+	 * options.buggy_init_scripts for backwards compatibility.
 	 */
+	profile_get_boolean(ctx->profile, "options", "accept_time_fudge",
+			    0, 1, &accept_time_fudge);
 	profile_get_boolean(ctx->profile, "options", "buggy_init_scripts",
-			    0, 0, &buggy_init_scripts);
-	ctx->time_fudge = buggy_init_scripts ? 86400 : 0;
+			    0, accept_time_fudge, &accept_time_fudge);
+	ctx->time_fudge = accept_time_fudge ? 86400 : 0;
 
 	/*
 	 * Check to see if the superblock last mount time or last
-- 
1.6.5.104.g2567b.dirty

