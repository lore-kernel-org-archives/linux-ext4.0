From: Adrian Bunk <bunk@stusta.de>
Subject: [RFC: 2.6 patch] make fs/jbd/transaction.c:__journal_temp_unlink_buffer() static
Date: Mon, 20 Nov 2006 03:24:15 +0100
Message-ID: <20061120022415.GO31879@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46609 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S933879AbWKTCYQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Nov 2006 21:24:16 -0500
To: sct@redhat.com, akpm@osdl.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch makes the needlessly global __journal_temp_unlink_buffer() 
static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/jbd/transaction.c |    4 +++-
 include/linux/jbd.h  |    1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.19-rc5-mm2/include/linux/jbd.h.old	2006-11-20 01:46:09.000000000 +0100
+++ linux-2.6.19-rc5-mm2/include/linux/jbd.h	2006-11-20 01:46:23.000000000 +0100
@@ -839,7 +839,6 @@
  */
 
 /* Filing buffers */
-extern void __journal_temp_unlink_buffer(struct journal_head *jh);
 extern void journal_unfile_buffer(journal_t *, struct journal_head *);
 extern void __journal_unfile_buffer(struct journal_head *);
 extern void __journal_refile_buffer(struct journal_head *);
--- linux-2.6.19-rc5-mm2/fs/jbd/transaction.c.old	2006-11-20 01:46:29.000000000 +0100
+++ linux-2.6.19-rc5-mm2/fs/jbd/transaction.c	2006-11-20 01:46:45.000000000 +0100
@@ -27,6 +27,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
+static void __journal_temp_unlink_buffer(struct journal_head *jh);
+
 /*
  * get_transaction: obtain a new transaction_t object.
  *
@@ -1499,7 +1501,7 @@
  *
  * Called under j_list_lock.  The journal may not be locked.
  */
-void __journal_temp_unlink_buffer(struct journal_head *jh)
+static void __journal_temp_unlink_buffer(struct journal_head *jh)
 {
 	struct journal_head **list = NULL;
 	transaction_t *transaction;
