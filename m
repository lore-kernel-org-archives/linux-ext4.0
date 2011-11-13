From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/3] jbd2: use KMEM_CACHE instead of kmem_cache_create
Date: Sun, 13 Nov 2011 19:21:31 +0800
Message-ID: <1321183291-4589-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37654 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1KMNo1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Nov 2011 08:44:27 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6140161iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 05:44:27 -0800 (PST)
In-Reply-To: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch lets jbd2 use KMEM_CACHE instead of kmem_cache_create.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd2/revoke.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 69fd935..1b67105 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -204,17 +204,13 @@ int __init jbd2_journal_init_revoke_caches(void)
 	J_ASSERT(!jbd2_revoke_record_cache);
 	J_ASSERT(!jbd2_revoke_table_cache);
 
-	jbd2_revoke_record_cache = kmem_cache_create("jbd2_revoke_record",
-					   sizeof(struct jbd2_revoke_record_s),
-					   0,
-					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
-					   NULL);
+	jbd2_revoke_record_cache = KMEM_CACHE(jbd2_revoke_record_s,
+					SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY);
 	if (!jbd2_revoke_record_cache)
 		goto record_cache_failure;
 
-	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
-					   sizeof(struct jbd2_revoke_table_s),
-					   0, SLAB_TEMPORARY, NULL);
+	jbd2_revoke_table_cache = KMEM_CACHE(jbd2_revoke_table_s,
+					     SLAB_TEMPORARY);
 	if (!jbd2_revoke_table_cache)
 		goto table_cache_failure;
 	return 0;
-- 
1.7.5.1

