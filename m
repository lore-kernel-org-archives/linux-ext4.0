From: Bernd Schubert <bschubert@q-leap.de>
Subject: [PATCH] e2fsck/e2fsprogs: use sscanf() instead of atoi() in the option parser
Date: Wed, 01 Aug 2007 16:50:04 +0200
Message-ID: <f8q6is$tg3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2077762.9lspjKfsKg"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40827 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160AbXHAOuV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2007 10:50:21 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IGFWg-0007Cw-2K
	for linux-ext4@vger.kernel.org; Wed, 01 Aug 2007 16:50:14 +0200
Received: from ns1.q-leap.de ([153.94.51.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2007 16:50:14 +0200
Received: from bschubert by ns1.q-leap.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2007 16:50:14 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--nextPart2077762.9lspjKfsKg
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit

[resent since the first mail doesn't seem to make it to this list]

Hi,

using atoi() should be avoided in the option parser since it doesn't check
for errors. I almost destroyed an important filesystem since I
specified "e2fsck -C -n" and -n was parsed as option to -C


Cheers,
Bernd



--nextPart2077762.9lspjKfsKg
Content-Type: text/x-diff; name="sscanf_instead_of_atoi.patch"
Content-Transfer-Encoding: 8Bit
Content-Disposition: attachment; filename="sscanf_instead_of_atoi.patch"

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


--nextPart2077762.9lspjKfsKg--
