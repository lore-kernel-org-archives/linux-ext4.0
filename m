From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ext4: Standardize error handling in ext4_da_write_inline_data_begin()
Date: Tue, 10 Dec 2013 11:13:59 +0100
Message-ID: <1386670440-3158-3-git-send-email-jack@suse.cz>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3LJKOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 05:14:05 -0500
In-Reply-To: <1386670440-3158-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function has a bit non-standard (for ext4) error recovery in that it
used a mix of 'out' labels and testing for 'handle' being NULL. There
isn't a good reason for that in the function so clean it up a bit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inline.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ed6e71fe5e9d..c417e52d194e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -859,7 +859,6 @@ retry_journal:
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-		handle = NULL;
 		goto out;
 	}
 
@@ -869,7 +868,7 @@ retry_journal:
 	if (inline_size >= pos + len) {
 		ret = ext4_prepare_inline_data(handle, inode, pos + len);
 		if (ret && ret != -ENOSPC)
-			goto out;
+			goto out_journal;
 	}
 
 	if (ret == -ENOSPC) {
@@ -878,7 +877,6 @@ retry_journal:
 							    flags,
 							    fsdata);
 		ext4_journal_stop(handle);
-		handle = NULL;
 		if (ret == -ENOSPC &&
 		    ext4_should_retry_alloc(inode->i_sb, &retries))
 			goto retry_journal;
@@ -894,7 +892,7 @@ retry_journal:
 	page = grab_cache_page_write_begin(mapping, 0, flags);
 	if (!page) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_journal;
 	}
 
 	down_read(&EXT4_I(inode)->xattr_sem);
@@ -911,16 +909,15 @@ retry_journal:
 
 	up_read(&EXT4_I(inode)->xattr_sem);
 	*pagep = page;
-	handle = NULL;
 	brelse(iloc.bh);
 	return 1;
 out_release_page:
 	up_read(&EXT4_I(inode)->xattr_sem);
 	unlock_page(page);
 	page_cache_release(page);
+out_journal:
+	ext4_journal_stop(handle);
 out:
-	if (handle)
-		ext4_journal_stop(handle);
 	brelse(iloc.bh);
 	return ret;
 }
-- 
1.8.1.4

