Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF15CC43218
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 13:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 819832077B
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 13:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DASxXibD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfDZNJn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:09:43 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:56104 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfDZNJm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Apr 2019 09:09:42 -0400
Received: by mail-it1-f194.google.com with SMTP id y134so5697450itc.5
        for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2019 06:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Zf0Gch2ThL9QbjasfCYI0waaxxpAPURL3JxXbNjeGA4=;
        b=DASxXibDuUKFiI6rSr7yUqm/0wVDODs5cPXhHnk9Wkqr/w7olJwIFd26vaCBExeG1V
         DmPq+qPAQqWlYH5FsZvexTuLtbdcyUAeeFCa/FeZMb42bwQlSjQ7G1KLSGr/jLwtfxIh
         qZmFHTqCWbXTKqc5EmsxlGHq3DbkH3q7nPC4ARV6nwCpFxYcFqikewPPvwX2jN96Ggpa
         dFea3DVyVOUNjXABtR7xCeqc3EaTX2W5rgZYhdeeCEKsLqyzgEueT5sEaBeSxXDrJz9q
         bOpLrFEXnEYiI3bz1VrkKN4X3q7TzjkPryJIpv92sEJ+ICB21xlVtxT211hFv4gGLuT9
         29FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Zf0Gch2ThL9QbjasfCYI0waaxxpAPURL3JxXbNjeGA4=;
        b=NZeUDL3k4KRf3Nv+qO8M1/IHw1L8Nhp4L/8a9//+TVapJfMwWPeItIoJP1Bm0uP6Zo
         NR0668uPb+ZA3+R0rlNrahAQv8LfzdD5wJBLH564XTHv4q1me5q397sJU5Gw9FPFxIRp
         /HITkFaUpRgacVlKWn1DWtBgv+pKqT6DWYn+oqIFWBEXFWPmWQQNOySBdPHG7JZDETp6
         q+eCiUSrlcd4wvlU1ZhrelPftHxzoDwIqNf0kBrGDQbFERskaf3s3TCEiH07MYu7CY8G
         saaT0W+M9oDyIjP+KbMAcqi3GjeBnXxItOvM2cF3RPMu1cwi/KX66i0IMkjKfZ3AESSl
         Odpg==
X-Gm-Message-State: APjAAAWIHRur6QaiMtjXz4RX7JwZ1WieDcAkBpxANuyNrEUdmKv1a6t7
        Ealwuy6RZPqCTR3Qmn8jJGAqJ/TLxqm8Qw==
X-Google-Smtp-Source: APXvYqyINF7owZq9O6Cy93OGBbVaTPNTPOE7m4CrnuMIANHCoJzgslNN0q8utYAxEUI3aYr/wA9cCQ==
X-Received: by 2002:a24:62c4:: with SMTP id d187mr1435314itc.175.1556284181530;
        Fri, 26 Apr 2019 06:09:41 -0700 (PDT)
Received: from C02TN4C6HTD6.us.cray.com (chippewa-nat.cray.com. [136.162.34.1])
        by smtp.gmail.com with ESMTPSA id j10sm1310741iop.39.2019.04.26.06.09.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 06:09:40 -0700 (PDT)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     alexey.lyashkov@gmail.com, Alexey Lyashkov <c17817@cray.com>
Subject: [PATCH] e2fsck: Do not to be quiet if verbose option used.
Date:   Fri, 26 Apr 2019 16:09:13 +0300
Message-Id: <20190426130913.9288-1-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Alexey Lyashkov <c17817@cray.com>

e2fsck don't print a message if 'p' option used and error can be fixed without
user assistance,  but 'v' option asks to be more verbose, so user expect to
see any output. But not.
Fix this, by avoid message suppress with verbose option used.

Change-Id: I358e9b04e44dd33fdb124c5663b2df0bf54ce370
Signed-off-by: Alexey Lyashkov <c17817@cray.com>
Cray-bug-id: LUS-6890
---
 e2fsck/e2fsck.h  |  1 +
 e2fsck/problem.c |  3 ++-
 e2fsck/unix.c    | 15 ++++++++-------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 1c7a67cb..64140fc3 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -174,6 +174,7 @@ struct resource_track {
 #define E2F_OPT_NOOPT_EXTENTS	0x10000 /* don't optimize extents */
 #define E2F_OPT_ICOUNT_FULLMAP	0x20000 /* use an array for inode counts */
 #define E2F_OPT_UNSHARE_BLOCKS  0x40000
+#define E2F_OPT_VERBOSE		0x80000 /* be verbose and PREEN_NOMSG ignore */
 
 /*
  * E2fsck flags
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0e6bacec..2576c9bb 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -2259,7 +2259,8 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 		if (ldesc->flags & PRL_SUPPRESS)
 			suppress++;
 	}
-	if ((ptr->flags & PR_PREEN_NOMSG) &&
+	if (((ctx->options & E2F_OPT_VERBOSE) == 0) &&
+	    (ptr->flags & PR_PREEN_NOMSG) &&
 	    (ctx->options & E2F_OPT_PREEN))
 		suppress++;
 	if ((ptr->flags & PR_NO_NOMSG) &&
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 5b3552ec..b073615e 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -60,7 +60,6 @@ extern int optind;
 /* Command line options */
 static int cflag;		/* check disk */
 static int show_version_only;
-static int verbose;
 
 static int replace_bad_blocks;
 static int keep_bad_blocks;
@@ -133,7 +132,7 @@ static void show_stats(e2fsck_t	ctx)
 		frag_percent_total = (frag_percent_total + 5) / 10;
 	}
 
-	if (!verbose) {
+	if ((ctx->options & E2F_OPT_VERBOSE) == 0) {
 		log_out(ctx, _("%s: %u/%u files (%0d.%d%% non-contiguous), "
 			       "%llu/%llu blocks\n"),
 			ctx->device_name, inodes_used, inodes,
@@ -143,7 +142,7 @@ static void show_stats(e2fsck_t	ctx)
 	}
 	profile_get_boolean(ctx->profile, "options", "report_features", 0, 0,
 			    &i);
-	if (verbose && i) {
+	if ((ctx->options & E2F_OPT_VERBOSE) && i) {
 		log_out(ctx, "\nFilesystem features:");
 		mask = &ctx->fs->super->s_feature_compat;
 		for (i = 0; i < 3; i++, mask++) {
@@ -807,6 +806,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	char 		*jbd_debug;
 #endif
 	unsigned long long phys_mem_kb;
+	int		verbose = 0;
 
 	retval = e2fsck_allocate_context(&ctx);
 	if (retval)
@@ -1037,8 +1037,8 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		ctx->options |= E2F_OPT_TIME | E2F_OPT_TIME2;
 	profile_get_boolean(ctx->profile, "options", "report_verbose", 0, 0,
 			    &c);
-	if (c)
-		verbose = 1;
+	if (c || verbose)
+		ctx->options |= E2F_OPT_VERBOSE;
 
 	profile_get_boolean(ctx->profile, "options", "no_optimize_extents",
 			    0, 0, &c);
@@ -1231,8 +1231,9 @@ static errcode_t e2fsck_check_mmp(ext2_filsys fs, e2fsck_t ctx)
 	if (retval)
 		goto check_error;
 
-	/* Print warning if e2fsck will wait for more than 20 secs. */
-	if (verbose || wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4) {
+	/* Print warning if e2fck will wait for more than 20 secs. */
+	if ((ctx->options & E2F_OPT_VERBOSE) ||
+	     wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4) {
 		log_out(ctx, _("MMP interval is %u seconds and total wait "
 			       "time is %u seconds. Please wait...\n"),
 			mmp_check_interval, wait_time * 2);
-- 
2.14.3

