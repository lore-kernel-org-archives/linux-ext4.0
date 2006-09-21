From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: ext4 kernel patches against linux-2.6.18-rc7-mm1
Date: Thu, 21 Sep 2006 17:15:23 +0200
Message-ID: <20060921151523.GA20682@lombardij>
References: <1158767799.9276.23.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:5529 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751240AbWIUPPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Sep 2006 11:15:25 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1158767799.9276.23.camel@kleikamp.austin.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 20, 2006 at 10:56:39AM -0500, Dave Kleikamp wrote:
> # These next 4 copy clone jdb2 from jbd and modify ext4 to use it
> jbd2-copy.patch
> jbd2-rename.patch

jbd and jbd2 currently use the same slab names which must be unique.
The patch below just renames jbd2's slabs.

Signed-off-by: Johann Lombardi <johann.lombardi@bull.net>

Index: linux-2.6.18-rc7-mm1/fs/jbd2/journal.c
===================================================================
--- linux-2.6.18-rc7-mm1.orig/fs/jbd2/journal.c	2006-09-21 16:37:49.566959224 +0200
+++ linux-2.6.18-rc7-mm1/fs/jbd2/journal.c	2006-09-21 16:38:19.145462608 +0200
@@ -1643,7 +1643,7 @@
 
 static kmem_cache_t *jbd_slab[JBD_MAX_SLABS];
 static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd_1k", "jbd_2k", "jbd_4k", NULL, "jbd_8k"
+	"jbd2_1k", "jbd2_2k", "jbd2_4k", NULL, "jbd2_8k"
 };
 
 static void jbd2_journal_destroy_jbd_slabs(void)
@@ -1714,7 +1714,7 @@
 	int retval;
 
 	J_ASSERT(jbd2_journal_head_cache == 0);
-	jbd2_journal_head_cache = kmem_cache_create("journal_head",
+	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				0,		/* flags */
@@ -2019,7 +2019,7 @@
 
 static int __init journal_init_handle_cache(void)
 {
-	jbd2_handle_cache = kmem_cache_create("journal_handle",
+	jbd2_handle_cache = kmem_cache_create("jbd2_journal_handle",
 				sizeof(handle_t),
 				0,		/* offset */
 				0,		/* flags */
Index: linux-2.6.18-rc7-mm1/fs/jbd2/revoke.c
===================================================================
--- linux-2.6.18-rc7-mm1.orig/fs/jbd2/revoke.c	2006-09-21 16:38:28.044109808 +0200
+++ linux-2.6.18-rc7-mm1/fs/jbd2/revoke.c	2006-09-21 16:38:40.978143536 +0200
@@ -169,13 +169,13 @@
 
 int __init jbd2_journal_init_revoke_caches(void)
 {
-	jbd2_revoke_record_cache = kmem_cache_create("revoke_record",
+	jbd2_revoke_record_cache = kmem_cache_create("jbd2_revoke_record",
 					   sizeof(struct jbd2_revoke_record_s),
 					   0, SLAB_HWCACHE_ALIGN, NULL, NULL);
 	if (jbd2_revoke_record_cache == 0)
 		return -ENOMEM;
 
-	jbd2_revoke_table_cache = kmem_cache_create("revoke_table",
+	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, 0, NULL, NULL);
 	if (jbd2_revoke_table_cache == 0) {
