From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext3: add writepage sanity checks
Date: Tue,  2 Mar 2010 15:51:02 +0300
Message-ID: <1267534262-13196-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57267 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab0CBMvJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Mar 2010 07:51:09 -0500
Received: by bwz1 with SMTP id 1so100077bwz.21
        for <linux-ext4@vger.kernel.org>; Tue, 02 Mar 2010 04:51:08 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- There is theoretical possibility to perform writepage on
   RO superblock. Add explicit check for what case.
- Page must being locked before writepage.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 8ac4acf..14d40a4 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1528,6 +1528,7 @@ static int ext3_ordered_writepage(struct page *page,
 	int err;
 
 	J_ASSERT(PageLocked(page));
+	WARN_ON_ONCE(IS_RDONLY(inode));
 
 	/*
 	 * We give up here if we're reentered, because it might be for a
@@ -1600,6 +1601,9 @@ static int ext3_writeback_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
+	J_ASSERT(PageLocked(page));
+	WARN_ON_ONCE(IS_RDONLY(inode));
+
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
@@ -1642,6 +1646,9 @@ static int ext3_journalled_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
+	J_ASSERT(PageLocked(page));
+	WARN_ON_ONCE(IS_RDONLY(inode));
+
 	if (ext3_journal_current_handle())
 		goto no_write;
 
-- 
1.6.6

