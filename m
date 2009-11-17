From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 2/2] ext2: add wait flag support to sync_fs
Date: Tue, 17 Nov 2009 09:46:19 -0800
Message-ID: <20091117174647.402219318@vyatta.com>
References: <20091117174617.285298261@vyatta.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:37781 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZKQSHs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 13:07:48 -0500
Received: from suva.vyatta.com (suva [127.0.0.1])
	by suva.vyatta.com (8.13.7/8.13.7) with ESMTP id nAHHlxw3030049
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 09:47:59 -0800
Content-Disposition: inline; filename=ext2-syncfs-wait.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make ext2 safer against accidental data loss during removal
by adding support for waiting for super block update on sync.
Don't know why this wasn't done originally, all the other file
systems have it.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/fs/ext2/super.c	2009-11-17 09:14:12.177002522 -0800
+++ b/fs/ext2/super.c	2009-11-17 09:14:32.698005421 -0800
@@ -1147,6 +1147,8 @@ static int ext2_sync_fs(struct super_blo
 		ext2_sync_super(sb, es);
 	} else {
 		ext2_commit_super(sb, es);
+		if (wait)
+			sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
 	}
 	sb->s_dirt = 0;
 	unlock_kernel();

-- 

