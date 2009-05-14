From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] ext2: Fix memory leak in ext2_fill_super()
Date: Fri, 15 May 2009 00:12:17 +0530
Message-ID: <ea11fea30905141142t578109f8ic8d7d86345c08efe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:42846 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZENSmg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 14:42:36 -0400
Received: by gxk10 with SMTP id 10so2757242gxk.13
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 11:42:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We forget to free up the space allocated for s_blockgroup_lock in case
of failed mounts. Below patch fixes up the memory leak.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 5c4afe6..e3c748f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1093,6 +1093,7 @@ failed_mount:
 	brelse(bh);
 failed_sbi:
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	return ret;
 }
-- 
1.5.4.3


-- 
Thanks -
Manish
