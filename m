From: Wang Long <wanglong19@meituan.com>
Subject: [PATCH] jbd2: set to NULL after kmem_cache_destroy
Date: Mon,  5 Feb 2018 21:39:17 +0800
Message-ID: <1517837957-1636-1-git-send-email-wanglong19@meituan.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanglong19@meituan.com
To: tytso@mit.edu, jack@suse.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx-fe5-210.meituan.com ([103.37.138.210]:60777 "EHLO
        mx02.meituan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbeBEQoY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Feb 2018 11:44:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Wang Long <wanglong19@meituan.com>
---
 fs/jbd2/journal.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 93016bb..38dc24c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2649,11 +2649,14 @@ static int __init jbd2_journal_init_handle_cache(void)
 
 static void jbd2_journal_destroy_handle_cache(void)
 {
-	if (jbd2_handle_cache)
+	if (jbd2_handle_cache) {
 		kmem_cache_destroy(jbd2_handle_cache);
-	if (jbd2_inode_cache)
+		jbd2_handle_cache = NULL;
+	}
+	if (jbd2_inode_cache) {
 		kmem_cache_destroy(jbd2_inode_cache);
