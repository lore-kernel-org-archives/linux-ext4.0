From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH 1/2] ext4: clean up ext4_dirty_inode()
Date: Thu, 17 Sep 2009 14:55:36 -0700
Message-ID: <6601abe90909171455q50ab5c6dr5b125278d0eae845@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:57624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbZIQVzf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 17:55:35 -0400
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id n8HLtc2Q017612
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 14:55:38 -0700
Received: from pxi8 (pxi8.prod.google.com [10.243.27.8])
	by zps19.corp.google.com with ESMTP id n8HLtMgB019411
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 14:55:36 -0700
Received: by pxi8 with SMTP id 8so327039pxi.27
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 14:55:36 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch cleans up ext4_dirty_inode(); it's attempt to detect non-matching
transactions can never be executed.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

If 'current_handle' is non-NULL, then ext4_start_journal() will return the
same handle with it's h_ref count incremented, and the h_transaction
pointers will be the same.

diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2009-09-17 13:59:48.000000000 -0700
+++ new/fs/ext4/inode.c	2009-09-17 14:14:43.000000000 -0700
@@ -5379,24 +5379,13 @@ void ext4_dirty_inode(struct inode *inod
 	handle_t *current_handle = ext4_journal_current_handle();
 	handle_t *handle;

-	if (!ext4_handle_valid(current_handle)) {
-		ext4_mark_inode_dirty(current_handle, inode);
-		return;
-	}
