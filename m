From: Theodore Ts'o <tytso@mit.edu>
Subject: [STABLE, 2.6.28.y] ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()
Date: Thu,  5 Mar 2009 02:35:15 -0500
Message-ID: <1236238515-8479-2-git-send-email-tytso@mit.edu>
References: <1235495688-8044-8-git-send-email-tytso@mit.edu>
 <1236238515-8479-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59136 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZCEHfU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Mar 2009 02:35:20 -0500
In-Reply-To: <1236238515-8479-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Functions ext4_write_begin() and ext4_da_write_begin() call
grab_cache_page_write_begin() without AOP_FLAG_NOFS. Thus it
can happen that page reclaim is triggered in that function
and it recurses back into the filesystem (or some other filesystem).
But this can lead to various problems as a transaction is already
started at that point. Add the necessary flag.

http://bugzilla.kernel.org/show_bug.cgi?id=11688

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit ebd3610b110bbb18ea6f9f2aeed1e1068c537227)
---
 fs/ext4/inode.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c794e61..b7f20b0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1347,6 +1347,10 @@ retry:
 		goto out;
 	}
 
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
+
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		ext4_journal_stop(handle);
@@ -1356,7 +1360,7 @@ retry:
 	*pagep = page;
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext4_get_block);
+				ext4_get_block);
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
@@ -2603,6 +2607,9 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
-- 
1.5.6.3

