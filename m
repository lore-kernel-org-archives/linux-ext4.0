From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] jbd2: use kmem_cache_zalloc wrapper instead of flag
Date: Mon, 21 May 2012 21:19:48 +0800
Message-ID: <1337606388-19105-1-git-send-email-gaowanlong@cn.fujitsu.com>
Cc: tytso@mit.edu, Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2EUNVQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 May 2012 09:21:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use kmem_cache_zalloc wrapper instead of flag __GFP_ZERO.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/jbd2/transaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index ddcd354..fb1ab953 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -162,8 +162,8 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmem_cache_alloc(transaction_cache,
-						   gfp_mask | __GFP_ZERO);
+		new_transaction = kmem_cache_zalloc(transaction_cache,
+						    gfp_mask);
 		if (!new_transaction) {
 			/*
 			 * If __GFP_FS is not present, then we may be
-- 
1.7.10

