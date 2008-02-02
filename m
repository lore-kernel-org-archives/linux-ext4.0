From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][8/28] e2fsprogs-config-before-cmdline.patch
Date: Sat, 02 Feb 2008 01:29:25 -0700
Message-ID: <20080202082925.GI31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58343 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbYBBI32 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:29:28 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128TSD7016540
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:29:28 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00101RH2RF00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:29:28 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch changes the order that the config file and command line are
parsed so that command line has precedence.  It also allows multiple
-E options to be specified on the command line.

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.4/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.4/e2fsck/unix.c
@@ -588,7 +588,6 @@ static errcode_t PRS(int argc, char *arg
 #ifdef HAVE_SIGNAL_H
 	struct sigaction	sa;
 #endif
-	char		*extended_opts = 0;
 	char		*cp;
 	int 		res;		/* result of sscanf */
 #ifdef CONFIG_JBD_DEBUG
@@ -619,6 +618,12 @@ static errcode_t PRS(int argc, char *arg
 		ctx->program_name = *argv;
 	else
 		ctx->program_name = "e2fsck";
+
+	if ((cp = getenv("E2FSCK_CONFIG")) != NULL)
+		config_fn[0] = cp;
+	profile_set_syntax_err_cb(syntax_err_report);
+	profile_init(config_fn, &ctx->profile);
+
 	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
 		case 'C':
@@ -645,7 +650,7 @@ static errcode_t PRS(int argc, char *arg
 			ctx->options |= E2F_OPT_COMPRESS_DIRS;
 			break;
 		case 'E':
-			extended_opts = optarg;
+			parse_extended_opts(ctx, optarg);
 			break;
 		case 'p':
 		case 'a':
@@ -771,13 +776,6 @@ static errcode_t PRS(int argc, char *arg
 			argv[optind]);
 		fatal_error(ctx, 0);
 	}
-	if (extended_opts)
-		parse_extended_opts(ctx, extended_opts);
-
-	if ((cp = getenv("E2FSCK_CONFIG")) != NULL)
-		config_fn[0] = cp;
-	profile_set_syntax_err_cb(syntax_err_report);
-	profile_init(config_fn, &ctx->profile);
 
 	if (flush) {
 		fd = open(ctx->filesystem_name, O_RDONLY, 0);

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
