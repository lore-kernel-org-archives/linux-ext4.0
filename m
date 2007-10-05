From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] jbd: JBD replace jbd_kmalloc with kmalloc
Date: Fri, 05 Oct 2007 15:38:19 -0700
Message-ID: <1191623899.3861.29.camel@localhost.localdomain>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
	 <1191477059-5357-2-git-send-email-tytso@mit.edu>
	 <20071004065204.GA21481@infradead.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51634 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXJEWin (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2007 18:38:43 -0400
In-Reply-To: <20071004065204.GA21481@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

JBD: JBD replace jbd_kmalloc with kmalloc

From: Mingming Cao <cmm@us.ibm.com>

This patch cleans up jbd_kmalloc and replace it with kmalloc directly

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---

 fs/jbd/journal.c     |   11 +----------
 fs/jbd/transaction.c |    4 ++--
 include/linux/jbd.h  |    6 ------
 3 files changed, 3 insertions(+), 18 deletions(-)


Index: linux-2.6.23-rc9/fs/jbd/journal.c
===================================================================
--- linux-2.6.23-rc9.orig/fs/jbd/journal.c	2007-10-05 12:08:08.000000000 -0700
+++ linux-2.6.23-rc9/fs/jbd/journal.c	2007-10-05 12:08:29.000000000 -0700
@@ -653,7 +653,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = jbd_kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
@@ -1607,15 +1607,6 @@ int journal_blocks_per_page(struct inode
 }
 
 /*
- * Simple support for retrying memory allocations.  Introduced to help to
- * debug different VM deadlock avoidance strategies.
- */
-void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-
-/*
  * Journal_head storage management
  */
 static struct kmem_cache *journal_head_cache;
Index: linux-2.6.23-rc9/fs/jbd/transaction.c
===================================================================
--- linux-2.6.23-rc9.orig/fs/jbd/transaction.c	2007-10-05 12:08:08.000000000 -0700
+++ linux-2.6.23-rc9/fs/jbd/transaction.c	2007-10-05 12:08:29.000000000 -0700
@@ -96,8 +96,8 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = jbd_kmalloc(sizeof(*new_transaction),
-						GFP_NOFS);
+		new_transaction = kmalloc(sizeof(*new_transaction),
+						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
Index: linux-2.6.23-rc9/include/linux/jbd.h
===================================================================
--- linux-2.6.23-rc9.orig/include/linux/jbd.h	2007-10-05 12:08:08.000000000 -0700
+++ linux-2.6.23-rc9/include/linux/jbd.h	2007-10-05 12:08:29.000000000 -0700
@@ -71,12 +71,6 @@ extern int journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-extern void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry);
-#define jbd_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
-#define jbd_rep_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), 1)
-
 static inline void *jbd_alloc(size_t size, gfp_t flags)
 {
 	return (void *)__get_free_pages(flags, get_order(size));
