From: Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.32-rc1 oops in ext4
Date: Wed, 30 Sep 2009 23:07:33 -0400
Message-ID: <20091001030733.GS24383@mit.edu>
References: <cb0375e10909301954y68e18290m97e9fecfbc5aa6e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Lutomirski <andy@luto.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40046 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbZJADHd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2009 23:07:33 -0400
Content-Disposition: inline
In-Reply-To: <cb0375e10909301954y68e18290m97e9fecfbc5aa6e3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 30, 2009 at 10:54:26PM -0400, Andrew Lutomirski wrote:
> All I did was boot Fedora 11 and open a Konsole.  I'm running
> 84d88d5d4efc37dfb8a93a4a58d8a227ee86ffa4.

I'm pretty sure this patch should fix things; can you confirm?

    	   	     	   	      	      - Ted

commit 1f94533d9cd75f6d2826018d54a971b9cc085992
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Sep 30 22:57:41 2009 -0400

    ext4: fix a BUG_ON crash by checking that page has buffers attached to it
    
    In ext4_num_dirty_pages() we were calling page_buffers() before
    checking to see if the page actually had pages attached to it; this
    would cause a BUG check crash in the inline function page_buffers().
    
    Thanks to Markus Trippelsdorf for reporting this bug.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ec367bc..6e65d0e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1146,8 +1146,8 @@ static int check_block_validity(struct inode *inode, const char *msg,
 }
 
 /*
- * Return the number of dirty pages in the given inode starting at
- * page frame idx.
+ * Return the number of contiguous dirty pages in a given inode
+ * starting at page frame idx.
  */
 static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
 				    unsigned int max_pages)
@@ -1181,15 +1181,15 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
 				unlock_page(page);
 				break;
 			}
-			head = page_buffers(page);
-			bh = head;
-			do {
-				if (!buffer_delay(bh) &&
-				    !buffer_unwritten(bh)) {
-					done = 1;
-					break;
-				}
-			} while ((bh = bh->b_this_page) != head);
+			if (page_has_buffers(page)) {
+				bh = head = page_buffers(page);
+				do {
+					if (!buffer_delay(bh) &&
+					    !buffer_unwritten(bh))
+						done = 1;
+					bh = bh->b_this_page;
+				} while (!done && (bh != head));
+			}
 			unlock_page(page);
 			if (done)
 				break;
