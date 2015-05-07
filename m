From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH] ext4: issue WARN_ON_ONCE() if page gets truncated in ext4_write_[da_]begin()
Date: Thu, 7 May 2015 17:17:23 +0800
Message-ID: <1430990243-8568-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50638 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295AbbEGJ0L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 May 2015 05:26:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_write_[da_]begin(), when we get a page successfully by calling
grab_cache_page_write_begin(), then unless this page is truncated by
ext4_truncate_failed_write(), which is called when ext4_write_[da_]begin()
run into some errors, otherwise I think this page won't be truncated by
other kernel path because we're holding i_mutex.

In this patch, if page is truncated by ext4_truncate_failed_write(), then
we just put it and call grab_cache_page_write_begin() again to get a new
page, then this check 'if (page->mapping != mapping)' won't be necessary.
We can remove this check, but according to Jan Kara's suggestion, we issue
WARN_ON_ONCE() here if page is truncated, that means something is wrong.
(Thanks to Jan Kara for his help)

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 fs/ext4/inode.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4415cea..5961fdf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -984,7 +984,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	int ret, needed_blocks;
 	handle_t *handle;
-	int retries = 0;
+	int retries = 0, page_truncated = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
@@ -1029,7 +1029,7 @@ retry_journal:
 	}
 
 	lock_page(page);
-	if (page->mapping != mapping) {
+	if (WARN_ON_ONCE(page->mapping != mapping)) {
 		/* The page got truncated from under us */
 		unlock_page(page);
 		page_cache_release(page);
@@ -1074,6 +1074,7 @@ retry_journal:
 		ext4_journal_stop(handle);
 		if (pos + len > inode->i_size) {
 			ext4_truncate_failed_write(inode);
+			page_truncated = 1;
 			/*
 			 * If truncate failed early the inode might
 			 * still be on the orphan list; we need to
@@ -1085,8 +1086,15 @@ retry_journal:
 		}
 
 		if (ret == -ENOSPC &&
-		    ext4_should_retry_alloc(inode->i_sb, &retries))
-			goto retry_journal;
+		    ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			if (page_truncated) {
+				page_cache_release(page);
+				page_truncated = 0;
+				goto retry_grab;
+			} else {
+				goto retry_journal;
+			}
+		}
 		page_cache_release(page);
 		return ret;
 	}
@@ -2609,7 +2617,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
 {
-	int ret, retries = 0;
+	int ret, retries = 0, page_truncated = 0;
 	struct page *page;
 	pgoff_t index;
 	struct inode *inode = mapping->host;
@@ -2663,7 +2671,7 @@ retry_journal:
 	}
 
 	lock_page(page);
-	if (page->mapping != mapping) {
+	if (WARN_ON_ONCE(page->mapping != mapping)) {
 		/* The page got truncated from under us */
 		unlock_page(page);
 		page_cache_release(page);
@@ -2687,12 +2695,21 @@ retry_journal:
 		 * outside i_size.  Trim these off again. Don't need
 		 * i_size_read because we hold i_mutex.
 		 */
-		if (pos + len > inode->i_size)
+		if (pos + len > inode->i_size) {
 			ext4_truncate_failed_write(inode);
+			page_truncated = 1;
+		}
 
 		if (ret == -ENOSPC &&
-		    ext4_should_retry_alloc(inode->i_sb, &retries))
-			goto retry_journal;
+		    ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			if (page_truncated) {
+				page_cache_release(page);
+				page_truncated = 0;
+				goto retry_grab;
+			} else {
+				goto retry_journal;
+			}
+		}
 
 		page_cache_release(page);
 		return ret;
-- 
1.8.3.1

