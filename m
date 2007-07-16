From: akpm@linux-foundation.org
Subject: [patch 203/268] ext3: remove extra IS_RDONLY() check
Date: Sun, 15 Jul 2007 23:41:14 -0700
Message-ID: <200707160641.l6G6fEMA015006@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, haveblue@us.ibm.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921AbXGPGsI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 02:48:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dave Hansen <haveblue@us.ibm.com>

ext3_change_inode_journal_flag() is only called from one location:
ext3_ioctl(EXT3_IOC_SETFLAGS).  That ioctl case already has a IS_RDONLY()
call in it so this one is superfluous.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-remove-extra-is_rdonly-check fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-remove-extra-is_rdonly-check
+++ a/fs/ext3/inode.c
@@ -3195,7 +3195,7 @@ int ext3_change_inode_journal_flag(struc
 	 */
 
 	journal = EXT3_JOURNAL(inode);
-	if (is_journal_aborted(journal) || IS_RDONLY(inode))
+	if (is_journal_aborted(journal))
 		return -EROFS;
 
 	journal_lock_updates(journal);
_
