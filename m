From: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: [PATCH] clear PAGECACHE_TAG_DIRTY for truncated pages
Date: Fri, 1 Feb 2008 20:18:47 +0800
Message-ID: <E1JKur1-0001Dh-Ol__45482.827598653$1201868386$gmane$org@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Michael Rubin <mrubin@google.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33742 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758617AbYBAMS4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2008 07:18:56 -0500
Content-Disposition: inline
Message-Id: <E1JKur1-0001Dh-Ol@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The `truncated' page in block_write_full_page()/nobh_writepage() may
stick for a long time.  For example, ext2_rmdir() will set i_size to
0, and then the dir inode and its pages may hang around because of
being referenced by some process.

To produce this situation:

In terminal 1:
                $ mkdir hi; cd hi
                $ sleep 1h; cd ..
In terminal 2:
                $ rmdir hi

The dir 'hi' is deleted in terminal 2 while still being referenced by
the shell(as working dir) in terminal 1.  The deleted inode 'hi' with
its dirty-and-truncated page will stay for 1 hour, during which the
pdflush will retry the page _at least_ once every 5s.

So clear PAGECACHE_TAG_DIRTY to prevent pdflush from retrying on it.

Tested-by: Joerg Platte <jplatte@naasa.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/buffer.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

--- linux-mm.orig/fs/buffer.c
+++ linux-mm/fs/buffer.c
@@ -2631,7 +2631,13 @@ int nobh_writepage(struct page *page, ge
 		if (page->mapping->a_ops->invalidatepage)
 			page->mapping->a_ops->invalidatepage(page, offset);
 #endif
+		/*
+		 * Clear PAGECACHE_TAG_DIRTY to stop pdflush from retrying.
+		 * Read block_write_full_page() for more details.
+		 */
+		set_page_writeback(page);
 		unlock_page(page);
+		end_page_writeback(page);
 		return 0; /* don't care */
 	}
 
@@ -2826,7 +2832,17 @@ int block_write_full_page(struct page *p
 		 * freeable here, so the page does not leak.
 		 */
 		do_invalidatepage(page, 0);
+		/*
+		 * Clear PAGECACHE_TAG_DIRTY to stop pdflush from retrying.
+		 *
+		 * Some truncated pages may hang around for long time.
+		 * For example, ext2_rmdir() will set i_size to 0, and then
+		 * keep the pages as long as the dir is still referenced(as
+		 * the working dir of some process).
+		 */
+		set_page_writeback(page);
 		unlock_page(page);
+		end_page_writeback(page);
 		return 0; /* don't care */
 	}
 
