From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] jbd jbd2: fix dio write returning EIO when
  try_to_release_page fails
Date: Mon, 04 Aug 2008 20:10:33 +0900
Message-ID: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: cmm@us.ibm.com, jack@suse.cz, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60539 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYHDLMd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 07:12:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

Dio write returns EIO when try_to_release_page fails because bh is
still referenced.
The patch 
"commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
Author: Mingming Cao <cmm@us.ibm.com>
Date:   Fri Jul 25 01:46:22 2008 -0700

    jbd: fix race between free buffer and commit transaction
" 
was merged into 2.6.27-rc1, but I noticed that this patch is not enough
to fix the race.
I did fsstress test heavily to 2.6.27-rc1, and found that dio write still 
sometimes got EIO through this test.
The patch above fixed race between freeing buffer(dio) and committing 
transaction(jbd) but I discovered that there is another race, 
freeing buffer(dio) and ext3/4_ordered_writepage.
: background_writeout()
     ->write_cache_pages()
       ->ext3_ordered_writepage()
     	   walk_page_buffers() <- take a bh ref
 	   block_write_full_page() <- unlock_page
		: <- end_page_writeback
                : <- race! (dio write->try_to_release_page fails)
      	   walk_page_buffers() <-release a bh ref

ext3_ordered_writepage holds bh ref and does unlock_page remaining 
taking a bh ref, so this causes the race and failure of 
try_to_release_page.

Following patch fixes this race.
Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c linux-2.6.27-rc1/fs/jbd/transaction.c
--- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 19:28:47.000000000 +0900
+++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.000000000 +0900
@@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
 	*/
 	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
 		journal_wait_for_transaction_sync_data(journal);
+
+		bh = head;
+		do {
+			while (atomic_read(&bh->b_count))
+				schedule();
+		} while ((bh = bh->b_this_page) != head);
 		ret = try_to_free_buffers(page);
 	}
 
diff -Nrup linux-2.6.27-rc1.org/fs/jbd2/transaction.c linux-2.6.27-rc1/fs/jbd2/transaction.c
--- linux-2.6.27-rc1.org/fs/jbd2/transaction.c	2008-07-29 19:28:47.000000000 +0900
+++ linux-2.6.27-rc1/fs/jbd2/transaction.c	2008-07-29 20:56:42.000000000 +0900
@@ -1583,6 +1583,12 @@ int jbd2_journal_try_to_free_buffers(jou
 	*/
 	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
 		jbd2_journal_wait_for_transaction_sync_data(journal);
+
+		bh = head;
+		do {
+			while (atomic_read(&bh->b_count))
+				schedule();
+		} while ((bh = bh->b_this_page) != head);
 		ret = try_to_free_buffers(page);
 	}
 

