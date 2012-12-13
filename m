From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 5/8] e2fsck/revoke.c: Fix undefined behavior in hash()
Date: Fri, 14 Dec 2012 00:04:27 +0200
Message-ID: <20121213220426.GM9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:57569 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab2LMWiw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:38:52 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4fKT019954
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:41 +0200
Received: from smtp-3.hut.fi ([130.233.228.93])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 18204-94 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:41 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4RQS019946
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:27 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There's a shift by (hash_shift - 12) in hash(), but hash() is called
with hash_shift=10, resulting in a negative shift and thus undefined
behavior.

A simple and stupid minimal fix is to just change the subtracted
amount to 10.

Caught by clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 e2fsck/revoke.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/revoke.c b/e2fsck/revoke.c
index 38c265e..dddef4d 100644
--- a/e2fsck/revoke.c
+++ b/e2fsck/revoke.c
@@ -115,7 +115,7 @@ static inline int hash(journal_t *journal, unsigned long block)
 
 	return ((block << (hash_shift - 6)) ^
 		(block >> 13) ^
-		(block << (hash_shift - 12))) & (table->hash_size - 1);
+		(block << (hash_shift - 10))) & (table->hash_size - 1);
 }
 
 static int insert_revoke_hash(journal_t *journal, unsigned long blocknr,
-- 
1.7.10.4
