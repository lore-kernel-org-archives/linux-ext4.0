From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Kernel BUG] ext4 for v2.6.32 round II
Date: Wed, 30 Sep 2009 23:01:51 -0400
Message-ID: <20091001030151.GR24383@mit.edu>
References: <E1Msrgx-0001br-MP@closure.thunk.org> <20091001014128.GA2092@phenom2.trippelsdorf.de> <alpine.LFD.2.01.0909301847030.6996@localhost.localdomain> <20091001021531.GA2025@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52156 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbZJADCC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2009 23:02:02 -0400
Content-Disposition: inline
In-Reply-To: <20091001021531.GA2025@phenom2.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Markus, 

I'm pretty sure the following should fix your problems; can you
confirm?

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
