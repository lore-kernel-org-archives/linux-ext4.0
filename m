From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Don't warn from writepage when readonly inode is spotted after error
Date: Thu, 22 Dec 2011 16:56:55 +0100
Message-ID: <1324569415-9824-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab1LVP5S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Dec 2011 10:57:18 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id DF18589994
	for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2011 16:57:17 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

WARN_ON_ONCE(IS_RDONLY(inode)) tends to trip when filesystem hits error and is
remounted read-only. This unnecessarily scares users (well, they should be
scared because of filesystem error, but the stack trace distracts them from the
right source of their fear ;-). We could as well just remove the WARN_ON but
it's not hard to fix it to not trip on filesystem with errors and not use more
cycles in the common case so that's what we do.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

  I carry this patch in my tree and will merge it with Linus in the next merge
window if noone objects.

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index a8d3217..91ac85b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1623,7 +1623,11 @@ static int ext3_ordered_writepage(struct page *page,
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is ordered to avoid
+	 * dereferencing inode->i_sb in non-error case to avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) && !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	/*
 	 * We give up here if we're reentered, because it might be for a
@@ -1698,7 +1702,11 @@ static int ext3_writeback_writepage(struct page *page,
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is ordered to avoid
+	 * dereferencing inode->i_sb in non-error case to avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) && !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	if (ext3_journal_current_handle())
 		goto out_fail;
@@ -1741,7 +1749,11 @@ static int ext3_journalled_writepage(struct page *page,
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is ordered to avoid
+	 * dereferencing inode->i_sb in non-error case to avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) && !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	if (ext3_journal_current_handle())
 		goto no_write;
-- 
1.7.1

