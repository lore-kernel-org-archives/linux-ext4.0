From: akpm@linux-foundation.org
Subject: [patch 252/260] ext[234]: fix comment for nonexistent variable
Date: Wed, 06 Feb 2008 01:40:15 -0800
Message-ID: <200802060939.m169duOk004795@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbYBFJs5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 04:48:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akinobu Mita <akinobu.mita@gmail.com>

The comment in ext[234]_new_blocks() describes about "i".  But there is no
local variable called "i" in that scope.  I guess it has been renamed to
group_no.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |    4 ++--
 fs/ext3/balloc.c |    2 +-
 fs/ext4/balloc.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext2/balloc.c~ext-fix-comment-for-nonexistent-variable fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext-fix-comment-for-nonexistent-variable
+++ a/fs/ext2/balloc.c
@@ -1315,8 +1315,8 @@ retry_alloc:
 	smp_rmb();
 
 	/*
-	 * Now search the rest of the groups.  We assume that 
-	 * i and gdp correctly point to the last group visited.
+	 * Now search the rest of the groups.  We assume that
+	 * group_no and gdp correctly point to the last group visited.
 	 */
 	for (bgi = 0; bgi < ngroups; bgi++) {
 		group_no++;
diff -puN fs/ext3/balloc.c~ext-fix-comment-for-nonexistent-variable fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext-fix-comment-for-nonexistent-variable
+++ a/fs/ext3/balloc.c
@@ -1572,7 +1572,7 @@ retry_alloc:
 
 	/*
 	 * Now search the rest of the groups.  We assume that
-	 * i and gdp correctly point to the last group visited.
+	 * group_no and gdp correctly point to the last group visited.
 	 */
 	for (bgi = 0; bgi < ngroups; bgi++) {
 		group_no++;
diff -puN fs/ext4/balloc.c~ext-fix-comment-for-nonexistent-variable fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext-fix-comment-for-nonexistent-variable
+++ a/fs/ext4/balloc.c
@@ -1700,7 +1700,7 @@ retry_alloc:
 
 	/*
 	 * Now search the rest of the groups.  We assume that
-	 * i and gdp correctly point to the last group visited.
+	 * group_no and gdp correctly point to the last group visited.
 	 */
 	for (bgi = 0; bgi < ngroups; bgi++) {
 		group_no++;
_
