From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][2/15] e2fsprogs-config-before-cmdline.patch
Date: Mon, 06 Oct 2008 16:01:08 +0530
Message-ID: <1223289068.4007.84.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_jzkfNuWpTLl9qcBQgTB6kw)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:59574 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYJFKb1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:31:27 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AVPSW027217
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:31:25 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00M01BS36U00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:31:25 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_jzkfNuWpTLl9qcBQgTB6kw)
Content-type: text/plain
Content-transfer-encoding: 7BIT

The patch changes the order that the config file and command line are
parsed so that command line has precedence.  It also adds a check to
make sure only one -E option is passed on the command line as -E option
parsing is not cumulative.

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: Andreas Dilger <adilger@sun.com>


--Boundary_(ID_jzkfNuWpTLl9qcBQgTB6kw)
Content-type: text/x-patch; charset=UTF-8;
 name=e2fsprogs-config-before-cmdline.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-config-before-cmdline.patch

The patch changes the order that the config file and command line are
parsed so that command line has precedence.  It also adds a check to
make sure only one -E option is passed on the command line as -E option
parsing is not cumulative.

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.11/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.11.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.11/e2fsck/unix.c
@@ -589,7 +589,6 @@ static errcode_t PRS(int argc, char *arg
 #ifdef HAVE_SIGNAL_H
 	struct sigaction	sa;
 #endif
-	char		*extended_opts = 0;
 	char		*cp;
 	int 		res;		/* result of sscanf */
 #ifdef CONFIG_JBD_DEBUG
@@ -620,6 +619,12 @@ static errcode_t PRS(int argc, char *arg
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
@@ -650,7 +655,7 @@ static errcode_t PRS(int argc, char *arg
 			ctx->options |= E2F_OPT_COMPRESS_DIRS;
 			break;
 		case 'E':
-			extended_opts = optarg;
+			parse_extended_opts(ctx, optarg);
 			break;
 		case 'p':
 		case 'a':
@@ -777,13 +782,6 @@ static errcode_t PRS(int argc, char *arg
 		fatal_error(ctx, 0);
 	}
 	ctx->filesystem_name = string_copy(ctx, ctx->filesystem_name, 0);
-	if (extended_opts)
-		parse_extended_opts(ctx, extended_opts);
--Boundary_(ID_jzkfNuWpTLl9qcBQgTB6kw)--
