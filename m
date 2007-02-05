From: Jim Garlick <garlick@llnl.gov>
Subject: [repost][patch 1/2] e2fsprogs: user selectable dup block handling
 in fsck (fwd)
Date: Sun, 4 Feb 2007 17:28:38 -0800 (PST)
Message-ID: <Pine.LNX.4.61.0702041720460.31030@webb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:19219 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbXBEB2i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Feb 2007 20:28:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a refresh of the e2fsck patches I sent last week, reflecting
comments received from the list and correcting one oversight.

The first patch (below), in addition to causing the config file to be 
parsed before command line args, now makes -E parsing cumulative.

The second patch has some cosmetic changes and a bug fix - now it gets 
the block bitmap and block alloc stats right after clone=zero processing.

Thanks,

Jim

---------- Forwarded message ----------
Date: Wed, 31 Jan 2007 08:22:20 -0800 (PST)
From: Jim Garlick <garlick@llnl.gov>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Subject: [patch 1/2] e2fsprogs: user selectable dup block handling in fsck

Hello,

E2fsck fixes files that are found to be sharing blocks by cloning
the shared blocks and giving each file a private copy in pass 1D.

Allowing all files claiming the shared blocks to have copies can
inadvertantly bypass access restrictions.  Deleting all the files, 
zeroing the cloned blocks, or placing the files in the /lost+found 
directory after cloning may be preferable in some secure environments.

The following patches implement config file and command line options 
in e2fsck that allow pass 1D behavior to be tuned according to site 
policy.

The first patch changes the order that the config file and command 
line are parsed so that command line has precedence.  It also adds 
a check to make sure only one -E option is passed on the command
line as -E option parsing is not cumulative.

The second patch adds two extended options and config file 
counterparts.  On the command line:

  -E clone=dup|zero

     Select the block cloning method.  "dup" is old behavior which remains
     the default.  "zero" is a new method that substitutes zero-filled
     blocks for the shared blocks in all the files that claim them.

  -E shared=preserve|lost+found|delete

     Select the disposition of files containing shared blocks.  "preserve"
     is the old behavior which remains the default.  "lost+found" causes
     files to be unlinked after cloning so they will be reconnected to
     /lost+found in pass 3.   "delete" skips cloning entirely and simply
     deletes the files.

In the config file:
   [options]
       clone=dup|zero
       shared=preserve|lost+found|delete

Regards,

Jim Garlick
Lawrence Livermore National Laboratory


Index: e2fsprogs+chaos/e2fsck/unix.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/unix.c
+++ e2fsprogs+chaos/e2fsck/unix.c
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
Index: e2fsprogs+chaos/e2fsck/ChangeLog
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/ChangeLog
+++ e2fsprogs+chaos/e2fsck/ChangeLog
@@ -1,3 +1,8 @@
+2007-01-30  Jim Garlick  <garlick@llnl.gov>
+
+	* unix.c: Parse config file before command line so command line
+		has precedence.  Make -E option parsing cumulative.
+
  2006-11-14  Theodore Tso  <tytso@mit.edu>

  	* unix.c (PRS): Always allocate the replacement PATH environment
