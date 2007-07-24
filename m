From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 8/13] Config before command line.
Date: Tue, 24 Jul 2007 16:35:02 +0530
Message-ID: <1185275102.3789.73.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40570 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbXGXLEa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:04:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The patch changes the order that the config file and command line are parsed so
that command line has precedence.  It also adds a check to make sure only one -E
option is passed on the command line as -E option parsing is not cumulative.

Signed-off-by: Jim Garlick  <garlick@llnl.gov>

Index: e2fsprogs-1.40.1/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.1/e2fsck/unix.c
@@ -583,7 +583,6 @@ static errcode_t PRS(int argc, char *arg
 #ifdef HAVE_SIGNAL_H
 	struct sigaction	sa;
 #endif
-	char		*extended_opts = 0;
 	char		*cp;
 
 	retval = e2fsck_allocate_context(&ctx);
@@ -610,6 +609,12 @@ static errcode_t PRS(int argc, char *arg
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
@@ -633,7 +638,7 @@ static errcode_t PRS(int argc, char *arg
 			ctx->options |= E2F_OPT_COMPRESS_DIRS;
 			break;
 		case 'E':
-			extended_opts = optarg;
+			parse_extended_opts(ctx, optarg);
 			break;
 		case 'p':
 		case 'a':
@@ -753,13 +758,6 @@ static errcode_t PRS(int argc, char *arg
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
