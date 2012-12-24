From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH] fs/ext3: set pointer = NULL, after kfree it
Date: Mon, 24 Dec 2012 13:58:14 +0800
Message-ID: <50D7EEF6.4070005@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:4853 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2LXF5U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 00:57:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  set s->base = NULL, after kfree it.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/ext3/xattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index d22ebb7..57aab94 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -847,8 +847,10 @@ cleanup:
 	if (ce)
 		mb_cache_entry_release(ce);
 	brelse(new_bh);
-	if (!(bs->bh && s->base == bs->bh->b_data))
+	if (!(bs->bh && s->base == bs->bh->b_data)) {
 		kfree(s->base);
+		s->base = NULL;
+	}
 
 	return error;
 
-- 
1.7.10.4
