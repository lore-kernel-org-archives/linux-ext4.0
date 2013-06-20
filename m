From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: deleted unnecessary assignments and useless "if"
 statement
Date: Thu, 20 Jun 2013 10:44:21 -0400
Message-ID: <20130620144421.GC28309@thunk.org>
References: <20130620054456.271300@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59785 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab3FTOoY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 10:44:24 -0400
Content-Disposition: inline
In-Reply-To: <20130620054456.271300@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 01:44:56AM -0400, jon ernst wrote:
> comparing unsigned variable with 0 always return false.
> err = 0 is duplicated and unnecessary.
> 
> Signed-off-by: "Jon Ernst" <jonernst07@gmx.com>

I've applied this with a few changes.

(a) your patch was white space corrupted
(b) one of the err = 0 which you removed was actually necessary.

I've reworked the error handling in ext4_block_zero_page_range() so
it's a bit more obvious.

Also your change showed up a potential issue with ext4_write_end(), in
that ext4_write_inline_data_end() returns an int, which can be
negative in the case of an error, and it's assigning this to copied,
which is an unsigned int.

				- Ted

>From 6e4837a3e8bc04a1c49f8668c32ce3239968a8ce Mon Sep 17 00:00:00 2001
From: jon ernst <jonernst07@gmx.com>
Date: Thu, 20 Jun 2013 10:42:05 -0400
Subject: [PATCH] ext4: delete unnecessary C statements

Comparing unsigned variable with 0 always returns false.
err = 0 is duplicated and unnecessary.

Signed-off-by: "Jon Ernst" <jonernst07@gmx.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
----
---
 fs/ext4/inode.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 78cf398..baf5c2b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1100,8 +1100,6 @@ static int ext4_write_end(struct file *file,
 	if (i_size_changed)
 		ext4_mark_inode_dirty(handle, inode);
 
-	if (copied < 0)
-		ret = copied;
 	if (pos + len > inode->i_size && ext4_can_truncate(inode))
 		/* if we have allocated more blocks and copied
 		 * less. We will have blocks allocated outside
@@ -3336,7 +3334,7 @@ int ext4_block_zero_page_range(handle_t *handle,
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	struct page *page;
-	int err = 0;
+	int err;
 
 	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
 				   mapping_gfp_mask(mapping) & ~__GFP_FS);
@@ -3366,13 +3364,10 @@ int ext4_block_zero_page_range(handle_t *handle,
 		iblock++;
 		pos += blocksize;
 	}
-
-	err = 0;
 	if (buffer_freed(bh)) {
 		BUFFER_TRACE(bh, "freed: skip");
 		goto unlock;
 	}
-
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
 		ext4_get_block(inode, iblock, bh, 0);
@@ -3395,22 +3390,19 @@ int ext4_block_zero_page_range(handle_t *handle,
 		if (!buffer_uptodate(bh))
 			goto unlock;
 	}
-
 	if (ext4_should_journal_data(inode)) {
 		BUFFER_TRACE(bh, "get write access");
 		err = ext4_journal_get_write_access(handle, bh);
 		if (err)
 			goto unlock;
 	}
-
 	zero_user(page, offset, length);
