From: Jan Kara <jack@suse.cz>
Subject: [PATCH] e2fsck: Don't skip time based checks if broken_system_clock=1 unnecessarily
Date: Fri, 28 Mar 2014 04:15:31 +0100
Message-ID: <1395976531-7447-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaC1DPj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Mar 2014 23:15:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When option broken_system_clock is set, we unconditionally skip checks
whether e2fsck should check the fs because the fs was last checked too
long ago. Distributions however set broken_system_clock by default as
some of the systems simply have the clocks broken and e2fsck stops the
boot because of that which is harsh given how minor issue that is (at
least for the fs). Thus checking every X days doesn't work with these
distributions.

Change slightly how broken_system_clock works to make it more useful. We
first check in the superblock whether the current time and times stored
in the superblock look sensible. If yes, we also do honor check
interval. If the current time and times in superblock don't correspond
properly, we skip the check interval test.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 e2fsck/super.c | 44 ++++++++++++++++++++++++++------------------
 e2fsck/unix.c  | 11 ++++++-----
 2 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index e9892e2db6b3..f2bdf98f26dc 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -840,28 +840,36 @@ void check_super_block(e2fsck_t ctx)
 	 * Check to see if the superblock last mount time or last
 	 * write time is in the future.
 	 */
-	if (!broken_system_clock &&
-	    !(ctx->flags & E2F_FLAG_TIME_INSANE) &&
+	if (!(ctx->flags & E2F_FLAG_TIME_INSANE) &&
 	    fs->super->s_mtime > (__u32) ctx->now) {
-		pctx.num = fs->super->s_mtime;
-		problem = PR_0_FUTURE_SB_LAST_MOUNT;
-		if (fs->super->s_mtime <= (__u32) ctx->now + ctx->time_fudge)
-			problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
-		if (fix_problem(ctx, problem, &pctx)) {
-			fs->super->s_mtime = ctx->now;
-			fs->flags |= EXT2_FLAG_DIRTY;
+		if (broken_system_clock)
+			ctx->flags |= E2F_FLAG_TIME_INSANE;
+		else {
+			pctx.num = fs->super->s_mtime;
+			problem = PR_0_FUTURE_SB_LAST_MOUNT;
+			if (fs->super->s_mtime <=
+			    (__u32) ctx->now + ctx->time_fudge)
+				problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
+			if (fix_problem(ctx, problem, &pctx)) {
+				fs->super->s_mtime = ctx->now;
+				fs->flags |= EXT2_FLAG_DIRTY;
+			}
 		}
 	}
-	if (!broken_system_clock &&
-	    !(ctx->flags & E2F_FLAG_TIME_INSANE) &&
+	if (!(ctx->flags & E2F_FLAG_TIME_INSANE) &&
 	    fs->super->s_wtime > (__u32) ctx->now) {
-		pctx.num = fs->super->s_wtime;
-		problem = PR_0_FUTURE_SB_LAST_WRITE;
-		if (fs->super->s_wtime <= (__u32) ctx->now + ctx->time_fudge)
-			problem = PR_0_FUTURE_SB_LAST_WRITE_FUDGED;
-		if (fix_problem(ctx, problem, &pctx)) {
-			fs->super->s_wtime = ctx->now;
-			fs->flags |= EXT2_FLAG_DIRTY;
+		if (broken_system_clock)
+			ctx->flags |= E2F_FLAG_TIME_INSANE;
+		else {
+			pctx.num = fs->super->s_wtime;
+			problem = PR_0_FUTURE_SB_LAST_WRITE;
+			if (fs->super->s_wtime <=
+			    (__u32) ctx->now + ctx->time_fudge)
+				problem = PR_0_FUTURE_SB_LAST_WRITE_FUDGED;
+			if (fix_problem(ctx, problem, &pctx)) {
+				fs->super->s_wtime = ctx->now;
+				fs->flags |= EXT2_FLAG_DIRTY;
+			}
 		}
 	}
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b39383d7ef70..9caa17c02f9c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -371,13 +371,13 @@ static void check_if_skip(e2fsck_t ctx)
 		if (batt && (fs->super->s_mnt_count <
 			     (unsigned) fs->super->s_max_mnt_count*2))
 			reason = 0;
-	} else if (!broken_system_clock && fs->super->s_checkinterval &&
-		   (ctx->now < lastcheck)) {
+	} else if (!(ctx->flags & E2F_FLAG_TIME_INSANE) &&
+		   fs->super->s_checkinterval && (ctx->now < lastcheck)) {
 		reason = _(" has filesystem last checked time in the future");
 		if (batt)
 			reason = 0;
-	} else if (!broken_system_clock && fs->super->s_checkinterval &&
-		   ((ctx->now - lastcheck) >=
+	} else if (!(ctx->flags & E2F_FLAG_TIME_INSANE) &&
+		   fs->super->s_checkinterval && ((ctx->now - lastcheck) >=
 		    ((time_t) fs->super->s_checkinterval))) {
 		reason = _(" has gone %u days without being checked");
 		reason_arg = (ctx->now - fs->super->s_lastcheck)/(3600*24);
@@ -434,7 +434,8 @@ static void check_if_skip(e2fsck_t ctx)
 		if (next_check <= 0)
 			next_check = 1;
 	}
-	if (!broken_system_clock && fs->super->s_checkinterval &&
+	if (!(ctx->flags & E2F_FLAG_TIME_INSANE) &&
+	    fs->super->s_checkinterval &&
 	    ((ctx->now - fs->super->s_lastcheck) >= fs->super->s_checkinterval))
 		next_check = 1;
 	if (next_check <= 5) {
-- 
1.8.1.4

