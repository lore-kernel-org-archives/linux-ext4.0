From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/3] ext4: Remove kernel_lock annotations
Date: Mon,  7 Nov 2011 09:22:28 +0100
Message-ID: <1320654148-4394-1-git-send-email-richard@nod.at>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, Richard Weinberger <richard@nod.at>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:54739 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1KGIU3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 03:20:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The BKL is gone, these annotations are useless.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ext4/super.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9953d80..92d99e4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3099,8 +3099,6 @@ static void ext4_destroy_lazyinit_thread(void)
 }
 
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
-				__releases(kernel_lock)
-				__acquires(kernel_lock)
 {
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh;
-- 
1.7.7

