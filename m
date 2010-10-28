From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfix update
Date: Thu, 28 Oct 2010 18:41:23 -0400
Message-ID: <E1PBb9v-0005RM-E0@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60265 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab0J1Wl2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 18:41:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to pick up the following fix.

Many thanks!!

					- Ted

>From b1142e8fec6a594723e5054055a7b53379b90490 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 28 Oct 2010 17:33:57 -0400
Subject: [PATCH] ext4: BUG_ON fix: check if page has buffers before calling page_buffers()

We need to make check if a page does not have buffes by checking
page_has_buffers(page) before calling page_buffers(page) in
ext4_writepage().  Otherwise page_buffers() could throw a BUG_ON.

Thanks also to Markus Trippelsdorf and Avinash Kurup who also reported
the problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
Tested-by: Sedat Dilek <sedat.dilek@googlemail.com>
---
 fs/ext4/inode.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2d6c6c8..1916164 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2718,7 +2718,7 @@ static int ext4_writepage(struct page *page,
 	 * try to create them using __block_write_begin.  If this
 	 * fails, redirty the page and move on.
 	 */
-	if (!page_buffers(page)) {
+	if (!page_has_buffers(page)) {
 		if (__block_write_begin(page, 0, len,
 					noalloc_get_block_write)) {
 		redirty_page:
@@ -2732,12 +2732,10 @@ static int ext4_writepage(struct page *page,
 	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
 			      ext4_bh_delay_or_unwritten)) {
 		/*
-		 * We don't want to do block allocation So redirty the
-		 * page and return We may reach here when we do a
-		 * journal commit via
-		 * journal_submit_inode_data_buffers.  If we don't
-		 * have mapping block we just ignore them. We can also
-		 * reach here via shrink_page_list
+		 * We don't want to do block allocation, so redirty
+		 * the page and return.  We may reach here when we do
+		 * a journal commit via journal_submit_inode_data_buffers.
+		 * We can also reach here via shrink_page_list
 		 */
 		goto redirty_page;
 	}
-- 
1.7.3.1

