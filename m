From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: make -y -y answer "no" to Abort?
Date: Sat, 03 Apr 2010 16:03:28 -0500
Message-ID: <4BB7AD20.1080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0DCVDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 17:03:33 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o33L3W4Z009250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 3 Apr 2010 17:03:32 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o33L3Se7020106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 3 Apr 2010 17:03:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

RH Bug 484913 - Change verbage of e2fsck questioning to make the "-y"
switch more useful

demonstrates:

sh-3.2# e2fsck -y /dev/VolGroup00/VolVol02
e2fsck 1.41.3 (12-Oct-2008)
The filesystem size (according to the superblock) is 14090240 blocks
The physical size of the device is 8847360 blocks
Either the superblock or the partition table is likely to be corrupt!

Abort? yes

"-y" generally means yes, take the corrective action but in this
case it stops fsck.

Below is a little hacky, but makes -y -y answer "no" to "Abort?"

I'm open to a better method if anyone has a suggestion.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 3fb15e6..98c309e 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -292,7 +292,7 @@ may not be specified at the same time as the
 .B \-n
 or
 .B \-p
-options.
+options.  If given twice, will answer `no' to any `Abort?' question.
 .SH EXIT CODE
 The exit code returned by
 .B e2fsck
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index e763b89..2881654 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -155,6 +155,7 @@ struct resource_track {
 #define E2F_OPT_WRITECHECK	0x0200
 #define E2F_OPT_COMPRESS_DIRS	0x0400
 #define E2F_OPT_FRAGCHECK	0x0800
+#define E2F_OPT_YESYES		0x1000
 
 /*
  * E2fsck flags
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 9043281..c12a70f 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1843,9 +1843,20 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 				answer = 1;
 			else
 				answer = 0;
-		} else
-			answer = ask(ctx, (ptr->prompt == PROMPT_NULL) ? "" :
+		} else {
+			/*
+			 * yesmeansno:
+			 * e2fsck -y -y really means yes, don't abort!
+			 */
+			if ((ptr->prompt == PROMPT_ABORT) &&
+			    (ctx->options & E2F_OPT_YESYES)) {
+				printf (_("%s? no\n\n"), _(prompt[(int) ptr->prompt]));
+                		answer = 0;
+			} else {
+				answer = ask(ctx, (ptr->prompt == PROMPT_NULL) ? "" :
 				     _(prompt[(int) ptr->prompt]), def_yn);
+			}
+		}
 		if (!answer && !(ptr->flags & PR_NO_OK))
 			ext2fs_unmark_valid(fs);
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index d53921a..d01b3cb 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -709,6 +709,10 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		case 'y':
 			if (ctx->options & (E2F_OPT_PREEN|E2F_OPT_NO))
 				goto conflict_opt;
+			if (ctx->options & (E2F_OPT_YES)) {
+				printf("yesyes\n");
+				ctx->options |= E2F_OPT_YESYES;
+			}
 			ctx->options |= E2F_OPT_YES;
 			break;
 		case 't':

