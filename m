From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix double unlock buffer mess during fs-resize
Date: Fri,  7 Sep 2012 14:14:44 +0400
Message-ID: <1347012884-29484-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, djwong@us.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45082 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760334Ab2IGKOv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Sep 2012 06:14:51 -0400
Received: by lbbgj3 with SMTP id gj3so1764197lbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Sep 2012 03:14:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bh_submit_read() is responsible for unlock bh on endio

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/resize.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 41f6ef6..3b05198 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1076,17 +1076,12 @@ static struct buffer_head *ext4_get_bitmap(struct super_block *sb, __u64 block)
 	struct buffer_head *bh = sb_getblk(sb, block);
 	if (!bh)
 		return NULL;
-
-	if (bitmap_uptodate(bh))
-		return bh;
