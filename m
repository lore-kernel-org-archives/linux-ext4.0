From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ext4: Add journal parameter to jbd2_journal_begin_ordered_truncate()
Date: Thu,  5 Feb 2009 15:53:01 +0100
Message-ID: <1233845582-954-3-git-send-email-jack@suse.cz>
References: <y>
 <1233845582-954-1-git-send-email-jack@suse.cz>
 <1233845582-954-2-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35095 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753354AbZBEOxD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 09:53:03 -0500
In-Reply-To: <1233845582-954-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add new parameter of the function.

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 03ba20b..658c4a7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -47,8 +47,10 @@
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
-	return jbd2_journal_begin_ordered_truncate(&EXT4_I(inode)->jinode,
-						   new_size);
+	return jbd2_journal_begin_ordered_truncate(
+					EXT4_SB(inode->i_sb)->s_journal,
+					&EXT4_I(inode)->jinode,
+					new_size);
 }
 
 static void ext4_invalidatepage(struct page *page, unsigned long offset);
-- 
1.6.0.2

