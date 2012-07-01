From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 29/35 v3] e2fsck: add three problem descriptions in pass1
Date: Sun,  1 Jul 2012 21:48:52 +0800
Message-ID: <1341150538-32047-30-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2GANln (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:43 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:43 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In pass1, we will meet three problems.  So add descriptions in problem
table.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/problem.c |   15 +++++++++++++++
 e2fsck/problem.h |    9 +++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 286257d..e55372d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1000,6 +1000,21 @@ static struct e2fsck_problem problem_table[] = {
 	     "@i %i does not match.  "),
 	  PROMPT_FIX, 0 },
 
+	/* INLINE_DATA is set and EXT_ATTR is not set */
+	{ PR_1_INLINE_DATA_AND_EXT_ATTR,
+	  N_("INLINE_DATA is set in @S, but it is missing EXT_ATTR feature\n"),
+	  PROMPT_FIX, 0 },
+
+	/* Inode has inline data, superblock missing INCOMPAT_INLINE_DATA feature */
+	{ PR_1_INLINE_DATA_FEATURE,
+	  N_("@i %i is in inline data format, but @S is missing INLINEDATA feature\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* INLINE_DATA_FL flag set on a non-inline-data filesystem */
+	{ PR_1_INLINE_DATA_SET,
+	  N_("@i %i has INLINE_DATA_FL flag set on @f without inline data support.\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 5caade4..4ea2b2d 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -587,6 +587,15 @@ struct problem_context {
 #define PR_1_EA_BLOCK_ONLY_CSUM_INVALID        0x01006C
 
 
+/* INLINE_DATA is set and EXT_ATTR is not set */
+#define PR_1_INLINE_DATA_AND_EXT_ATTR	0x01006D
+
+/* Inode has inline data, superblock missing INCOMPAT_INLINE_DATA feature */
+#define PR_1_INLINE_DATA_FEATURE	0x01006E
+
+/* INLINE_DATA_FL flag set on a non-inline-data capable filesystem */
+#define PR_1_INLINE_DATA_SET		0x01006F
+
 /*
  * Pass 1b errors
  */
-- 
1.7.4.1

