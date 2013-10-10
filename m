From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH] e2fsck: fix corrupted orphan list in preen mode
Date: Thu, 10 Oct 2013 15:55:19 +0800
Message-ID: <1381391719-29461-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:32968 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JJHxe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Oct 2013 03:53:34 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz1so2305855pad.30
        for <linux-ext4@vger.kernel.org>; Thu, 10 Oct 2013 00:53:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Currently we don't try to fix the corrupted orphan list in preen mode.
When we meet this problem fsck will ask administrator to handle it.
But when application uses aio dio to manipulate the file and the server
gets a power failure or cold reset it is easy to trigger this problem.
If there is only one server, it is OK.  However, when a large number of
servers are reset, it is a disaster.

This commit makes e2fsck fix corrupted orphan list in preen mode, and
might make our lives better.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/problem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index b0a6e19..29a6b5d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -722,13 +722,13 @@ static struct e2fsck_problem problem_table[] = {
 	/* Deal with inodes that were part of orphan linked list */
 	{ PR_1_LOW_DTIME,
 	  N_("@i %i was part of the @o @i list.  "),
-	  PROMPT_FIX, PR_LATCH_LOW_DTIME, 0 },
+	  PROMPT_FIX, PR_LATCH_LOW_DTIME | PR_PREEN_OK, 0 },
 
 	/* Deal with inodes that were part of corrupted orphan linked
 	   list (latch question) */
 	{ PR_1_ORPHAN_LIST_REFUGEES,
 	  N_("@is that were part of a corrupted orphan linked list found.  "),
-	  PROMPT_FIX, 0 },
+	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* Error allocating refcount structure */
 	{ PR_1_ALLOCATE_REFCOUNT,
-- 
1.7.9.7

