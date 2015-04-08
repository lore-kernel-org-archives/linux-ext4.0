From: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH] ext4: Move check under lock scope to close a race.
Date: Tue,  7 Apr 2015 21:46:50 -0700
Message-ID: <1428468410-12793-2-git-send-email-dccitaliano@gmail.com>
References: <1428468410-12793-1-git-send-email-dccitaliano@gmail.com>
Cc: Davide Italiano <dccitaliano@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f196.google.com ([209.85.192.196]:33865 "EHLO
	mail-pd0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbDHErE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2015 00:47:04 -0400
Received: by pdjp10 with SMTP id p10so24388808pdj.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Apr 2015 21:47:03 -0700 (PDT)
In-Reply-To: <1428468410-12793-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fallocate() checks that the file is extent-based and returns
EOPNOTSUPP in case is not. Other tasks can convert from and to
indirect and extent so it's safe to check only after grabbing
the inode mutex.

Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
---
 fs/ext4/extents.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bed4308..8a9ee08 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4934,13 +4934,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (ret)
 		return ret;
 
-	/*
-	 * currently supporting (pre)allocate mode for extent-based
-	 * files _only_
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return -EOPNOTSUPP;
