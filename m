From: akpm@linux-foundation.org
Subject: - ext-fix-comment-for-nonexistent-variable.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:44 -0800
Message-ID: <200802070030.m170UPtI007387@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934353AbYBGAnh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 19:43:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext[234]: fix comment for nonexistent variable
has been removed from the -mm tree.  Its filename was
     ext-fix-comment-for-nonexistent-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext[234]: fix comment for nonexistent variable
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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
