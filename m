From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 5/7] ext4: don't lock the next page in write_cache_pages if not needed
Date: Sat, 12 Feb 2011 19:15:55 -0500
Message-ID: <1297556157-21559-6-git-send-email-tytso@mit.edu>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39660 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1BMAQA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 19:16:00 -0500
In-Reply-To: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have accumulated a contiguous region of memory to be written
out, and the next page can added to this region, don't bother locking
(and then unlocking the page) before writing out the memory.  In the
unlikely event that the next page was being written back by some other
CPU, we can also skip waiting that page to finish writeback.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6dfdc0e..2ac64e3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2761,6 +2761,16 @@ static int write_cache_pages_da(struct address_space *mapping,
 
 			*done_index = page->index + 1;
 
+			/*
+			 * If we can't merge this page, and we have
+			 * accumulated an contiguous region, write it
+			 */
+			if ((mpd->next_page != page->index) &&
+			    (mpd->next_page != mpd->first_page)) {
+				mpage_da_map_and_submit(mpd);
+				goto ret_extent_tail;
+			}
+
 			lock_page(page);
 
 			/*
@@ -2784,25 +2794,8 @@ static int write_cache_pages_da(struct address_space *mapping,
 
 			BUG_ON(PageWriteback(page));
 
-			/*
-			 * Can we merge this page to current extent?
-			 */
 			if (mpd->next_page != page->index) {
 				/*
-				 * Nope, we can't. So, we map
-				 * non-allocated blocks and start IO
-				 * on them
-				 */
-				if (mpd->next_page != mpd->first_page) {
-					mpage_da_map_and_submit(mpd);
-					/*
-					 * skip rest of the page in the page_vec
-					 */
-					unlock_page(page);
-					goto ret_extent_tail;
-				}
