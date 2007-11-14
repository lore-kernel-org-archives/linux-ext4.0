From: Joe Perches <joe@perches.com>
Subject: [PATCH] - [4/15] - remove defconfig ptr comparisons to 0 - fs/jbd
Date: Tue, 13 Nov 2007 18:05:01 -0800
Message-ID: <1195005901.5163.90.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4750 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761389AbXKNCFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 5d14243..0459657 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1619,14 +1619,14 @@ static int journal_init_journal_head_cache(void)
 {
 	int retval;
 
-	J_ASSERT(journal_head_cache == 0);
+	J_ASSERT(!journal_head_cache);
 	journal_head_cache = kmem_cache_create("journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (journal_head_cache == 0) {
+	if (!journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index ad2eacf..d5f8eee 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -173,13 +173,13 @@ int __init journal_init_revoke_caches(void)
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (revoke_record_cache == 0)
+	if (!revoke_record_cache)
 		return -ENOMEM;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (revoke_table_cache == 0) {
+	if (!revoke_table_cache) {
 		kmem_cache_destroy(revoke_record_cache);
 		revoke_record_cache = NULL;
 		return -ENOMEM;
