From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] e2fsck: add the max_count_problems setting in e2fsck.conf
Date: Sun, 18 Mar 2012 15:52:47 -0400
Message-ID: <1332100368-2683-5-git-send-email-tytso@mit.edu>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40347 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212Ab2CRTwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 15:52:47 -0400
In-Reply-To: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also add appropriate documentation for options/max_count_problems and
problems/0xXXXXXX/max_count settings in /etc/e2fsck.conf

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/e2fsck.conf.5.in |   12 ++++++++++++
 e2fsck/problem.c        |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index 2a600d0..a89d7b4 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -136,6 +136,13 @@ filesystem checks (either based on time or number of mounts) should
 be doubled if the system is running on battery.  This setting defaults to 
 true.
 .TP
+.I max_count_problems
+This relation specifies the maximum number of problem reports of a
+particular type will be printed to stdout before further problem reports
+of that type are squelched.  This can be useful if the console is slow
+(i.e., connected to a serial port) and so a large amount of output could
+end up delaying the boot process for a long time (potentially hours).
+.TP
 .I indexed_dir_slack_percentage
 When
 .BR e2fsck (8)
@@ -171,6 +178,11 @@ whether this filesystem problem should be automatically fixed when
 .B e2fsck
 is running in preen mode.
 .TP
+.I max_count
+This integer relation overrides the 
+.I max_count_problems
+parameter (set in the options section) for this particular problem.
+.TP
 .I no_ok
 This boolean relation overrides the default behavior determining
 whether or not the filesystem will be marked as inconsistent if the user
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 7d5b10d..06eb179 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1824,6 +1824,9 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 		reconfigure_bool(ctx, ptr, key, PR_NO_NOMSG, "no_nomsg");
 		reconfigure_bool(ctx, ptr, key, PR_PREEN_NOHDR, "preen_noheader");
 		reconfigure_bool(ctx, ptr, key, PR_FORCE_NO, "force_no");
+		profile_get_integer(ctx->profile, "options",
+				    "max_count_problems", 0, 0,
+				    &ptr->max_count);
 		profile_get_integer(ctx->profile, "problems", key, "max_count",
 				    ptr->max_count, &ptr->max_count);
 
-- 
1.7.9.107.g97f9a

