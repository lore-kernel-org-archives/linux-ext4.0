From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] ext4: Fix memory leak in ext4_fill_super()
Date: Fri, 15 May 2009 00:07:27 +0530
Message-ID: <ea11fea30905141137t4c35c029k3ed746af8de84407@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:51720 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZENSht (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 14:37:49 -0400
Received: by gxk10 with SMTP id 10so2751994gxk.13
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 11:37:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We forget to free up the space allocated for s_blockgroup_lock in case
of failed mounts.
Below patch fixes up the memory leak.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..fdc1e12 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2862,6 +2862,7 @@ failed_mount:
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
