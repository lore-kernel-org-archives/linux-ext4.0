From: Simon Xu <xu.simon@oracle.com>
Subject: [PATCH] ext3: reduce redundant check of '*options'
Date: Thu, 13 Jan 2011 20:42:38 +0800
Message-ID: <1294922558-2313-1-git-send-email-xu.simon@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Simon Xu <xu.simon@oracle.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:38877 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab1AMMn1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 07:43:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't need to check whether '*options' equals to ',' twice.

Signed-off-by: Simon Xu <xu.simon@oracle.com>
---
 fs/ext3/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index b7d0554..dbb84e6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -891,13 +891,13 @@ static ext3_fsblk_t get_sb_block(void **data, struct super_block *sb)
 	options += 3;
 	/*todo: use simple_strtoll with >32bit ext3 */
 	sb_block = simple_strtoul(options, &options, 0);
-	if (*options && *options != ',') {
+	if (*options == ',') {
+		options++;
+	} else if (*options) {
 		ext3_msg(sb, "error: invalid sb specification: %s",
 		       (char *) *data);
 		return 1;
 	}
-	if (*options == ',')
-		options++;
 	*data = (void *) options;
 	return sb_block;
 }
-- 
1.7.3.5

