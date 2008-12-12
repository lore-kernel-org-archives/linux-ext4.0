From: akpm@linux-foundation.org
Subject: + ext3-ensure-link-targets-are-null-terminated.patch added to -mm tree
Date: Thu, 11 Dec 2008 19:32:52 -0800
Message-ID: <200812120332.mBC3WqJg009789@imap1.linux-foundation.org>
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbYLLDc4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2008 22:32:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: ensure link targets are NULL-terminated
has been added to the -mm tree.  Its filename is
     ext3-ensure-link-targets-are-null-terminated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: ensure link targets are NULL-terminated
From: "Duane Griffin" <duaneg@dghda.com>

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ext3/inode.c~ext3-ensure-link-targets-are-null-terminated fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-ensure-link-targets-are-null-terminated
+++ a/fs/ext3/inode.c
@@ -2817,9 +2817,10 @@ struct inode *ext3_iget(struct super_blo
 		inode->i_op = &ext3_dir_inode_operations;
 		inode->i_fop = &ext3_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext3_inode_is_fast_symlink(inode))
+		if (ext3_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext3_fast_symlink_inode_operations;
-		else {
+			((char *) ei->i_data)[inode->i_size] = '\0';
+		} else {
 			inode->i_op = &ext3_symlink_inode_operations;
 			ext3_set_aops(inode);
 		}
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch
ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext2-tighten-restrictions-on-inode-flags.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext3-tighten-restrictions-on-inode-flags.patch
ext3-ensure-link-targets-are-null-terminated.patch

