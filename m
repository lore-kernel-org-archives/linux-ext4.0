From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: use a better hash function for the revoke table
Date: Thu, 30 Oct 2014 10:00:15 -0400
Message-ID: <1414677615-29296-1-git-send-email-tytso@mit.edu>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53085 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760280AbaJ3OAW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Oct 2014 10:00:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The old hash function didn't work well for 64-bit block numbers, and
used undefined (negative) shift right behavior.  Use the generic
64-bit hash function instead.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 fs/jbd2/revoke.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index d5e95a1..c6cbaef 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -92,6 +92,7 @@
 #include <linux/init.h>
 #include <linux/bio.h>
 #include <linux/log2.h>
+#include <linux/hash.h>
 #endif
 
 static struct kmem_cache *jbd2_revoke_record_cache;
@@ -130,16 +131,9 @@ static void flush_descriptor(journal_t *, struct buffer_head *, int, int);
 
 /* Utility functions to maintain the revoke table */
 
-/* Borrowed from buffer.c: this is a tried and tested block hash function */
 static inline int hash(journal_t *journal, unsigned long long block)
 {
-	struct jbd2_revoke_table_s *table = journal->j_revoke;
-	int hash_shift = table->hash_shift;
-	int hash = (int)block ^ (int)((block >> 31) >> 1);
