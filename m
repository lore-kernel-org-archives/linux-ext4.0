From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext3: Avoid starting a transaction in writepage
	when not necessary
Date: Fri, 27 Mar 2009 23:23:46 +0100
Message-ID: <20090327222346.GJ31071@duck.suse.cz>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <1238185471-31152-3-git-send-email-tytso@mit.edu> <1238185471-31152-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbZC0WXt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 18:23:49 -0400
Content-Disposition: inline
In-Reply-To: <1238185471-31152-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 27-03-09 16:24:31, Theodore Ts'o wrote:
> From: Jan Kara <jack@suse.cz>
> 
> We don't have to start a transaction in writepage() when all the blocks
> are a properly allocated. Even in ordered mode either the data has been
> written via write() and they are thus already added to transaction's list
> or the data was written via mmap and then it's random in which transaction
> they get written anyway.
> 
> This should help VM to pageout dirty memory without blocking on transaction
> commits.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  Please, use the patch below instead (and I'd also wait a few days for
Mingo to check whether it also helps him). It also changes data=writeback
mode in the same way and it adheres to coding style...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

---

>From 8c1678ee703b36f3be51c856f4586c1512d98521 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Mar 2009 13:08:04 +0100
Subject: [PATCH] ext3: Avoid starting a transaction in writepage when not necessary

We don't have to start a transaction in writepage() when all the blocks
are a properly allocated. Even in ordered mode either the data has been
written via write() and they are thus already added to transaction's list
or the data was written via mmap and then it's random in which transaction
they get written anyway.

This should help VM to pageout dirty memory without blocking on transaction
commits.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index e230f7a..73f605a 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1420,6 +1420,10 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
+static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh);
+}
 /*
  * Note that we always start a transaction even if we're not journalling
  * data.  This is to preserve ordering: any hole instantiation within
@@ -1490,6 +1494,19 @@ static int ext3_ordered_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	if (!page_has_buffers(page)) {
+		create_empty_buffers(page, inode->i_sb->s_blocksize,
+				(1 << BH_Dirty)|(1 << BH_Uptodate));
+		page_bufs = page_buffers(page);
+	} else {
+		page_bufs = page_buffers(page);
+		if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
+				       NULL, buffer_unmapped)) {
+			/* Provide NULL get_block() to catch bugs if buffers
+			 * weren't really mapped */
+			return block_write_full_page(page, NULL, wbc);
+		}
+	}
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 
 	if (IS_ERR(handle)) {
@@ -1497,11 +1514,6 @@ static int ext3_ordered_writepage(struct page *page,
 		goto out_fail;
 	}
 
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, inode->i_sb->s_blocksize,
-				(1 << BH_Dirty)|(1 << BH_Uptodate));
-	}
-	page_bufs = page_buffers(page);
 	walk_page_buffers(handle, page_bufs, 0,
 			PAGE_CACHE_SIZE, NULL, bget_one);
 
@@ -1549,6 +1561,15 @@ static int ext3_writeback_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	if (page_has_buffers(page)) {
+		if (!walk_page_buffers(NULL, page_buffers(page), 0,
+				      PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
+			/* Provide NULL get_block() to catch bugs if buffers
+			 * weren't really mapped */
+			return block_write_full_page(page, NULL, wbc);
+		}
+	}
+
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-- 
1.6.0.2

