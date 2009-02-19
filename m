From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()
Date: Thu, 19 Feb 2009 15:24:48 +0100
Message-ID: <1235053488-16937-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbZBSOYw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2009 09:24:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Functions ext4_write_begin() and ext4_da_write_begin() call
grab_cache_page_write_begin() without AOP_FLAG_NOFS. Thus it
can happen that page reclaim is triggered in that function
and it recurses back into the filesystem (or some other filesystem).
But this can lead to various problems as a transaction is already
started at that point. Add the necessary flag.

(Reported in http://bugzilla.kernel.org/show_bug.cgi?id=11688)

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 03ba20b..e62e6e4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1366,6 +1366,10 @@ retry:
 		goto out;
 	}
 
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
+
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		ext4_journal_stop(handle);
@@ -1375,7 +1379,7 @@ retry:
 	*pagep = page;
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext4_get_block);
+				ext4_get_block);
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
@@ -2648,6 +2652,9 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
-- 
1.6.0.2

