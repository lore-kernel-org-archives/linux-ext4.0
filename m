From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/4] e2fsck: Add QCOW2 support
Date: Fri, 25 Feb 2011 13:49:33 +0100
Message-ID: <1298638173-25050-4-git-send-email-lczerner@redhat.com>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab1BYMt6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Feb 2011 07:49:58 -0500
In-Reply-To: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds QCOW2 support for e2fsck. In order to avoid creating
real QCOW2 image support, which would require creating a lot of code, we
simply bypass the problem by converting the QCOW2 image into raw image
and than let e2fsck work with raw image. Conversion itself can be quite
fast, so it should not be a serious slowdown.

Add '-Q' option to specify path for the raw image. It not specified the
raw image will be saved in /tmp direcotry in format
<qcow2_filename>.raw.XXXXXX, where X chosen randomly.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/e2fsck.8.in |    8 +++++-
 e2fsck/unix.c      |   74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 3fb15e6..36d1492 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -8,7 +8,7 @@ e2fsck \- check a Linux ext2/ext3/ext4 file system
 .SH SYNOPSIS
 .B e2fsck
 [
-.B \-pacnyrdfkvtDFV
+.B \-pacnyrdfkvtDFVQ
 ]
 [
 .B \-b
@@ -263,6 +263,12 @@ will print a description of the problem and then exit with the value 4
 logically or'ed into the exit code.  (See the \fBEXIT CODE\fR section.)
 This option is normally used by the system's boot scripts.  It may not 
 be specified at the same time as the
+.TP
+.BI \-Q " filename"
+When e2fsck is attempting to check QCOW2 image, it has to convert QCOW2
+into raw image. This option specify the filename for the raw image. If
+this option is ommited, raw image will be created in /tmp direcotry.
+.TP
 .B \-n
 or
 .B \-y
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7eb269c..acfff47 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -19,6 +19,7 @@
 #include <fcntl.h>
 #include <ctype.h>
 #include <time.h>
+#include <limits.h>
 #ifdef HAVE_SIGNAL_H
 #include <signal.h>
 #endif
@@ -53,6 +54,7 @@ extern int optind;
 #include "e2p/e2p.h"
 #include "e2fsck.h"
 #include "problem.h"
+#include "ext2fs/qcow2.h"
 #include "../version.h"
 
 /* Command line options */
@@ -626,8 +628,10 @@ static const char *config_fn[] = { ROOT_SYSCONFDIR "/e2fsck.conf", 0 };
 
 static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 {
-	int		flush = 0;
-	int		c, fd;
+	int		flush = 0, raw_name_set = 0;
+	int		c, fd, qcow2_fd;
+	struct		ext2_qcow2_hdr *header = NULL;
+	char		*d_name, raw_name[PATH_MAX];
 #ifdef MTRACE
 	extern void	*mallwatch;
 #endif
@@ -667,7 +671,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		ctx->program_name = *argv;
 	else
 		ctx->program_name = "e2fsck";
-	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
+	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDkQ:")) != EOF)
 		switch (c) {
 		case 'C':
 			ctx->progress = e2fsck_update_progress;
@@ -790,6 +794,10 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		case 'k':
 			keep_bad_blocks++;
 			break;
+		case 'Q':
+			raw_name_set++;
+			snprintf(raw_name, PATH_MAX, "%s", optarg);
+			break;
 		default:
 			usage(ctx);
 		}
@@ -819,10 +827,66 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	ctx->io_options = strchr(argv[optind], '?');
 	if (ctx->io_options)
 		*ctx->io_options++ = 0;
-	ctx->filesystem_name = blkid_get_devname(ctx->blkid, argv[optind], 0);
+
+	d_name = argv[optind];
+
+	/* Check whether the device, of image is QCOW2 */
+#ifdef HAVE_OPEN64
+	qcow2_fd = open64(d_name, O_RDONLY);
+#else
+	qcow2_fd = open(d_name, O_RDONLY);
+#endif
+	if (qcow2_fd < 0)
+		goto skip_qcow2;
+
+	header = qcow2_read_header(qcow2_fd, d_name);
+	if (header) {
+		int raw_fd;
+		char *path;
+		/*
+		 * We have qcow2 image, so need to convert it into raw
+		 * image, then pass its filename into further e2fsck code.
+		 */
+		if (!raw_name_set) {
+			if (!(path = strdup(d_name)))
+				fatal_error(ctx, "Could not allocate path");
+			snprintf(raw_name, PATH_MAX, "/tmp/%s.raw.XXXXXX",
+				 basename(path));
+			free(path);
+			raw_fd = mkstemp(raw_name);
+			printf(_("QCOW2 image detected! Converting into raw"
+				 " image = %s\n"), raw_name);
+		} else {
+#ifdef HAVE_OPEN64
+			raw_fd = open64(raw_name, O_CREAT|O_TRUNC|O_WRONLY, 0600);
+#else
+			raw_fd = open(raw_name, O_CREAT|O_TRUNC|O_WRONLY, 0600);
+#endif
+		}
+
+		if (raw_fd < 0) {
+			com_err(ctx->program_name, errno,
+				_("while opening raw image file %s"),raw_name);
+			fatal_error(ctx, 0);
+		}
+
+		retval = qcow2_write_raw_image(qcow2_fd, raw_fd, header);
+		if (retval) {
+			com_err(ctx->program_name, retval,
+				_("while converting qcow image %s into "
+				  "raw image %s"),d_name, raw_name);
+			fatal_error(ctx, 0);
+		}
+		close(raw_fd);
+		d_name = raw_name;
+	}
+	close(qcow2_fd);
+
+skip_qcow2:
+	ctx->filesystem_name = blkid_get_devname(ctx->blkid, d_name, 0);
 	if (!ctx->filesystem_name) {
 		com_err(ctx->program_name, 0, _("Unable to resolve '%s'"),
-			argv[optind]);
+			d_name);
 		fatal_error(ctx, 0);
 	}
 	if (extended_opts)
-- 
1.7.4

