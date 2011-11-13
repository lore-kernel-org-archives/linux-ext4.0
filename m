From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/3] jbd2: rename functions initializing caches
Date: Sun, 13 Nov 2011 19:21:30 +0800
Message-ID: <1321183291-4589-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37654 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1KMNoZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Nov 2011 08:44:25 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6140161iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 05:44:25 -0800 (PST)
In-Reply-To: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch renames functions initializing caches to let them
be in accord with functions destroying caches.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd2/journal.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 56b8a1a..a5e99c4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2007,7 +2007,7 @@ static struct kmem_cache *jbd2_journal_head_cache;
 static atomic_t nr_journal_heads = ATOMIC_INIT(0);
 #endif
 
-static int journal_init_jbd2_journal_head_cache(void)
+static int jbd2_journal_init_journal_head_cache(void)
 {
 	int retval;
 
@@ -2025,7 +2025,7 @@ static int journal_init_jbd2_journal_head_cache(void)
 	return retval;
 }
 
-static void jbd2_journal_destroy_jbd2_journal_head_cache(void)
+static void jbd2_journal_destroy_journal_head_cache(void)
 {
 	if (jbd2_journal_head_cache) {
 		kmem_cache_destroy(jbd2_journal_head_cache);
@@ -2313,7 +2313,7 @@ static void __exit jbd2_remove_jbd_stats_proc_entry(void)
 
 struct kmem_cache *jbd2_handle_cache, *jbd2_inode_cache;
 
-static int __init journal_init_handle_cache(void)
+static int __init jbd2_journal_init_handle_cache(void)
 {
 	jbd2_handle_cache = KMEM_CACHE(jbd2_journal_handle, SLAB_TEMPORARY);
 	if (jbd2_handle_cache == NULL) {
@@ -2348,9 +2348,9 @@ static int __init journal_init_caches(void)
 
 	ret = jbd2_journal_init_revoke_caches();
 	if (ret == 0)
-		ret = journal_init_jbd2_journal_head_cache();
+		ret = jbd2_journal_init_journal_head_cache();
 	if (ret == 0)
-		ret = journal_init_handle_cache();
+		ret = jbd2_journal_init_handle_cache();
 	if (ret == 0)
 		ret = jbd2_journal_init_transaction_cache();
 	return ret;
@@ -2359,7 +2359,7 @@ static int __init journal_init_caches(void)
 static void jbd2_journal_destroy_caches(void)
 {
 	jbd2_journal_destroy_revoke_caches();
-	jbd2_journal_destroy_jbd2_journal_head_cache();
+	jbd2_journal_destroy_journal_head_cache();
 	jbd2_journal_destroy_handle_cache();
 	jbd2_journal_destroy_transaction_cache();
 	jbd2_journal_destroy_slabs();
-- 
1.7.5.1

