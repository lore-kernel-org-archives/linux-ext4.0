From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] e2fsck: fix problem report typo
Date: Thu, 7 Jan 2016 11:40:25 -0500
Message-ID: <20160107164025.GA1958@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33533 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcAGQk6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jan 2016 11:40:58 -0500
Received: by mail-qg0-f42.google.com with SMTP id b35so201627157qge.0
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jan 2016 08:40:58 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove the stray left parenthesis.  Observed while testing bigalloc_1k
filesystems with shared/298 on 32 bit ARM running 4.3 kernels.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 e2fsck/problem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index a7da94d..7bd660d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1255,7 +1255,7 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Inode extent tree could be narrower */
 	{ PR_1E_CAN_NARROW_EXTENT_TREE,
-	  N_("@i %i @x tree (at (level %b) could be narrower.  "),
+	  N_("@i %i @x tree (at level %b) could be narrower.  "),
 	  PROMPT_FIX, PR_NO_OK | PR_PREEN_NO | PR_PREEN_OK },
 
 	/* Pass 2 errors */
-- 
2.1.4

