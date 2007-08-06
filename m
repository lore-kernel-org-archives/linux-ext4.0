From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH] e2fsck/e2fsprogs: use sscanf() instead of atoi() in the option parser
Date: Mon, 6 Aug 2007 12:53:55 +0200
Message-ID: <200708061253.56187.bs@q-leap.de>
References: <f8q6is$tg3$1@sea.gmane.org> <20070804021912.GG7449@thunk.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_E3vtG9Hi39MA/6d"
Cc: Bernd Schubert <bs@q-leap.de>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:60987 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbXHFLS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Aug 2007 07:18:58 -0400
In-Reply-To: <20070804021912.GG7449@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Boundary-00=_E3vtG9Hi39MA/6d
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Ted,

> In your patch submissions.  See the SUBMITTING-PATCHES file in the
> top-level directory of e2fsprogs source tree for the significance of
> the Signed-off-by line.  For this patch, can you indicate whether you
> are willing to add a Signed-off-by: DCO?

sorry that I did not read that file and so didn't know a signed-off is 
required.

Sure I'm willing to add a signed-off :) I'm also adding the patch again to 
this mail.


Signed-off-by: Bernd Schubert <bs@q-leap.de>


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH

--Boundary-00=_E3vtG9Hi39MA/6d
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="sscanf_instead_of_atoi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sscanf_instead_of_atoi.patch"

diff -r 7b057872ec06 e2fsck/unix.c
--- a/e2fsck/unix.c	Fri Jul 27 16:08:50 2007 +0200
+++ b/e2fsck/unix.c	Tue Jul 31 12:20:22 2007 +0200
@@ -585,6 +585,10 @@ static errcode_t PRS(int argc, char *arg
 #endif
 	char		*extended_opts = 0;
 	char		*cp;
+	int 		res;		/* result of sscanf */
+#ifdef CONFIG_JBD_DEBUG
+	char 		*jbd_debug;
+#endif
 
 	retval = e2fsck_allocate_context(&ctx);
 	if (retval)
@@ -614,7 +618,10 @@ static errcode_t PRS(int argc, char *arg
 		switch (c) {
 		case 'C':
 			ctx->progress = e2fsck_update_progress;
-			ctx->progress_fd = atoi(optarg);
+			res = sscanf(optarg, "%d", &ctx->progress_fd);
+			if (res != 1)
+				goto sscanf_err;
+
 			if (!ctx->progress_fd)
 				break;
 			/* Validate the file descriptor to avoid disasters */
@@ -674,20 +681,26 @@ static errcode_t PRS(int argc, char *arg
 			/* What we do by default, anyway! */
 			break;
 		case 'b':
-			ctx->use_superblock = atoi(optarg);
+			res = sscanf(optarg, "%d", &ctx->use_superblock);
+			if (res != 1)
+				goto sscanf_err;
 			ctx->flags |= E2F_FLAG_SB_SPECIFIED;
 			break;
 		case 'B':
 			ctx->blocksize = atoi(optarg);
 			break;
 		case 'I':
-			ctx->inode_buffer_blocks = atoi(optarg);
+			res = sscanf(optarg, "%d", &ctx->inode_buffer_blocks);
+			if (res != 1)
+				goto sscanf_err;
 			break;
 		case 'j':
 			ctx->journal_name = string_copy(ctx, optarg, 0);
 			break;
 		case 'P':
-			ctx->process_inode_size = atoi(optarg);
+			res = sscanf(optarg, "%d", &ctx->process_inode_size);
+			if (res != 1)
+				goto sscanf_err;
 			break;
 		case 'L':
 			replace_bad_blocks++;
@@ -830,10 +843,22 @@ static errcode_t PRS(int argc, char *arg
 		putenv(newpath);
 	}
 #ifdef CONFIG_JBD_DEBUG
-	if (getenv("E2FSCK_JBD_DEBUG"))
-		journal_enable_debug = atoi(getenv("E2FSCK_JBD_DEBUG"));
+	jbd_debug = getenv("E2FSCK_JBD_DEBUG");
+	if (jbd_debug)
+		res = sscanf(jbd_debug, "%d", &journal_enable_debug);
+		if (res != 1) {
+			fprintf(stderr,
+			        _("\nInvalid argument \"%s\", not an integer\n\n"),
+			        jbd_debug);
+			exit (1);
+		}
 #endif
 	return 0;
+
+sscanf_err:
+	fprintf(stderr, _("\nInvalid argument \"%s\", not an integer\n\n"),
+	        optarg);
+	exit (1);
 }
 
 static const char *my_ver_string = E2FSPROGS_VERSION;

--Boundary-00=_E3vtG9Hi39MA/6d--
