From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 28/32] e2fsck: add three problem descriptions in pass1
Date: Mon, 16 Apr 2012 19:40:03 +0800
Message-ID: <1334576407-4007-29-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLen (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:43 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:43 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In pass1, we will meet three problems.  So add descriptions in problem table.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/problem.c |   15 +++++++++++++++
 e2fsck/problem.h |    9 +++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index d51a408..de6153d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -946,6 +946,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has zero length extent\n\t(@n logical @b %c, physical @b %b)\n"),
 	  PROMPT_CLEAR, 0 },
 
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
index 07df810..79b6825 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -558,6 +558,15 @@ struct problem_context {
 /* Extent has zero length */
 #define PR_1_EXTENT_LENGTH_ZERO		0x010066
 
+/* INLINE_DATA is set and EXT_ATTR is not set */
+#define PR_1_INLINE_DATA_AND_EXT_ATTR	0x010067
+
+/* Inode has inline data, superblock missing INCOMPAT_INLINE_DATA feature */
+#define PR_1_INLINE_DATA_FEATURE	0x010068
+
+/* INLINE_DATA_FL flag set on a non-inline-data capable filesystem */
+#define PR_1_INLINE_DATA_SET		0x010069
+
 /*
  * Pass 1b errors
  */
-- 
1.7.4.1

