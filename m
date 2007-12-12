From: akpm@linux-foundation.org
Subject: + ext-fix-comment-for-nonexistent-variable.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:28:25 -0800
Message-ID: <200712120528.lBC5SPI1027465@imap1.linux-foundation.org>
Cc: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbXLLF27 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2007 00:28:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext[234]: fix comment for nonexistent variable
has been added to the -mm tree.  Its filename is
     ext-fix-comment-for-nonexistent-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1703,7 +1703,7 @@ retry_alloc:
 
 	/*
 	 * Now search the rest of the groups.  We assume that
-	 * i and gdp correctly point to the last group visited.
+	 * group_no and gdp correctly point to the last group visited.
 	 */
 	for (bgi = 0; bgi < ngroups; bgi++) {
 		group_no++;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-net.patch
git-battery.patch
fs-use-hlist_unhashed.patch
fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
ext-fix-comment-for-nonexistent-variable.patch
ext-use-ext_get_group_desc.patch
ext-remove-unused-argument-for-ext_find_goal.patch
