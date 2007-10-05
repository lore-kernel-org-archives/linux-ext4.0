From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] jbd2: JBD replace jbd2_kmalloc with kmalloc
Date: Fri, 05 Oct 2007 15:39:19 -0700
Message-ID: <1191623960.3861.31.camel@localhost.localdomain>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53857 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXJEWjn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2007 18:39:43 -0400
In-Reply-To: <20071004065204.GA21481@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

JBD2: JBD2 replace jbd2_kmalloc with kmalloc

From: Mingming Cao <cmm@us.ibm.com>

This patch cleans up jbd_kmalloc and replace it with kmalloc directly

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---

 fs/jbd2/journal.c     |   11 +----------
 fs/jbd2/transaction.c |    4 ++--
 include/linux/jbd2.h  |    7 -------
 3 files changed, 3 insertions(+), 19 deletions(-)


Index: linux-2.6.23-rc9/fs/jbd2/journal.c
===================================================================
--- linux-2.6.23-rc9.orig/fs/jbd2/journal.c	2007-10-05 12:08:26.000000000 -0700
+++ linux-2.6.23-rc9/fs/jbd2/journal.c	2007-10-05 12:08:32.000000000 -0700
@@ -654,7 +654,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = jbd_kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
@@ -1619,15 +1619,6 @@ size_t journal_tag_bytes(journal_t *jour
 }
 
 /*
- * Simple support for retrying memory allocations.  Introduced to help to
- * debug different VM deadlock avoidance strategies.
- */
-void * __jbd2_kmalloc (const char *where, size_t size, gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-
-/*
  * Journal_head storage management
  */
 static struct kmem_cache *jbd2_journal_head_cache;
Index: linux-2.6.23-rc9/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.23-rc9.orig/fs/jbd2/transaction.c	2007-10-05 12:08:26.000000000 -0700
+++ linux-2.6.23-rc9/fs/jbd2/transaction.c	2007-10-05 12:08:32.000000000 -0700
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
Index: linux-2.6.23-rc9/include/linux/jbd2.h
===================================================================
--- linux-2.6.23-rc9.orig/include/linux/jbd2.h	2007-10-05 12:08:26.000000000 -0700
+++ linux-2.6.23-rc9/include/linux/jbd2.h	2007-10-05 12:08:32.000000000 -0700
@@ -71,13 +71,6 @@ extern u8 jbd2_journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-extern void * __jbd2_kmalloc (const char *where, size_t size, gfp_t flags, int retry);
-#define jbd_kmalloc(size, flags) \
-	__jbd2_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
-#define jbd_rep_kmalloc(size, flags) \
-	__jbd2_kmalloc(__FUNCTION__, (size), (flags), 1)
-
-
 static inline void *jbd2_alloc(size_t size, gfp_t flags)
 {
 	return (void *)__get_free_pages(flags, get_order(size));
