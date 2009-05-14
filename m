From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] ext3: Fix memory leak in ext3_fill_super()
Date: Fri, 15 May 2009 00:10:43 +0530
Message-ID: <ea11fea30905141140r7895d094qb7df6372f6a19cc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:61325 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZENSlC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 14:41:02 -0400
Received: by yx-out-2324.google.com with SMTP id 3so820808yxj.1
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 11:41:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We forget to free up the space allocated for s_blockgroup_lock in case
of failed mounts. Below patch fixes up the memory leak.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext3/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 599dbfe..d8b73d4 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2021,6 +2021,7 @@ failed_mount:
 	brelse(bh);
 out_fail:
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	lock_kernel();
 	return ret;
-- 
1.5.4.3


-- 
Thanks -
Manish
